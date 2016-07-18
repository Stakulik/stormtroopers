module Api::V1
  class SwUnitsController < ApplicationController
    before_action :authenticate_request!
    before_action :sw_unit_class
    before_action :sw_unit, only: [:show, :update, :destroy]
    before_action :define_sort_params, only: [:index, :search]

    def index
      check_overflow(@sw_unit_class.count) if params[:per]

      @sw_units = @sw_unit_class.all.order(@sort_by => @order).
                    page(params[:page]).per(params[:per] || 10)

      render json: @sw_units, meta: pagination_meta(@sw_units),
             each_serializer: SwUnits::IndexSerializer
    end

    def create
      @sw_unit = @sw_unit_class.new(sw_unit_params)

      if @sw_unit.save
#       add_related_object if @sw_unit_class != "Planet"

        render json: @sw_unit, status: :created, serializer: SwUnits::ShowSerializer
      else
        render json: @sw_unit.errors, status: :unprocessable_entity
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

      render json: @sw_unit, status: :ok, serializer: SwUnits::ShowSerializer
    end

    def search
      unless params[:query].empty?
        @sw_units = @sw_unit_class.search_in_name(params[:query]).reorder(@sort_by => @order)
      end

      @sw_units = @sw_unit_class.all.order(@sort_by => @order) if params[:query].empty?

      check_overflow(@sw_units.count) if params[:per]

      @sw_units = @sw_units.page(params[:page]).per(params[:per] || 10)

      render json: @sw_units, meta: pagination_meta(@sw_units), status: :ok,
             each_serializer: SwUnits::IndexSerializer
    end

    private

    def sw_unit_class
      m = request.path.match %r{v1\/(\w{6,9})}

      @sw_unit_class = Kernel.const_get(define_class_name(m[1]).capitalize)
    end

    def define_class_name(raw_name)
      raw_name == "people" ? "person" : raw_name[0..-2]
    end

    def sw_unit
      @sw_unit = @sw_unit_class.find(params[:id])
    end

    def sw_unit_params
      if @sw_unit_class.to_s == "Starship"
        starship_params
      elsif @sw_unit_class.to_s == "Planet"
        planet_params
      else
        person_params
      end
    end

    def starship_params
      params.require(:starship).permit(:name, :model, :manufacturer, :cost_in_credits, :length,
                                       :max_atmosphering_speed, :crew, :passengers, :consumables,
                                       :cargo_capacity, :MGLT, :hyperdrive_rating, :url,
                                       :starship_class, pilots_ids: [])
    end

    def planet_params
      params.require(:planet).permit(:name, :rotation_period, :orbital_period, :diameter, :climate,
                                     :gravity, :terrain, :surface_water, :population, :url)
    end

    def person_params
      params.require(:person).permit(:name, :birth_year, :eye_color, :gender, :hair_color, :height,
                                     :mass, :skin_color, :planet_id, :url, starships_ids: [])
    end

    def define_sort_params
      @sort_by = (params[:sort_by] || "id").to_sym

      @order = (params[:order] || "asc").to_sym
    end

    def check_overflow(amount)
      params[:page] = 1 if params[:page].to_i > (amount / params[:per].to_f).ceil
    end

    def pagination_meta(object)
      {
        current_page: object.current_page,
        next_page: object.next_page,
        prev_page: object.prev_page,
        total_pages: object.total_pages,
        total_count: object.total_count
      }
    end

    def add_related_object
      if @sw_unit_class == "Person" && !starships_ids.empty?
        starships_ids.each { |ship_id| Starship.find(ship_id) << @sw_unit }
      elsif @sw_unit_class == "Starship" && !pilots_ids.empty?
        pilots_ids.each { |pilot_id| Person.find(pilot_id) << @sw_unit }
      end
    end
  end
end
