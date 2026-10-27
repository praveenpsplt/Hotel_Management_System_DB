# Hotel Management System — MySQL Database Project

## Project Overview

The **Hotel Management System** is a relational database project built with MySQL. It stores and organizes hotel information such as guests, room types, rooms, reservations, departments, staff, payments, and additional services.

The project demonstrates relational database design, primary and foreign keys, constraints, sample data, joins, aggregate functions, and basic CRUD operations.

## Objectives

- Maintain guest information with unique email addresses and phone numbers.
- Manage room types, room prices, room capacity, and room status.
- Record guest reservations and their check-in/check-out dates.
- Organize hotel employees by department.
- Track payments and payment status.
- Record additional services requested for a booking.
- Run reports for bookings, room availability, payments, and staff.

## Technology

- **Database:** MySQL
- **SQL client:** MySQL Workbench (or another MySQL client)
- **Language:** SQL

## Database Structure

Database name: `hotel_management`

| Table | Purpose |
|---|---|
| `guests` | Guest contact and address details |
| `room_types` | Room categories, nightly prices, and capacity |
| `rooms` | Room numbers, floors, types, and current status |
| `departments` | Hotel departments and department email addresses |
| `staff` | Employee details and department assignment |
| `bookings` | Reservation reference, guest, room, dates, and status |
| `payments` | Payment amounts, methods, transaction references, and status |
| `services` | Optional hotel services and prices |
| `service_orders` | Services requested for a specific booking |

### Relationship Summary

- One guest can have multiple bookings.
- One room type can be assigned to multiple rooms.
- A room can have bookings at different times.
- One department can have multiple staff members.
- One booking can have multiple payment records.
- One booking can have multiple service orders.
- One service can appear in multiple service orders.

`PK` means Primary Key; `FK` means Foreign Key.

## Entity Relationship Diagram (Text View)

```text
room_types (1) -------- (many) rooms
                              |
                              | (one room to many bookings over time)
                              |
guests (1) ------------- (many) bookings
                              |
                    +---------+---------+
                    |                   |
              (many) payments     (many) service_orders (many) ---- services (1)

departments (1) ------- (many) staff
```

## Setup Instructions

### 1. Install MySQL

Install MySQL Server and, optionally, MySQL Workbench. Ensure the MySQL service is running.

### 2. Create the database

Open MySQL Workbench, connect to your local MySQL server, and execute:

```sql
CREATE DATABASE hotel_management;
USE hotel_management;
```

### 3. Create the tables

Run the `CREATE TABLE` statements for all nine tables in this order:

1. `guests`
2. `room_types`
3. `rooms`
4. `departments`
5. `staff`
6. `bookings`
7. `payments`
8. `services`
9. `service_orders`

The order respects the foreign-key dependencies.

### 4. Insert sample data

Run the sample `INSERT INTO` statements after creating all tables. The sample records use illustrative guest, employee, reservation, payment, and service information.

### 5. Verify the setup

```sql
USE hotel_management;
SHOW TABLES;

SELECT * FROM guests;
SELECT * FROM room_types;
SELECT * FROM rooms;
SELECT * FROM departments;
SELECT * FROM staff;
SELECT * FROM bookings;
SELECT * FROM payments;
SELECT * FROM services;
SELECT * FROM service_orders;
```

> **Note:** The complete SQL schema and sample data are provided in the project conversation. Save those statements in a file such as `hotel_management.sql` if you want to run the entire project from one script.

## Example Queries

### 1. Show bookings with guest and room details

```sql
SELECT
    b.booking_reference,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    g.phone,
    r.room_number,
    rt.type_name AS room_type,
    b.check_in,
    b.check_out,
    b.booking_status
FROM bookings AS b
JOIN guests AS g ON b.guest_id = g.guest_id
JOIN rooms AS r ON b.room_id = r.room_id
JOIN room_types AS rt ON r.room_type_id = rt.room_type_id;
```

### 2. Find rooms without overlapping active bookings

This example checks availability from **1 November 2026** to **5 November 2026**. The checkout date is exclusive: a booking ending on 1 November does not overlap a stay beginning on 1 November.

