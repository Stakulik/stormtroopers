class Planet < ApplicationRecord
  has_many :residents, class_name: "Person"
  
  validates :name, :rotation_period, :orbital_period, :terrain, :population, length: { in: 3..30 }
end
