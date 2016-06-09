class Starship < ApplicationRecord
  has_and_belongs_to_many :pilots, class_name: "Person", foreign_key: :person_id
  
end
