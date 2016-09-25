# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: ENV["SG_USER_NAME"],
  password: ENV["SG_PASSWORD"],
  domain: ENV["BACKEND_DOMAIN"],
  address: "smtp.sendgrid.net",
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

ActionMailer::Base.delivery_method = :smtp
