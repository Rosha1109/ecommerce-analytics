DROP VIEW clients_with_address;
DROP VIEW best_selling_things;
DROP VIEW clients_total_spend;

CREATE VIEW client_with_address AS
SELECT c.client_id,
c.name,
c.client.EMAIL_ADDRESS,
h.street,
h.city,
h.postal_code
FROM client c JOIN HomeAddress h 
ON c.client_id= h.client_id;

CREATE VIEW client_purchases AS
SELECT
c.client_id,
c.name,
COUNT(p.PURCHASE_ID) AS purchase_count
FROM client c LEFT JOIN purchase p ON c.client_id = p.client_id
GROUP BY c.client_id,c.name;

CREATE VIEW best_selling_things AS
SELECT
    t.thing_id,
    t.thing_name,
    SUM(pp.QUANTITY) AS total_quantity,
    SUM(pp.QUANTITY * t.sell_price) AS total_earnings
FROM thing t JOIN PurchasePart pp ON t.thing_id = pp.thing_id
GROUP BY t.thing_id, t.thing_name
ORDER BY total_earnings DESC;

 
CREATE VIEW clients_total_spend AS
SELECT
    c.client_id,
    c.name,
    c.email_address,
    SUM(pp.quantity * t.sell_price) AS total_spend
FROM client c
JOIN purchase p ON c.client_id=p.CLIENT_ID
JOIN purchasepart pp ON p.purchase_id = pp.purchase_id
JOIN thing t ON pp.thing_id = t.thing_id
GROUP BY c.client_id, c.name, c.email_address; 

