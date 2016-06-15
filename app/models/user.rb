class User < ApplicationRecord

  attr_accessor :current_password

  validates :email, uniqueness: { case_sensitive: false }, length: { in: 6..30 }, 
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :first_name, length: { in: 3..30 }
  validates :last_name, length: { in: 3..30 }
  validates :password, length: { in: 6..20}
  validates_presence_of :current_password, on: :update
  
  before_save do
    self.email = email.downcase
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
    self.auth_token = "-"
  end

  has_secure_password

  def self.find_by_credentials(email, password)
    return nil unless email && password

    User.find_by(email: email)&.authenticate(password)
  end

end
