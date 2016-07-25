class SwUnits::ShowSerializer < SwUnitSerializer
  def attributes

    unit_attributes = {}

    unit_attributes["#{object.class.to_s.downcase}"] = filter_additional_params(object)

    add_related_objects(unit_attributes)
  end

  def filter_additional_params(object)
    params = define_additional_params(object)

    object.attributes.select { |key, _v| params.include?(key) }
  end

  def add_related_objects(unit_attributes)

    related_objects = get_related_objects(unit_attributes["#{object.class.to_s.downcase}"])

    unit_attributes["#{related_objects[0..-2]}_ids"] = object.send(related_objects).map(&:id)

    unit_attributes[related_objects] = object.send(related_objects).map do |ro|
      filter_additional_params(ro)
    end

    unit_attributes["planet"] = Planet.find(object.planet_id) if object.class.to_s == "Person"

    unit_attributes
  end

  def define_additional_params(object)
    if object.class.to_s == "Person"
      %w(id name birth_year eye_color gender hair_color height mass skin_color planet_id created_at
         updated_at)
    elsif object.class.to_s == "Planet"
      %w(id name rotation_period orbital_period climate diameter gravity surface_water terrain
         population created_at updated_at)
    else
      %w(id name model manufacturer cost_in_credits max_atmosphering_speed passengers consumables
         cargo_capacity hyperdrive_rating MGLT starship_class length crew created_at updated_at)
    end
  end

  def get_related_objects(filtered_object)
    if filtered_object.key?("gender")
      "starships"
    elsif filtered_object.key?("gravity")
      "residents"
    else
      "pilots"
    end
  end
end
