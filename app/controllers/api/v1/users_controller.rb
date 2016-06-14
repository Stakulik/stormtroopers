module Api::V1
  class UsersController < ApplicationController
    before_action :authenticate_request!, only: [:show, :update, :destroy]
    before_action :add_confirmation_token, only: [:create]
    before_action :get_user_by_email, only: [:resend_confirmation, :forgot_password, :update_password]
    before_action :check_user_confirmation, only: [:forgot_password, :update_password]

    def show
      render json: @current_user, serializer: Users::ShowSerializer
    end

    def create
      user = User.new(user_params)

      if user.save
        RegistrationMailer.confirmation_instructions(user).deliver_now

        render json: { success: ["Please go to your inbox #{user.email} and confirm creating an account"] }
      else
        render json: { errors: [user.errors.messages] }
      end
    end

    # def edit
    #   render json: @current_user, serializer: Users::EditSerializer
    # end

    def update
      unless User.find_by(email: @current_user.email)&.authenticate(user_params[:current_password])
        return render json: { errors: ["Wrong current password"] }
      end

      if @current_user.update_attributes(user_params)
        render json: { success: ["Updated successfully"] }
      else
        render json: { errors: [@current_user.errors.messages] }
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
          user.assign_attributes({ confirmation_token: nil, confirmed_at: Time.now })

          user.save(validate: false)

          return render json: { success: ["Your account has been successfully confirmed"] }
        end
      end

      render json: { errors: ["Confirmation link is invalid."] }
    end

    def resend_confirmation
      if @user&.confirmed_at
        render json: { errors: ["Email was already confirmed, please try signing in"] }
      elsif @user&.confirmation_token
        RegistrationMailer.confirmation_instructions(@user).deliver_now

        render json: { success: ["We've send confirmation instructions onto #{@user.email}"] }
      else
        render json: { errors: ["Link is invalid"] }
      end
    end

    def forgot_password
      if @user
        @user.update_attribute(:reset_password_token, generate_token)

        RegistrationMailer.reset_password_instructions(@user).deliver_now

        render json: { success: ["We've send instructions onto #{@user.email}"] }
      else
        render json: { errors: ["Link is invalid"] }
      end
    end

    def reset_password
      user = User.find_by(reset_password_token: params[:reset_password_token])

      if user
        render json: { email: user.email }
      else
        render json: { errors: ["Link is invalid."] }
      end
    end

    def update_password
      if !@user
        render json: { errors: ["Link is invalid"] }
      elsif @user&.update_attributes(user_params)
        @user.update_attribute(:reset_password_token, nil)

        render json: { success: ["Updated successfully."] }
      else
        render json: { errors: [@user.errors.messages] }
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :auth_token,
        :confirmation_token, :confirmed_at, :current_password)
    end

    def add_confirmation_token
      params[:user][:confirmation_token] = generate_token
    end

    def get_user_by_email
      @user = User.find_by(email: params[:email] || user_params[:email]) rescue nil
    end

    def generate_token
      SecureRandom.hex
    end

  end
end
