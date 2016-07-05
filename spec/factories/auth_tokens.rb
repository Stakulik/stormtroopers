FactoryGirl.define do
  factory :auth_token do
    content AuthToken.encode(user_id: 1)
    user
  end
end
