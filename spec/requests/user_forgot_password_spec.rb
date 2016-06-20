require "rails_helper"

describe "User forgots password", type: :request do
  let(:user) { create(:user) }
  let(:confirmed_user) { create(:user, :confirmed) }
  let(:headers) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": AuthToken.last&.content } }

  context "with a confirmed account" do
    it "successfully" do
      post v1_forgot_password_path, { email: confirmed_user.email }

      expect(response.body).to include("We've send instructions onto #{confirmed_user.email}")

      get v1_reset_password_path, { reset_password_token: User.last.reset_password_token }

      expect(response.body).to include(confirmed_user.email)

      post v1_update_password_path, { user: { email: confirmed_user.email, password: "",
        password_confirmation: "newpassword" } }

      expect(response.body).to include("errors")

      post v1_update_password_path, { user: { email: confirmed_user.email, password: "newpassword",
        password_confirmation: "newpassword" } }

      expect(response.body).to include("Your password has been changed")

      get v1_users_path(User.last), nil, headers

      expect(response.body).to include(User.last.email)
    end

    it "destroying other previous auth tokens" do
      log_in(confirmed_user)

      first_token = AuthToken.where(user_id: confirmed_user).last.content

      Timecop.travel(Time.now + 10.minutes)

      log_in(confirmed_user)

      second_token = AuthToken.where(user_id: confirmed_user).last.content

      Timecop.travel(Time.now + 10.minutes)

      log_in(confirmed_user)

      expect(AuthToken.where(user_id: confirmed_user).size).to eq(3)

      post v1_forgot_password_path, {email: confirmed_user.email}

      expect(response.body).to include("We've send instructions onto #{confirmed_user.email}")

      get v1_reset_password_path, {reset_password_token: User.last.reset_password_token}

      expect(response.body).to include(confirmed_user.email)

      post v1_update_password_path, { user: { email: confirmed_user.email, password: "newpassword",
        password_confirmation: "newpassword" } }

      expect(response.body).to include("Your password has been changed")

      get v1_users_path(User.last), nil, headers

      expect(response.body).to include(User.last.email)

      get v1_users_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": first_token }

      expect(response.body).to include("Not Authenticated")

      get v1_users_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": second_token }
      
      expect(response.body).to include("Not Authenticated")
    end
  end

  context "with an unconfirmed account" do
    it "gets errors" do
      post v1_forgot_password_path, {email: user.email}

      expect(response.body).to include("You have to confirm your email")

      get v1_reset_password_path, {reset_password_token: nil}

      expect(response.body).to include("Not Authenticated")

      post v1_update_password_path, { user: { email: user.email, password: "newpassword",
        password_confirmation: "newpassword" } }

      expect(response.body).to include("You have to confirm your email")
    end
  end

  context "and clicks on a reset token link:" do
    it "the link's expired before a click - gets a time out error" do
      post v1_forgot_password_path, { email: confirmed_user.email }

      expect(response.body).to include("We've send instructions onto #{confirmed_user.email}")

      confirmed_user.update_attribute(:reset_password_token, AuthToken.encode({ user_id: confirmed_user.id }, 120))

      Timecop.travel(Time.now + 121.minutes)

      get v1_reset_password_path, {reset_password_token: User.last.reset_password_token}

      expect(response.body).to include("Authentication Timeout")
    end

    it "the link hasn't expired before a click" do
      post v1_forgot_password_path, { email: confirmed_user.email }

      expect(response.body).to include("We've send instructions onto #{confirmed_user.email}")

      confirmed_user.update_attribute(:reset_password_token, AuthToken.encode({ user_id: confirmed_user.id }, 120))

      Timecop.travel(Time.now + 119.minutes)

      get v1_reset_password_path, {reset_password_token: User.last.reset_password_token}

      expect(response.body).to include(confirmed_user.email)
    end
  end
end
