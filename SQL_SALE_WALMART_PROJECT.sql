create database SQL_project
use SQL_project
CREATE TABLE Sales_WALMART (
    invoice_id VARCHAR(30),
    branch VARCHAR(5),
    city VARCHAR(30),
    customer_type VARCHAR(30),
    gender VARCHAR(10),
    product_line VARCHAR(100),
    unit_price DECIMAL(10, 2),
    quantity INT,
    VAT FLOAT,
    total DECIMAL(10, 2),
    date DATE,
    time TIMESTAMP,
    payment_method DECIMAL(10, 2),
    cogs DECIMAL(10, 2),
    gross_margin_percentage FLOAT, 
    gross_income DECIMAL(10, 2),
    rating FLOAT)
SELECT * FROM Sales_WALMART

alter table Sales_WALMART add column tax_5 float
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Walmartsales.csv'
into table Sales_WALMART
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

alter table Sales_WALMART add column payment varchar(20)

ALTER TABLE Sales_WALMART
ADD COLUMN time_of_day VARCHAR(20);

UPDATE Sales_WALMART
SET time_of_day = CASE
    WHEN TIME(Time) BETWEEN '05:00:00' AND '11:59:59' THEN 'Morning'
    WHEN TIME(Time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    WHEN TIME(Time) BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
    ELSE 'Night' -- For times outside the standard day range (if applicable)
END;

set SQL_SAFE_UPDATES=0

ALTER TABLE Sales_WALMART
ADD COLUMN day_name VARCHAR(10);

UPDATE Sales_WALMART
SET day_name = CASE
    WHEN DAYNAME(Date) = 'Monday' THEN 'Mon'
    WHEN DAYNAME(Date) = 'Tuesday' THEN 'Tue'
    WHEN DAYNAME(Date) = 'Wednesday' THEN 'Wed'
    WHEN DAYNAME(Date) = 'Thursday' THEN 'Thu'
    WHEN DAYNAME(Date) = 'Friday' THEN 'Fri'
    ELSE 'Other' END;

ALTER TABLE Sales_WALMART
ADD COLUMN month_name VARCHAR(3);

UPDATE Sales_WALMART
SET month_name = CASE
    WHEN MONTHNAME(Date) = 'January' THEN 'Jan'
    WHEN MONTHNAME(Date) = 'February' THEN 'Feb'
    WHEN MONTHNAME(Date) = 'March' THEN 'Mar'
    WHEN MONTHNAME(Date) = 'April' THEN 'Apr'
    WHEN MONTHNAME(Date) = 'May' THEN 'May'
    WHEN MONTHNAME(Date) = 'June' THEN 'Jun'
    WHEN MONTHNAME(Date) = 'July' THEN 'Jul'
    WHEN MONTHNAME(Date) = 'August' THEN 'Aug'
    WHEN MONTHNAME(Date) = 'September' THEN 'Sep'
    WHEN MONTHNAME(Date) = 'October' THEN 'Oct'
    WHEN MONTHNAME(Date) = 'November' THEN 'Nov'
    WHEN MONTHNAME(Date) = 'December' THEN 'Dec'
    ELSE 'Unknown' END;

SELECT * from Sales_WALMART

--Generic Question
--Q_1			
SELECT COUNT(DISTINCT City) AS unique_city_count
FROM Sales_WALMART;

--Q_2
SELECT DISTINCT Branch, City
FROM Sales_WALMART;

--Product
Q1
SELECT COUNT(DISTINCT `Product_Line`) 
FROM Sales_WALMART;

Q2
SELECT Payment, COUNT(*) 
FROM Sales_WALMART
GROUP BY Payment
ORDER BY payment_count DESC
LIMIT 1;

Q3
SELECT `product_line`, SUM(Quantity) 
FROM Sales_WALMART
GROUP BY `product_line`
ORDER BY total_quantity_sold DESC
LIMIT 1;

Q4

SELECT MONTHNAME(STR_TO_DATE(Date, '%d-%m-%Y')),
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) ,
    SUM(Total)
FROM Sales_WALMART
GROUP BY YEAR(STR_TO_DATE(Date, '%d-%m-%Y')), MONTH(STR_TO_DATE(Date, '%d-%m-%Y'))
ORDER BY year DESC, MONTH(STR_TO_DATE(Date, '%d-%m-%Y')) DESC;

Q5
SELECT MONTHNAME(STR_TO_DATE(Date, '%d-%m-%Y')),
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')),
    SUM(cogs)
FROM Sales_WALMART
GROUP BY 
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')),
    MONTH(STR_TO_DATE(Date, '%d-%m-%Y'))
ORDER BY total_cogs DESC
LIMIT 1;

Q6

