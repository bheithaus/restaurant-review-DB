class ChefTenure < Model

  def self.table_name
    "chef_tenures"
  end

  attr_accessible :chef_id, :restaurant_id, :is_head_chef,
                    :start_date, :end_date

end