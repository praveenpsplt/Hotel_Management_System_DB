SELECT
    b.booking_reference,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    g.phone,
    r.room_number,
    rt.type_name AS room_type,
    b.check_in,
    b.check_out,
    b.booking_status
FROM bookings b
JOIN guests g
    ON b.guest_id = g.guest_id
JOIN rooms r
    ON b.room_id = r.room_id
JOIN room_types rt
    ON r.room_type_id = rt.room_type_id;