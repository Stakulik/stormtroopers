class ApplicationController < ActionController::API
  include ActionController::Serialization

  require "exceptions"

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Exceptions::AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from Exceptions::NotAuthenticatedError, with: :user_not_authenticated

  attr_reader :current_user

  before_action :add_allow_credentials_headers
  after_action :prolong_token, if: -> () { @auth_token }

  def options
    head status: 200, "Access-Control-Allow-Headers": "accept, content-type"
  end

  private

  def authenticate_request!
    fail Exceptions::NotAuthenticatedError unless get_auth_token && find_current_user && decoded_auth_token[:ip]

    rescue JWT::ExpiredSignature
      raise Exceptions::AuthenticationTimeoutError
    rescue JWT::VerificationError, JWT::DecodeError
      raise Exceptions::NotAuthenticatedError
  end

  def add_allow_credentials_headers
    response.headers["Access-Control-Allow-Origin"] = request.headers["Origin"] || "*"
    # response.headers["Access-Control-Allow-Credentials"] = "true"
  end

  def prolong_token
    if (@decoded_auth_token[:exp] - Time.now.to_i < 12.hours.to_i) && check_clients_ip
      new_auth_token = @current_user.auth_tokens.create(content: AuthToken.encode({ user_id: @current_user.id,
        ip: request.remote_ip }))&.content

      response.set_header("X-APP-TOKEN", new_auth_token)
    end
  end

  def get_auth_token
    @auth_token = request.headers["AUTHORIZATION"]
  end

  def find_current_user
    @current_user = AuthToken.find_by(content: @auth_token)&.user
  end

  def decoded_auth_token
    @decoded_auth_token ||= AuthToken.decode(@auth_token)
  end

  def check_clients_ip
    if @decoded_auth_token[:ip] == request.remote_ip
      true
    else
      AuthToken.find_by(content: @auth_token).destroy

      false
    end
  end

  def authentication_timeout
    render json: { errors: "Authentication Timeout" }, status: 419
  end

  def user_not_authenticated
    render json: { errors: "Not Authenticated" }, status: :unauthorized
  end

  def check_user_confirmation
    render json: { errors: "You have to confirm your email" }, status: :forbidden if @user && !@user.confirmed_at
  end

  def record_not_found
    render plain: "404 Not Found", status: :not_found
  end
end
