class SwUnits::ShowSerializer < SwUnitSerializer
  def attributes
    unit_attributes = {}

    unit_attributes[object.class.to_s.downcase] = filter_additional_params(object)

    related_objects = get_related_objects(unit_attributes[object.class.to_s.downcase])

    add_data_about_related_objects(unit_attributes, related_objects)
  end

  def filter_additional_params(object)
    params = define_additional_params(object)

    object.attributes.select { |key, _v| params.include?(key) }
  end

  def add_data_about_related_objects(unit_attributes, related_objects)
    unit_attributes[object.class.to_s.downcase]["#{related_objects[0..-2]}_ids"] =
      related_ids(related_objects)

    unit_attributes[related_objects] = related_objects(related_objects)

    object.class.to_s == "Person" ? add_planet_for_person(unit_attributes) : unit_attributes
  end

  def related_ids(related_objects)
    object.send(related_objects).ids
  end

  def related_objects(related_objects)
    object.send(related_objects).map { |ro| filter_additional_params(ro) }
  end

  def add_planet_for_person(unit_attributes)
    unit_attributes["person"]["planet"] = Planet.find(object.planet_id)

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
