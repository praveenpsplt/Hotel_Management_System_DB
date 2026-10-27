SELECT
    b.booking_reference,
    r.room_number,
    DATEDIFF(b.check_out, b.check_in) AS nights,
    rt.price_per_night,
    DATEDIFF(b.check_out, b.check_in)
        * rt.price_per_night AS room_total
FROM bookings b
JOIN rooms r
    ON b.room_id = r.room_id
JOIN room_types rt
    ON r.room_type_id = rt.room_type_id;