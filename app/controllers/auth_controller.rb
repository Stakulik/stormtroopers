class AuthController < ApplicationController

  def authenticate
    user = User.find_by_credentials(params[:email], params[:password])

    if user
      render json: authentication_payload(user)
    else
      render json: { errors: ['Invalid email or password'] }, status: :unauthorized
    end
  end

  def log_out


    render plain: "Logged out successfully"
  end

  private

  def authentication_payload(user)
    return nil unless user && user.id

    {
      auth_token: AuthToken.encode({ user_id: user.id }),
      user: { id: user.id, email: user.email }
    }
  end
  
end
