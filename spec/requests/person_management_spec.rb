require "rails_helper"

describe "Person", type: :request do
  it_behaves_like "sw unit", :person
end
