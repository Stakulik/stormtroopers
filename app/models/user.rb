class User < ApplicationRecord
  validates :email, uniqueness: { case_sensitive: false }, length: { in: 6..30 }, 
                  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_secure_password

  before_save { self.email = email.downcase }

end
