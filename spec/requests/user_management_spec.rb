require "rails_helper"

describe "User", type: :request do
  let(:user) { create(:user) }
  let(:confirmed_user) { create(:user, :confirmed) }
  let(:headers) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": AuthToken.last&.content } }

  describe "signup" do
    it "successfully" do
      post v1_signup_path, user: attributes_for(:user)

      expect(response.body).to include(
        "Please go to your inbox #{User.last.email} and confirm creating an account"
      )

      get v1_confirmation_path(confirmation_token: User.last.confirmation_token)

      expect(response.body).to include("Thanks for signing up for Stormtroopers application")

      get v1_users_path(User.last), nil, headers

      expect(response.body).to include(User.last.email)
    end

    it "gets errors (sends invalid data)" do
      post v1_signup_path, user: attributes_for(:user, password: "pas", email: "")

      expect(response.body).to include("errors")
    end

    it "a confirmation link expires after 24 hours" do
      post v1_signup_path, user: attributes_for(:user)

      expect(response.body).to include(
        "Please go to your inbox #{User.last.email} and confirm creating an account"
      )

      Timecop.travel(Time.now + 25.hours)

      get v1_confirmation_path(confirmation_token: User.last.confirmation_token)

      expect(response.body).to include("Authentication Timeout")

      Timecop.travel(Time.now - 70.minutes)

      get v1_confirmation_path(confirmation_token: User.last.confirmation_token)

      expect(response.body).to include("Thanks for signing up for Stormtroopers application")
    end
  end

  context "authenticated" do
    describe "updates account's" do
      it "first name and last name successfully" do
        log_in(confirmed_user)

        put v1_users_path(confirmed_user),
            { user: { first_name: "Francisco", last_name: "D'anconia" } },
            headers

        expect(response.body).to include("errors")

        put v1_users_path(confirmed_user),
            { user: { first_name: "Francisco", last_name: "D'anconia",
                      current_password: "wrongPassword" } },
            headers

        expect(response.body).to include("errors")

        put v1_users_path(confirmed_user),
            { user: { first_name: "Francisco", last_name: "D'anconia",
                      current_password: confirmed_user.password } },
            headers

        expect(response.body).to include("Your profile has been update successfully")

        get v1_users_path(confirmed_user), nil, headers

        expect(response.body).to include("Francisco")
      end

      it "password successfully" do
        log_in(confirmed_user)

        put v1_users_path(confirmed_user),
            { user: { password: "newpassword", password_confirmation: "newpassword" } },
            headers

        expect(response.body).to include("errors")

        put v1_users_path(confirmed_user),
            { user: { password: "newpassword", password_confirmation: "newpassword",
                      current_password: confirmed_user.password } },
            headers

        expect(response.body).to include("Your profile has been update successfully")

        delete v1_logout_path, nil, headers

        expect(response.body).to include("Logged out successfully")

        log_in(confirmed_user, nil, "newpassword")
      end

      it "email successfully" do
        log_in(confirmed_user)

        put v1_users_path(confirmed_user),
            { user: { email: "w@e", current_password: confirmed_user.password } },
            headers

        expect(response.body).to include("errors")

        put v1_users_path(confirmed_user), { user: { email: "new@example.com" } }, headers

        expect(response.body).to include("errors")

        put v1_users_path(confirmed_user),
            { user: { email: "new@example.com", current_password: confirmed_user.password } },
            headers

        expect(response.body).to include("Your profile has been update successfully")

        get v1_users_path(confirmed_user), nil, headers

        expect(response.body).to include("new@example.com")
      end
    end

    describe "destroys an account" do
      it "successfully" do
        log_in(confirmed_user)

        delete v1_destroy_account_path, nil, headers

        expect(response.body).to include("Your account has been successfully destroyed")

        get v1_users_path(confirmed_user), nil, headers

        expect(response.body).to include("Not Authenticated")
      end
    end
  end

  context "not authenticated" do
    describe "get's errors when updates account's" do
      it "first name and last name" do
        post v1_login_path, user: { email: confirmed_user.email, password: "wrongPassword" }

        expect(response.body).to include("errors")

        put v1_users_path(confirmed_user),
            { user: { first_name: "Francisco", last_name: "D'anconia",
                      current_password: confirmed_user.password } },
            headers

        expect(response.body).to include("Not Authenticated")
      end

      it "password" do
        post v1_login_path, user: { email: confirmed_user.email, password: "wrongPassword" }

        expect(response.body).to include("errors")

        put v1_users_path(confirmed_user),
            { user: { password: "newpassword", password_confirmation: "newpassword",
                      current_password: confirmed_user.password } },
            headers

        expect(response.body).to include("Not Authenticated")
      end

      it "email" do
        post v1_login_path, user: { email: confirmed_user.email, password: "wrongPassword" }

        expect(response.body).to include("errors")

        put v1_users_path(confirmed_user),
            { user: { email: "new@example.com", current_password: confirmed_user.password } },
            headers

        expect(response.body).to include("Not Authenticated")
      end
    end

    describe "destroys an account" do
      it "unsuccessfully" do
        delete v1_destroy_account_path, nil, headers

        expect(response.body).to include("Not Authenticated")
      end
    end
  end
end
