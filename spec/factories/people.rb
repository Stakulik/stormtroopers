FactoryGirl.define do
  factory :person do
    name          "Rambo"
    birth_year    "1930"
    eye_color     "grey"
    gender        "male"
    hair_color    "-"
    height        "1.98"
    mass          "103"
    skin_color    "brown"
    url         ""
    planet_id      1
    homeworld

    before(:create) { create(:planet) }
  end
end
