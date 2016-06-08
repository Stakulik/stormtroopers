class StarshipSerializer < ActiveModel::Serializer
  attributes :id, :name, :model

  self.root = "starship"
end
