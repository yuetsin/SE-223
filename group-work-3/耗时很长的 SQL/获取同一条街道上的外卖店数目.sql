SELECT 
    road, COUNT(T.road)
FROM
    (SELECT 
        SUBSTRING(address, POSITION(' ' IN address) + 1) AS road
    FROM
        one.store
    ORDER BY road) AS T
GROUP BY road;