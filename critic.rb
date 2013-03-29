class Critic < Model
  def self.table_name
    "critics"
  end

  attr_accessible :screen_name

  def reviews
    query = <<-SQL
      SELECT restaurant_review.*
        FROM critics
        JOIN restaurant_reviews
          ON id = critic_id
       WHERE id = :id
    SQL

    self.class.multi_query(RestaurantReview, query, :id => self.id)
  end

  def avg_review_score
    query = <<-SQL
      SELECT AVG(score)
        FROM critics
        JOIN restaurant_reviews
          ON id = critic_id
       WHERE id = :id
    SQL

    DB.execute(query, :id => id)[0].values[0]
  end

  def unreviewed_restaurants
    query = <<-SQL
      SELECT restaurants.*
        FROM restaurants
       WHERE id NOT IN
     (SELECT restaurant_id
        FROM restaurant_reviews
       WHERE critic_id = :id)
    SQL

    self.class.multi_query(Restaurant, query, :id => self.id)
  end
end