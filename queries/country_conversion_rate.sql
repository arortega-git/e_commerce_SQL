-- Which country has the highest conversion rate (users with at least one order / total users)?

WITH total_users AS (
  SELECT
    country, 
    (
      SELECT COUNT(DISTINCT(user_id))FROM ecommerce.orders GROUP BY country
    ) as  total_num_users,
    COUNT(DISTINCT(user_id)) as country_users,
  FROM `ecommerce.users`
  GROUP BY country
) 
SELECT
  country,
  ROUND((country_users / total_num_users) * 100, 2) AS country_conversion_rate 
FROM total_users

