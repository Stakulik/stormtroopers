class Planet < ApplicationRecord
  has_many :residents, class_name: "Person", dependent: :destroy
  
  validates :name, :rotation_period, :orbital_period, :terrain, :population, length: { in: 1..50 }
end
