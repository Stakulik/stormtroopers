class SwUnits::IndexSerializer < SwUnitSerializer

  def attributes
    filter_main_params(object)
  end

  def filter_main_params(object)
    params = %w(id name created_at updated_at)

    params << "birth_year" if object.class.to_s == "Person"

    object.attributes.select { |key, v| params.include?(key) }
  end
end
