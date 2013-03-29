class RestaurantReview < Model
  def self.table_name
    "restaurant_review"
  end

  attr_accessible :critic_id, :restaurant_id, :review, :score, :date
end