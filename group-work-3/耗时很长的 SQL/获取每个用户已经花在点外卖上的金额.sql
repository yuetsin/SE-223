SELECT 
    user_attributes.username, balance, SUM(amount * price) AS total_spent, COUNT(*) AS order_count
FROM
    order_include,
    dishes,
    orders,
    user_attributes
WHERE
    order_include.dish_id = dishes.dish_id
        AND order_include.order_id = orders.order_id
        AND user_attributes.username = orders.username
        GROUP BY  username
ORDER BY username;