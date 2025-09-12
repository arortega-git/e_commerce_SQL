-- Compute the average basket size (products per order)
-- and detect orders 2 standard deviations above the mean
WITH basket_per_order AS (
  SELECT
    o.order_id,
    SUM(oi.quantity) AS num_items_basket
  FROM ecommerce.orders o
  JOIN ecommerce.order_items oi ON o.order_id = oi.order_id
  GROUP BY o.order_id
),
stats AS (
  SELECT
    AVG(num_items_basket) AS mean_basket_size,
    STDDEV(num_items_basket) AS std_basket_size
  FROM basket_per_order
)
SELECT
  b.order_id,
  b.num_items_basket,
  s.mean_basket_size,
  s.std_basket_size
FROM basket_per_order b
CROSS JOIN stats s
WHERE b.num_items_basket > s.mean_basket_size + 2 * s.std_basket_size
ORDER BY b.num_items_basket DESC;
