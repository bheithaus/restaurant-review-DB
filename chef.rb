class Chef < Model
  def self.table_name
    "chef"
  end

  attr_accessible :first_name, :last_name, :mentor
end