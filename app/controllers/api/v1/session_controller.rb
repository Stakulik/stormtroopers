module Api::V1
  class SessionController < ApplicationController
    require "auth_token"

    before_action :authenticate_request!, only: [:destroy]
    before_action :get_user_by_credentials, only: [:create]
    before_action :check_user_confirmation, only: [:create]

    def create
      if @user
        auth_token = @user.auth_tokens.create(content: AuthToken.encode({ user_id: @user.id }))

        render json: authentication_payload(@user, auth_token&.content), status: :ok
      else
        render json: { errors: "That email/password combination is not valid" }, status: :bad_request
      end
    end

    def destroy
      AuthToken.find_by(content: @auth_token).destroy

      render json: { success: "Logged out successfully" }, status: :ok
    end

    private

    def get_user_by_credentials
      @user = User.find_by_credentials(params.dig(:user, :email), params.dig(:user, :password))
    end

    def authentication_payload(user, auth_token)
      return nil unless user && user.id

      {
        auth_token: auth_token,
        user: { id: user.id, email: user.email }
      }
    end
  end
end
