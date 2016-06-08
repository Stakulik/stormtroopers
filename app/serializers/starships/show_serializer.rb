class Starships::ShowSerializer < StarshipSerializer
  embed :ids, include: true

  attributes(*(Starship.attribute_names - ["created_at", "updated_at"] ).map(&:to_sym))

  has_many :people, serializer: People::IndexSerializer

end
