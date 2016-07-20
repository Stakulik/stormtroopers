class Planet < ApplicationRecord
  include PgSearch
  pg_search_scope :search_in_name, against: [:name], using: { tsearch: { prefix: true } }

  has_many :residents, class_name: "Person", dependent: :destroy

  validates_presence_of :name, :rotation_period, :orbital_period, :climate, :diameter, :gravity,
                        :surface_water, :terrain, :population, :url

  def initialize
    super

    self.url = "swapi.co"
  end
end
