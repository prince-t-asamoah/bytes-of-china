-- 1. and 2. Create table restaurant and address and primary keys to each table
CREATE TABLE restaurant (
  id INTEGER  PRIMARY KEY,
  name VARCHAR(20),
  description VARCHAR(100),
  telephone CHAR(10),
  hours VARCHAR(100),
  rating DECIMAL
);

CREATE TABLE address (
  id INTEGER PRIMARY KEY,
  street_number VARCHAR(10),
  street_name VARCHAR(20),
  city VARCHAR(20),
  state VARCHAR(15),
  google_map_link VARCHAR(50),
  restaurant_id INTEGER REFERENCES restaurant(id) UNIQUE
);

-- 3. Create a category table and add a primary key
CREATE TABLE category (
  id CHAR(2) PRIMARY KEY,
  name VARCHAR(20),
  description VARCHAR(200)
);


-- 4. Create a dish table and add a primary key
CREATE TABLE dish (
  id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  description VARCHAR(200),
  hot_and_spicy BOOLEAN
);

-- Create a reference table with foreign keys from category and dishes table
CREATE TABLE categories_dishes (
  category_id CHAR(2) REFERENCES category(id),
  dish_id INTEGER REFERENCES dish(id),
  price MONEY,
  PRIMARY KEY (category_id, dish_id)
);

-- 5. Create a review table with primary key and foreign key referencing restaurant table
CREATE TABLE review (
  id INTEGER PRIMARY KEY,
  rating DECIMAL,
  description VARCHAR(100),
  date DATE,
  restaurant_id INTEGER REFERENCES restaurant(id)
);

-- Validate all the keys of the tables
SELECT constraint_name, column_name, table_name
FROM
  information_schema.key_column_usage
WHERE
  table_name = 'restaurant'
OR
  table_name = 'address'
OR
  table_name = 'category'
OR
  table_name = 'dish'
OR
  table_name = 'review'
OR 
  table_name = 'categories_dishes';

-- 9. Add sample date into all tables
/* 
 *--------------------------------------------
 Insert values for restaurant
 *--------------------------------------------
 */
INSERT INTO restaurant VALUES (
  1,
  'Bytes of China',
  'Delectable Chinese Cuisine',
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm',
  3.9
);

/* 
 *--------------------------------------------
 Insert values for address
 *--------------------------------------------
 */
INSERT INTO address VALUES (
  1,
  '2020',
  'Busy Street',
  'Chinatown',
  'MA',
  'http://bit.ly/BytesOfChina',
  1
);

/* 
 *--------------------------------------------
 Insert values for review
 *--------------------------------------------
 */
INSERT INTO review VALUES (
  1,
  5.0,
  'Would love to host another birthday party at Bytes of China!',
  '05-22-2020',
  1
);

INSERT INTO review VALUES (
  2,
  4.5,
  'Other than a small mix-up, I would give it a 5.0!',
  '04-01-2020',
  1
);

INSERT INTO review VALUES (
  3,
  3.9,
  'A reasonable place to eat for lunch, if you are in a rush!',
  '03-15-2020',
  1
);

/* 
 *--------------------------------------------
 Insert values for category
 *--------------------------------------------
 */
INSERT INTO category VALUES (
  'C',
  'Chicken',
  null
);

INSERT INTO category VALUES (
  'LS',
  'Luncheon Specials',
  'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'
);

INSERT INTO category VALUES (
  'HS',
  'House Specials',
  null
);

/* 
 *--------------------------------------------
 Insert values for dish
 *--------------------------------------------
 */
INSERT INTO dish VALUES (
  1,
  'Chicken with Broccoli',
  'Diced chicken stir-fried with succulent broccoli florets',
  false
);

INSERT INTO dish VALUES (
  2,
  'Sweet and Sour Chicken',
  'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers',
  false
);

INSERT INTO dish VALUES (
  3,
  'Chicken Wings',
  'Finger-licking mouth-watering entree to spice up any lunch or dinner',
  true
);

