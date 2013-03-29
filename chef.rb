class Chef < Model
  def self.table_name
    "chef"
  end

  attr_accessible :first_name, :last_name, :mentor

  def proteges
    query = <<-SQL
      SELECT c2.*
        FROM chef c1 JOIN chef c2
          ON c1.id = c2.mentor
       WHERE c1.id = :id
    SQL

    self.class.multi_query(Chef, query, :id => self.id)
  end

  def num_proteges
    query = <<-SQL
      SELECT COUNT(*)
        FROM chef c1 JOIN chef c2
          ON c1.id = c2.mentor
       WHERE c1.id = :id
    SQL

    DB.execute(query, :id => self.id)[0].values[0]
  end
end