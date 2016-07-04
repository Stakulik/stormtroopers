class Starship < ApplicationRecord
  has_and_belongs_to_many :pilots, class_name: "Person", join_table: :pilots_starships

  validates_presence_of :name, :model, :max_atmosphering_speed, :cost_in_credits
end
