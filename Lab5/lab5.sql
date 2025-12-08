CREATE TYPE license AS ENUM ('A', 'B', 'C', 'D', 'E');
CREATE TYPE fuel AS ENUM ('Petrol', 'Diesel', 'Electric', 'Hybrid');
CREATE TYPE status AS ENUM ('pending', 'confirmed', 'completed');
CREATE TYPE car_status AS ENUM ('Available', 'Booked', 'Repaired');
CREATE TYPE payment_type AS ENUM ('Credit Card', 'Debit Card', 'Gift Card');
CREATE TYPE transaction AS ENUM ('Online', 'POS');

-- 2. Driver License
CREATE TABLE IF NOT EXISTS driver_license (
    driver_license_id SERIAL PRIMARY KEY,
    license_number CHAR(10) NOT NULL UNIQUE,
    license_type license NOT NULL,
    expiry_date DATE NOT NULL
);

-- 3. User
CREATE TABLE IF NOT EXISTS "user" (
    user_id SERIAL PRIMARY KEY,
    driver_license_id INTEGER REFERENCES driver_license(driver_license_id) ON DELETE SET NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    firstname VARCHAR(32) NOT NULL,
    lastname VARCHAR(32) NOT NULL
);

-- 4. Car Location
CREATE TABLE IF NOT EXISTS car_location (
    car_location_id SERIAL PRIMARY KEY,
    address VARCHAR(255) NOT NULL
);

-- 5. Car Model (NEW TABLE - Result of Normalization)
CREATE TABLE IF NOT EXISTS car_model (
    model_id SERIAL PRIMARY KEY,
    model_name VARCHAR(50) NOT NULL UNIQUE,
    fuel_type fuel NOT NULL,
    base_price DECIMAL(8, 2) NOT NULL CHECK (base_price > 0)
);

-- 6. Car (MODIFIED TABLE)
CREATE TABLE IF NOT EXISTS car (
    car_id SERIAL PRIMARY KEY,
    model_id INTEGER REFERENCES car_model(model_id) ON DELETE RESTRICT,
    location INTEGER REFERENCES car_location(car_location_id) ON DELETE SET NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    status car_status NOT NULL
);

-- 7. Booking
CREATE TABLE IF NOT EXISTS booking (
    book_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES "user"(user_id) ON DELETE SET NULL,
    car_id INTEGER REFERENCES car(car_id) ON DELETE SET NULL,
    status status DEFAULT 'pending'
);

-- 8. Trip (UPDATED: Linked to Booking)
CREATE TABLE IF NOT EXISTS trip (
    trip_id SERIAL PRIMARY KEY,
    book_id INTEGER REFERENCES booking(book_id) ON DELETE SET NULL, 
    start_location INTEGER REFERENCES car_location(car_location_id) ON DELETE SET NULL,
    end_location INTEGER REFERENCES car_location(car_location_id) ON DELETE SET NULL,
    start_time TIMESTAMP NOT NULL DEFAULT NOW(),
    end_time TIMESTAMP,
    price DECIMAL(8, 2) CHECK (price >= 0)
);

-- 9. Payment
CREATE TABLE IF NOT EXISTS payment (
    payment_id SERIAL PRIMARY KEY,
    trip_id INTEGER REFERENCES trip(trip_id) ON DELETE SET NULL,
    payment_date TIMESTAMP NOT NULL,
    amount DECIMAL(8, 2) NOT NULL CHECK (amount > 0),
    payment_type payment_type,
    transaction_method transaction,
    status status DEFAULT 'pending'
);

INSERT INTO driver_license (license_number, license_type, expiry_date) VALUES 
('DL1234567A', 'A', '2028-10-25'),
('DL9876543B', 'B', '2027-05-15'),
('DL1122334C', 'C', '2030-01-01');

INSERT INTO "user" (driver_license_id, email, firstname, lastname) VALUES 
(1, 'olenakovalenko@example.com', 'Olena', 'Kovalenko'),
(2, 'andriy.melnyk@example.com', 'Andriy', 'Melnyk'),
(3, 'taras.shevch@example.com', 'Taras', 'Shevchuk'),
(NULL, 'user.anon@example.com', 'Dmytro', 'Anonim'); 

INSERT INTO car_location (address) VALUES 
('Kyiv, Shevchenko St, 10'),
('Kyiv, Airport Boryspil'),
('Lviv, Rynok Square, 1');

INSERT INTO car_model (model_name, fuel_type, base_price) VALUES 
('Toyota Prius', 'Hybrid', 4.50),
('Tesla Model 3', 'Electric', 6.00),
('Ford Focus', 'Petrol', 3.00),
('Audi Q7', 'Diesel', 5.50);

INSERT INTO car (model_id, location, license_plate, status) VALUES 
(1, 1, 'AA1234AA', 'Available'), 
(2, 1, 'AA5678AA', 'Booked'),    
(3, 2, 'BB0001BB', 'Repaired'),  
(4, 3, 'CC7777CC', 'Available'); 

INSERT INTO booking (user_id, car_id, status) VALUES 
(1, 2, 'confirmed'), 
(2, 1, 'pending');  

INSERT INTO trip (book_id, start_location, end_location, start_time, end_time, price) VALUES 
(1, 1, 2, '2025-12-10 09:00:00', '2025-12-10 11:30:00', 50.00), 
(2, 1, NULL, '2025-12-12 14:00:00', NULL, NULL); 

INSERT INTO payment (trip_id, payment_date, amount, payment_type, transaction_method, status) VALUES 
(1, '2025-12-10 11:35:00', 50.00, 'Credit Card', 'Online', 'completed');