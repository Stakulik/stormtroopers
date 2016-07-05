FactoryGirl.define do
  factory :planet, aliases: [:homeworld] do
    name            "Custom planet"
    rotation_period 33
    orbital_period  125
    terrain         "canyons, sinkholes"
    population      100500
    climate         "temperate"
    diameter        3000
    gravity         "3 not standard"
    surface_water   20
    url             "http://swapi.co/api/planets/"
  end
end
