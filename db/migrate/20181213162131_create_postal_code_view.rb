class CreatePostalCodeView < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE VIEW postal_code_views AS
        SELECT
          sc.postal_code,
          COUNT(sc.postal_code) AS total_places,
          SUM(sc.chairs) AS total_chairs,
          ROUND(100 * (SUM(sc.chairs)::DECIMAL / SUM(SUM(sc.chairs)) OVER()), 2) AS chairs_pct,
          (SELECT name FROM street_cafes WHERE chairs = MAX(sc.chairs) LIMIT 1) AS place_with_max_chairs,
          MAX(sc.chairs) AS max_chairs
        FROM street_cafes sc
        GROUP BY sc.postal_code
        ORDER BY sc.postal_code ASC
    SQL
  end

  def down
    execute "DROP VIEW postal_code_views"
  end
end
