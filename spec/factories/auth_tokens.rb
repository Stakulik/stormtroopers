FactoryGirl.define do
  factory :auth_token do
    content     "adzgsdzogv"
    expired_at  Time.now + 1.day
    user
  end
end
