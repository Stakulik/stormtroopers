require "faker"

FactoryGirl.define do
  factory :person do
    name          Faker::StarWars.character
    birth_year    "19BBY"
    eye_color     Faker::Color.color_name
    gender        "male"
    hair_color    Faker::Color.color_name
    height        Faker::Number.decimal(2, 1)
    mass          Faker::Number.number(3)
    skin_color    Faker::Color.color_name
    url           "http://swapi.co/api/people/"
    homeworld
  end
end
