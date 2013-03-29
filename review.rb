class RestaurantReview < Model
  def self.table_name
    "restaurant_reviews"
  end

  attr_accessible :critic_id, :restaurant_id, :review, :score, :day
end