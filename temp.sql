select count(customer_id) as customer_count -- подсчитываем количество ID покупателей
from customers as c -- в таблице customers

select count(distinct last_name)
from customers c 

select count(distinct first_name)
from customers c 

select first_name, last_name
from customers c 

select * from customers c 

select * from employees e 

select * from sales 

select * from products p 

select concat(e.first_name, ' ', e.last_name),
-- s.product_id,
p.name,
p.price,
s.quantity,
count( distinct s.sales_person_id),
(p.price * s. quantity) as sum
from employees e
left join sales s
on s.sales_person_id = e.employee_id
left join products p
on p.product_id = s.product_id 
group by concat(e.first_name, ' ', e.last_name), p.name, p.price, s.quantity, (p.price * s. quantity)

select concat(e.first_name, ' ', e.last_name) as employee,
sum(p.price * s. quantity) as sum
from employees e
left join sales s
on s.sales_person_id = e.employee_id
left join products p
on p.product_id = s.product_id
group by concat(e.first_name, ' ', e.last_name)
