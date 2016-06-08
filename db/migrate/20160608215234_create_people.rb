class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :name, default: "", null: false
      t.string :birth_year, default: "", null: false
      t.string :eye_color, default: "", null: false
      t.string :gender, default: "", null: false
      t.string :hair_color, default: "", null: false
      t.string :height, default: "", null: false
      t.string :mass, default: "", null: false
      t.string :skin_color, default: "", null: false

      t.timestamps
    end
  end
end
