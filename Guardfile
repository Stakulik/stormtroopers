guard :bundler do
  require "guard/bundler"
  require "guard/bundler/verify"
  helper = Guard::Bundler::Verify.new

  files = ["Gemfile"]
  files += Dir["*.gemspec"] if files.any? { |f| helper.uses_gemspec?(f) }

  files.each { |file| watch(helper.real_path(file)) }
end

guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch("spec/rails_helper") { rspec.spec_dir }
  watch(rspec.spec_support) { "spec/requests" }
  # watch(rspec.spec_files) { rspec.spec_dir }

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w(erb haml slim))

  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  
  watch(rails.app_controller)  { "spec/requests" }
  watch(%r{^app/controllers/api/v1/(.+)_(controller)\.rb$}) { |m| "spec/requests/#{m[1]}_management_spec.rb" }
  watch("app/controllers/api/v1/people_controller.rb")  { "spec/requests/person_management_spec.rb" }
  watch("app/controllers/api/v1/session_controller.rb") { "spec/requests/user_sessions_spec.rb" } # переименовать
  watch("app/controllers/api/v1/users_controller.rb") do |m|
    [
      rspec.spec.call("requests/user_management"),
      rspec.spec.call("requests/user_forgot_password")
    ]
  end

  watch(%r{^spec/factories/(.+)\.rb$}) { |m| "spec/models/#{m[1][0..-2]}_spec.rb" }
  watch(%r{^spec/factories/people.rb$}) { |m| "spec/models/person_spec.rb" }

  # Rails config changes
  watch(rails.routes)          { "#{rspec.spec_dir}/requests" }
end
