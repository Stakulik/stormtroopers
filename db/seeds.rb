ActiveRecord::Base.connection.execute("TRUNCATE PLANETS")
ActiveRecord::Base.connection.execute("TRUNCATE PEOPLE")
ActiveRecord::Base.connection.execute("TRUNCATE STARSHIPS")

def create_subject(data, i)
  if i == 0
    Planet.create(filter_planet_params(data))
  elsif i == 1
    Person.create(filter_person_params(data))
  else
    starship_to_pilots(data["pilots"], Starship.create(filter_starship_params(data)))
  end
end

def filter_planet_params(planet_data)
  planet_data.except("residents", "films", "created", "edited")
end

def filter_person_params(person_data)
  person_data["planet_id"] = Planet.where(url: person_data["homeworld"]).first.id rescue nil

  person_data.except("created", "edited", "films", "homeworld", "species", "vehicles", "starships")
end

def filter_starship_params(starship_data)
  starship_data.except("pilots", "films", "created", "edited")
end

def starship_to_pilots(pilots, starship)
  pilots.each do |pilot_url|
    pilot = Person.where(url: pilot_url).first rescue nil

    pilot.starships << starship if pilot
  end
end

["planets", "people", "starships"].each.with_index do |subject, i|

  1.upto(i == 0 ? 61 : i == 1 ? 87 : 37) do |c|
    raw_data = RestClient.get "https://swapi.co/api/#{subject}/#{c}/" rescue nil

    create_subject(JSON.parse(raw_data), i) if raw_data
  end
end
