SELECT
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'Completed';