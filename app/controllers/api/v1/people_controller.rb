module Api::V1
  class PeopleController < ApplicationController
    # before_action :authenticate_request!#, only: [:create, :update, :destroy]
    before_action :set_person, only: [:show, :update, :destroy]

    def index
      people = Person.all

      render json: people, each_serializer: People::IndexSerializer
    end

    def create
      person = Person.new(person_params)

      if person.save
        render json: person, status: :created, serializer: People::ShowSerializer
      else
        render json: person.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @person, serializer: People::ShowSerializer
    end

    def update
      if @person.update(person_params)
        render json: @person, status: :ok, serializer: People::ShowSerializer
      else
        render json: @person.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @person.destroy

      render nothing: true, status: :no_content
    end

    private

    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:name, :birth_year, :eye_color, :gender, :hair_color, :height, :mass,
        :skin_color, :planet_id, :url)
    end

  end
end
