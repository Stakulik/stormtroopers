class Starship < ApplicationRecord
  has_and_belongs_to_many :pilots, class_name: "Person", join_table: :pilots_starships
  
end
