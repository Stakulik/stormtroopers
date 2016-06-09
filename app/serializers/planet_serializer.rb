class PlanetSerializer < ActiveModel::Serializer
  attributes :id, :name

  self.root = "planet"
end
