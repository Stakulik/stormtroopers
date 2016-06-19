module Api::V1
  class PlanetsController < ApplicationController
    before_action :authenticate_request!#, only: [:create, :update, :destroy]
    before_action :set_planet, only: [:show, :update, :destroy]

    def index
      planet = Planet.all

      render json: planet, each_serializer: Planets::IndexSerializer
    end

    def create
      planet = Planet.new(planet_params)

      if planet.save
        render json: planet, status: :created, serializer: Planets::ShowSerializer
      else
        render json: planet.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @planet, serializer: Planets::ShowSerializer
    end

    def update
      if @planet.update(planet_params)
        render json: @planet, status: :ok, serializer: Planets::ShowSerializer
      else
        render json: @planet.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @planet.destroy

      render nothing: true, status: :no_content
    end

    private

    def set_planet
      @planet = Planet.find(params[:id])
    end

    def planet_params
      params.require(:planet).permit(:name, :rotation_period, :orbital_period, :diameter, :climate, :gravity, :terrain,
        :surface_water, :population, :url)
    end

  end
end
