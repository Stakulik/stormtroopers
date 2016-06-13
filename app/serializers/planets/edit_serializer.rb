class Planets::EditSerializer < PlanetSerializer
  attributes(*(Planet.attribute_names - ["created_at", "updated_at"] ).map(&:to_sym))

end
