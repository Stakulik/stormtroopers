class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :password_confirmation
end
