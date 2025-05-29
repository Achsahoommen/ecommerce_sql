DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO customers VALUES
(1, 'Alice', 'alice@example.com', '2023-01-01'),
(2, 'Bob', 'bob@example.com', '2023-02-01'),
(3, 'Charlie', 'charlie@example.com', '2023-03-01');

INSERT INTO orders VALUES
(101, 1, '2023-05-01', 250.00),
(102, 1, '2023-06-01', 150.00),
(103, 2, '2023-05-03', 500.00),
(104, 3, '2023-06-10', 100.00);

INSERT INTO order_items VALUES
(1, 101, 'Laptop', 1, 250.00),
(2, 102, 'Keyboard', 2, 75.00),
(3, 103, 'Monitor', 2, 250.00),
(4, 104, 'Mouse', 4, 25.00);

-- Query 1: Select orders with total_amount > 100, ordered descending by total_amount
SELECT * FROM orders
WHERE total_amount > 100
ORDER BY total_amount DESC;

-- Query 2: Total orders and sum of amount per customer
SELECT customer_id, COUNT(*) AS total_orders, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- Query 3: Join customers with their orders (only customers with orders)
SELECT c.name, o.order_id, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- Query 4: Left join customers with orders (includes customers with no orders)
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Query 5: Customers who placed orders with total_amount > 200
SELECT * FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
    WHERE total_amount > 200
);

-- Create a view summarizing customers' number of orders and total spent
CREATE VIEW customer_summary AS
SELECT c.customer_id, c.name, COUNT(o.order_id) AS num_orders, SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Create an index on orders table for faster customer_id lookup
CREATE INDEX idx_order_customer ON orders(customer_id);
