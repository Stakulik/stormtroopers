class ApplicationController < ActionController::API
  include ActionController::Serialization

  require "exceptions"

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Exceptions::AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from Exceptions::NotAuthenticatedError, with: :user_not_authenticated

  attr_reader :current_user

  before_action :add_allow_credentials_headers
  
  def add_allow_credentials_headers
    response.headers["Access-Control-Allow-Origin"] = request.headers["Origin"] || "*"
    response.headers["Access-Control-Allow-Credentials"] = "true"
  end

  def options
    head status: 200, "Access-Control-Allow-Headers": "accept, content-type"
  end

  protected

  def authenticate_request!
    fail Exceptions::NotAuthenticatedError unless get_auth_token && decoded_auth_token[:ip] && find_current_user

    # check_clients_ip if 2 == rand(3)

    rescue JWT::ExpiredSignature
      raise Exceptions::AuthenticationTimeoutError
    rescue Exceptions::WrongClientsIpError, JWT::VerificationError, JWT::DecodeError
      raise Exceptions::NotAuthenticatedError
  end

  private

  def get_auth_token
    @auth_token = request.headers["AUTHORIZATION"]
  end

  def decoded_auth_token
    @decoded_auth_token ||= AuthToken.decode(@auth_token)
  end

  def find_current_user
    @current_user = AuthToken.find_by(content: @auth_token)&.user
  end

  def authentication_timeout
    render json: { errors: "Authentication Timeout" }, status: 419
  end

  def forbidden_resource
    render json: { errors: "Not Authorized To Access Resource" }, status: :forbidden
  end

  def user_not_authenticated
    render json: { errors: "Not Authenticated" }, status: :unauthorized
  end

  def check_user_confirmation
    render json: { errors: "You have to confirm your email" }, status: :forbidden if @user && !@user.confirmed_at
  end

  def check_clients_ip
    raise Exceptions::WrongClientsIpError unless @decoded_auth_token[:ip] == request.remote_ip
  end

  def record_not_found
    render plain: "404 Not Found", status: :not_found
  end
end
