class User < ApplicationRecord

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :validatable #:rememberable

end
