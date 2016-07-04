class Planet < ApplicationRecord
  has_many :residents, class_name: "Person", dependent: :destroy
  
  validates_presence_of :name, :rotation_period, :orbital_period, :terrain, :population
end
