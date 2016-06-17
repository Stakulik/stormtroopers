require "rails_helper"

describe "Planet:", type: :request do
  let!(:planet) { create(:planet) }
  let(:confirmed_user) { create(:user, :confirmed) }
  let(:headers) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": AuthToken.last&.content } }

  context "authenticated user" do
    it "can see all planets" do
      log_in(confirmed_user)

      get v1_planets_path, nil, headers

      expect(response.status).to eq(200)
    end

    it "creates a new planet" do
      log_in(confirmed_user)

      post v1_planets_path, { planet: attributes_for(:planet, name: "") }, headers

      expect(response.status).to eq(422)

      post v1_planets_path, { planet: attributes_for(:planet, name: "My planet") }, headers

      expect(response.status).to eq(201)

      get v1_planet_path(Planet.last), nil, headers

      expect(response.body).to include("My planet")
    end

    it "updates a planet" do
      log_in(confirmed_user)

      get v1_planet_path(planet), nil, headers

      expect(response.body).to include(planet.name)

      put v1_planet_path(planet), { planet: attributes_for(:planet, name: "") }, headers

      expect(response.status).to eq(422)

      put v1_planet_path(planet), { planet: attributes_for(:planet, name: "Planet 3000") }, headers

      expect(response.status).to eq(200)

      get v1_planet_path(planet), nil, headers

      expect(response.body).to include("Planet 3000")
    end

    it "destroys a planet" do
      log_in(confirmed_user)

      delete v1_planet_path(planet), nil, headers

      expect(response.status).to eq(204)

      get v1_planet_path(planet), nil, headers

      expect(response.status).to eq(404)
    end
  end

  context "not authenticated user" do
    it "can't see all planets" do
      get v1_planets_path, nil, headers

      expect(response.status).to eq(401)
    end

    it "can't create a new planet" do
      post v1_planets_path, { planet: attributes_for(:planet, name: "My planet") }, headers

      expect(response.status).to eq(401)

      get v1_planet_path(Planet.last), nil, headers

      expect(response.status).to eq(401)
    end

    it "can't update a planet" do
      get v1_planet_path(planet), nil, headers

      expect(response.status).to eq(401)

      put v1_planet_path(planet), { planet: attributes_for(:planet, name: "Planet 3000") }, headers

      expect(response.status).to eq(401)
    end

    it "can't destroy a planet" do
      delete v1_planet_path(planet), nil, headers

      expect(response.status).to eq(401)
    end
  end
end
