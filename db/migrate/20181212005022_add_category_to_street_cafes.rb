class AddCategoryToStreetCafes < ActiveRecord::Migration[5.1]
  def change
    add_column :street_cafes, :category, :string
  end
end
