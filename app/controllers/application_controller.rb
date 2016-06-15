class ApplicationController < ActionController::API
  include ActionController::Serialization
  require "exceptions"
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  attr_reader :current_user

  rescue_from Exceptions::AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from Exceptions::NotAuthenticatedError, with: :user_not_authenticated

  before_action :add_allow_credentials_headers
  
  def add_allow_credentials_headers                                                                                                                                                       
    response.headers["Access-Control-Allow-Origin"] = request.headers["Origin"] || "*"                                                                                                                                                                                                     
    response.headers["Access-Control-Allow-Credentials"] = "true"                                                                                                                                                                                                                          
  end 

  def options                                                                                                                                                                                                                                                                              
    head status: 200, "Access-Control-Allow-Headers": "accept, content-type"                                                                                                                                                                                                         
  end

protected

  # This method gets the current user based on the user_id included
  # in the Authorization header (json web token).
  #
  # Call this from child controllers in a before_action or from
  # within the action method itself
  def authenticate_request!
    @current_user = User.find_by(auth_token: request.headers["AUTHORIZATION"]) rescue nil

    fail Exceptions::NotAuthenticatedError unless @current_user
  rescue JWT::ExpiredSignature
    raise Exceptions::AuthenticationTimeoutError
  rescue JWT::VerificationError, JWT::DecodeError
    raise Exceptions::NotAuthenticatedError
  end

  private

  # Authentication Related Helper Methods
  # ------------------------------------------------------------
  def user_id_included_in_auth_token?
    http_auth_token && decoded_auth_token && decoded_auth_token[:user_id]
  end

  # Decode the authorization header token and return the payload
  def decoded_auth_token
    @decoded_auth_token ||= AuthToken.decode(http_auth_token)
  end

  # Raw Authorization Header token (json web token format)
  # JWT"s are stored in the Authorization header using this format:
  # Bearer somerandomstring.encoded-payload.anotherrandomstring
  def http_auth_token
    @http_auth_token ||= if request.headers["Authorization"].present?
                           request.headers["Authorization"].split(" ").last
                         end
  end

  # Helper Methods for responding to errors
  # ------------------------------------------------------------
  def authentication_timeout
    render json: { errors: ["Authentication Timeout"] }, status: 419
  end

  def forbidden_resource
    render json: { errors: ["Not Authorized To Access Resource"] }, status: :forbidden
  end

  def user_not_authenticated
    render json: { errors: ["Not Authenticated"] }, status: :unauthorized
  end

  def check_user_confirmation
    render json: { errors: ["You have to confirm your email"] } if @user && !@user.confirmed_at
  end

  def record_not_found
    render plain: "404 Not Found", status: :not_found
  end
end
