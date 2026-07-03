CREATE DATABASE Walmartsales;

CREATE table sales(
 invoice_id varchar(30) not null primary key,
 branch varchar(5) not null,
 city varchar(30) not null,
 customer_type varchar(30) not null,
 gender varchar(10) not null,
 product_line varchar(100) not null,
 unit_price decimal(10, 2) not null,
 quantity int not null,
 vat float,
 total decimal(10, 2) not null,
 date varchar (20) not null,
 time time not null,
 payment_method varchar(50) not null,
 cogs decimal(10, 2) not null,
 gross_margin_percentage float,
 gross_income decimal(12, 4) not null,
 rating float
 );
 drop table sales;
 alter table sales
 modify column date varchar(20);
 
 update sales
 set date = str_to_date(date, '%d-%m-%Y');
 
 alter table sales
 modify column date DATE;
 
#-----------------------------FEATURE ENGINEERING----------------------------------

-- time_of_day

select
    time,
	(CASE
        WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
        End) AS time_of_date
   from sales;           

alter table sales 
add column time_of_date varchar(20);

update sales
set time_of_date = (
CASE
 WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
 WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
 ELSE "Evening"
 END);
 
 -- DAY NAME
 
 Select 
   date,
   dayname(date) as day_name
   from sales;
   
alter table sales
add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- MONTH NAME

SELECT
   date,
   monthname(date)
   from sales;
   
alter table sales
add column month_name varchar(10);

update sales
set month_name = MONTHNAME(date);

 #Level 1 – 
 #---------------------------------Basic Queries--------------------------------------------

#1.Count total number of transactions
SELECT COUNT(*) AS total_transactions
FROM sales;

#2.Find total sales amount.
SELECT SUM(total) AS total_sales_amount
FROM sales;

#3.Show distinct cities.
select distinct city
from sales;

#4.Find average rating.
select avg(rating) as average_rating
from sales;

#5.Count number of male vs female customers.
SELECT gender, COUNT(*) AS total_customers
FROM sales
GROUP BY gender;

#6.Show highest unit price.
SELECT MAX(unit_price) AS highest_unit_price
FROM sales;

#7.Show lowest unit price.
SELECT MIN(unit_price) AS lowest_unit_price
FROM sales;

SELECT 
  MAX(unit_price) AS highest_unit_price,
  MIN(unit_price) AS lowest_unit_price
FROM sales;

#8.Find total quantity sold.
SELECT SUM(quantity) AS total_quantity_sold
FROM sales;

#Level 2 – Aggregate + GROUP BY

#9.Total sales by city.
select city, sum(total) as total_sales
from sales
group by city;

#10.Total sales by branch.
select branch, sum(total) as total_sales
from sales
group by branch;

#11.Average rating by product line.
SELECT product_line, AVG(rating) AS average_rating
FROM sales
GROUP BY product_line;

#12.Total gross income by branch.
select branch, sum(total) as total_gross_income
from sales
group by branch;

#13.Which payment method is used most?
select payment_method, count(*) as usage_count
from sales
group by payment_method;

#14.Total sales by gender.
select gender, sum(total) as total_sales
from sales
group by gender;

#15.Best selling product line (by quantity).
SELECT product_line, SUM(quantity) AS total_selling_product
FROM sales
GROUP BY product_line;

#Level 3 – Date & Time Analysis

#16.Sales per month.
SELECT MONTH(order_date) AS month,
SUM(total_amount) AS monthly_sales
FROM sales
GROUP BY MONTH(order_date);

#Level 4 - WHERE Analysis

#17.Show all Sales where Quatity is greater than 8
select * from sales
where quantity > 8;

#18.Display all tranasactions made by female customers.
select * from sales
where gender = 'Female';

#19.Show all customers who paid using Cash.
Select * from sales
Where payment_method = 'Cash';

#Level 5 - Order By Analysis

#20.Display branches ranked by gross income.

Select branch, 
SUM(gross_income) As total_gross_income
from sales
group by branch
order by total_gross_income DESC;

#21.List payment methods from most used to least used.

Select payment_method,
Count(*) as usage_count
from sales
group by payment_method
order by usage_count DESC;

#Level 6 - Limit Analysis

#22.Show the top 5 highest sales transactions.

select * from sales
order by total DESC 
Limit 5;

#23.Show the top 3 cities with the highest revenue.

select city,
sum(total) as total_revenue
from sales
group by city
order by total_revenue DESC
limit 3;

#Level 7 - Having Analysis

#23.Show cities with total sales greater than 50000.

select city,
sum(total) as total_sales
from sales
group by city
having sum(total) > 50000;

#24.Display branches whose average rating is above 7.

select branch,
avg(rating) as average_rating
from sales
group by branch
having avg(rating) > 7;

#Level 8 - Distnict Analysis
  
#25.Display all unique cities.

select distinct city
from sales;
