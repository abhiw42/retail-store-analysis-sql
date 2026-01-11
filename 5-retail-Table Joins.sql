-- Table Joins
-- INNER JOIN, LEFT JOIN, and combining data from multiple tables

-- 1. Basic INNER JOIN - Sales with customer names
-- Shows how to combine sales and customer data
SELECT 
    s.sale_id,
    s.sale_date,
    c.first_name,
    c.last_name,
    s.total_amount
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.sale_date;

-- 2. Three-table JOIN - Sales with customer and product details
-- Demonstrates joining multiple tables
SELECT 
    s.sale_date,
    c.first_name,
    c.last_name,
    p.product_name,
    s.quantity,
    s.total_amount
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.sale_date;

-- 3. Products with category information
-- Simple two-table join
SELECT 
    p.product_name,
    p.price,
    c.category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- 4. LEFT JOIN - All customers with their purchase count
-- Shows customers even if they haven't made purchases
SELECT 
    c.first_name,
    c.last_name,
    c.registration_date,
    COUNT(s.sale_id) as purchase_count,
    COALESCE(SUM(s.total_amount), 0) as total_spent
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.registration_date
ORDER BY total_spent DESC;

-- 5. Sales report with all details
-- Complete sales information
SELECT 
    s.sale_id,
    s.sale_date,
    c.first_name + ' ' + c.last_name as customer_name,
    c.city,
    c.state,
    p.product_name,
    cat.category_name,
    s.quantity,
    p.price as unit_price,
    s.total_amount
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
ORDER BY s.sale_date DESC;

-- 6. Customer purchase history
-- Detailed customer activity
SELECT 
    c.first_name,
    c.last_name,
    c.email,
    s.sale_date,
    p.product_name,
    s.quantity,
    s.total_amount
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
INNER JOIN products p ON s.product_id = p.product_id
WHERE c.customer_id = 1  -- Specific customer
ORDER BY s.sale_date;

-- 7. Products never sold
-- LEFT JOIN to find products with no sales
SELECT 
    p.product_name,
    p.price,
    c.category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- 8. Category sales summary
-- Aggregated data across joined tables
SELECT 
    c.category_name,
    COUNT(DISTINCT p.product_id) as products_in_category,
    COUNT(s.sale_id) as total_sales,
    SUM(s.total_amount) as category_revenue
FROM categories c
INNER JOIN products p ON c.category_id = p.category_id
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY c.category_id, c.category_name
ORDER BY category_revenue DESC;

