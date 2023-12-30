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
