require "rails_helper"

describe "User", type: :request do
  let(:user) { create(:user) }
  let(:confirmed_user) { create(:user, :confirmed) }
  let(:headers) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": AuthToken.last&.content } }

  context "with a confirmed account" do
    context "successfully logs in and logs out" do
      it "using an auth token" do
        log_in(confirmed_user)

        delete v1_logout_path, nil, headers

        expect(response.body).to include("Logged out successfully")

        delete v1_logout_path, nil, headers

        expect(response.body).to include("Not Authenticated")

        get v1_users_path(confirmed_user), nil, headers

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

      delete v1_logout_path, nil, headers

      expect(response.body).to include("Not Authenticated")
    end
  end

  context "with an unconfirmed account" do
    it "gets a message to confirm email when tries to log in" do
      post v1_login_path, { user: { email: user.email, password: user.password } }

      expect(response.body).to include("You have to confirm your email")

      delete v1_logout_path, nil, headers

      expect(response.body).to include("Not Authenticated")
    end
  end

  context "without an account" do
    it "gets errors when tries to log in" do
      post v1_login_path, { user: { email: "wrong@email.com", password: "wrongPassword" } }

      expect(response.body).to include("That email/password combination is not valid")

      get v1_users_path(confirmed_user), nil, headers

      expect(response.body).to include("Not Authenticated")

      delete v1_logout_path, nil, headers

      expect(response.body).to include("Not Authenticated")
    end
  end

  describe "sliding expiration" do
    context "an auth token expires today" do
      it "and a client gets a new one" do
        log_in(confirmed_user)

        old_auth_token = AuthToken.last&.content

        Timecop.travel(Time.now + 71.hours)

        get v1_users_path(confirmed_user), nil, headers

        expect(response.headers).to include("X-APP-TOKEN")

        new_auth_token = AuthToken.last&.content

        expect(old_auth_token).to_not eq(new_auth_token)

        get v1_users_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": new_auth_token }

        expect(response.body).to include(User.last.email)

        get v1_users_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": old_auth_token }

        expect(response.body).to include(User.last.email)

        Timecop.travel(Time.now + 71.hours)

        get v1_users_path(confirmed_user), nil, { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": new_auth_token }

        expect(response.body).to include(User.last.email)
      end

      it "but a client gets errors because ip-addresses don't match" do
        log_in(confirmed_user)

        AuthToken.last&.update_attribute(:content, AuthToken.encode({ user_id: confirmed_user.id, ip: "192.168.1.1" }))

        Timecop.travel(Time.now + 71.hours)

        get v1_users_path(confirmed_user), nil, headers

        expect(response.headers).to_not include("X-APP-TOKEN")

        get v1_users_path(confirmed_user), nil, headers

        expect(response.body).to include("Not Authenticated")
      end
    end

    context "an auth token expires tomorrow" do
      it "and a client doesn't receive a new one" do
        log_in(confirmed_user)

        Timecop.travel(Time.now + 47.hours)

        get v1_users_path(confirmed_user), nil, headers

        expect(response.headers).to_not include("X-APP-TOKEN")
      end
    end
  end
end
