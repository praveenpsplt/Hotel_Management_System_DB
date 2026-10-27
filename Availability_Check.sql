SELECT
    r.room_number,
    rt.type_name,
    rt.price_per_night
FROM rooms r
JOIN room_types rt
    ON r.room_type_id = rt.room_type_id
WHERE r.room_status <> 'Maintenance'
AND NOT EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.room_id = r.room_id
      AND b.booking_status IN (
          'Confirmed', 'Checked-In'
      )
      AND b.check_in < '2026-11-05'
      AND b.check_out > '2026-11-01'
);