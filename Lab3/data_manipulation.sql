-- 1.1 SELECT - Вибір конкретних стовпців з фільтрацією
SELECT license_number, license_type, expiry_date 
FROM driver_license 
WHERE license_type = 'B';

-- 1.2 SELECT - Знайти клієнтів з конкретним ім'ям
SELECT client_id, email, firstname, lastname 
FROM client 
WHERE firstname = 'John';

-- 1.3 SELECT - Знайти локації з певною адресою
SELECT car_location_id, address 
FROM car_location 
WHERE address LIKE '%Downtown%';

-- 1.4 SELECT - Знайти доступні електричні автомобілі
SELECT license_plate, car_type, fuel, price, status 
FROM car 
WHERE status = 'Available' AND fuel = 'Electric';

-- 1.5 SELECT - Знайти автомобілі з ціною більше 150
SELECT license_plate, car_type, price, status 
FROM car 
WHERE price > 150.00 
ORDER BY price DESC;

-- 1.6 SELECT - Перегляд всіх бронювань
SELECT * FROM booking;

-- 1.7 SELECT - Знайти підтверджені бронювання
SELECT book_id, user_id, car_id, status 
FROM booking 
WHERE status = 'confirmed';

-- 1.8 SELECT - Перегляд всіх поїздок
SELECT * FROM trip;

-- 1.9 SELECT - Знайти поїздки з вартістю більше 100
SELECT trip_id, car_id, user_id, start_time, end_time, price 
FROM trip 
WHERE price > 100.00;

-- 1.10 SELECT - Перегляд всіх платежів
SELECT * FROM payment;

-- 1.11 SELECT - Знайти завершені платежі картками
SELECT payment_id, payment_date, amount, payment_type, status 
FROM payment 
WHERE status = 'completed' AND payment_type IN ('Credit Card', 'Debit Card');

-- 2.1 INSERT - Додати нове водійське посвідчення
INSERT INTO driver_license (license_number, license_type, expiry_date)
VALUES ('F67890123', 'C', '2029-06-15');

SELECT * FROM driver_license WHERE license_number = 'F67890123';

-- 2.2 INSERT - Додати нового клієнта
INSERT INTO client (email, firstname, lastname, driver_license)
VALUES ('emma.johnson@example.com', 'Emma', 'Johnson', 6);

SELECT * FROM client WHERE email = 'emma.johnson@example.com';

-- 2.3 INSERT - Додати нову локацію
INSERT INTO car_location (address)
VALUES ('303 Beach Rd, Seaside');

SELECT * FROM car_location WHERE address LIKE '%Seaside%';

-- 2.4 INSERT - Додати новий автомобіль
INSERT INTO car (license_plate, car_type, fuel, price, status, booked_by, is_in)
VALUES ('PQR678', 'Tesla Model 3', 'Electric', 180.00, 'Available', NULL, 6);

SELECT * FROM car WHERE license_plate = 'PQR678';

-- 2.5 INSERT - Додати нове бронювання
INSERT INTO booking (user_id, car_id, status)
VALUES (6, 6, 'pending');

SELECT * FROM booking WHERE user_id = 6 AND car_id = 6;

-- 2.6 INSERT - Додати нову поїздку
INSERT INTO trip (car_id, user_id, start_time, end_time, duration, price, start_location, end_location)
VALUES (6, 6, '2025-11-05 14:00:00', '2025-11-05 16:30:00', '2.5 hours', 140.00, 6, 1);

SELECT * FROM trip WHERE car_id = 6 AND user_id = 6;

-- 2.7 INSERT - Додати новий платіж
INSERT INTO payment (payment_date, amount, payment_type, transaction_method, status, trip_id)
VALUES ('2025-11-05 16:35:00', 140.00, 'Credit Card', 'Online', 'completed', 6);

SELECT * FROM payment WHERE trip_id = 6;

-- 2.8 INSERT - Додати кілька клієнтів одночасно
INSERT INTO driver_license (license_number, license_type, expiry_date)
VALUES 
    ('G78901234', 'A', '2031-03-20'),
    ('H89012345', 'B', '2030-09-10');

INSERT INTO client (email, firstname, lastname, driver_license)
VALUES 
    ('oliver.davis@example.com', 'Oliver', 'Davis', 7),
    ('sophia.wilson@example.com', 'Sophia', 'Wilson', 8);

SELECT * FROM client WHERE client_id >= 7;

