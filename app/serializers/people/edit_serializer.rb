class People::EditSerializer < PersonSerializer

  attributes(*(Person.attribute_names - ["created_at", "updated_at"] ).map(&:to_sym))

end
