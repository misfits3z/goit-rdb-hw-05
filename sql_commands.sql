-- 1
SELECT *,
       (SELECT customer_id 
        FROM orders 
        WHERE orders.id = order_details.order_id) AS customer_id
FROM order_details;

-- 2
SELECT *, 
       (SELECT shipper_id 
        FROM orders 
        WHERE orders.id = order_details.order_id ) AS shipper_id
FROM order_details
WHERE order_id IN (
    SELECT id 
    FROM orders 
    WHERE shipper_id = 3
);
-- 3
SELECT
    order_id,
    AVG(quantity) AS avg_quantity
FROM
    (SELECT * FROM order_details WHERE quantity>10) AS temp_table
GROUP BY
    order_id;

-- 4
    WITH TemporalTable AS (
    SELECT *
    FROM order_details
    WHERE quantity > 10
)
SELECT order_id,
    AVG(quantity) AS avg_quantity
FROM TemporalTable
GROUP BY order_id;

-- 5
DELIMITER //

CREATE FUNCTION Divide(input_number1 FLOAT, input_number2 FLOAT)
RETURNS FLOAT
DETERMINISTIC
NO SQL
BEGIN
    DECLARE result FLOAT;
    
    -- Перевірка ділення на 0 
    IF input_number2 = 0 THEN
        SET result = NULL;  
    ELSE
        SET result = input_number1 / input_number2;
    END IF;
    
    RETURN result;
END //

DELIMITER ;
SELECT quantity, Divide(quantity, 10) AS divided_quantity
FROM order_details;