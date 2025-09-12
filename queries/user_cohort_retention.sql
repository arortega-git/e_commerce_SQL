WITH new_users AS (
    SELECT 
        FORMAT_DATE('%Y-%m', DATE(signup_date)) AS signup_month,
        COUNT(user_id) AS total_new_users
    FROM ecommerce.users
    GROUP BY signup_month
), 
-- We calculate the number of new users per month
user_orders AS (
    SELECT 
        u.user_id,
        FORMAT_DATE('%Y-%m', DATE(u.signup_date)) AS signup_month,
        FORMAT_DATE('%Y-%m', DATE(o.order_date)) AS order_month
    FROM ecommerce.users u
    JOIN ecommerce.orders o
    ON u.user_id = o.user_id
),
-- We obtain the list of users who made an order, their signup month and the months they made an order. The join will filter just the users
-- who made an order already, since it joins the data by user_id on the common rows
retention AS (
    SELECT 
        signup_month,
        order_month,
        COUNT(DISTINCT user_id) AS retained_users
    FROM user_orders
    GROUP BY signup_month, order_month
)
-- We group the distinct users by signup month and order month, calculating the # of users who signed up and made and order afterwards
SELECT
    r.signup_month,
    r.order_month,
    n.total_new_users,
    r.retained_users AS num_users_who_ordered_in_following_months,
    ROUND(CAST(r.retained_users AS FLOAT64) / n.total_new_users, 2) AS retention_rate
FROM retention r
JOIN new_users n
ON r.signup_month = n.signup_month
ORDER BY r.signup_month
-- And finally we divide the number of total users who signed up by the num of users who made
-- an order after signing up, grouped by signup month and order month