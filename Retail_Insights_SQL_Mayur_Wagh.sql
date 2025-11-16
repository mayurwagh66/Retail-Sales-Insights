--Step1 : Creating the database
Create DATABASE RetailSQLProject

--Step 2 : Import CSV files
--Imported 3 CSV files; orders.csv,products.csv,customers.csv

select * from dbo.orders

--Step 3: Data Type Fixing
--Altering column data types (converting discount from float to decimal)
ALTER TABLE orders
Alter COLUMN discount Decimal(4,2);
select * from dbo.customers
select * from dbo.products

----Altering column data types (converting sales from float to decimal)
ALTER TABLE orders
Alter COLUMN sales Decimal(10,2);

----Altering column data types (converting profit from float to decimal)
ALTER TABLE orders
Alter COLUMN profit Decimal(10,2);

--Step 4 : Previewing Tables
--Previewing first 5 rows of each table
select top 5 * from orders;
select top 5 * from products;
select top 5 * from customers;

--Step 5: Checking Row Counts
--Checking number of rows in each table 
Select count(*) as order_count from orders;
Select count(*) as product_count from products;
Select count(*) as customer_count from customers;

--Step 6: Null Value Check
--Checking for NULL values in orders table
SELECT 
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
  SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
  SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
  SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
  SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS null_discount,
  SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM orders;

--Checking for NULL values in products table
SELECT 
  SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
  SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
  SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product_name,
  SUM(CASE WHEN sub_category IS NULL THEN 1 ELSE 0 END) AS null_sub_category
FROM products;

--Checking for NULL values in customers table
SELECT 
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
  SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS null_customer_name,
  SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS null_region,
  SUM(CASE WHEN segment IS NULL THEN 1 ELSE 0 END) AS null_segment,
  SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
  SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM customers;

--Step 7: Exploratory Data Analysis (EDA) 
-- Step 7.1: Total Sales, Quantity, and Profit
SELECT 
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity,
    SUM(profit) AS total_profit
FROM orders;

-- Step 7.2: Monthly Sales Trend
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS month,
    SUM(sales) AS monthly_sales
FROM orders
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month;

-- Step 7.3: Sales by Region
SELECT 
    region,
    SUM(sales) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- Step 7.4: Profit by Category and Sub-Category
SELECT 
    p.category,
    p.sub_category,
    SUM(o.profit) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY p.category, total_profit DESC;

-- Step 7.5: Top 10 Products by Sales
SELECT TOP 10
    p.product_name,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;

-- Step 7.6: Region-wise Total Sales and Profit
SELECT 
    o.region,
    SUM(o.sales) AS total_sales,
    SUM(o.profit) AS total_profit
FROM orders o
GROUP BY o.region
ORDER BY total_profit DESC;


--Step 7.7: Segment-wise Sales Analysis
SELECT 
    c.segment,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_sales DESC;

--Step 7.8: Top 10 Cities by Total Profit
SELECT TOP 10
    c.city,
    SUM(o.profit) AS total_profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_profit DESC;

--Step 7.9: High Discount Orders (More than 20%)
SELECT 
    order_id,
    discount,
    sales,
    profit
FROM orders
WHERE discount > 0.20
ORDER BY discount DESC;

/*
Step 8: Key Business Insights 
1. Home Office customers contributed the highest revenue among all segments, 
indicating a strong individual buyer market compared to Corporate or Consumer segments.

2. Kolkata, followed by Indore, Bhopal, Mumbai, Pune, Delhi, and Chandigarh, were the most profitable cities 
— making them key regions for sales expansion and customer retention.

3. Home and Electronics were the most profitable categories. 
Among the four sub-categories — Furniture, Skincare, Shirts, and Mobile — all contributed significantly,
with Furniture and Skincare being the top profit drivers.

4. Orders offering discounts greater than 20% often led to negative profit, 
suggesting that aggressive discounting may reduce overall profitability.

5. The top-selling products included high-revenue items such as Product 18 (₹2.13L), Product 7 (₹2.09L), and Product 26 (₹2.08L),
highlighting their strong market demand and sales impact.

*/

