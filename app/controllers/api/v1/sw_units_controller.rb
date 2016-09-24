module Api::V1
  class SwUnitsController < ApplicationController
    before_action :authenticate_request!
    before_action :set_sw_unit_class
    before_action :set_sw_unit, only: [:show, :update, :destroy]
    before_action :set_sw_units, only: [:index]

    def index
      prepare_sw_units_for_rendering if params[:per]

      render json: @sw_units, meta: pagination_meta(@sw_units), status: :ok,
             each_serializer: SwUnits::IndexSerializer
    end

    def create
      @sw_unit = @sw_unit_class.new(sw_unit_params)

      if @sw_unit.save
        add_related_objects if @sw_unit_class != "Planet"

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
        add_related_objects if @sw_unit_class != "Planet"

        render json: @sw_unit, status: :ok, serializer: SwUnits::ShowSerializer
      else
        render json: @sw_unit.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @sw_unit.destroy

      render json: @sw_unit, status: :ok, serializer: SwUnits::ShowSerializer
    end

    private

    def set_sw_unit_class
      m = request.path.match %r{v1\/(\w{6,9})}

      @sw_unit_class = Kernel.const_get(define_class_name(m[1]).capitalize)
    end

    def define_class_name(raw_name)
      raw_name == "people" ? "person" : raw_name[0..-2]
    end

    def set_sw_unit
      @sw_unit = @sw_unit_class.find(params[:id])
    end

    def set_sw_units
      set_sort_params

      @sw_units =
        if !params[:query] || params[:query].empty?
          @sw_unit_class.all.order(@sort_by => @order)
        else
          @sw_unit_class.search_in_name(params[:query]).reorder(@sort_by => @order)
        end
    end

    def set_sort_params
      @sort_by = (params[:sort_by] || "id").to_sym

      @order = (params[:order] || "asc").to_sym
    end

    def prepare_sw_units_for_rendering
      prevent_overflow(@sw_units.count)

      @sw_units = @sw_units.page(params[:page]).per(params[:per])
    end

    def prevent_overflow(amount)
      params[:page] = 1 if params[:page].to_i > (amount / params[:per].to_f).ceil
    end

    def pagination_meta(object)
      return nil unless params[:per]

      {
        current_page: object.current_page,
        next_page: object.next_page,
        prev_page: object.prev_page,
        total_pages: object.total_pages,
        total_count: object.total_count
      }
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
                                       :starship_class)
    end

    def planet_params
      params.require(:planet).permit(:name, :rotation_period, :orbital_period, :diameter, :climate,
                                     :gravity, :terrain, :surface_water, :population, :url)
    end

    def person_params
      params.require(:person).permit(:name, :birth_year, :eye_color, :gender, :hair_color, :height,
                                     :mass, :skin_color, :planet_id, :url)
    end

    def add_related_objects
      collection_name = define_collection_name

      return unless collection_name

      clear_collection(collection_name) if params[:action] == "update"

      refill_collection(collection_name)
    end

    def define_collection_name
      if @sw_unit_class.to_s == "Person" && !params.dig(:person, :starships_ids)&.empty?
        "starships"
      elsif @sw_unit_class.to_s == "Starship" && !params.dig(:starship, :pilots_ids)&.empty?
        "pilots"
      end
    end

    def clear_collection(collection_name)
      @sw_unit.send(collection_name)&.clear
    end

    def refill_collection(collection_name)
      related_class = (@sw_unit_class == Person) ? Starship : Person

      params.dig(@sw_unit_class.to_s.downcase, "#{collection_name}_ids")&.each do |unit_id|
        @sw_unit.send(collection_name) << related_class.find(unit_id)
      end
    end
  end
end
