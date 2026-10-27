SELECT
    b.booking_reference,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    s.service_name,
    so.quantity,
    s.service_price * so.quantity AS service_total,
    so.order_status
FROM service_orders so
JOIN bookings b
    ON so.booking_id = b.booking_id
JOIN guests g
    ON b.guest_id = g.guest_id
JOIN services s
    ON so.service_id = s.service_id;