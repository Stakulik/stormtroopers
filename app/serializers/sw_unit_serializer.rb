class SwUnitSerializer < ActiveModel::Serializer
  attributes :id

  self.root = "sw_unit"
end
