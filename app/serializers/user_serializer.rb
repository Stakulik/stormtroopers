class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :password_confirmation

  self.root = "user"
end
