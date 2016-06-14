class People::ShowSerializer < PersonSerializer
  embed :ids, include: true

  # attributes(*(Person.attribute_names - ["created_at", "updated_at"] ).map(&:to_sym))
  attributes :name, :birth_year, :eye_color, :gender, :hair_color, :height, :mass, :skin_color

  has_many :starships, serializer: Starships::IndexSerializer
end
