class People::ShowSerializer < PersonSerializer
  embed :ids, include: true

  attributes(*(Person.attribute_names - ["created_at", "updated_at"] ).map(&:to_sym))

  has_many :starships, serializer: Starships::IndexSerializer

end
