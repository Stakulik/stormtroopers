module Api::V1
  class UsersController < ApplicationController
    before_action :authenticate_request!, only: [:show, :update, :destroy]
    before_action :get_user_by_email, only: [:forgot_password, :update_password]
    before_action :check_user_confirmation, only: [:forgot_password, :update_password]
    before_action :check_expiration, only: [:confirmation, :reset_password]

    def show
      render json: @current_user, serializer: Users::ShowSerializer
    end

    def create
      user = User.new(user_params)

      user.confirmation_token = AuthToken.encode({ }, 1440)

      if user.save
        RegistrationMailer.confirmation_instructions(user).deliver_now

        render json: { success: "Please go to your inbox #{user.email} and confirm creating an account" },
          status: :created
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
    end

    def update
      unless User.find_by(email: @current_user.email)&.authenticate(user_params[:current_password])
        return render json: { errors: "The current password is incorrect" }, status: :unprocessable_entity
      end

      if @current_user.update_attributes(user_params)
        render json: { success: "Your profile has been update successfully" }, status: :ok
      else
        render json: { errors: @current_user.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      @current_user.destroy

      render json: { success: "Your account has been successfully destroyed" }, status: :ok
    end

    def confirmation
      if conf_token = params[:confirmation_token]
        user = User.find_by(confirmation_token: conf_token)

        if user && !user.confirmed_at
          user.assign_attributes({ confirmation_token: nil, confirmed_at: Time.now })

          user.save(validate: false)

          return render json: { success: "Your account has been successfully confirmed",
            auth_token: user.auth_tokens.create(content: AuthToken.encode({ user_id: user.id, ip: request.remote_ip })) },
              status: :ok
        end
      end

      render json: { errors: "Confirmation link is invalid" }, status: :bad_request
    end

    def forgot_password
      if @user
        @user.update_attribute(:reset_password_token, AuthToken.encode({ user_id: @user.id }, 120))

        RegistrationMailer.reset_password_instructions(@user).deliver_now

        render json: { success: "We've send instructions onto #{@user.email}" }, status: :ok
      else
        render json: { errors: "Link is invalid" }, status: :bad_request
      end
    end

    def reset_password
      user = User.find_by(reset_password_token: params[:reset_password_token])

      if user
        render json: { email: user.email }, status: :ok
      else
        render json: { errors: "Link is invalid" }, status: :bad_request
      end
    end

    def update_password
      user_params[:reset_password_token] = nil

      if !@user
        render json: { errors: "Link is invalid" }, status: :bad_request
      elsif @user&.update_attributes(user_params)
        AuthToken.where(user_id: @user).destroy_all

        render json: { success: "Your password has been changed",
          auth_token: @user.auth_tokens.create(content: AuthToken.encode({ user_id: @user.id, ip: request.remote_ip })) },
            status: :ok
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation,
        :confirmation_token, :confirmed_at, :current_password)
    end

    def get_user_by_email
      @user = User.find_by(email: params[:email] || user_params[:email]) rescue nil
    end

    def check_expiration
      AuthToken.decode(params[:reset_password_token] || params[:confirmation_token])

      rescue JWT::ExpiredSignature
        raise Exceptions::AuthenticationTimeoutError
      rescue  JWT::VerificationError, JWT::DecodeError
        raise Exceptions::NotAuthenticatedError
    end
  end
end
