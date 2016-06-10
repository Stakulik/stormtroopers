class ApplicationController < ActionController::API
  include ActionController::Serialization

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
    unless user_id_in_token?
      render json: { errors: ["Not Authenticated"] }, status: :unauthorized

      return
    end

    @current_user = User.find(auth_token[:user_id])
    
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ["Not Authenticated"] }, status: :unauthorized
  end

  private

  def http_token
    @http_token ||= if request.headers["Authorization"].present?
      request.headers["Authorization"].split(" ").last
    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

end
