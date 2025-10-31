CREATE TYPE license AS ENUM ('A', 'B', 'C', 'D', 'E');
CREATE TYPE fuel AS ENUM ('Petrol', 'Diesel', 'Electric', 'Hybrid');
CREATE TYPE status AS ENUM ('pending', 'confirmed', 'completed');
CREATE TYPE car_status AS ENUM ('Available', 'Booked', 'Repaired');
CREATE TYPE payment_type AS ENUM ('Credit Card', 'Debit Card', 'Gift Card');
CREATE TYPE transaction AS ENUM ('Online', 'POS');

CREATE TABLE IF NOT EXISTS driver_license (
	driver_license_id serial PRIMARY KEY,
	license_number char(10) NOT NULL UNIQUE,
	license_type license NOT NULL,
	expiry_date date NOT NULL
);

CREATE TABLE IF NOT EXISTS client (
	client_id serial PRIMARY KEY,
	email varchar(100) NOT NULL UNIQUE,
	firstname varchar(32) NOT NULL,
	lastname varchar(32) NOT NULL,
	driver_license integer not null references driver_license(driver_license_id)
);

CREATE TABLE IF NOT EXISTS car_location (
    car_location_id serial PRIMARY KEY,
    address varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS car (
    car_id serial PRIMARY KEY,
    license_plate varchar(20) NOT NULL UNIQUE,
    car_type varchar(50) NOT NULL,
    fuel fuel,
    price decimal(8, 2) NOT NULL CHECK (price > 0),
    status car_status NOT NULL,
	booked_by integer references client(client_id),
    is_in integer not null references car_location(car_location_id)
);

CREATE TABLE IF NOT EXISTS booking (
    book_id serial PRIMARY KEY,
    user_id integer not null references client(client_id),
    car_id integer not null references car(car_id),
    status status DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS trip (
    trip_id serial PRIMARY KEY,
    car_id integer not null references car(car_id),
    user_id integer not null references client(client_id),
    start_time timestamp NOT NULL DEFAULT NOW(),
    end_time timestamp,
    duration varchar(50),
    price decimal(8, 2) CHECK (price >= 0),
    start_location integer not null references car_location(car_location_id),
    end_location integer not null references car_location(car_location_id)
);

CREATE TABLE IF NOT EXISTS payment (
    payment_id serial PRIMARY KEY,
    payment_date timestamp NOT NULL,
    amount decimal(8, 2) NOT NULL CHECK (amount > 0),
    payment_type payment_type,
    transaction_method transaction,
    status status DEFAULT 'pending',
    trip_id integer not null references trip(trip_id)
);

INSERT INTO driver_license (license_number, license_type, expiry_date)
VALUES
    ('A12345678', 'A', '2030-10-14'),
    ('B23456789', 'B', '2032-05-20'),
    ('C34567890', 'C', '2027-12-01'),
    ('D45678901', 'A', '2026-07-10'),
    ('E56789012', 'B', '2028-08-15');


INSERT INTO client (email, firstname, lastname, driver_license)
VALUES
    ('john.doe@example.com', 'John', 'Doe', 1),
    ('jane.smith@example.com', 'Jane', 'Smith', 2),
    ('sam.jones@example.com', 'Sam', 'Jones', 3),
    ('lucy.brown@example.com', 'Lucy', 'Brown', 4),
    ('mark.white@example.com', 'Mark', 'White', 5);


INSERT INTO car_location (address)
VALUES
    ('123 Main St, City Center'),
    ('456 Elm St, Downtown'),
    ('789 Oak St, Suburbs'),
    ('101 Pine St, Old Town'),
    ('202 Maple St, Riverside');

INSERT INTO car (license_plate, car_type, fuel, price, status, booked_by, is_in)
VALUES
    ('ABC123', 'Sedan', 'Petrol', 150.00, 'Available', NULL, 1),
    ('DEF456', 'SUV', 'Diesel', 200.00, 'Booked', 2, 2),
    ('GHI789', 'Hatchback', 'Electric', 120.00, 'Available', NULL, 3),
    ('JKL012', 'Coupe', 'Petrol', 180.00, 'Booked', 4, 4),
    ('MNO345', 'Convertible', 'Hybrid', 220.00, 'Repaired', NULL, 5);

INSERT INTO booking (user_id, car_id, status)
VALUES
    (1, 1, 'pending'),
    (2, 2, 'confirmed'),
    (3, 3, 'completed'),
    (4, 4, 'pending'),
    (5, 5, 'confirmed');

INSERT INTO trip (car_id, user_id, start_time, end_time, duration, price, start_location, end_location)
VALUES
    (1, 1, '2025-10-14 10:00:00', '2025-10-14 12:00:00', '2 hours', 100.00, 1, 2),
    (2, 2, '2025-10-12 15:00:00', '2025-10-12 16:30:00', '1.5 hours', 120.00, 2, 3),
    (3, 3, '2025-10-13 08:00:00', '2025-10-13 09:30:00', '1.5 hours', 90.00, 3, 4),
    (4, 4, '2025-10-11 18:00:00', '2025-10-11 19:30:00', '1.5 hours', 110.00, 4, 5),
    (5, 5, '2025-10-10 14:00:00', '2025-10-10 16:00:00', '2 hours', 130.00, 5, 1);

INSERT INTO payment (payment_date, amount, payment_type, transaction_method, status, trip_id)
VALUES
    ('2025-10-14 12:10:00', 100.00, 'Credit Card', 'Online', 'completed', 1),
    ('2025-10-12 16:30:00', 120.00, 'Debit Card', 'Online', 'completed', 2),
    ('2025-10-13 09:45:00', 90.00, 'Gift Card', 'Online', 'pending', 3),
    ('2025-10-11 19:45:00', 110.00, 'Credit Card', 'POS', 'completed', 4),
    ('2025-10-10 16:15:00', 130.00, 'Debit Card', 'POS', 'completed', 5);