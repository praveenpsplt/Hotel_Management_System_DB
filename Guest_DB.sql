CREATE DATABASE hotel_management;

USE hotel_management;


-- 1. HOTEL GUESTS
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
-- 2. ROOM TYPES
CREATE TABLE room_types (
    room_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    price_per_night DECIMAL(10,2) NOT NULL,
    capacity INT NOT NULL
);

-- 3. ROOMS
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    floor_number INT,
    room_status ENUM(
        'Available',
        'Occupied',
        'Maintenance'
    ) DEFAULT 'Available',

    FOREIGN KEY (room_type_id)
        REFERENCES room_types(room_type_id)
);

-- 4. DEPARTMENTS
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_email VARCHAR(100) UNIQUE
);

-- 5. HOTEL STAFF
CREATE TABLE staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    job_title VARCHAR(100),
    salary DECIMAL(10,2),
    joining_date DATE,

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- 6. BOOKINGS / RESERVATIONS
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_reference VARCHAR(30) NOT NULL UNIQUE,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    number_of_guests INT NOT NULL DEFAULT 1,
    booking_status ENUM(
        'Confirmed',
        'Checked-In',
        'Checked-Out',
        'Cancelled'
    ) DEFAULT 'Confirmed',
    booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (guest_id)
        REFERENCES guests(guest_id),

    FOREIGN KEY (room_id)
        REFERENCES rooms(room_id),

    CHECK (check_out > check_in),
    CHECK (number_of_guests > 0)
);

-- 7. PAYMENTS
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM(
        'Cash',
        'Card',
        'UPI',
        'Bank Transfer'
    ) NOT NULL,
    payment_status ENUM(
        'Pending',
        'Completed',
        'Failed',
        'Refunded'
    ) DEFAULT 'Pending',
    transaction_reference VARCHAR(100) UNIQUE,

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id),

    CHECK (amount >= 0)
);

-- 8. HOTEL SERVICES
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    service_price DECIMAL(10,2) NOT NULL,
    description VARCHAR(255),

    CHECK (service_price >= 0)
);

-- 9. SERVICE ORDERS
CREATE TABLE service_orders (
    service_order_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status ENUM(
        'Requested',
        'In Progress',
        'Completed',
        'Cancelled'
    ) DEFAULT 'Requested',

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id),

    FOREIGN KEY (service_id)
        REFERENCES services(service_id),

    CHECK (quantity > 0)
);

-- Room types
INSERT INTO room_types
(type_name, description, price_per_night, capacity)
VALUES
('Standard', 'Standard single or double room', 2000.00, 2),
('Deluxe', 'Premium room with additional amenities', 3500.00, 3),
('Suite', 'Luxury suite with living area', 6000.00, 4);

-- Rooms
INSERT INTO rooms
(room_number, room_type_id, floor_number, room_status)
VALUES
('101', 1, 1, 'Available'),
('102', 1, 1, 'Available'),
('201', 2, 2, 'Available'),
('202', 2, 2, 'Available'),
('301', 3, 3, 'Available');

-- Guests
INSERT INTO guests
(first_name, last_name, email, phone, address)
VALUES
('Rahul', 'Sharma', 'rahul@example.com',
 '9000000001', 'Hyderabad'),
('Priya', 'Reddy', 'priya@example.com',
 '9000000002', 'Bengaluru'),
('Arjun', 'Kumar', 'arjun@example.com',
 '9000000003', 'Chennai');

-- Departments
INSERT INTO departments
(department_name, department_email)
VALUES
('Reception', 'reception@hotel.com'),
('Housekeeping', 'housekeeping@hotel.com'),
('Food and Beverage', 'food@hotel.com'),
('IT Support', 'it@hotel.com'),
('Finance', 'finance@hotel.com');

-- Staff
INSERT INTO staff
(first_name, last_name, email, phone,
 department_id, job_title, salary, joining_date)
VALUES
('Amit', 'Verma', 'amit@hotel.com', '9111111111',
 1, 'Receptionist', 25000.00, '2025-01-10'),
('Sneha', 'Rao', 'sneha@hotel.com', '9111111112',
 2, 'Housekeeping Supervisor', 30000.00, '2024-06-15'),
('Kiran', 'Das', 'kiran@hotel.com', '9111111113',
 4, 'IT Administrator', 45000.00, '2025-03-01');

-- Bookings
INSERT INTO bookings
(booking_reference, guest_id, room_id,
 check_in, check_out, number_of_guests, booking_status)
VALUES
('HTL-2026-001', 1, 1, '2026-11-01', '2026-11-03', 2, 'Confirmed'),
('HTL-2026-002', 2, 3, '2026-11-05', '2026-11-08', 2, 'Confirmed'),
('HTL-2026-003', 3, 5, '2026-11-10', '2026-11-12', 3, 'Confirmed');

-- Payments
INSERT INTO payments
(booking_id, amount, payment_method,
 payment_status, transaction_reference)
VALUES
(1, 4000.00, 'UPI', 'Completed', 'TXN-10001'),
(2, 3500.00, 'Card', 'Completed', 'TXN-10002'),
(3, 6000.00, 'Cash', 'Pending', NULL);

-- Services
INSERT INTO services
(service_name, service_price, description)
VALUES
('Room Service', 300.00, 'Food delivered to the room'),
('Laundry', 200.00, 'Laundry and ironing'),
('Airport Pickup', 1000.00, 'Airport transportation'),
('Extra Bed', 500.00, 'Additional bed for the guest');

-- Service orders
INSERT INTO service_orders
(booking_id, service_id, quantity, order_status)
VALUES
(1, 1, 2, 'Completed'),
(1, 2, 1, 'Requested'),
(2, 3, 1, 'Completed');


