require "faker"

FactoryGirl.define do
  factory :planet, aliases: [:homeworld] do
    name            Faker::StarWars.planet
    rotation_period Faker::Number.number(2)
    orbital_period  Faker::Number.number(3)
    terrain         "canyons, sinkholes"
    population      Faker::Number.number(6)
    climate         "temperate"
    diameter        Faker::Number.number(4)
    gravity         "3 not standard"
    surface_water   Faker::Number.number(2)
    url             "http://swapi.co/api/planets/"
  end
end
