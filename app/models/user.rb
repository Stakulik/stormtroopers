class User < ApplicationRecord

  attr_accessor :current_password

  has_many :auth_tokens, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }, length: { in: 6..30 }, 
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :first_name, length: { in: 3..30 }
  validates :last_name, length: { in: 3..30 }
  validates :password, length: { in: 6..20}, on: :create
  validates :password, length: { in: 6..20}, on: :update, unless: :password_blank?
  validates_presence_of :current_password, on: :update, unless: :reset_password?

  has_secure_password

  before_save do
    self.email = email.downcase
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
  end

  def self.find_by_credentials(email, password)
    return nil unless email && password

    User.find_by(email: email)&.authenticate(password)
  end

  private

  def password_blank?
    password.blank? && password_confirmation.blank?
  end

  def reset_password?
    self.reset_password_token
  end

end
