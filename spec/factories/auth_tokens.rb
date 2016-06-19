FactoryGirl.define do
  factory :auth_token do
    content     "adzgsdzogv"
    expired_at  nil
    user
  end
end
