-- Calculate the average days between orders
WITH format_dates AS (
  SELECT
    user_id,
    order_date,
    DATE(order_date) AS order_day,
    LAG(DATE(order_date)) OVER (
      PARTITION BY user_id
      ORDER BY DATE(order_date)
    ) AS prev_order
  FROM `ecommerce.orders`
), day_diff AS (
  SELECT
    user_id,
    prev_order,
    DATE_DIFF(order_day, prev_order, DAY) AS num_day_diff
  FROM format_dates
  ORDER BY user_id
)
SELECT
  user_id,
  CAST(AVG(num_day_diff) AS INT64) AS avg_day_diff
FROM day_diff
WHERE prev_order IS NOT NULL
GROUP BY user_id
ORDER BY avg_day_diff DESC