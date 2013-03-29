class Critic < Model
  def self.table_name
    "critic"
  end

  attr_accessible :screen_name

  def reviews
    query = <<-SQL
      SELECT *

    SQL
  end
end