class Starships::ShowSerializer < StarshipSerializer
  embed :ids, include: true

  # attributes(*(Starship.attribute_names - ["created_at", "updated_at"] ).map(&:to_sym))
  attributes :id, :name, :model, :manufacturer, :max_atmosphering_speed, :cost_in_credits

  has_many :pilots, serializer: People::IndexSerializer
end
