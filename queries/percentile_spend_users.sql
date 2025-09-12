-- Calculate each user’s total spend and classify them into percentiles (e.g., top 10%, middle 40%, etc.)

SELECT
  user_id,
  total_spend_per_user AS total_spend_per_user,
  (PERCENT_RANK() OVER(ORDER BY total_spend_per_user ASC)*100) as quantile_over_100
FROM (
  SELECT 
    o.user_id,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_spend_per_user
  FROM `ecommerce.orders` o
  JOIN `ecommerce.order_items` oi ON o.order_id = oi.order_id
  JOIN `ecommerce.products` p ON oi.product_id = p.product_id
  GROUP BY o.user_id
)
ORDER BY total_spend_per_user DESC