class CreateStarships < ActiveRecord::Migration[5.0]
  def change
    create_table :starships do |t|
      t.string :name, default: ""
      t.string :model, default: ""

      t.timestamps
    end
  end
end
