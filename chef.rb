class Chef < Model
  def self.table_name
    "chefs"
  end

  attr_accessible :first_name, :last_name, :mentor

  def co_workers
    #chefs who worked with this one at same restaurant at same time
    query = <<-SQL
      SELECT chefs.*
        FROM chef_tenures my_ten
        JOIN chef_tenures co_ten
          ON my_ten.restaurant_id = co_ten.restaurant_id
        JOIN chefs
          ON id = co_ten.chef_id
       WHERE ( co_ten.start_date BETWEEN my_ten.start_date AND my_ten.end_date
          OR   co_ten.end_date BETWEEN my_ten.start_date AND my_ten.end_date )
         AND my_ten.chef_id = :id
         AND NOT co_ten.chef_id = :id
    SQL

    self.class.multi_query(Chef, query, :id => self.id)
  end

  def reviews
    #reviews of restaurants when this chef was head there
    query = <<-SQL
      SELECT reviews.*
        FROM chef_tenures tenures
        JOIN restaurant_reviews reviews
          ON tenures.restaurant_id = reviews.restaurant_id
       WHERE reviews.day BETWEEN tenures.start_date AND tenures.end_date
         AND tenures.is_head_chef = 1
         AND tenures.chef_id = :id
    SQL

    self.class.multi_query(RestaurantReview, query, :id => self.id)
  end

  def proteges
    query = <<-SQL
      SELECT c2.*
        FROM chefs c1
        JOIN chefs c2
          ON c1.id = c2.mentor
       WHERE c1.id = :id
    SQL

    self.class.multi_query(Chef, query, :id => self.id)
  end

  def num_proteges
    query = <<-SQL
      SELECT COUNT(*)
        FROM chefs c1
        JOIN chefs c2
          ON c1.id = c2.mentor
       WHERE c1.id = :id
    SQL

    DB.execute(query, :id => self.id)[0].values[0]
  end
end