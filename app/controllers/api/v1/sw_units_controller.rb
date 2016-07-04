module Api::V1
  class SwUnitsController < ApplicationController
    before_action :authenticate_request!
    before_action :get_sw_unit_class
    before_action :get_sw_unit, only: [:show, :update, :destroy]
    before_action :define_sort_params, only: [:index]
    after_action :add_nav_links, only: [:index]

    def index
      @sw_units = @sw_unit_class.all.order(@prop => @sort).page(params[:page]).per(params[:per])

      render json: @sw_units, each_serializer: SwUnits::IndexSerializer
    end

    def create
      sw_unit = @sw_unit_class.new(sw_unit_params)

      if sw_unit.save
        render json: sw_unit, status: :created, serializer: SwUnits::ShowSerializer
      else
        render json: sw_unit.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @sw_unit, serializer: SwUnits::ShowSerializer
    end

    def update
      if @sw_unit.update(sw_unit_params)
        render json: @sw_unit, status: :ok, serializer: SwUnits::ShowSerializer
      else
        render json: @sw_unit.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @sw_unit.destroy

      render nothing: true, status: :no_content
    end

    private

    def get_sw_unit_class
      m = request.path.match /v1\/(\w{6,9})/

      @sw_unit_class = Kernel.const_get(define_class_name(m[1]).capitalize)
    end

    def define_class_name(raw_name)
      raw_name == "people" ? "person" : raw_name[0..-2]
    end

    def get_sw_unit
      @sw_unit = @sw_unit_class.find(params[:id])
    end

    def sw_unit_params
      if @sw_unit_class.to_s == "Starship" 
        params.require(:starship).permit(:name, :model, :manufacturer, :cost_in_credits, :length,
          :max_atmosphering_speed, :crew, :passengers, :cargo_capacity, :consumables,
          :hyperdrive_rating, :MGLT, :starship_class, :url)
      elsif @sw_unit_class.to_s == "Planet"
        params.require(:planet).permit(:name, :rotation_period, :orbital_period, :diameter,
          :climate, :gravity, :terrain, :surface_water, :population, :url)
      else
        params.require(:person).permit(:name, :birth_year, :eye_color, :gender, :hair_color,
          :height, :mass, :skin_color, :planet_id, :url)
      end
    end

    def define_sort_params
      @prop = (params[:property] || "id").to_sym

      @sort = (params[:sort_by] || "asc").to_sym
    end

    def add_nav_links
      if @sw_units.page(params[:page].to_i + 1).per(params[:per]).any? && params[:page]
        add_page_link("next_page", params[:page].to_i + 1)
      end
      
      add_page_link("prev_page", params[:page].to_i - 1) if params[:page].to_i - 1 > 0
    end

    def add_page_link(type, page_number)
      response.body.insert(1, "\"#{type}\":\"#{request.path}/?page=#{page_number}&per=#{params[:per]}\",")
    end
  end
end
