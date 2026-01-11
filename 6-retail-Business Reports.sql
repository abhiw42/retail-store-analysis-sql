-- Business Reports
-- Practical queries for business analysis and reporting

-- 1. Monthly Sales Report
-- Key business metrics by month
SELECT 
    YEAR(sale_date) as year,
    MONTH(sale_date) as month,
    MONTHNAME(sale_date) as month_name,
    COUNT(*) as total_transactions,
    COUNT(DISTINCT customer_id) as unique_customers,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as average_transaction_value
FROM sales 
GROUP BY YEAR(sale_date), MONTH(sale_date), MONTHNAME(sale_date)
ORDER BY year, month;

-- 2. Top 10 Best Selling Products
-- Product performance ranking
SELECT 
    p.product_name,
    c.category_name,
    COUNT(s.sale_id) as times_sold,
    SUM(s.quantity) as total_quantity,
    SUM(s.total_amount) as total_revenue,
    AVG(s.total_amount) as avg_sale_amount
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 3. Customer Analysis Report
-- Customer behavior and value analysis
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.state,
    c.registration_date,
    COUNT(s.sale_id) as total_purchases,
    SUM(s.total_amount) as total_spent,
    AVG(s.total_amount) as avg_order_value,
    MAX(s.sale_date) as last_purchase_date,
    DATEDIFF(CURDATE(), MAX(s.sale_date)) as days_since_last_purchase
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.state, c.registration_date
ORDER BY total_spent DESC;

-- 4. Category Performance Report
-- Sales performance by product category
SELECT 
    c.category_name,
    COUNT(DISTINCT p.product_id) as products_count,
    COUNT(s.sale_id) as total_sales,
    SUM(s.total_amount) as total_revenue,
    AVG(s.total_amount) as avg_sale_amount,
    SUM(s.quantity) as total_units_sold
FROM categories c
INNER JOIN products p ON c.category_id = p.category_id
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC;

-- 5. Geographic Sales Report
-- Sales performance by state
SELECT 
    c.state,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(s.sale_id) as total_sales,
    SUM(s.total_amount) as total_revenue,
    AVG(s.total_amount) as avg_transaction_value,
    SUM(s.total_amount) / COUNT(DISTINCT c.customer_id) as avg_revenue_per_customer
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.state
ORDER BY total_revenue DESC;

-- 6. Daily Sales Trend
-- Daily sales performance for trend analysis
SELECT 
    sale_date,
    COUNT(*) as transactions,
    SUM(total_amount) as daily_revenue,
    AVG(total_amount) as avg_transaction,
    COUNT(DISTINCT customer_id) as unique_customers
FROM sales 
GROUP BY sale_date
ORDER BY sale_date;

-- 7. Product Profitability Report
-- Profit analysis by product
SELECT 
    p.product_name,
    c.category_name,
    p.price,
    p.cost,
    (p.price - p.cost) as profit_per_unit,
    ROUND(((p.price - p.cost) / p.price) * 100, 2) as profit_margin_percent,
    COALESCE(SUM(s.quantity), 0) as units_sold,
    COALESCE(SUM(s.total_amount), 0) as total_revenue,
    COALESCE(SUM(s.quantity) * p.cost, 0) as total_cost,
    COALESCE(SUM(s.total_amount) - SUM(s.quantity) * p.cost, 0) as total_profit
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.cost
ORDER BY total_profit DESC;

-- 8. Customer Segmentation Report
-- Basic customer segmentation by spending
SELECT 
    CASE 
        WHEN total_spent >= 200 THEN 'High Value'
        WHEN total_spent >= 100 THEN 'Medium Value'
        WHEN total_spent > 0 THEN 'Low Value'
        ELSE 'No Purchases'
    END as customer_segment,
    COUNT(*) as customer_count,
    AVG(total_spent) as avg_spending,
    SUM(total_spent) as segment_revenue
FROM (
    SELECT 
        c.customer_id,
        COALESCE(SUM(s.total_amount), 0) as total_spent
    FROM customers c
    LEFT JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id
) customer_totals
GROUP BY customer_segment
ORDER BY avg_spending DESC;