class Restaurant < Model
  def self.table_name
    "restaurants"
  end

  def self.top_restaurants

  end

  def self.by_neighborhood(neighborhood)
    query = <<-SQL
      SELECT *
      FROM restaurants
      WHERE neighborhood = ?
    SQL

    multi_query(Restaurant, query, neighborhood)
  end

  attr_accessible :name, :neighborhood, :cuisine

  def reviews
    query = <<-SQL
      SELECT restaurant_reviews.*
        FROM restaurants
        JOIN restaurant_reviews
          ON id = restaurant_id
       WHERE id = :id
    SQL

    self.class.multi_query(RestaurantReview, query, :id => self.id)
  end

  def avg_review_score
    query = <<-SQL
        SELECT AVG(score)
          FROM restaurants
          JOIN restaurant_reviews
            ON id = restaurant_id
         WHERE name = :name
    SQL

    DB.execute(query, :name => self.name)[0].values[0]
  end
end