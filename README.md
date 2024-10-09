# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_p1;

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
```

### 2. Data Exploration & Cleaning

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.

```sql
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

- **SALES PERFORMANCE**

1. **What is the total sales (total_sale) for each category?**:
```sql
SELECT category, SUM(total_sale) AS total_sale, COUNT(*) AS total_orders
FROM retail_sales 
GROUP BY category;
```

2. **Which day had the highest total sales?**:
```sql
SELECT sale_date, SUM(total_sale) as total_sales
FROM  retail_sales
GROUP BY sale_date
ORDER BY total_sales DESC
LIMIT 1;
```

3. **What is the average total sales per transaction?**:
```sql
SELECT AVG(total_sale) AS avg_sales_per_transaction
FROM retail_sales;
```

4. **What is the total revenue for each product category based on gender?**:
```sql
SELECT category,gender, SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category,gender
ORDER BY gender;
```

- **CUSTOMER ANALYSIS**

1. **What is the distribution of sales by gender?**:
```sql
SELECT gender, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY gender
ORDER BY total_sale DESC;
```

2. **What is the average age of customers making purchases for each category?**:
```sql
SELECT category, ROUND(AVG(age),2) AS avg_age
FROM retail_sales
GROUP BY category;
```

3. **What are the top 5 customer IDs based on total spending?**:
```sql
SELECT customer_id, SUM(total_sale) as total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
```
- **PRODUCT PERFORMANCE**
1. **Which product category has the highest quantity sold?**:
```sql
SELECT category, COUNT(quantity), SUM(total_sale) AS total_quantity_sold
FROM retail_sales
GROUP BY category
ORDER BY COUNT(quantity) DESC
LIMIT 1;
```

2. **What is the average price per unit for each product category?**:
```sql
SELECT category, ROUND(AVG(price_per_unit)) AS avg_price
FROM retail_sales
GROUP BY category;
```

3. **Which category has the highest cost of goods sold (COGS)?**:
```sql
SELECT category, SUM(cogs) AS total_cogs
FROM retail_sales
GROUP BY category
ORDER BY total_cogs DESC
LIMIT 1;
```
- **TIME-BASED ANALYSIS**
  
1. **What is the average sales for each month and which is the highest selling month in each year?**:
```sql
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
WHERE rank =1;
```
2. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```
- **PROFIT ANALYSIS**
1.**What is the profit made by each category and which category made the highest profit (total_sale - cogs)?**:
```sql
SELECT category, SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;
```
2.**What is the average profit margin for each product category?**:
```sql
SELECT category, AVG(total_sale - cogs) AS profit_margin
FROM retail_sales
GROUP BY category
ORDER BY profit_margin DESC;
```

### 4.Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

### 5.Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

### 6.Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

### 7.Author - Simran Kaur

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Thank you for your support, and I look forward to connecting with you!
