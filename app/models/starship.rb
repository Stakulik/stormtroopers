class Starship < ApplicationRecord
  include PgSearch
  pg_search_scope :search_in_name, against: [:name], using: { tsearch: { prefix: true } }

  has_and_belongs_to_many :pilots, class_name: "Person", join_table: :pilots_starships

  validates_presence_of :name, :model, :manufacturer, :cost_in_credits, :max_atmosphering_speed,
                        :passengers, :cargo_capacity, :consumables, :hyperdrive_rating, :MGLT,
                        :starship_class, :length, :crew, :url

  before_validation { self.url ||= "swapi.co" }
end
