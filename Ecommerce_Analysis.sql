create database Ecommerce;
use Ecommerce;

-- joining all the tables to the falt table (STREAMING CATALOG) 
select 
	o.order_id, o.customer_id, o.order_date, o.product_name, o.category,
    o.total_amount_usd as total_amount, o.payment_method, o.device_used, o.delivery_days,
    o.order_status, o.session_duration_minutes,
    c.country, c.age, c.membership_tier, c.churned,
    ps.total_orders, ps.return_rate from orders o
    left join customers c on o.customer_id = c.customer_id
    left join product_summary ps on o.product_name = ps.product_name;
    
-- creating view for the above joins
create view Ecommerce_summary as 
	select 
	o.order_id, o.customer_id, o.order_date, o.product_name, o.category,
    o.total_amount_usd as total_amount, o.payment_method, o.device_used, o.delivery_days,
    o.order_status, o.session_duration_minutes,
    c.country, c.age, c.membership_tier, c.churned,
    ps.total_orders, ps.return_rate from orders o
    left join customers c on o.customer_id = c.customer_id
    left join product_summary ps on o.product_name = ps.product_name;
    
select * from Ecommerce_summary;

-- calculating KPI's
select
	round(sum(total_amount_usd),2) as Total_Revenue,
    count(order_id) as Total_Orders,
    round(sum(total_amount_usd) / count(order_id),2) as AOV
from orders;

-- revenue vs trend
select
	year, round(sum(total_amount_usd),2) as Total_Revenue
from orders group by year order by year;

-- Revenue vs payment method
select
	payment_method,round(sum(total_amount_usd),2) as Total_Revenue
from orders group by payment_method order by Total_Revenue desc;

-- Revenue vs Category
select
	category, round(sum(total_amount_usd),2) as Total_Revenue
from orders group by category order by Total_Revenue desc;

-- Revenue vs membership tier
select 
	customers.membership_tier, round(sum(orders.total_amount_usd),2)  as Total_Revenue
from orders left join customers on orders.customer_id =  customers.customer_id
group by customers.membership_tier order by Total_Revenue desc;

-- customer status vs customer count
select 
	o.is_repeat_customer, count(c.customer_id) as Customer_Count
from orders o left join customers c on o.customer_id = c.customer_id
group by o.is_repeat_customer order by Customer_Count desc;

-- Customer count vs device vs churn
select preferred_device, churned, count(customer_id) as Customer_Count
from customers group by preferred_device,churned order by Customer_Count desc;

-- top 7 categories
select
	category, count(order_id)  as Total_Orders
from orders group by category order by Total_Orders desc limit 7;

-- top 5 products
select
	product_name, round(sum(total_amount_usd),2)  as Total_Revenue
from orders group by product_name order by Total_Revenue desc limit 5;








