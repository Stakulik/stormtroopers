class Users::EditSerializer < UserSerializer
  attributes(*(Person.attribute_names - ["created_at", "updated_at"] ).map(&:to_sym))

end
