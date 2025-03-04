-- SQL Retail Sales Analysis - P1
create database sql_project_p2;


--create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,	
		sale_time TIME, 	
		customer_id INT,
		gender VARCHAR(15),	
		age	INT,
		category VARCHAR(15),	
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,	
		total_sale FLOAT
);


SELECT * FROM retail_sales
LIMIT 10;

SELECT count(*) FROM retail_sales; -- check total rows

-- data cleaning 
 SELECT * FROM retail_sales
 where transactions_id IS NULL
 OR sale_date is NULL
 OR sale_time is NULL 
 OR gender is NULL
 OR category is NULL
 OR quantiy is NULL
 OR cogs IS NULL
 OR total_sale is NULL ; -- checking for nulls 

--deleting null rows
DELETE FROM retail_sales
where transactions_id IS NULL
 OR sale_date is NULL
 OR sale_time is NULL 
 OR gender is NULL
 OR category is NULL
 OR quantiy is NULL
 OR cogs IS NULL
 OR total_sale is NULL ;

 -- data exploration

 --How many total sales?
 SELECT count(*) as total_sales FROM retail_sales;

-- How many unique customers total? 
SELECT COUNT(DISTINCT customer_id) as unique_customers FROM retail_sales;

-- How many categories?
SELECT count(DISTINCT category) FROM retail_sales;
-- What are the categories? 
SELECT DISTINCT category FROM retail_sales; 

-- Data Analysis & Business Key Problems & Answers
-- Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * from retail_sales
where sale_date = '2022-11-05';

-- Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * from retail_sales 
WHERE category = 'Clothing'
and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
and quantiy >= 4; 

--Q3 Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT count(*) as total_orders, sum(total_sale) as net_sales, category from retail_sales 
group by category; 

--Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, round(avg(age), 2) as av_age from retail_sales 
where category = 'Beauty'
group by category;

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales 
where total_sale >1000; 

-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select count(*) as total_trans, gender, category from retail_sales
group by category, gender
order by category, gender; 

--Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year, month, avg_sale FROM 
(
	select 
		EXTRACT (YEAR FROM sale_date) as year,
		EXTRACT (MONTH FROM sale_date) as month,
		avg(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY avg(total_sale) DESC) as rank

	from retail_sales

	group by year, month
) as t1
where rank =1;

--Q8 **Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id, sum(total_sale) as net_sales from retail_sales


group by customer_id
order by net_sales desc

limit 5;

--Q9 Write a SQL query to find the number of unique customers who purchased items from each category.:

select count(distinct customer_id) as unique_customers, category 

from retail_sales 

group by category; 

--Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(select *,
CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift

from retail_sales)	
	
SELECT count(*) as total_orders, shift from hourly_sale
group by shift;

--end of project
