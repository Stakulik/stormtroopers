FactoryGirl.define do
  factory :user do
    email       "doe@example.com"
    first_name  "John"
    last_name   "Doe"
    password    "qazwsx"
    password_confirmation "qazwsx"
    auth_token  1

    trait :fan do
      email       "henry@example.com"
      first_name  "Henry"
      last_name   "Rearden"
    end

    trait :confirmed do
      confirmed_at        Time.now
      confirmation_token  nil
    end
  end
end
