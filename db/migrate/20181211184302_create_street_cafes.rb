class CreateStreetCafes < ActiveRecord::Migration[5.1]
  def change
    create_table :street_cafes do |t|
      t.string :name
      t.string :address
      t.string :postal_code
      t.integer :chairs
      
      # t.timestamps
    end
  end
end
