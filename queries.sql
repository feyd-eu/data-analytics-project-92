SELECT COUNT(customer_id) AS customer_count -- подсчитываем количество ID покупателей
FROM customers -- в таблице customers

/** Step 5.1 **/
select
  concat(e.first_name, ' ', e.last_name) as name,           -- cоставляем полное имя продавца из его имени и фамилии
  count(s.sales_person_id) as operations,                   -- подсчитываем количество операций на каждого продавца
  round(coalesce(sum(s.quantity * p.price),0),0) as income  -- подсчитываем доход на каждого продавца
                                                                -- заменяем coalesce NULL на 0
                                                                -- округляем до целого числа
from employees e                                            -- выбираем данные из таблицы employees; объединяем ее с таблицами sales и products
left join sales s
  on s.sales_person_id = e.employee_id
left join products p
  on p.product_id = s.product_id
group by concat(e.first_name, ' ', e.last_name)             -- группируем данные по имени продавца
order by income desc                                        -- ранжирум по доходу от большего к меньшему    
LIMIT 10                                                    -- оставляем только 10 первых результатов    


/** Step 5.3 **/
with tab as (select                                         -- создаем CTE для последующей работы
    s.quantity,                                             -- выбираем количество проданных товаров
    p.price,                                                -- выбираем цену каждого товара
    concat(e.first_name, ' ', e.last_name) as name,         -- cоставляем полное имя продавца из его имени и фамилии
    s.sale_date as date,                                    -- выбираем дату продажи
    to_char(s.sale_date, 'day') as weekday                  -- превращаем дату продажи в день недели, записанный с маленькой буквы
from employees e                                            -- выбираем данные из таблицы employees; объединяем ее с таблицами sales и products
left join sales s
  on s.sales_person_id = e.employee_id
left join products p
  on p.product_id = s.product_id
group by e.employee_id, s.customer_id, s.sale_date, s.quantity, p.price, p.name) -- группируем данные по всем указанным ранее параметрам

select
	distinct t.name,                                          -- выбираем полное имя продавца из CTE; distinct помогает избавиться от дублирующихся строк
	t.date,                                                   -- выбираем дату продажи (к сожалениию, не понимаю, как обойтись без нее в целях сортировки)
	t.weekday,                                                -- выбираем день продажи
	round(sum(t.quantity * t.price) over (partition by t.name order by t.date),0) as income -- считаем суммарный доход по продавцу на каждую из дат
from tab as t                                               -- выбираем данные из CTE tab
group by t.date, weekday, t.name, t.quantity, t.price       -- группируем данные по всем указанным ранее параметрам
order by t.date, t.name                                     -- сортируем данные по дате и имени продавца   
