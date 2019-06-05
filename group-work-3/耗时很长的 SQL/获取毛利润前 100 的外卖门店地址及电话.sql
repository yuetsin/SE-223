SELECT 
    store.store_id,
    store.s_phone,
    store.address,
    SUM(amount * price) AS raw_profit
FROM
    orders,
    order_include,
    dishes,
    store
WHERE
    orders.order_id = order_include.order_id
        AND order_include.dish_id = dishes.dish_id
        AND dishes.store_id = store.store_id
GROUP BY store_id
ORDER BY raw_profit DESC
LIMIT 100;