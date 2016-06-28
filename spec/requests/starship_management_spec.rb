require "rails_helper"

describe "Starship:", type: :request do
  it_behaves_like "sw unit", :starship
end
