FactoryGirl.define do
  factory :user do
    email       Faker::Internet.email
    first_name  Faker::Name.first_name
    last_name   Faker::Name.last_name
    password    "qazwsx"
    password_confirmation "qazwsx"
    auth_token  nil

    trait :confirmed do
      confirmed_at        Time.now
      confirmation_token  nil
    end
  end
end
