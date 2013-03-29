CREATE TABLE chef (
  id INTEGER PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  mentor INTEGER
);

CREATE TABLE restaurant (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  neighborhood VARCHAR(50) NOT NULL,
  cuisine VARCHAR(50) NOT NULL
);

CREATE TABLE chef_tenure (
  chef_id INTEGER NOT NULL,
  restaurant_id INTEGER NOT NULL,
  is_head_chef INTEGER NOT NULL,
  start_date CHAR(10) NOT NULL,
  end_date CHAR(10),
  FOREIGN KEY(chef_id) REFERENCES chef(id),
  FOREIGN KEY(restaurant_id) REFERENCES restaurant(id)
);

CREATE TABLE critic (
  id INTEGER PRIMARY KEY,
  screen_name VARCHAR(30) NOT NULL
);

CREATE TABLE restaurant_review (
  critic_id INTEGER NOT NULL,
  restaurant_id INTEGER NOT NULL,
  review TEXT,
  score INTEGER,
  date CHAR(10),
  FOREIGN KEY(critic_id) REFERENCES critic(id),
  FOREIGN KEY(restaurant_id) REFERENCES restaurant(id)
);


-- insert into restaurant_review
-- (critic_id, restaurant_id, review, score)
-- VALUES
-- (3,1,"delicious gruel!",5)