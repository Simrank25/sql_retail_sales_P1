-- SQL Retail Sales Analysis -P1
CREATE DATABASE sql_project_p1;

-- Create TABLE
CREATE TABLE retail_sales
            (
                transactions_id INT PRIMARY KEY,
                sale_date DATE,
                sale_time TIME,
                customer_id INT,
                gender VARCHAR(15),
                age INT,
                category VARCHAR(15),
                quantity INT,
                price_per_unit FLOAT,
                cogs FLOAT,
                total_sale FLOAT
            );

-- Data Cleaning
SELECT * 
FROM retail_sales
WHERE 
 transactions_id IS NULL
 OR 
 sale_date IS NULL
 OR 
 sale_time IS NULL
 OR 
 customer_id IS NULL
 OR 
 gender IS NULL
 OR 
 age IS NULL
 OR 
 category IS NULL
 OR 
 quantity IS NULL
 OR 
 price_per_unit IS NULL
 OR 
 cogs IS NULL
 OR 
 total_sale IS NULL;

DELETE FROM retail_sales 
WHERE 
 transactions_id IS NULL
 OR 
 sale_date IS NULL
 OR 
 sale_time IS NULL
 OR 
 customer_id IS NULL
 OR 
 gender IS NULL
 OR 
 age IS NULL
 OR 
 category IS NULL
 OR 
 quantity IS NULL
 OR 
 price_per_unit IS NULL
 OR 
 cogs IS NULL
 OR 
 total_sale IS NULL;

-- DATA EXPLORATION
-- Record Count
SELECT COUNT(*) AS total_sale
FROM retail_sales;

-- Unique customer count
SELECT COUNT(DISTINCT(customer_id)) 
FROM retail_sales;

-- Distinct product category count
SELECT DISTINCT category 
FROM retail_sales;

-- Data Analysis

-- SALES PERFORMANCE

--What is the total sales (total_sale) for each category?
SELECT category, SUM(total_sale) AS total_sale, COUNT(*) AS total_orders
FROM retail_sales 
GROUP BY category;

-- Which day had the highest total sales?
SELECT sale_date, SUM(total_sale) as total_sales
FROM  retail_sales
GROUP BY sale_date
ORDER BY total_sales DESC
LIMIT 1;

-- What is the average total sales per transaction?
SELECT AVG(total_sale) AS avg_sales_per_transaction
FROM retail_sales;

-- What is the total revenue for each product category based on gender?
SELECT category,gender, SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category,gender
ORDER BY gender;

-- CUSTOMER ANALYSIS
-- What is the distribution of sales by gender?
SELECT gender, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY gender
ORDER BY total_sale DESC;

-- What is the average age of customers making purchases for each category?
SELECT category, ROUND(AVG(age),2) AS avg_age
FROM retail_sales
GROUP BY category;

-- What are the top 5 customer IDs based on total spending?
SELECT customer_id, SUM(total_sale) as total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- PRODUCT PERFORMANCE 
-- Which product category has the highest quantity sold?
SELECT category, COUNT(quantity), SUM(total_sale) AS total_quantity_sold
FROM retail_sales
GROUP BY category
ORDER BY COUNT(quantity) DESC
LIMIT 1;

-- What is the average price per unit for each product category?
SELECT category, ROUND(AVG(price_per_unit)) AS avg_price
FROM retail_sales
GROUP BY category;

-- Which category has the highest cost of goods sold (COGS)?
SELECT category, SUM(cogs) AS total_cogs
FROM retail_sales
GROUP BY category
ORDER BY total_cogs DESC
LIMIT 1;

-- TIME-BASED ANALYSIS

-- What is the average sales for each month and which is the highest selling month in each year?
SELECT year, month, avg_sale
FROM
(
 SELECT EXTRACT(YEAR FROM sale_date) as year,
        EXTRACT(MONTH FROM sale_date) as month,
        AVG(total_sale) AS avg_sale, 
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) as rank
 FROM retail_sales
 GROUP BY 1,2
) as t1
WHERE rank =1 

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS 
(
SELECT *,
       CASE
           WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
	       WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	       ELSE 'Evening'
		END AS shift
FROM retail_sales
)
SELECT shift, COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;

-- PROFIT ANALYSIS
-- What is the profit made by each category and which category made the highest profit (total_sale - cogs)?
SELECT category, SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

-- What is the average profit margin for each product category?
SELECT category, AVG(total_sale - cogs) AS profit_margin
FROM retail_sales
GROUP BY category
ORDER BY profit_margin DESC;


--END OF PROJECT


  