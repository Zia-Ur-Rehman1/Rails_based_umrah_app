class CreateHotels < ActiveRecord::Migration[8.0]
  def change
    create_table :hotels do |t|
      t.integer :city
      t.string :name
      t.integer :category
      t.string :distance
      t.string :agency
      t.string :agency_contact

      t.timestamps
    end
  end
end
