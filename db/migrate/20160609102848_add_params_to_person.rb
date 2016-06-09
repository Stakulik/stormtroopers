class AddParamsToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :url, :string, null: false
    add_column :people, :planet_id, :integer, null: false
  end
end
