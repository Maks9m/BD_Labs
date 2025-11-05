# Лабораторна робота 4: Агрегатні функції, JOIN та підзапити

Навчитися використовувати:

- Агрегатні функції (COUNT, SUM, AVG, MIN, MAX)
- Групування даних (GROUP BY, HAVING)
- Об'єднання таблиць (INNER JOIN, LEFT JOIN, RIGHT JOIN)
- Підзапити (у SELECT, WHERE, HAVING, FROM)
- Складні багатотабличні запити з агрегацією

## Структура роботи

Файл `lab4.sql` містить **12 запитів**, розділених на 3 категорії:

1. **Агрегатні функції** (4 запити) - COUNT, SUM, AVG, MIN, MAX з GROUP BY
2. **JOIN запити** (4 запити) - INNER JOIN, LEFT JOIN, RIGHT JOIN
3. **Підзапити** (4 запити) - у SELECT, WHERE, HAVING, FROM

---

## Частина 1: Агрегатні функції

### 1.1. Статистика за типом палива

```sql
SELECT fuel, COUNT(*) AS car_count, AVG(price) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM car
GROUP BY fuel
ORDER BY avg_price DESC;
```

**Що робить:** Агрегує дані про машини за типом палива з використанням COUNT, AVG, MIN, MAX.

---

### 1.2. Клієнти за типом посвідчення

```sql
SELECT dl.license_type, COUNT(c.client_id) AS client_count
FROM driver_license dl
LEFT JOIN client c ON dl.license_id = c.license_id
GROUP BY dl.license_type
ORDER BY client_count DESC;
```

**Що робить:** Групує клієнтів за типом водійського посвідчення (A, B, C, D).

---

### 1.3. Середній платіж за типом оплати

```sql
SELECT payment_type, AVG(amount) AS avg_payment, COUNT(*) AS payment_count, SUM(amount) AS total_amount
FROM payment
GROUP BY payment_type
ORDER BY avg_payment DESC;
```

**Що робить:** Обчислює середню, загальну суму та кількість платежів для кожного типу оплати.

---

### 1.4. Статистика бронювань

```sql
SELECT status, COUNT(*) AS count, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM booking
GROUP BY status
ORDER BY count DESC;
```

**Що робить:** Підраховує кількість бронювань за статусом з розрахунком відсотків через віконну функцію.

---

## Частина 2: JOIN запити

### 2.1. INNER JOIN: Деталі поїздок

```sql
SELECT cl.firstname || ' ' || cl.lastname AS client_name, car.brand || ' ' || car.model AS car_info, t.start_time, t.end_time, t.distance, p.amount, p.payment_type
FROM trip t
INNER JOIN client cl ON t.client_id = cl.client_id
INNER JOIN car ON t.car_id = car.car_id
INNER JOIN payment p ON t.trip_id = p.trip_id
ORDER BY t.start_time DESC;
```

**Що робить:** Об'єднує 4 таблиці (trip, client, car, payment) для повного звіту про поїздки.

---

### 2.2. LEFT JOIN: Клієнти та бронювання

```sql
SELECT c.firstname, c.lastname, c.email, COUNT(b.booking_id) AS total_bookings
FROM client c
LEFT JOIN booking b ON c.client_id = b.client_id
GROUP BY c.client_id, c.firstname, c.lastname, c.email
ORDER BY total_bookings DESC;
```

**Що робить:** Показує всіх клієнтів з кількістю бронювань (включаючи клієнтів без бронювань).

---

### 2.3. LEFT JOIN: Дохід від машин

```sql
SELECT c.brand, c.model, c.year, COUNT(t.trip_id) AS total_trips, SUM(p.amount) AS total_revenue, AVG(p.amount) AS avg_trip_revenue
FROM car c
LEFT JOIN trip t ON c.car_id = t.car_id
LEFT JOIN payment p ON t.trip_id = p.trip_id
GROUP BY c.car_id, c.brand, c.model, c.year
ORDER BY total_revenue DESC NULLS LAST;
```

**Що робить:** Обчислює загальний та середній дохід від кожної машини (включаючи машини без поїздок).

---

### 2.4. RIGHT JOIN: Локації та машини

```sql
SELECT l.city, l.address, COUNT(c.car_id) AS car_count
FROM car c
RIGHT JOIN car_location l ON c.location_id = l.location_id
GROUP BY l.location_id, l.city, l.address
ORDER BY car_count DESC;
```

**Що робить:** Виводить всі локації з кількістю машин (включаючи порожні паркінги).

---

## Частина 3: Підзапити

### 3.1. Підзапит у SELECT: Машини дорожче середньої

```sql
SELECT brand, model, price, (SELECT AVG(price) FROM car) AS avg_price, price - (SELECT AVG(price) FROM car) AS price_difference
FROM car
WHERE price > (SELECT AVG(price) FROM car)
ORDER BY price DESC;
```

**Що робить:** Порівнює ціну кожної машини з середньою через підзапит у SELECT та WHERE.

---

### 3.2. Підзапит у WHERE: VIP-клієнти

```sql
SELECT c.firstname, c.lastname, c.email
FROM client c
WHERE c.client_id IN (
    SELECT DISTINCT t.client_id
    FROM trip t
    JOIN payment p ON t.trip_id = p.trip_id
    WHERE p.amount > (SELECT AVG(amount) FROM payment)
)
ORDER BY c.lastname;
```

**Що робить:** Знаходить клієнтів через підзапит у WHERE, які робили платежі вище середнього.

---

### 3.3. Підзапит у HAVING: Завантажені локації

```sql
SELECT l.city, l.address, COUNT(c.car_id) AS car_count
FROM car_location l
LEFT JOIN car c ON l.location_id = c.location_id
GROUP BY l.location_id, l.city, l.address
HAVING COUNT(c.car_id) > (
    SELECT AVG(car_count)
    FROM (SELECT COUNT(car_id) AS car_count FROM car GROUP BY location_id) AS avg_cars
)
ORDER BY car_count DESC;
```

**Що робить:** Використовує підзапит у HAVING для порівняння з середньою кількістю машин.

---

### 3.4. Підзапит у FROM: Статистика активних клієнтів

```sql
SELECT client_name, total_trips, total_spent
FROM (
    SELECT cl.firstname || ' ' || cl.lastname AS client_name, COUNT(t.trip_id) AS total_trips, SUM(p.amount) AS total_spent
    FROM client cl
    JOIN trip t ON cl.client_id = t.client_id
    JOIN payment p ON t.trip_id = p.trip_id
    GROUP BY cl.client_id, cl.firstname, cl.lastname
) AS client_stats
WHERE total_trips > 1
ORDER BY total_spent DESC;
```

**Що робить:** Використовує підзапит у FROM як віртуальну таблицю для фільтрації активних клієнтів.
