require "rails_helper"

describe "User", type: :request do
  let(:user) { create(:user) }
  let(:confirmed_user) { create(:user, :confirmed) }
  let(:headers_with_auth_token) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": AuthToken.last&.content } }

  context "with a confirmed account" do
    context "successfully logs in and logs out" do
      it "using an auth token" do
        log_in(confirmed_user)

        delete v1_logout_path, nil, headers_with_auth_token

        expect(response.body).to include("Logged out successfully")

        delete v1_logout_path, nil, headers_with_auth_token

        expect(response.body).to include("Not Authenticated")

        get v1_users_path(confirmed_user), nil, headers_with_auth_token

        expect(response.body).to include("Not Authenticated")
      end

      it "using several auth tokens" do
        log_in(confirmed_user)

        first_token = AuthToken.where(user_id: confirmed_user).last.content

        Timecop.travel(Time.now + 10.minutes)
        
        log_in(confirmed_user)

        second_token = AuthToken.where(user_id: confirmed_user).last.content

        expect(first_token).to_not eq(second_token)

        get v1_users_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": first_token }

        expect(response.body).to include(confirmed_user.first_name)

        delete v1_logout_path, nil, { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": second_token }

        expect(response.body).to include("Logged out successfully")

        get v1_users_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": first_token }

        expect(response.body).to include(confirmed_user.first_name)
      end
    end

    it "gets errors due to invalid data when tries to log in" do
      post v1_login_path, { user: { email: confirmed_user.email, password: "wrongPassword" } }

      expect(response.body).to include("That email/password combination is not valid")

      delete v1_logout_path, nil, headers_with_auth_token

      expect(response.body).to include("Not Authenticated")
    end
  end

  context "with an unconfirmed account" do
    it "gets a message to confirm email when tries to log in" do
      post v1_login_path, { user: { email: user.email, password: user.password } }

      expect(response.body).to include("You have to confirm your email")

      delete v1_logout_path, nil, headers_with_auth_token

      expect(response.body).to include("Not Authenticated")
    end
  end

  context "without an account" do
    it "gets errors when tries to log in" do
      post v1_login_path, { user: { email: "wrong@email.com", password: "wrongPassword" } }

      expect(response.body).to include("That email/password combination is not valid")

      get v1_users_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.body).to include("Not Authenticated")

      delete v1_logout_path, nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.body).to include("Not Authenticated")
    end
  end
end
