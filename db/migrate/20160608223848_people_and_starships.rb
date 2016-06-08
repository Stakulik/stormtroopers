class PeopleAndStarships < ActiveRecord::Migration[5.0]
  def change
    create_table :people_starships, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :starship, index: true
    end
  end
end
