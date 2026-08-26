-- Load customers data from CSV file into PostgreSQL
COPY customers
FROM '/Users/ulugbekmedetov/bi-journey/northstar_commerce/data/raw/customers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Load orders data from CSV file into PostgreSQL
COPY orders
FROM '/Users/ulugbekmedetov/bi-journey/northstar_commerce/data/raw/orders_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Load products data from CSV file into PostgreSQL
COPY products
FROM '/Users/ulugbekmedetov/bi-journey/northstar_commerce/data/raw/products_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Load order_items data from CSV file into PostgreSQL
COPY order_items
FROM '/Users/ulugbekmedetov/bi-journey/northstar_commerce/data/raw/order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Load payments data from CSV file into PostgreSQL
COPY payments
FROM '/Users/ulugbekmedetov/bi-journey/northstar_commerce/data/raw/payments_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Load category_translation data from CSV file into PostgreSQL
COPY category_translation
FROM '/Users/ulugbekmedetov/bi-journey/northstar_commerce/data/raw/product_category_name_translation.csv'
DELIMITER ','
CSV HEADER;