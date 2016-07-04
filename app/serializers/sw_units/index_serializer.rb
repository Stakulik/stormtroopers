class SwUnits::IndexSerializer < SwUnitSerializer

  def attributes
    filter_main_params(object)
  end

  def filter_main_params(object)
    params =
      if object.class.to_s == "Person"
        %w(id name birth_year)
      else
        %w(id name)
      end

    object.attributes.select { |key, v| params.include?(key) }
  end
end
