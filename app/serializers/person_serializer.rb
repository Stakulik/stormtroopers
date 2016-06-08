class PersonSerializer < ActiveModel::Serializer
  attributes :id

  self.root = "person"
end
