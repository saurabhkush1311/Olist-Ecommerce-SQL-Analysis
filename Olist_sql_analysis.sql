-- KPI 1: Weekday vs. Weekend Sales Analysis (Date Functions)
-- Goal: Determine if we get more orders on weekdays (Mon-Fri) or weekends (Sat-Sun).

Select  
CASE WHEN dayofweek(date(O.order_purchase_timestamp)) IN (2,3,4,5,6) THEN "Weekday" ELSE "Weekend" END as week_sales,
round(count(order_id)/(select count(*) from olist_orders_dataset)*100 ,2) as total_sales
from olist_orders_dataset O 
group by 1;


-- KPI 2: Delivery Performance by State (Complex Aggregation)
-- Goal: Identify which states have the worst delivery delays.

with order_base as (select *,
timestampdiff(day,order_estimated_delivery_date,order_delivered_customer_date) as delays
from olist_orders_dataset 
where order_status="delivered" and 
timestampdiff(day,order_estimated_delivery_date,order_delivered_customer_date)>0
) 

select c.customer_state, round(avg(o.delays),2) as avg_delays_days
from order_base o
left join olist_customers_dataset c
on o.customer_id=c.customer_id
group by 1
order by 2 desc;

-- KPI 3: Revenue by Payment Type Over Time (Pivot/Grouping)
-- Goal: Track how payment preferences have changed.

SELECT date_format(date(O.order_purchase_timestamp),'%Y-%m') As Months,
ifnull(round(sum(case when P.payment_type="credit_card" then P.payment_value end),2),0) As Credit_card,
ifnull(round(sum(case when P.payment_type="debit_card" then P.payment_value end),2),0) As Debit_card,
ifnull(round(sum(case when P.payment_type="boleto" then P.payment_value end),2),0) As Boleto,
ifnull(round(sum(case when P.payment_type="Voucher" then P.payment_value end),2),0) As Voucher
 FROM olist_orders_dataset O
 left join olist_order_payments_dataset P
 on O.order_id=P.order_id
 Group by 1
 Order By 1;
 
 -- KPI 4: "Power Sellers" Identification (Window Functions)
-- Goal: Find our top sellers to reward them 

SELECT seller_id, round(sum(price),2) As Revenue,
dense_rank() over(order by sum(price) desc) As Ranking
FROM olist_order_items_dataset 
group by 1
having sum(price) > 50000;

-- KPI 5: Customer Retention (The "Cohort" Logic)
-- Goal: Count how many unique customers have made more than 1 separate order.

with base as (SELECT c.customer_unique_id, count( distinct o.order_id)
FROM olist_customers_dataset c
Left join olist_orders_dataset o
on c.customer_id=o.customer_id
group by 1
having count( distinct o.order_id)>1
order by 2 desc)

select count( distinct customer_unique_id) as "customer Retention", round(count( distinct customer_unique_id)/(select count(distinct customer_unique_id) from olist_customers_dataset)*100,2) As "Customer Retention Percentage"
from base;

-- KPI 6: Month-over-Month (MoM) Revenue Growth
-- The "Wall Street" Metric: Stakeholders don't just want to know how much we sold; they want to know the velocity of growth. 
-- Are we growing or shrinking compared to last month?

with base as (SELECT date_format((o.order_purchase_timestamp),"%Y-%m") As Months_Years, sum(p.payment_value) As Monthly_Revenue,
lag(sum(p.payment_value)) over(order by date_format((o.order_purchase_timestamp),"%Y-%m")) as prev_month_rev
FROM olist_orders_dataset o
Left Join olist_order_payments_dataset p
on o.order_id=p.order_id
Group by 1)

select Months_Years,Monthly_Revenue,prev_month_rev, round((Monthly_Revenue-prev_month_rev)/prev_month_rev*100,2) as MOM_Growth_per
from base
where round((Monthly_Revenue-prev_month_rev)/prev_month_rev*100,2) is not null;

-- KPI 7: The "Pareto Principle" (80/20 Rule) Analysis
-- The "Strategy" Metric: In almost every business, 20% of the products (or customers) drive 80% of the revenue. We need to identify that top tier.
-- The Challenge: Calculate the Cumulative Percentage of revenue contributed by each product category.

SELECT p.product_category_name, sum(o.price) as revenue,
sum(sum(o.price)) over(order by sum(o.price) desc)/sum(sum(o.price)) over() * 100 as percentage_revenue
FROM olist_products_dataset p
left join olist_order_items_dataset o
on p.product_id=o.product_id
group by 1;



