--Get top 5 most profitable clients
SELECT *
FROM clients_total_spend
ORDER BY total_spend DESC
FETCH FIRST 5 rows only;
--Get top 3 quantities in stock
SELECT *
FROM top_selling_things
ORDER BY total_quantity DESC
FETCH FIRST 3 ROWS ONLY;

--Revenue for each city
SELECT
    h.city,
    SUM(pp.quantity * t.sell_price) AS total_revenue
FROM purchase p
JOIN client c ON p.client_id = c.client_id
JOIN homeaddress h ON c.client_id = h.client_id
JOIN purchasepart pp ON p.purchase_id = pp.purchase_id
JOIN thing t ON pp.thing_id = t.thing_id
GROUP BY h.city
ORDER BY total_revenue DESC;

--Avg revenue for each purchase
SELECT
    AVG(order_total) AS avg_order_value
FROM (
    SELECT
        p.purchase_id,
        SUM(pp.quantity * t.sell_price) AS order_total
    FROM purchase p
    JOIN purchasepart pp ON p.purchase_id = pp.purchase_id
    JOIN thing t ON pp.thing_id = t.thing_id
    GROUP BY p.purchase_id
);