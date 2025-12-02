-- 1. Driver Licenses (12 rows)
INSERT INTO driver_license (license_number, license_type, expiry_date) VALUES
('DL10000001', 'B', '2026-01-15'),
('DL10000002', 'B', '2027-03-22'),
('DL10000003', 'A', '2025-11-30'),
('DL10000004', 'C', '2028-07-10'),
('DL10000005', 'B', '2026-09-05'),
('DL10000006', 'B', '2029-02-14'),
('DL10000007', 'D', '2025-12-25'),
('DL10000008', 'B', '2027-06-18'),
('DL10000009', 'E', '2030-01-01'),
('DL10000010', 'B', '2026-04-12'),
('DL10000011', 'A', '2028-08-30'),
('DL10000012', 'B', '2027-10-05');

-- 2. Users (12 rows)
INSERT INTO "user" (email, firstname, lastname, driver_license_id) VALUES
('john.doe@example.com', 'John', 'Doe', 1),
('jane.smith@example.com', 'Jane', 'Smith', 2),
('mike.jones@example.com', 'Mike', 'Jones', 3),
('sarah.connor@example.com', 'Sarah', 'Connor', 4),
('bruce.wayne@example.com', 'Bruce', 'Wayne', 5),
('clark.kent@example.com', 'Clark', 'Kent', 6),
('diana.prince@example.com', 'Diana', 'Prince', 7),
('peter.parker@example.com', 'Peter', 'Parker', 8),
('tony.stark@example.com', 'Tony', 'Stark', 9),
('natasha.romanoff@example.com', 'Natasha', 'Romanoff', 10),
('steve.rogers@example.com', 'Steve', 'Rogers', 11),
('wanda.maximoff@example.com', 'Wanda', 'Maximoff', 12);

-- 3. Car Locations (12 rows)
INSERT INTO car_location (address) VALUES
('123 Main St, New York, NY'),
('456 Elm St, Los Angeles, CA'),
('789 Oak St, Chicago, IL'),
('101 Pine St, Houston, TX'),
('202 Maple St, Phoenix, AZ'),
('303 Cedar St, Philadelphia, PA'),
('404 Birch St, San Antonio, TX'),
('505 Walnut St, San Diego, CA'),
('606 Ash St, Dallas, TX'),
('707 Cherry St, San Jose, CA'),
('808 Spruce St, Austin, TX'),
('909 Fir St, Jacksonville, FL');

-- 4. Car Models (12 rows)
INSERT INTO car_model (model_name, fuel_type, base_price) VALUES
('Toyota Corolla', 'Petrol', 50.00),
('Honda Civic', 'Petrol', 55.00),
('Tesla Model 3', 'Electric', 80.00),
('Ford Mustang', 'Petrol', 90.00),
('Chevrolet Bolt', 'Electric', 70.00),
('Toyota Prius', 'Hybrid', 60.00),
('BMW 3 Series', 'Diesel', 85.00),
('Audi A4', 'Diesel', 88.00),
('Nissan Leaf', 'Electric', 65.00),
('Hyundai Elantra', 'Hybrid', 52.00),
('Kia Forte', 'Petrol', 48.00),
('Mercedes C-Class', 'Diesel', 95.00);

-- 5. Cars (12 rows)
INSERT INTO car (model_id, location, license_plate, status) VALUES
(1, 1, 'ABC-1234', 'Available'),
(2, 2, 'DEF-5678', 'Booked'),
(3, 3, 'GHI-9012', 'Available'),
(4, 4, 'JKL-3456', 'Repaired'),
(5, 5, 'MNO-7890', 'Available'),
(6, 6, 'PQR-1234', 'Booked'),
(7, 7, 'STU-5678', 'Available'),
(8, 8, 'VWX-9012', 'Available'),
(9, 9, 'YZA-3456', 'Booked'),
(10, 10, 'BCD-7890', 'Available'),
(11, 11, 'EFG-1234', 'Repaired'),
(12, 12, 'HIJ-5678', 'Available');

-- 6. Bookings (15 rows)
INSERT INTO booking (user_id, car_id, status) VALUES
(1, 1, 'completed'),
(2, 2, 'confirmed'),
(3, 3, 'completed'),
(4, 4, 'pending'),
(5, 5, 'completed'),
(6, 6, 'confirmed'),
(7, 7, 'completed'),
(8, 8, 'completed'),
(9, 9, 'confirmed'),
(10, 10, 'completed'),
(11, 11, 'pending'),
(12, 12, 'completed'),
(1, 3, 'completed'),
(2, 4, 'completed'),
(3, 5, 'completed');

-- 7. Trips (12 rows)
-- Linking to bookings that are 'completed' or 'confirmed'
INSERT INTO trip (book_id, start_location, end_location, start_time, end_time, price) VALUES
(1, 1, 2, '2025-11-01 10:00:00', '2025-11-01 12:00:00', 100.00),
(3, 3, 4, '2025-11-02 14:00:00', '2025-11-02 16:00:00', 160.00),
(5, 5, 6, '2025-11-03 09:00:00', '2025-11-03 11:00:00', 140.00),
(7, 7, 8, '2025-11-04 13:00:00', '2025-11-04 15:00:00', 170.00),
(8, 8, 9, '2025-11-05 08:00:00', '2025-11-05 10:00:00', 176.00),
(10, 10, 11, '2025-11-06 15:00:00', '2025-11-06 17:00:00', 104.00),
(12, 12, 1, '2025-11-07 11:00:00', '2025-11-07 13:00:00', 190.00),
(2, 2, 3, '2025-11-08 10:00:00', NULL, 110.00),
(6, 6, 7, '2025-11-09 12:00:00', NULL, 120.00),
(9, 9, 10, '2025-11-10 14:00:00', NULL, 130.00),
(13, 3, 1, '2025-11-12 08:00:00', '2025-11-12 09:00:00', 80.00),
(14, 4, 2, '2025-11-13 10:00:00', '2025-11-13 11:00:00', 90.00);

-- 8. Payments (12 rows)
INSERT INTO payment (trip_id, payment_date, amount, payment_type, transaction_method, status) VALUES
(1, '2025-11-01 12:05:00', 100.00, 'Credit Card', 'Online', 'completed'),
(2, '2025-11-02 16:05:00', 160.00, 'Debit Card', 'POS', 'completed'),
(3, '2025-11-03 11:05:00', 140.00, 'Credit Card', 'Online', 'completed'),
(4, '2025-11-04 15:05:00', 170.00, 'Gift Card', 'Online', 'completed'),
(5, '2025-11-05 10:05:00', 176.00, 'Debit Card', 'POS', 'completed'),
(6, '2025-11-06 17:05:00', 104.00, 'Credit Card', 'Online', 'completed'),
(7, '2025-11-07 13:05:00', 190.00, 'Credit Card', 'POS', 'completed'),
(8, '2025-11-08 10:05:00', 110.00, 'Debit Card', 'Online', 'pending'),
(9, '2025-11-09 12:05:00', 120.00, 'Credit Card', 'Online', 'pending'),
(10, '2025-11-10 14:05:00', 130.00, 'Gift Card', 'POS', 'pending'),
(11, '2025-11-12 09:05:00', 80.00, 'Credit Card', 'Online', 'completed'),
(12, '2025-11-13 11:05:00', 90.00, 'Debit Card', 'POS', 'completed');
