-- SQL RETAIL SALES ANALYSIS - PROJECT --
use project;
SELECT 
    *
FROM
    sales_details;
SELECT 
    COUNT(*)
FROM
    sales_details;
-- CHECKING NULL VALUES
SELECT 
    *
FROM
    sales_details
WHERE
    transaction_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR total_sale IS NULL
        OR cogs IS NULL
        OR price_per_unit IS NULL;
-- DATA  EXPLORATION
-- how many sales we have ?
SELECT 
    COUNT(*) AS total_sale
FROM
    sales_details;
 -- how many costumers we have?
SELECT 
    COUNT(customer_id) AS total_customers
FROM
    sales_details;
 -- how many unique customers we have ?
SELECT 
    COUNT(DISTINCT customer_id)
FROM
    sales_details;
 
 -- how many distinct category we have ?
SELECT DISTINCT
    category
FROM
    sales_details;

-- data analysis and bussiness key problems and answers?
-- 1. write a sql query to retrieve all columns for sales made on '2022- 11-05'?
SELECT 
    *
FROM
    sales_details
WHERE
    sale_date = '2022-11-05';
-- write a sql query to retrive transaction where the category is 'clothing'  and the quantity said is more than 4 in the month of nov 2022?
SELECT 
    *
FROM
    sales_details
WHERE
    category = 'Clothing' AND quantiy >= 4
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
-- Write a sql query to calculate the total sales (total_sale) for each category
SELECT 
    category,
    SUM(total_sale) AS Total_Sales,
    COUNT(*) AS Total_Orders
FROM
    sales_details
GROUP BY category;
-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category. 
SELECT 
    category, ROUND(AVG(age)) AS AVG_AGE
FROM
    sales_details
WHERE
    category = 'Beauty'
GROUP BY category;
-- Write a SQL query to find all transactions where the total_sale is greater than  1000.
SELECT 
    *
FROM
    sales_details
WHERE
    total_sale > 1000;
 -- Write a SQl query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(*) AS total_transaction
FROM
    sales_details
GROUP BY category , gender
ORDER BY category ASC;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        ROUND(AVG(total_sale)) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date) 
            ORDER BY ROUND(AVG(total_sale)) DESC
        ) AS sales_rank
    FROM 
        sales_details
    GROUP BY 
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
) AS RankedSales
WHERE 
    sales_rank = 1;
-- Write a SQL query to find 5 customers based on the highest total sales?
SELECT 
    customer_id AS customer, SUM(total_sale) AS total_sale
FROM
    sales_details
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;
-- Write a SQL query to find the number of unique customers who purchased items from each category?

SELECT 
    category, COUNT(DISTINCT customer_id) AS Uniquecustomer
FROM
    sales_details
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (example morning <12 ,
--  afternoon between 12 and 17 , evening >17)
with hourly_sales
as 
( select 
 case 
 when extract(hour from sale_time) < 12 then 'Morning'
 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
 else 'Evening'
 end as shift
 from sales_details
 )
select shift , count(*)
 from hourly_sales
group by shift;
 

