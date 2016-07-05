FactoryGirl.define do
  factory :starship do
    name                    "Custom space ship"
    model                   "Suppa Turbo 3"
    max_atmosphering_speed  30234
    cost_in_credits         130000
    manufacturer            "Incom Corporation"
    passengers              300
    cargo_capacity          934934
    hyperdrive_rating       10.3
    consumables             "1 week"
    MGLT                    "100"
    starship_class          "Starfighter"
    length                  500.2
    crew                    29
    url                     "http://swapi.co/api/starships/"
  end
end