SELECT `Product line`, 
SUM(`Total`) 
FROM Sales_WALMART
GROUP BY `Product line`
ORDER BY total_revenue DESC
LIMIT 1;

Q7
SELECT City, 
SUM(Total) 
FROM Sales_WALMART
GROUP BY City
ORDER BY total_revenue DESC
LIMIT 1;

Q8
SELECT `Product line`, 
SUM(`Tax 5%`) 
FROM Sales_WALMART
GROUP BY `Product line`
ORDER BY total_vat DESC
LIMIT 1;
Q9

SELECT `Product line`,
    SUM(`Total`),
    CASE
        WHEN SUM(`Total`) > (SELECT AVG(SUM(`Total`)) FROM Sales_WALMART GROUP BY `Product line`) THEN 'Good'
        ELSE 'Bad'
    END AS sales_category
FROM Sales_WALMART
GROUP BY `Product line`
ORDER BY total_sales DESC;

Q10
WITH AverageSales AS (
SELECT AVG(total_sales) 
FROM (
SELECT SUM(`Quantity`) 
FROM Sales_WALMART
GROUP BY `Branch`) 
SELECT `Branch`,
SUM(`Quantity`) 
FROM Sales_WALMART
GROUP BY `Branch`
HAVING total_products_sold > (SELECT avg_sales FROM AverageSales)
ORDER BY total_products_sold DESC;

Q11

SELECT `Gender`,`Product line`, 
COUNT(*) AS product_line_count
FROM Sales_WALMART
GROUP BY `Gender`, `Product line`
ORDER BY `Gender`, product_line_count DESC;

Q12
SELECT `Product line`,AVG(`Rating`) 
FROM Sales_WALMART
GROUP BY `Product line`
ORDER BY average_rating DESC;

--Sale
Q1
SELECT `day_name`,`time_of_day`,
COUNT(*) 
FROM Sales_WALMART
GROUP BY `day_name`, `time_of_day`
ORDER BY FIELD(`day_name`, 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'),
FIELD(`time_of_day`, 'Morning', 'Afternoon', 'Evening');

Q2
SELECT `Customer_type`,
SUM(`Total`) 
FROM Sales_WALMART
GROUP BY `Customer_type`
ORDER BY total_revenue DESC
LIMIT 1;

Q3
SELECT `City`,MAX(`VAT`) 
FROM Sales_WALMART
GROUP BY `City`
ORDER BY max_vat_percent DESC
LIMIT 1;

Q4
SELECT `Customer_type`, 
 SUM(`VAT`) 
FROM Sales_WALMART
GROUP BY `Customer_type`
ORDER BY total_vat_paid DESC
LIMIT 1;

__Customer

Q1
SELECT COUNT(DISTINCT `Customer_type`) 
FROM Sales_WALMART;

Q2
SELECT COUNT(DISTINCT `Payment`) 
FROM Sales_WALMART;
Q3
SELECT `Customer_type`, COUNT(*)
FROM Sales_WALMART
GROUP BY `Customer_type`
ORDER BY frequency DESC
LIMIT 1;
Q4
SELECT `Customer_type`, COUNT(*) 
FROM Sales_WALMART
GROUP BY `Customer_type`
ORDER BY total_sales DESC
LIMIT 1;
Q5
SELECT `Gender`, COUNT(*) 
FROM Sales_WALMART
GROUP BY `Gender`
ORDER BY total_customers DESC
LIMIT 1;
Q6
SELECT `Branch`, `Gender`, COUNT(*) 
FROM Sales_WALMART
GROUP BY `Branch`, `Gender`
ORDER BY `Branch`, total_customers DESC;
Q7
SELECT HOUR(STR_TO_DATE(`Date`, '%d-%m-%Y %H:%i:%s')) 
COUNT(*) 
FROM Sales_WALMART
WHERE `Rating` 
GROUP BY hour_of_day
ORDER BY total_ratings DESC
LIMIT 1;

Q8
SELECT `Branch`,
HOUR(STR_TO_DATE(`Date`, '%d-%m-%Y %H:%i:%s')) 
COUNT(*) 
FROM Sales_WALMART
WHERE `Rating` 
GROUP BY `Branch`, hour_of_day
ORDER BY `Branch`, total_ratings DESC;
Q9
SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 7 THEN 'Saturday'
    AVG(Rating)
FROM Sales_WALMART
WHERE Rating IS NOT NULL
GROUP BY day_of_week
ORDER BY avg_rating DESC
LIMIT 1;
Q10 

SELECT 
    Branch,
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y')) = 7 THEN 'Saturday'
    
    AVG(Rating) 
FROM Sales_WALMART
WHERE Rating IS NOT NULL
GROUP BY Branch, day_of_week
ORDER BY Branch, avg_rating DESC;





























