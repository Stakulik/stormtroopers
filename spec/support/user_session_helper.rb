module UserSessionHelper
  def log_in(user, email = nil, password = nil)
    post v1_login_path, user: { email: email || user.email, password: password || user.password }

    expect(response.body).to include("auth_token")

    get v1_users_path(user), nil, "HTTP_ACCEPT": "application/json",
                                  "AUTHORIZATION": AuthToken.last&.content

    expect(response.body).to include(User.last.email)
  end
end
