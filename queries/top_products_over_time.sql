WITH main AS (
  SELECT 
    p.product_id,
    p.category,
    p.price * oi.quantity AS tot_amount,
    DATE_TRUNC(o.order_date, QUARTER) AS quarter
  FROM ecommerce.order_items oi
  JOIN ecommerce.products p
    ON oi.product_id = p.product_id
  JOIN ecommerce.orders o
    ON oi.order_id = o.order_id
)
SELECT
  quarter,
  product_id,
  category,
  ROUND(SUM(tot_amount), 2) AS sum_amount,
  RANK() OVER (PARTITION BY quarter ORDER BY SUM(tot_amount) DESC) AS ranking_quarter
FROM main
GROUP BY quarter, product_id, category
QUALIFY ranking_quarter BETWEEN 1 AND 5
ORDER BY quarter ASC, ranking_quarter ASC;
