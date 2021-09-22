--- 7

WITH results as (
SELECT  carton_id,
MIN(carton_vol) as carton_vol
FROM
(
SELECT carton.carton_id,
       (carton.len * carton.width * carton.height) as carton_vol,
       calc.order_vol
       FROM carton
       INNER JOIN
(       
SELECT oi.order_id,
  SUM(p.len * p.width * p.height * oi.product_quantity) as order_vol
       FROM order_items as oi
       INNER JOIN product as p
       ON oi.product_id = p.product_id
       WHERE
       order_id = 10006
       GROUP BY oi.order_id) as calc
       ) res
       WHERE
       carton_vol >= order_vol
       GROUP BY carton_id
       ORDER BY carton_vol)
select * from results
LIMIT 1;

  
 
 
--- 8 
 
Select online_customer.CUSTOMER_ID, concat(CUSTOMER_FNAME, ' ', CUSTOMER_LNAME) as customer_full_name, order_header.ORDER_ID, order_items.PRODUCT_QUANTITY
from online_customer, order_header, order_items
where online_customer.customer_id = order_header.CUSTOMER_ID and order_items.ORDER_ID = order_header.ORDER_ID
and PRODUCT_QUANTITY > 10;

--- 9

SELECT order_items.ORDER_ID, 
  online_customer.CUSTOMER_ID,
       CONCAT(CUSTOMER_FNAME, ' ', CUSTOMER_LNAME) as customer_full_name, 
       SUM(order_items.PRODUCT_QUANTITY) as product_quantity
from online_customer, order_header, order_items
where order_items.ORDER_ID = order_header.ORDER_ID and online_customer.customer_id = order_header.CUSTOMER_ID and order_items.order_id > 10060 AND
      order_status = "Shipped"
GROUP BY order_id, customer_id, customer_full_name;


--- 10

WITH shipped_products as
(SELECT oh.order_id,
  oi.product_id,
       oi.product_quantity,
       p.product_price,
       p.product_class_code,
       pc.product_class_desc,
       c.customer_id
       FROM
       order_header as oh JOIN order_items as oi ON oh.order_id = oi.order_id
       JOIN online_customer as c on oh.customer_id = c.customer_id
       JOIN address as a ON c.address_id = a.address_id
       JOIN product as p ON oi.product_id = p.product_id
       JOIN product_class as pc on pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE
       WHERE
       oh.order_status = "Shipped" AND
       a.country != "USA" AND
       a.country != "India")
       SELECT product_class_desc,
     SUM(product_quantity) as 'Total Quantity',
              SUM(product_quantity * product_price) as 'Total Value'
              FROM shipped_products
              GROUP BY product_class_desc
              ORDER BY 2 DESC
              LIMIT 1;


