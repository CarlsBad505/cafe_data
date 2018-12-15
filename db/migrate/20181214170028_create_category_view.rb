class CreateCategoryView < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE VIEW category_views AS
        SELECT
          sc.category,
          COUNT(sc.category) AS total_places,
          SUM(sc.chairs) AS total_chairs
        FROM street_cafes sc
        GROUP BY sc.category
        ORDER BY sc.category ASC
    SQL
  end

  def down
    execute "DROP VIEW category_views"
  end
end
