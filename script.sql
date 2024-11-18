-- 1.Retrieve the total number of orders placed.
select count(*) as total_orders from orders;

-- 2.Calculate the total revenue generated from pizza sales.
select round(sum(price*quantity),2) as "total revenue" from pizzas p inner join order_details o on
p.pizza_id=o.pizza_id;

-- 3.Identify the highest-priced pizza.
select price,name from pizzas p inner join pizza_types pt 
on p.pizza_type_id=pt.pizza_type_id order by price desc limit 1;

-- 4.Identify the most common pizza size ordered.
SELECT SIZE,COUNT(QUANTITY) AS COUNT FROM PIZZAS P inner JOIN order_details O
ON P.PIZZA_ID=O.pizza_id group by SIZE order by COUNT DESC;

-- 5.List the top 5 most ordered pizza types along with their quantities.
SELECT name,sum(quantity) as Quantity from pizza_types pt inner join pizzas p 
on pt.pizza_type_id=p.pizza_type_id inner join order_details o on p.pizza_id=o.pizza_id 
group by name order by quantity desc limit 5;

-- 6.Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT category,sum(quantity) as Quantity from pizza_types pt inner join pizzas p 
on pt.pizza_type_id=p.pizza_type_id inner join order_details o on p.pizza_id=o.pizza_id 
group by category order by quantity desc ;

-- 7.Determine the distribution of orders by hour of the day.
select hour(order_time) hour,count(quantity) as quantity from orders o 
inner join order_details od on o.order_id=od.order_id
group by hour order by hour ;

-- 8.Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) as count from pizza_types group by category;

-- 9.Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity_orders)) as average_pizza_ordered_perday from (select date(order_date)  as date ,count(quantity) as quantity_orders from orders o inner join order_details od 
on o.order_id=od.order_id group by date)as ord_qty  ;

-- 10.Determine the top 3 most ordered pizza types based on revenue.
select name,sum(price*quantity) as revenue from pizzas inner join order_details
on pizzas.pizza_id=order_details.pizza_id inner join pizza_types on 
pizzas.pizza_type_id=pizza_types.pizza_type_id
group by name order by revenue desc limit 3;

-- 11.Calculate the percentage contribution of each pizza type to total revenue.
select category,concat(round((revenue/sum(revenue) over ())*100),"%")as percentage from
(select category,round(sum(price*quantity),2) as revenue from pizzas 
inner join order_details
on pizzas.pizza_id=order_details.pizza_id inner join pizza_types on 
pizzas.pizza_type_id=pizza_types.pizza_type_id
group by category order by revenue desc)as rev ;



-- 12.Analyze the cumulative revenue generated over time.
select month,round(sum(revenue) 
over(rows between unbounded preceding and current row)) as cumulative_sum from 
(select monthname(order_date) as month, sum(price*quantity) as revenue
 from pizzas join order_details
on pizzas.pizza_id=order_details.pizza_id join orders on order_details.order_id=orders.order_id
group by month) as rev group by month;


select month(order_date) as month,round(sum(price*quantity)) as revenue
from pizzas join order_details
on pizzas.pizza_id=order_details.pizza_id join orders on 
order_details.order_id=orders.order_id
group by month;

-- 13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
with cte as 
(select category,name,sum(price*quantity) as revenue,rank() 
over(partition by category order by sum(price*quantity) desc) as ranks
 from pizzas join order_details
on pizzas.pizza_id=order_details.pizza_id join
 pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
 group by category,name ) 
 select * from cte where ranks<=3;
 
 

