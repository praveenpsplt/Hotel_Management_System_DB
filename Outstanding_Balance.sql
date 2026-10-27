SELECT
    b.booking_reference,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    COALESCE(SUM(
        CASE
            WHEN p.payment_status = 'Completed'
            THEN p.amount
            ELSE 0
        END
    ), 0) AS amount_paid
FROM bookings b
JOIN guests g
    ON b.guest_id = g.guest_id
LEFT JOIN payments p
    ON b.booking_id = p.booking_id
GROUP BY
    b.booking_id,
    b.booking_reference,
    g.first_name,
    g.last_name;