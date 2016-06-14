class Planets::ShowSerializer < PlanetSerializer
  embed :ids, include: true

  # attributes(*(Planet.attribute_names - ["created_at", "updated_at"] ).map(&:to_sym))
  attributes :name, :rotation_period, :orbital_period, :terrain, :population

  has_many :residents, serializer: People::IndexSerializer

end
