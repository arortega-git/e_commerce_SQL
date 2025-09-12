-- Track monthly revenue by product category

--First we truncate the order date to month level and we group by category and month, by the sum of the revenue
WITH amount_month AS (
  SELECT
    DATE_TRUNC(o.order_date, MONTH) AS month_order,
    p.category,
    SUM(oi.unit_price * oi.quantity) AS revenue_per_category
  FROM `ecommerce.order_items` oi 
    JOIN `ecommerce.orders` o ON oi.order_id = o.order_id 
    JOIN `ecommerce.products` p ON oi.product_id = p.product_id
  GROUP BY category, month_order
)
--Then we calculate the window functions for previous revenue, so we can calculate the growth rate
SELECT
  category,
  month_order,
  COALESCE(LAG(amount_month.revenue_per_category, 1) OVER(PARTITION BY category ORDER BY month_order ASC), 0) AS prev_revenue,
  amount_month.revenue_per_category,
  ROUND(
    (
      (amount_month.revenue_per_category - (
        COALESCE(LAG(amount_month.revenue_per_category, 1) OVER(PARTITION BY category ORDER BY month_order ASC), 0)
        )
      ) /    amount_month.revenue_per_category
    ) * 100, 2
  ) AS growth_rate
FROM amount_month
