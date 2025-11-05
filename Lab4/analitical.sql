-- 1.1 Статистика машин за типом палива (COUNT, AVG, MIN, MAX)
SELECT fuel, COUNT(*) AS car_count, AVG(price) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM car
GROUP BY fuel
ORDER BY avg_price DESC;

-- 1.2 Кількість клієнтів за типом водійського посвідчення
SELECT dl.license_type, COUNT(c.client_id) AS client_count
FROM driver_license dl
LEFT JOIN client c ON dl.license_id = c.license_id
GROUP BY dl.license_type
ORDER BY client_count DESC;

-- 1.3 Аналіз платежів за типом оплати (AVG, COUNT, SUM)
SELECT payment_type, AVG(amount) AS avg_payment, COUNT(*) AS payment_count, SUM(amount) AS total_amount
FROM payment
GROUP BY payment_type
ORDER BY avg_payment DESC;

-- 1.4 Розподіл бронювань за статусами з відсотками
SELECT status, COUNT(*) AS count, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM booking
GROUP BY status
ORDER BY count DESC;

-- 2.1 INNER JOIN: Повна інформація про поїздки (4 таблиці)
SELECT cl.firstname || ' ' || cl.lastname AS client_name, car.brand || ' ' || car.model AS car_info, t.start_time, t.end_time, t.distance, p.amount, p.payment_type
FROM trip t
INNER JOIN client cl ON t.client_id = cl.client_id
INNER JOIN car ON t.car_id = car.car_id
INNER JOIN payment p ON t.trip_id = p.trip_id
ORDER BY t.start_time DESC;

-- 2.2 LEFT JOIN: Клієнти та їх бронювання (включно з 0)
SELECT c.firstname, c.lastname, c.email, COUNT(b.booking_id) AS total_bookings
FROM client c
LEFT JOIN booking b ON c.client_id = b.client_id
GROUP BY c.client_id, c.firstname, c.lastname, c.email
ORDER BY total_bookings DESC;

-- 2.3 LEFT JOIN: Дохід від кожної машини
SELECT c.brand, c.model, c.year, COUNT(t.trip_id) AS total_trips, SUM(p.amount) AS total_revenue, AVG(p.amount) AS avg_trip_revenue
FROM car c
LEFT JOIN trip t ON c.car_id = t.car_id
LEFT JOIN payment p ON t.trip_id = p.trip_id
GROUP BY c.car_id, c.brand, c.model, c.year
ORDER BY total_revenue DESC NULLS LAST;

-- 2.4 RIGHT JOIN: Всі локації з кількістю машин
SELECT l.city, l.address, COUNT(c.car_id) AS car_count
FROM car c
RIGHT JOIN car_location l ON c.location_id = l.location_id
GROUP BY l.location_id, l.city, l.address
ORDER BY car_count DESC;

-- 3.1 Підзапит у SELECT/WHERE: Машини дорожче середньої
SELECT brand, model, price, (SELECT AVG(price) FROM car) AS avg_price, price - (SELECT AVG(price) FROM car) AS price_difference
FROM car
WHERE price > (SELECT AVG(price) FROM car)
ORDER BY price DESC;

-- 3.2 Підзапит у WHERE: VIP-клієнти з платежами вище середнього
SELECT c.firstname, c.lastname, c.email
FROM client c
WHERE c.client_id IN (
    SELECT DISTINCT t.client_id
    FROM trip t
    INNER JOIN payment p ON t.trip_id = p.trip_id
    WHERE p.amount > (SELECT AVG(amount) FROM payment)
)
ORDER BY c.lastname;

-- 3.3 Підзапит у HAVING: Локації з кількістю машин вище середньої
SELECT l.city, l.address, COUNT(c.car_id) AS car_count
FROM car_location l
LEFT JOIN car c ON l.location_id = c.location_id
GROUP BY l.location_id, l.city, l.address
HAVING COUNT(c.car_id) > (
    SELECT AVG(car_count)
    FROM (SELECT COUNT(car_id) AS car_count FROM car GROUP BY location_id) AS avg_cars
)
ORDER BY car_count DESC;

-- 3.4 Підзапит у FROM: Активні клієнти з кількома поїздками
SELECT client_name, total_trips, total_spent
FROM (
    SELECT cl.firstname || ' ' || cl.lastname AS client_name, COUNT(t.trip_id) AS total_trips, SUM(p.amount) AS total_spent
    FROM client cl
    INNER JOIN trip t ON cl.client_id = t.client_id
    INNER JOIN payment p ON t.trip_id = p.trip_id
    GROUP BY cl.client_id, cl.firstname, cl.lastname
) AS client_stats
WHERE total_trips > 1
ORDER BY total_spent DESC;
