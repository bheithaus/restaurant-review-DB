class Critic < Model
  def self.table_name
    "critic"
  end

  attr_accessible :screen_name

  def reviews
    query = <<-SQL
      SELECT restaurant_review.*
        FROM critic JOIN restaurant_review
          ON id = critic_id
       WHERE id = :id
    SQL

    self.class.multi_query(RestaurantReview, query, :id => self.id)
  end
end