ActiveRecord::Base.connection.execute("TRUNCATE PEOPLE")
ActiveRecord::Base.connection.execute("TRUNCATE STARSHIPS")

def filter_starship_params(starship_data)
  starship_data.except("manufacturer", "cost_in_credits", "max_atmosphering_speed", "crew", "passengers",
                        "cargo_capacity", "consumables", "hyperdrive_rating", "MGLT", "starship_class", 
                        "pilots", "films", "created", "edited", "url", "length")
end

def filter_person_params(person_data)
  person_data.except("url", "created", "edited", "films", "homeworld", "species", "vehicles", "starships")
end

1.upto(15) do |c|

  sleep(0.5) if c % 4 == 0

  [ "people", "starships" ].each.with_index do |subject, i|

    raw_data = RestClient.get "https://swapi.co/api/#{subject}/#{c}/" rescue nil

    next unless raw_data

    data = JSON.parse(raw_data)

    if i == 0
      Person.create(filter_person_params(data))
    else
      Starship.create(filter_starship_params(data))
    end
  end
end
