FactoryGirl.define do
  factory :planet, aliases: [:homeworld] do
    name            "Custom planet"
    rotation_period "33"
    orbital_period  "25"
    terrain         "canyons, sinkholes"
    population      "100500"
    url             ""
  end
end
