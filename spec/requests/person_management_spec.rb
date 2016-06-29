require "rails_helper"

describe "Person", type: :request do
  include_examples "sw unit", :person
end
