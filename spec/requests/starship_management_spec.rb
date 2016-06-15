require "rails_helper"

describe "Starship:", type: :request do
  let!(:starship) { create(:starship) }
  let(:confirmed_user) { create(:user, :confirmed) }
  let(:headers_with_auth_token) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": User.last.auth_token } }

  context "authenticated user" do
    it "can see all starships" do
      log_in(confirmed_user)

      get v1_starships_path, nil, headers_with_auth_token

      expect(response.status).to eq(200)
    end

    it "creates a new starship" do
      log_in(confirmed_user)

      post v1_starships_path, { starship: attributes_for(:starship, name: "") }, headers_with_auth_token

      expect(response.status).to eq(422)

      post v1_starships_path, { starship: attributes_for(:starship, name: "My starship") }, headers_with_auth_token

      expect(response.status).to eq(201)

      get v1_starship_path(Starship.last), nil, headers_with_auth_token

      expect(response.body).to include("My starship")
    end

    it "updates a starship" do
      log_in(confirmed_user)

      get v1_starship_path(starship), nil, headers_with_auth_token

      expect(response.body).to include(starship.name)

      put v1_starship_path(starship), { starship: attributes_for(:starship, name: "") }, headers_with_auth_token

      expect(response.status).to eq(422)

      put v1_starship_path(starship), { starship: attributes_for(:starship, name: "Starship 3000") }, headers_with_auth_token

      expect(response.status).to eq(200)

      get v1_starship_path(starship), nil, headers_with_auth_token

      expect(response.body).to include("Starship 3000")
    end

    it "destroys a starship" do
      log_in(confirmed_user)

      delete v1_starship_path(starship), nil, headers_with_auth_token

      expect(response.status).to eq(204)

      get v1_starship_path(starship), nil, headers_with_auth_token

      expect(response.status).to eq(404)
    end
  end

  context "not authenticated user" do
    it "can't see all starships" do
      get v1_starships_path, nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)
    end

    it "can't create a new starship" do
      post v1_starships_path, { starship: attributes_for(:starship, name: "My starship") }, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)

      get v1_starship_path(Starship.last), nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)
    end

    it "can't update a starship" do
      get v1_starship_path(starship), nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)

      put v1_starship_path(starship), { starship: attributes_for(:starship, name: "starship 3000") },
        { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)
    end

    it "can't destroy a starship" do
      delete v1_starship_path(starship), nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)
    end
  end
end
