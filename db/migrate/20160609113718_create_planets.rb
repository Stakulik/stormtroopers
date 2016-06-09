class CreatePlanets < ActiveRecord::Migration[5.0]
  def change
    create_table :planets do |t|
      t.string :name
      t.string :rotation_period
      t.string :orbital_period
      t.string :diameter
      t.string :climate
      t.string :gravity
      t.string :terrain
      t.string :surface_water
      t.string :population
      t.string :url, null: false

      t.timestamps
    end
  end
end
