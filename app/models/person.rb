class Person < ApplicationRecord
  has_and_belongs_to_many :starships, join_table: :pilots_starships
  belongs_to :homeworld, class_name: "Planet", foreign_key: :planet_id
  
  validates_presence_of :name, :birth_year, :eye_color, :gender, :hair_color, :height, :mass, :url,
    :skin_color
end
