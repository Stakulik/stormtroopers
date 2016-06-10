class AuthController < ApplicationController
  before_action :authenticate_request!, only: [:log_out]


  def authenticate
    user = User.find_by_credentials(params[:email], params[:password])

    if user
      user.update_attribute(:auth_token, AuthToken.encode({ user_id: user.id }))

      render json: authentication_payload(user)
    else
      render json: { errors: ["Invalid email or password"] }, status: :unauthorized
    end
  end

  def log_out
    current_user.update_attribute(:auth_token, AuthToken.encode({ user_id: current_user.id }, 0))

    render json: { success: ["Logged out successfully"] }
  end

  private

  def authentication_payload(user)
    return nil unless user && user.id

    {
      auth_token: user.auth_token,
      user: { id: user.id, email: user.email }
    }
  end
  
end
