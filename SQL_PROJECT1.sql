
---------CREATING A TABLE FOR RETAILSALES

drop table if exists retailsale;
create table retailsale(	transactions_id int primary key,	
							sale_date date,	
							sale_time time,	
							customer_id int,	
							gender varchar(10),	
							age int,	
							category varchar(20),	
							quantity int,	
							price_per_unit float,	
							cogs float,	
							total_sale float
					);
					
drop table retail; 

select * from retailsale;

select * from retailsale Limit 10;

select count(*) from retailsale

-------DATA CLEANING

select * from retailsale 
where  
	transactions_id is Null
	OR
	 sale_date is Null
	 OR
	 sale_time is Null
	 OR
	 customer_id is Null
	 OR
	 gender is Null
	 Or
	 age is Null
	 OR
	 category is Null
	 OR
	 quantity is Null
	 Or
	 price_per_unit is Null
	 OR
	 cogs is Null
	 Or
	 total_sale is Null;

delete from retailsale
where
	transactions_id is Null
	OR
	 sale_date is Null
	 OR
	 sale_time is Null
	 OR
	 customer_id is Null
	 OR
	 gender is Null
	 Or
	 age is Null
	 OR
	 category is Null
	 OR
	 quantity is Null
	 Or
	 price_per_unit is Null
	 OR
	 cogs is Null
	 Or
	 total_sale is Null;

select count(*) from retailsale;

---------DATA EXPLORATION

----------HOW MANY SALES WE HAVE?

select count(*) as total_sales from retailsale;

-----------HOW MANY UNIQUE_CUSTOMERS WE HAVE ?

select count(distinct customer_id) as unique_customers from retailsale;

-----------HOW MANY CATEGORYS ARE THERE?

select distinct category from retailsale;

-----------WHAT IS THE MAXIMUM QUNTITY CUSTOMERS PURCHASED?

select max(quantity) as max_pur_cus from retailsale;

-----------WHAT IS THE MINIMUM QUANTITY CUSTOMERS PURCHASED?

select min(quantity) as min_pur_cus from retailsale;


-----------DATA  ANALYSIS , BUSSINESS KEY PROBLEMS AND ANSWERS

-------1) WRITE A SQL QUERY TO RETRIVE ALL COLUMNS FOR SALEES MADE ON '2022-11-05'

select * from retailsale where sale_date='2022-11-05';

--------2) WRITE A SQL QUERY TO RETRIVE ALL TRANSACTIONS WHERE THE CATEGORY IS 'CLOTHING' AND
----------THE QUANTITY SOLD IS MORE THAN OR EQUAL TO 4 IN THE MONTH OF 'NOV-2022'

select * from retailsale 
where
	category = 'Clothing'
	and
	quantity >= 4
	and
	to_char(sale_date,'yyyy-mm')='2022-11';

------3) WRITE A SQL QUERY TO CALCULATE TOTAL SALES FOR EACH CATEGORY

SELECT 
	category,
	sum(total_sale)
from retailsale
group by category;

---------4) WRITE A SQL QUERY TO FIND AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEM FROM
------------BEAUTY CATEGORY

select 
	round(avg(age),2) as avg_age_cus
from retailsale
where 
	category='Beauty';

--------5) WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE THE TOTAL_SALE IS GREATER THAN 1000

select * from retailsale
where total_sale>1000

--------6) WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS_ID MADE BY EACH GENDER IN EACH CATEGORY

select
	category,
	gender,
	count(*) as total_trans
from retailsale
group by 1,2

--------7) WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH.FIND OUT BEST SELLING MONTH IN EACH YEAR

select
		year,
		month,
		avg_sale
from
(
select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc)as rank
from retailsale
group by 1,2
) as t1
where rank =1;

--------8) Write a sql query to find top5 customers based on the highest total sales

select
		customer_id,
		sum(total_sale)
from retailsale
group by 1
order by 2 desc
limit 5;

--------- 9) Write a sql query to find the unique customers who purchased items from each category

select
		category,
		count(distinct customer_id)
from retailsale
group by 1;

--------10) Write a sql querry to create each shift and number of orders
---------(example morning <12,afternoon between 12 and 17,evining >17)


with hourly_sale
as
(
select
	case
			when extract(hour from sale_time) <12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'Eveining'
	end as shift
from retailsale
)
select 
		shift,
		count(*) as total_orders
from hourly_sale
group by shift;



