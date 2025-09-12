-- Identify users who haven’t placed an order in the last 90 days.

SELECT
 user_id,
 MAX(order_date) AS latest_order,
 CURRENT_DATETIME() as current_date,
 DATE_DIFF(
  CURRENT_DATETIME()
  , CAST(MAX(order_date) AS DATETIME)
  , DAY
 ) AS days_from_last_order
FROM ecommerce.orders
GROUP BY user_id
HAVING
  days_from_last_order > 90