class Review < Model
  def self.table_name
    "reviews"
  end

  attr_accessible :critic_id, :restaurant_id, :review,
                  :score, :day
end