class UsersController < ApplicationController
  before_action :authenticate_request!, except: [:create, :confirmation]
  before_action :add_confirmation_token, only: [:create]

  def show
    @current_user.to_json(only: [:email])
  end

  def create
    user = User.new(user_params)

    if user.save
      # отправить письмо
      render json: { success: ["We've send confirmation instructions onto #{user.email}"] }
    else
      render json: { errors: [user.errors.messages.to_json] }
    end
  end

  def update
    if @current_user.update_attributes(user_params)
      render json: { success: ["Updated successfully"] }
    else
      render json: { errors: [@current_user.errors.messages.to_json] }
    end
  end

  def destroy
    @current_user.destroy

    render json: { success: ["Your account has been successfully destroyed"] }
  end

  def confirmation
    if conf_token = params[:confirmation_token]
      user = User.find_by(confirmation_token: conf_token)

      if user && !user.confirmed_at
        user.update_attributes(confirmation_token: nil, confirmed_at: Time.now)

        return render json: { success: ["Your account has been successfully confirmed"] }
      end
    end

    render json: { errors: ["Confirmation link is invalid."] }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :auth_token, :confirmation_token,
      :confirmed_at)
  end

  def add_confirmation_token
    params[:user][:confirmation_token] = SecureRandom.hex
  end

end
