class AddParamsToStarship < ActiveRecord::Migration[5.0]
  def change
    add_column :starships, :url, :string, null: false
    add_column :starships, :manufacturer, :string
    add_column :starships, :cost_in_credits, :string
    add_column :starships, :max_atmosphering_speed, :string
    add_column :starships, :passengers, :string
    add_column :starships, :cargo_capacity, :string
    add_column :starships, :consumables, :string
    add_column :starships, :hyperdrive_rating, :string
    add_column :starships, :MGLT, :string
    add_column :starships, :starship_class, :string
    add_column :starships, :length, :string
    add_column :starships, :crew, :string
  end
end
