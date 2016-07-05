class AuthToken < ApplicationRecord
  belongs_to :user

  validates :content, uniqueness: true, length: { minimum: 1 }
  validates_presence_of :user_id
  validates_presence_of :expired_at

  before_validation { self.expired_at = 73.hours.from_now }

  def self.encode(payload, ttl_in_minutes = 60 * 24 * 3)
    payload[:exp] = ttl_in_minutes.minutes.from_now.to_i

    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token, leeway = nil)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, leeway: leeway)

    HashWithIndifferentAccess.new(decoded[0])
  end
end
