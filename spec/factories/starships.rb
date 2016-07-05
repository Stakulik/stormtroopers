FactoryGirl.define do
  factory :starship do
    name                    Faker::StarWars.vehicle
    model                   Faker::Lorem.word.capitalize
    max_atmosphering_speed  Faker::Number.number(5)
    cost_in_credits         Faker::Number.number(6)
    manufacturer            Faker::Company.name
    passengers              Faker::Number.number(3)
    cargo_capacity          Faker::Number.number(6)
    hyperdrive_rating       Faker::Number.decimal(2, 1)
    consumables             "1 week"
    MGLT                    "100"
    starship_class          "Starfighter"
    length                  Faker::Number.decimal(3, 1)
    crew                    Faker::Number.number(3)
    url                     "http://swapi.co/api/starships/"
  end
end
