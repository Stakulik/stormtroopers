require "rails_helper"

describe "User", type: :request do
  let(:user) { create(:user) }
  let(:confirmed_user) { create(:user, :confirmed) }
  let(:headers_with_auth_token) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": User.last.auth_token } }

  describe "signup:" do
    it "sends valid data, gets a success message and confirms an account" do
      post v1_signup_path, user: attributes_for(:user)

      expect(response.body).to include("Please go to your inbox #{User.last.email} and confirm creating an account")

      get v1_confirmation_path(confirmation_token: User.last.confirmation_token)

      expect(response.body).to include("Your account has been successfully confirmed")
    end

    it "User sends invalid data and get errors" do
      post v1_signup_path, user: attributes_for(:user, password: "pas", email: "" )

      expect(response.body).to include( "errors")
    end
  end

  describe "log in and log out" do
    context "authenticated" do
      it "successfully" do
        log_in(confirmed_user)

        delete v1_logout_path, nil, headers_with_auth_token

        expect(response.body).to include("Logged out successfully")
      end
    end

    context "not authenticated" do
      it "unsuccessfully log in" do
        post v1_login_path, {email: confirmed_user.email, password: "wrongPassword"}

        expect(response.body).to include("That email/password combination is not valid")

        get v1_user_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json" }

        expect(response.body).to include("Not Authenticated")
      end

      it "unsuccessfully log out" do
        delete v1_logout_path, nil, { "HTTP_ACCEPT": "application/json" }

        expect(response.body).to include("Not Authenticated")
      end
    end
  end

  describe "forgot password" do
    context "with a confirmed account" do
      it "successfully" do
        post v1_forgot_password_path, {email: confirmed_user.email}

        expect(response.body).to include("We've send instructions onto #{confirmed_user.email}")

        get v1_reset_password_path, {reset_password_token: User.last.reset_password_token}

        expect(response.body).to include(confirmed_user.email)

        post v1_update_password_path, { user: { email: confirmed_user.email, password: "",
          password_confirmation: "newpassword" } }

        expect(response.body).to include("errors")

        post v1_update_password_path, { user: { email: confirmed_user.email, password: "newpassword",
          password_confirmation: "newpassword" } }

        expect(response.body).to include("Password updated successfully")

        log_in(confirmed_user, nil, "newpassword")
      end
    end

    context "with an unconfirmed account" do
      it "gets errors" do
        post v1_forgot_password_path, {email: user.email}

        expect(response.body).to include("errors")

        post v1_update_password_path, { user: { email: user.email, password: "newpassword",
          password_confirmation: "newpassword" } }

        expect(response.body).to include("errors")
      end
    end
  end

  describe "update an account" do
    context "authenticated" do
      it "updates a first name and a last name successfully" do
        log_in(confirmed_user)

        put v1_user_path(confirmed_user), { user: { first_name: "Francisco", last_name: "D'anconia" } },
          headers_with_auth_token

        expect(response.body).to include("errors")

        put v1_user_path(confirmed_user), { user: { first_name: "Francisco", last_name: "D'anconia",
          current_password: "qazwsx"} }, headers_with_auth_token

        expect(response.body).to include("success")

        get v1_user_path(confirmed_user), nil, headers_with_auth_token

        expect(response.body).to include("Francisco")
      end

      it "updates a password successfully" do
        log_in(confirmed_user)

        put v1_user_path(confirmed_user), { user: { password: "newpassword", password_confirmation: "newpassword" } },
          headers_with_auth_token

        expect(response.body).to include("errors")

        put v1_user_path(confirmed_user), { user: { password: "newpassword", password_confirmation: "newpassword",
          current_password: "qazwsx"} }, headers_with_auth_token

        expect(response.body).to include("success")

        delete v1_logout_path, nil, headers_with_auth_token

        log_in(confirmed_user, nil, "newpassword")
      end

      it "updates an email successfully" do
        log_in(confirmed_user)

        put v1_user_path(confirmed_user), { user: { email: "w@e", current_password: "qazwsx" } }, headers_with_auth_token

        expect(response.body).to include("errors")

        put v1_user_path(confirmed_user), { user: { email: "new@example.com" } }, headers_with_auth_token

        expect(response.body).to include("errors")

        put v1_user_path(confirmed_user), { user: { email: "new@example.com", current_password: "qazwsx"} },
          headers_with_auth_token

        expect(response.body).to include("success")

        get v1_user_path(confirmed_user), nil, headers_with_auth_token

        expect(response.body).to include(User.last.email)
      end
    end
  end

  describe "destroy an account" do
    context "authenticated" do
      it "successfully" do
        log_in(confirmed_user)

        delete v1_destroy_account_path, nil, headers_with_auth_token

        expect(response.body).to include("success")          
      end
    end

    context "not authenticated" do
      it "gets errors" do
        log_in(confirmed_user)

        delete v1_destroy_account_path, nil, { "HTTP_ACCEPT": "application/json" }

        expect(response.body).to include("errors")          
      end
    end
  end
end