module Api::V1
  class StarshipsController < ApplicationController

    before_action :set_starship, only: [:show, :update, :destroy]

    def index
      @starship = Starship.all

      render json: @starship, each_serializer: Starships::IndexSerializer
    end

    def create
      @starship = Starship.new(starship_params)

      if @starship.save
        render json: @starship, status: :created, serializer: Starships::ShowSerializer
      else
        render json: @starship.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @starship, serializer: Starships::ShowSerializer
    end

    def update
      if @starship.update(starship_params)
        render json: @starship, serializer: Starships::ShowSerializer
      else
        render json: @starship.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @starship.destroy

      head :no_content
    end

    private

    def set_starship
      @starship = Starship.find(params[:id])
    end

    def starship_params
      params.require(:starship).permit(:name, :model)
    end

  end
end
