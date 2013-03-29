require 'sqlite3'
require 'singleton'
require './model'
require './chef'
require './chef_tenure'
require './critic'
require './review'
require './restaurant'

class Database < SQLite3::Database
  include Singleton

  def initialize
    super("restaurants.db")

    self.results_as_hash = true
    self.type_translation = true
  end
end

DB ||= Database.instance

def populate
  ##Save Restaurants
  puts "adding restaurants to Database..."
  restaurant_data = [
    {"name"=>"Millenium", "neighborhood"=>"Nob Hill", "cuisine"=>"Gourmet Plant Based"},
    {"name"=>"Green Earth", "neighborhood"=>"Berkeley", "cuisine"=>"Macrobiotic Plant Based"},
    {"name"=>"Plant Cafe", "neighborhood"=>"Embarcadero", "cuisine"=>"Gourmet Plant Based"},
    {"name"=>"Oasis", "neighborhood"=>"Financial District", "cuisine"=>"Falafel"},
    {"name"=>"Tara Thai", "neighborhood"=>"SOMA", "cuisine"=>"Thai"},
    {"name"=>"Mehfil", "neighborhood"=>"SOMA", "cuisine"=>"Indian"}
  ]
  restaurant_data.each { |data| Restaurant.new(data).save }
  sleep(1)
  ##Save Chefs
  puts "adding chefs to Database..."
  chef_data = [
    {"first_name"=>"Bo", "last_name"=>"Diddly", "mentor"=>nil},
    {"first_name"=>"Kyle", "last_name"=>"Knies", "mentor"=>1},
    {"first_name"=>"Brian", "last_name"=>"Heithaus", "mentor"=>2},
    {"first_name"=>"Mick", "last_name"=>"Jagger", "mentor"=>3},
    {"first_name"=>"George", "last_name"=>"Michael", "mentor"=>2},
    {"first_name"=>"Great", "last_name"=>"Chef", "mentor"=>3}
  ]
  chef_data.each { |data| Chef.new(data).save }
  sleep(1)
  ##Save  ChefTenures
  puts "adding chefs' tenures to Database..."
  tenure_data = [
    {"chef_id"=>1, "restaurant_id"=>4, "start_date"=>"2000-10-05", "end_date"=>"2004-01-20", "is_head_chef" => 1},
    {"chef_id"=>1, "restaurant_id"=>1, "start_date"=>"2004-03-10", "end_date"=>"2006-03-10", "is_head_chef" => 0},
    {"chef_id"=>2, "restaurant_id"=>2, "start_date"=>"2012-09-05", "end_date"=>"2013-09-05", "is_head_chef" => 1},
    {"chef_id"=>3, "restaurant_id"=>2, "start_date"=>"2012-07-29", "end_date"=>"2012-10-28", "is_head_chef" => 0},
    {"chef_id"=>4, "restaurant_id"=>3, "start_date"=>"2003-06-15", "end_date"=>"2008-06-15", "is_head_chef" => 1},
    {"chef_id"=>5, "restaurant_id"=>1, "start_date"=>"2007-10-05", "end_date"=>"2010-10-05", "is_head_chef" => 1},
    {"chef_id"=>6, "restaurant_id"=>6, "start_date"=>"2000-10-05", "end_date"=>"2012-10-05", "is_head_chef" => 1}
  ]
  tenure_data.each { |data| ChefTenure.new(data).save }
  sleep(1)
  ##Save  Critics
  puts "adding critics to Database..."
  critic_data = [
    { "screen_name" => "leCool" },
    { "screen_name" => "Chompsta" },
    { "screen_name" => "meSoHungry" },
    { "screen_name" => "iHateFood" }
  ]
  critic_data.each { |data| Critic.new(data).save }
  sleep(1)
  ##Save Reviews
  puts "adding reviews to Database..."
  review_data = [
    {"critic_id"=>1,"restaurant_id"=>1,"review"=>nil,"score"=>5,"day"=>"2008-11-05"},
    {"critic_id"=>2,"restaurant_id"=>2,"review"=>nil,"score"=>3,"day"=>"2009-05-05"},
    {"critic_id"=>3,"restaurant_id"=>3,"review"=>nil,"score"=>5,"day"=>"2008-04-05"},
    {"critic_id"=>4,"restaurant_id"=>5,"review"=>nil,"score"=>3,"day"=>"2012-02-05"},
    {"critic_id"=>1,"restaurant_id"=>4,"review"=>nil,"score"=>3,"day"=>"2013-11-05"},
    {"critic_id"=>1,"restaurant_id"=>3,"review"=>nil,"score"=>5,"day"=>"2013-11-05"},
    {"critic_id"=>3,"restaurant_id"=>1,"review"=>nil,"score"=>4,"day"=>"2013-12-05"}
  ]
  reviews = ["this place rocks",
             "I loved their baba ganoush",
             "you wouldn't believe how good their Gado Gado is!",
             "Eat here every night!",
             "The best lunch specials",
             "whats that french word? for medium quality?",
             "dancing on my tastebuds",
             "i love this food!"
           ]

  review_data.each_with_index do |data, i|
    data["review"] = reviews[i]
    RestaurantReview.new(data).save
  end
  "success"
end