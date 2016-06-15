require "rails_helper"

describe "Person:", type: :request do
  let!(:person) { create(:person) }
  let(:confirmed_user) { create(:user, :confirmed) }
  let(:headers_with_auth_token) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": User.last.auth_token } }

  context "authenticated user" do
    it "can see all people" do
      log_in(confirmed_user)

      get v1_people_path, nil, headers_with_auth_token

      expect(response.status).to eq(200)
    end

    it "creates a new person" do
      log_in(confirmed_user)

      post v1_people_path, { person: attributes_for(:person, name: "") }, headers_with_auth_token
      expect(response.body).to include("My person")

      expect(response.status).to eq(422)

      post v1_people_path, { person: attributes_for(:person, name: "My person") }, headers_with_auth_token

      expect(response.status).to eq(201)

      get v1_people_path(Person.last), nil, headers_with_auth_token

      expect(response.body).to include("My person")
    end

    it "updates a person" do
      log_in(confirmed_user)

      get v1_person_path(person), nil, headers_with_auth_token

      expect(response.body).to include(person.name)

      put v1_person_path(person), { person: attributes_for(:person, name: "") }, headers_with_auth_token

      expect(response.status).to eq(422)

      put v1_person_path(person), { person: attributes_for(:person, name: "Person 3000") }, headers_with_auth_token

      expect(response.status).to eq(200)

      get v1_person_path(person), nil, headers_with_auth_token

      expect(response.body).to include("Person 3000")
    end

    it "destroys a person" do
      log_in(confirmed_user)

      delete v1_person_path(person), nil, headers_with_auth_token

      expect(response.status).to eq(204)

      get v1_person_path(person), nil, headers_with_auth_token

      expect(response.status).to eq(404)
    end
  end

  context "not authenticated user" do
    it "can't see all people" do
      get v1_people_path, nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)
    end

    it "can't create a new person" do
      post v1_people_path, { person: attributes_for(:person, name: "My person") }, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)

      get v1_person_path(Person.last), nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)
    end

    it "can't update a person" do
      get v1_person_path(person), nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)

      put v1_person_path(person), { person: attributes_for(:person, name: "person 3000") },
        { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)
    end

    it "can't destroy a person" do
      delete v1_person_path(person), nil, { "HTTP_ACCEPT": "application/json" }

      expect(response.status).to eq(401)
    end
  end
end