INSERT INTO dish VALUES (
  4,
  'Beef with Garlic Sauce',
  'Sliced beef steak marinated in garlic sauce for that tangy flavor',
  true
);

INSERT INTO dish VALUES (
  5,
  'Fresh Mushroom with Snow Peapods and Baby Corns',
  'Colorful entree perfect for vegetarians and mushroom lovers',
  false
);

INSERT INTO dish VALUES (
  6,
  'Sesame Chicken',
  'Crispy chunks of chicken flavored with savory sesame sauce',
  false
);

INSERT INTO dish VALUES (
  7,
  'Special Minced Chicken',
  'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.',
  false
);

INSERT INTO dish VALUES (
  8,
  'Hunan Special Half & Half',
  'Shredded beef in Peking sauce and shredded chicken in garlic sauce',
  true
);

/*
 *--------------------------------------------
 Insert valus for cross-reference table, categories_dishes
 *--------------------------------------------
 */
INSERT INTO categories_dishes VALUES (
  'C',
  1,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'C',
  3,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  1,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  4,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  5,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  6,
  15.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  7,
  16.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  8,
  17.95
);

-- 10. Display Restaurant name, address and contact info
SELECT
  restaurant.name,
  address.street_number,
  address.street_name,
  restaurant.telephone
FROM
  restaurant, address
WHERE
  restaurant.id = address.restaurant_id;

--11. Best Restaurant Rating
SELECT 
  MAX(rating) AS best_rating
FROM review;

--12. Display dish name, price and category and sorted by dish name
SELECT
  dish.name AS dish_name,
  categories_dishes.price AS price,
  category.name AS category
FROM
  dish, categories_dishes, category
WHERE
  dish.id = categories_dishes.dish_id
  AND
  category.id = categories_dishes.category_id
  ORDER BY 1;

--13. Display dish name, price and category and sorted by category
SELECT
  category.name AS category,
  dish.name AS dish_name,
  categories_dishes.price AS price
FROM
  dish, categories_dishes, category
WHERE
  dish.id = categories_dishes.dish_id
  AND
  category.id = categories_dishes.category_id
  ORDER BY 3;

-- 14. Display all spicy dishes with their price and category
SELECT
    dish.name AS spicy_dish_name,
    category.name AS category,
    categories_dishes.price AS price
  FROM
    dish, category, categories_dishes
  WHERE
    dish.id = categories_dishes.dish_id
  AND
    category.id = categories_dishes.category_id
  AND
    dish.hot_and_spicy = true
  ORDER BY 1;
  
-- 15. Display dish id and count the number of dishes in a category
  SELECT
    dish_id,
    COUNT(dish_id) AS dish_count
  FROM categories_dishes
  GROUP BY 1
  ORDER BY 1;

--16. Display dish id, count the number of dishes in more than one category 
  SELECT
    dish_id,
    COUNT(dish_id) AS dish_count
  FROM categories_dishes
  GROUP BY 1
  HAVING COUNT(dish_id) > 1
  ORDER BY 1;

-- 17. Display dish id, dish name and count the number of times in a category
 SELECT
    dish_id,
    dish.name AS dish_name,
    COUNT(dish_id) AS dish_count
  FROM
    categories_dishes, dish
  WHERE
    categories_dishes.dish_id = dish.id
  GROUP BY 1, 2
  ORDER BY 3;

-- Display dish id, dish name of a dish that appears in more than one category
  SELECT
    dish_id,
    dish.name AS dish_name,
    COUNT(dish_id) AS dish_count
  FROM
    categories_dishes, dish
  WHERE
    categories_dishes.dish_id = dish.id
  GROUP BY 1, 2
  HAVING
    COUNT(dish_id) > 1
  ORDER BY 3;

-- 18. Display Best rating review
SELECT restaurant.name AS name,
  MAX(review.rating) AS best_rating
FROM restaurant
INNER JOIN review
    ON restaurant.id = review.id
GROUP BY 1;