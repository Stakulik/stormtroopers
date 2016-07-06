source "https://rubygems.org"
ruby "2.3.0"

gem "rails", ">= 5.0.0.rc1", "< 5.1"

gem "puma", "~> 3.0"

gem "pg"
gem "pg_search"

gem "jwt"

gem "active_model_serializers", "~> 0.9.3"

gem "rest-client"

gem "bcrypt", "~> 3.1.7"

gem "haml-rails", "~> 0.9.0"

gem "kaminari"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem "byebug", platform: :mri
  gem "factory_girl_rails"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "timecop", "~> 0.8.1"
  gem "guard-bundler", require: false
  gem "guard-rspec", require: false
  gem "guard-zeus", require: false
  gem "guard-rails", require: false
  gem "guard-migrate", require: false
  gem "rubocop", "~> 0.41.0", require: false
end

group :development do
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "faker", "~> 1.6.0"
end

group :production do
  gem "rails_12factor"
end
