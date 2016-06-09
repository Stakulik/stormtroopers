source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '>= 5.0.0.rc1', '< 5.1'

gem 'puma', '~> 3.0'

gem 'pg'

gem 'active_model_serializers', '~> 0.9.3'

gem 'rest-client'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem 'rails_12factor'
end