require "rails_helper"

%w(starship planet person).each do |unit_type|
  describe unit_type.capitalize, type: :request do
    let!(:unit) { create(unit_type) }
    let!(:units_path) { unit_type == "person" ? "/v1/people" : "/v1/#{unit_type}s" }
    let(:unit_class) { Kernel.const_get(unit_type.capitalize) }
    let(:planet) { create(:planet) } # person requires a homeworld
    let(:confirmed_user) { create(:user, :confirmed) }
    let(:headers) { { "HTTP_ACCEPT": "application/json", "AUTHORIZATION": AuthToken.last&.content } }

    context "authenticated user" do
      it "can see all #{unit_type}s" do
        log_in(confirmed_user)

        get units_path.to_s, nil, headers

        expect(response.status).to eq(200)
      end

      it "creates a new #{unit_type}" do
        log_in(confirmed_user)

        post units_path.to_s, { "#{unit_type}": attributes_for(unit_type, name: "") }, headers

        expect(response.status).to eq(422)

        post units_path.to_s,
             { "#{unit_type}": attributes_for(unit_type,
                                              name: "My #{unit_type}",
                                              planet_id: planet.id) },
             headers

        expect(response.status).to eq(201)

        get "#{units_path}/#{unit_class.last.id}", nil, headers

        expect(response.body).to include("My #{unit_type}")
      end

      it "updates a #{unit_type}" do
        log_in(confirmed_user)

        get "#{units_path}/#{unit.id}", nil, headers

        expect(response.body).to include(unit.name)

        put "#{units_path}/#{unit.id}",
            { "#{unit_type}": attributes_for(unit_type, name: "") },
            headers

        expect(response.status).to eq(422)

        put "#{units_path}/#{unit.id}",
            { "#{unit_type}": attributes_for(unit_type, name: "#{unit_type} 3000") },
            headers

        expect(response.status).to eq(200)

        get "#{units_path}/#{unit.id}", nil, headers

        expect(response.body).to include("#{unit_type} 3000")
      end

      it "destroys a #{unit_type}" do
        log_in(confirmed_user)

        delete "#{units_path}/#{unit.id}", nil, headers

        expect(response.status).to eq(204)

        get "#{units_path}/#{unit.id}", nil, headers

        expect(response.status).to eq(404)
      end
    end

    context "not authenticated user" do
      it "can't see all #{unit_type}s" do
        get units_path.to_s, nil, headers

        expect(response.status).to eq(401)
      end

      it "can't create a new #{unit_type}" do
        post units_path.to_s,
             { "#{unit_type}": attributes_for(unit_type, name: "My #{unit_type}") },
             headers

        expect(response.status).to eq(401)

        get "#{units_path}/#{unit.id}", nil, headers

        expect(response.status).to eq(401)
      end

      it "can't update a #{unit_type}" do
        get "#{units_path}/#{unit.id}", nil, headers

        expect(response.status).to eq(401)

        put "#{units_path}/#{unit.id}",
            { "#{unit_type}": attributes_for(unit_type, name: "#{unit_type} 3000") },
            headers

        expect(response.status).to eq(401)
      end

      it "can't destroy a #{unit_type}" do
        delete "#{units_path}/#{unit.id}", nil, headers

        expect(response.status).to eq(401)
      end
    end

    describe "pagination" do
      context "user is able" do
        it "to change a count of #{unit_type}s and to move through the pages" do
          22.times { create(unit_type) }

          log_in(confirmed_user)

          get "#{units_path}/?page=1&per=4", nil, headers

          expect(response.body).to include("name")
          expect(response.body).to include("next_page")
          expect(response.body).to include('"prev_page":null')
          expect(response.body).to include('"total_pages":6')

          get "#{units_path}/?page=2&per=10", nil, headers

          expect(response.body).to include("next_page")
          expect(response.body).to include("prev_page")
          expect(response.body).to include('"total_pages":3')

          get "#{units_path}/?page=3&per=10", nil, headers

          expect(response.body).to include("total_count")
          expect(response.body).to include('"next_page":null')
        end
      end
    end

    describe "filter" do
      it "by name" do
        ("a".."m").each { |l| create(unit_type, name: l * 2) }

        log_in(confirmed_user)

        get "#{units_path}/?page=1&per=10&sort_by=name", nil, headers # default order=asc

        expect(response.body).to include("aa")
        expect(response.body).to_not include("mm")

        get "#{units_path}/?page=2&per=10&sort_by=name&order=asc", nil, headers

        expect(response.body).to include("mm")
        expect(response.body).to_not include("aa")

        get "#{units_path}/?page=1&per=10&sort_by=name&order=desc", nil, headers

        expect(response.body).to include("mm")
        expect(response.body).to_not include("aa")
      end
    end

    describe "#search" do
      it "successfully - a #{unit_type} exists" do
        log_in(confirmed_user)

        get "#{units_path}/search?query=#{unit.name[0, 2]}", nil, headers

        expect(response.body).to include(unit.name)
      end

      it "returns 404 - such name doesn't exist" do
        log_in(confirmed_user)

        get "#{units_path}/search?query=zz", nil, headers

        expect(response.status).to eq(404)
      end
    end
  end
end