```sql
SELECT
    r.room_number,
    rt.type_name,
    rt.price_per_night
FROM rooms AS r
JOIN room_types AS rt ON r.room_type_id = rt.room_type_id
WHERE r.room_status <> 'Maintenance'
  AND NOT EXISTS (
      SELECT 1
      FROM bookings AS b
      WHERE b.room_id = r.room_id
        AND b.booking_status IN ('Confirmed', 'Checked-In')
        AND b.check_in < '2026-11-05'
        AND b.check_out > '2026-11-01'
  );
```

### 3. Calculate room charges

```sql
SELECT
    b.booking_reference,
    r.room_number,
    DATEDIFF(b.check_out, b.check_in) AS nights,
    rt.price_per_night,
    DATEDIFF(b.check_out, b.check_in) * rt.price_per_night AS room_total
FROM bookings AS b
JOIN rooms AS r ON b.room_id = r.room_id
JOIN room_types AS rt ON r.room_type_id = rt.room_type_id;
```

### 4. Calculate completed payments by booking

```sql
SELECT
    b.booking_reference,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    COALESCE(
        SUM(CASE WHEN p.payment_status = 'Completed' THEN p.amount ELSE 0 END),
        0
    ) AS amount_paid
FROM bookings AS b
JOIN guests AS g ON b.guest_id = g.guest_id
LEFT JOIN payments AS p ON b.booking_id = p.booking_id
GROUP BY b.booking_id, b.booking_reference, g.first_name, g.last_name;
```

### 5. Show employees by department

```sql
SELECT
    d.department_name,
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    s.job_title,
    s.email
FROM departments AS d
LEFT JOIN staff AS s ON d.department_id = s.department_id
ORDER BY d.department_name;
```

### 6. Get total completed payments

```sql
SELECT COALESCE(SUM(amount), 0) AS total_completed_payments
FROM payments
WHERE payment_status = 'Completed';
```

### 7. Show service orders

```sql
SELECT
    b.booking_reference,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    s.service_name,
    so.quantity,
    s.service_price * so.quantity AS service_total,
    so.order_status
FROM service_orders AS so
JOIN bookings AS b ON so.booking_id = b.booking_id
JOIN guests AS g ON b.guest_id = g.guest_id
JOIN services AS s ON so.service_id = s.service_id;
```

### 8. Update a booking status

```sql
UPDATE bookings
SET booking_status = 'Checked-In'
WHERE booking_reference = 'HTL-2026-001';
```

## Constraints and Design Notes

- `PRIMARY KEY` uniquely identifies each record.
- `FOREIGN KEY` links related tables and helps maintain referential integrity.
- `UNIQUE` prevents duplicate emails, phone numbers, room numbers, and booking references where specified.
- `NOT NULL` requires a value for essential fields.
- `CHECK` validates conditions such as positive guest counts and valid date ranges (enforcement depends on the MySQL version).
- `ENUM` restricts status and payment-method fields to the listed values.
- `AUTO_INCREMENT` generates numeric IDs automatically.

## Current Scope and Future Improvements

This is a learning/demo database, not a complete production booking platform.

Possible improvements:

- Prevent overlapping reservations safely using transactions and appropriate concurrency controls.
- Calculate complete invoices, including service charges, taxes, discounts, and refunds.
- Add a booking-room allocation model if one reservation can contain multiple rooms.
- Add audit fields, indexes for frequently searched columns, and role-based database permissions.
- Add staff login and application-level authentication if a front end is developed.
- Implement a workflow that updates room occupancy during check-in and check-out.
- Add stored procedures, views, and triggers only where they suit the application's requirements.

**Important:** The `rooms.room_status` value and booking records must be kept consistent by the application or a defined database workflow. The example availability query excludes maintenance rooms and rooms with overlapping active bookings, but concurrent booking attempts still require transaction-safe handling.

## Suggested Repository Layout

```text
hotel-management-system/
├── README.md
├── hotel_management.sql
└── docs/
    └── er-diagram.png
```

- `README.md`: Project overview and setup guide.
- `hotel_management.sql`: Database creation, table definitions, and sample data.
- `docs/er-diagram.png`: Optional exported ER diagram.

## Learning Outcomes

By completing this project, you can practice:

- Database and table creation
- Data types and constraints
- Primary keys and foreign keys
- One-to-many relationships
- `INSERT`, `SELECT`, and `UPDATE`
- `JOIN`, `GROUP BY`, aggregate functions, and subqueries
- Date calculations and reservation availability logic

## License

This project is intended for learning and portfolio demonstration. Add a license file if you plan to distribute it publicly.
