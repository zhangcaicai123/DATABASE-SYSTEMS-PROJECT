-- Drop the tables if they exist
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS order_reviews;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS order_payments;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS product_category;

-- Create all the tables with appropriate constraints
CREATE TABLE customers (
	customer_id TEXT NOT NULL,
	customer_unique_id TEXT NOT NULL,
	customer_zip_code_prefix TEXT,
	customer_city TEXT,
	customer_state TEXT,
	PRIMARY KEY (customer_id)
);

CREATE TABLE orders (
	order_id TEXT NOT NULL,
	customer_id TEXT,
	order_status TEXT,
	order_purchase_timestamp DATETIME,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME,
	PRIMARY KEY (order_id),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_payments (
	order_id TEXT NOT NULL,
	payment_sequential INTEGER NOT NULL,
	payment_type TEXT,
	payment_installments INTEGER,
	payment_value DECIMAL(10, 2),
	PRIMARY KEY (order_id, payment_sequential),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_items (
	order_id TEXT NOT NULL,
	order_item_id INTEGER NOT NULL,
	product_id TEXT,
	seller_id TEXT, 
	shipping_limit_date DATETIME,
	price DECIMAL(10, 2),
	freight_value DECIMAL(10, 2),
	PRIMARY KEY (order_id, order_item_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES product(product_id),
	FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE order_reviews (
	review_id TEXT NOT NULL,
	order_id TEXT NOT NULL,
	review_score INTEGER,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date DATETIME,
	review_answer_timestamp DATETIME,
	PRIMARY KEY (review_id, order_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


CREATE TABLE product_category (
	product_category_name TEXT NOT NULL,
	product_category_name_english TEXT,
	PRIMARY KEY (product_category_name)
);

CREATE TABLE products (
	product_id TEXT NOT NULL,
	product_category_name TEXT,
	product_name_length INTEGER,
	product_description_length INTEGER,
	product_photos_qty INTEGER,
	product_weight_g INTEGER,
	product_length_cm INTEGER,
	product_height_cm INTEGER,
	product_width_cm INTEGER,
	PRIMARY KEY (product_id),
	FOREIGN KEY (product_category_name) REFERENCES product_category(product_category_name)
);

CREATE TABLE sellers (
	seller_id TEXT NOT NULL,
	seller_zip_code_prefix TEXT,
	seller_city TEXT,
	seller_state TEXT,
	PRIMARY KEY (seller_id)
);


-- Load data from csv files
.mode csv
.header on
.import --csv --skip 1 csv/olist_orders_dataset.csv orders
.import --csv --skip 1 csv/olist_order_items_dataset.csv order_items
.import --csv --skip 1 csv/olist_order_reviews_dataset.csv order_reviews
.import --csv --skip 1 csv/olist_customers_dataset.csv customers
.import --csv --skip 1 csv/olist_order_payments_dataset.csv order_payments
.import --csv --skip 1 csv/product_category_name_translation.csv product_category
.import --csv --skip 1 csv/olist_products_dataset.csv products
.import --csv --skip 1 csv/olist_sellers_dataset.csv sellers

-- Reclaim unused space
VACUUM;