-- 3.1 UPDATE - Спочатку перевіримо, які записи будуть змінені
SELECT * FROM client WHERE client_id = 1;

UPDATE client 
SET email = 'john.doe.updated@example.com', 
    lastname = 'Doe-Smith'
WHERE client_id = 1;

SELECT * FROM client WHERE client_id = 1;

-- 3.2 UPDATE - Змінити ціну автомобіля
SELECT license_plate, price FROM car WHERE license_plate = 'ABC123';

UPDATE car 
SET price = 165.00
WHERE license_plate = 'ABC123';

SELECT license_plate, price FROM car WHERE license_plate = 'ABC123';

-- 3.3 UPDATE - Змінити статус бронювання
SELECT * FROM booking WHERE book_id = 1;

UPDATE booking 
SET status = 'confirmed'
WHERE book_id = 1;

SELECT * FROM booking WHERE book_id = 1;

-- 3.4 UPDATE - Оновити статус автомобіля
SELECT license_plate, status, booked_by FROM car WHERE car_id = 1;

UPDATE car 
SET status = 'Booked', 
    booked_by = 1
WHERE car_id = 1;

SELECT license_plate, status, booked_by FROM car WHERE car_id = 1;

-- 3.5 UPDATE - Оновити дату закінчення водійського посвідчення
SELECT * FROM driver_license WHERE driver_license_id = 1;

UPDATE driver_license 
SET expiry_date = '2032-10-14'
WHERE driver_license_id = 1;

SELECT * FROM driver_license WHERE driver_license_id = 1;

-- 3.6 UPDATE - Змінити статус платежу з pending на completed
SELECT * FROM payment WHERE payment_id = 3;

UPDATE payment 
SET status = 'completed'
WHERE payment_id = 3;

SELECT * FROM payment WHERE payment_id = 3;

-- 3.7 UPDATE - Оновити час завершення та ціну поїздки
SELECT * FROM trip WHERE trip_id = 1;

UPDATE trip 
SET end_time = '2025-10-14 13:00:00', 
    duration = '3 hours', 
    price = 150.00
WHERE trip_id = 1;

SELECT * FROM trip WHERE trip_id = 1;

-- 3.8 UPDATE - Масове оновлення: підвищити ціни на всі бензинові автомобілі на 10%
SELECT license_plate, fuel, price FROM car WHERE fuel = 'Petrol';

UPDATE car 
SET price = price * 1.10
WHERE fuel = 'Petrol';

SELECT license_plate, fuel, price FROM car WHERE fuel = 'Petrol';

-- 4.1 DELETE - Видалити конкретний платіж (спочатку перевірка)
SELECT * FROM payment WHERE payment_id = 6;

DELETE FROM payment 
WHERE payment_id = 6;

SELECT * FROM payment WHERE payment_id = 6;

-- 4.2 DELETE - Видалити конкретну поїздку (спочатку перевірка)
SELECT * FROM trip WHERE trip_id = 6;

DELETE FROM trip 
WHERE trip_id = 6;

SELECT * FROM trip WHERE trip_id = 6;

-- 4.3 DELETE - Видалити бронювання за умовою
SELECT * FROM booking WHERE user_id = 6 AND car_id = 6;

DELETE FROM booking 
WHERE user_id = 6 AND car_id = 6;

SELECT * FROM booking WHERE user_id = 6 AND car_id = 6;

-- 4.4 DELETE - Видалити автомобіль
SELECT * FROM car WHERE car_id = 6;

DELETE FROM car 
WHERE car_id = 6;

SELECT * FROM car WHERE car_id = 6;

-- 4.5 DELETE - Видалити клієнта
SELECT * FROM client WHERE client_id = 6;

DELETE FROM client 
WHERE client_id = 6;

SELECT * FROM client WHERE client_id = 6;

-- 4.6 DELETE - Видалити локацію
SELECT * FROM car_location WHERE car_location_id = 6;

DELETE FROM car_location 
WHERE car_location_id = 6;

SELECT * FROM car_location WHERE car_location_id = 6;

-- 4.7 DELETE - Видалити водійське посвідчення
SELECT * FROM driver_license WHERE driver_license_id = 6;

DELETE FROM driver_license 
WHERE driver_license_id = 6;

SELECT * FROM driver_license WHERE driver_license_id = 6;

-- 4.8 DELETE - Видалити завершені бронювання
SELECT * FROM booking WHERE status = 'completed';

DELETE FROM booking 
WHERE status = 'completed';

SELECT * FROM booking WHERE status = 'completed';