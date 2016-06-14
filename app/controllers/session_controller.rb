class SessionController < ApplicationController
  require "auth_token"

  before_action :authenticate_request!, only: [:destroy]

  def create
    user = User.find_by_credentials(params[:email], params[:password])

    if user
      user.update_attribute(:auth_token, AuthToken.encode({ user_id: user.id }))

      render json: authentication_payload(user)
    else
      render json: { errors: ["That email/password combination is not valid."] }, status: :unauthorized
    end
  end

  def destroy
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
