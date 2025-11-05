# Лабораторна робота 3: Маніпулювання даними (DML операції)

Практика роботи з основними операціями DML у PostgreSQL: **SELECT**, **INSERT**, **UPDATE**, **DELETE** з дотриманням найкращих практик безпеки даних.

Всі SQL операції у файлі [`data_manipulation.sql`](./data_manipulation.sql):

1. **SELECT** - 11 запитів (фільтрація, WHERE, ORDER BY, LIKE)
2. **INSERT** - 8 операцій (одиночні та масові вставки)
3. **UPDATE** - 8 операцій (оновлення полів з WHERE)
4. **DELETE** - 8 операцій (безпечне видалення з WHERE)

Всього: 35 SQL операцій

## Приклади операцій

### SELECT - Отримання даних

```sql
-- Фільтрація з умовами
SELECT license_plate, car_type, fuel, price, status 
FROM car 
WHERE status = 'Available' AND fuel = 'Electric';

-- Сортування
SELECT license_plate, car_type, price 
FROM car 
WHERE price > 150.00 
ORDER BY price DESC;

-- Текстовий пошук
SELECT car_location_id, address 
FROM car_location 
WHERE address LIKE '%Downtown%';
```

### INSERT - Додавання записів

```sql
-- Одиночна вставка
INSERT INTO driver_license (license_number, license_type, expiry_date)
VALUES ('F67890123', 'C', '2029-06-15');

-- Масова вставка
INSERT INTO client (email, firstname, lastname, driver_license)
VALUES 
    ('oliver.davis@example.com', 'Oliver', 'Davis', 7),
    ('sophia.wilson@example.com', 'Sophia', 'Wilson', 8);
```

### UPDATE - Оновлення даних

```sql
-- Оновлення одного поля
UPDATE car 
SET price = 165.00
WHERE license_plate = 'ABC123';

-- Оновлення кількох полів
UPDATE client 
SET email = 'john.doe.updated@example.com', 
    lastname = 'Doe-Smith'
WHERE client_id = 1;

-- Масове оновлення з обчисленнями
UPDATE car 
SET price = price * 1.10
WHERE fuel = 'Petrol';
```

### DELETE - Видалення записів

```sql
-- Видалення одного запису
DELETE FROM payment 
WHERE payment_id = 6;

-- Умовне видалення
DELETE FROM booking 
WHERE status = 'completed';
```

## Найкращі практики

### Безпека

* **Завжди WHERE** у UPDATE та DELETE
* **Перевірка ДО/ПІСЛЯ** кожної операції
* **Правильний порядок** видалення (залежні → головні)

### Ефективність

* Вибір конкретних стовпців замість `SELECT *`
* Використання індексів (PK, FK)
* Фільтрація на рівні БД

## Опис схеми бази даних

### Таблиці та їх структура

**1. driver_license** - Водійські посвідчення

* `driver_license_id` (PK) - Унікальний ідентифікатор
* `license_number` (UNIQUE) - Номер посвідчення (10 символів)
* `license_type` (ENUM) - Категорія ('A', 'B', 'C', 'D', 'E')
* `expiry_date` - Дата закінчення терміну дії

**2. client** - Клієнти системи

* `client_id` (PK) - Унікальний ідентифікатор
* `email` (UNIQUE) - Електронна адреса
* `firstname`, `lastname` - Ім'я та прізвище
* `driver_license` (FK) - Посилання на driver_license(driver_license_id)

**3. car_location** - Локації автомобілів

* `car_location_id` (PK) - Унікальний ідентифікатор
* `address` - Адреса локації

**4. car** - Автомобілі

* `car_id` (PK) - Унікальний ідентифікатор
* `license_plate` (UNIQUE) - Номерний знак
* `car_type` - Тип автомобіля
* `fuel` (ENUM) - Тип палива ('Petrol', 'Diesel', 'Electric', 'Hybrid')
* `price` - Ціна оренди (CHECK: price > 0)
* `status` (ENUM) - Статус ('Available', 'Booked', 'Repaired')
* `booked_by` (FK, nullable) - Посилання на client(client_id)
* `is_in` (FK) - Посилання на car_location(car_location_id)

**5. booking** - Бронювання

* `book_id` (PK) - Унікальний ідентифікатор
* `user_id` (FK) - Посилання на client(client_id)
* `car_id` (FK) - Посилання на car(car_id)
* `status` (ENUM) - Статус ('pending', 'confirmed', 'completed')

**6. trip** - Поїздки

* `trip_id` (PK) - Унікальний ідентифікатор
* `car_id` (FK) - Посилання на car(car_id)
* `user_id` (FK) - Посилання на client(client_id)
* `start_time`, `end_time` - Час початку/завершення
* `duration` - Тривалість
* `price` - Вартість (CHECK: price >= 0)
* `start_location`, `end_location` (FK) - Посилання на car_location(car_location_id)

**7. payment** - Платежі

* `payment_id` (PK) - Унікальний ідентифікатор
* `payment_date` - Дата платежу
* `amount` - Сума (CHECK: amount > 0)
* `payment_type` (ENUM) - Тип ('Credit Card', 'Debit Card', 'Gift Card')
* `transaction_method` (ENUM) - Метод ('Online', 'POS')
* `status` (ENUM) - Статус ('pending', 'confirmed', 'completed')
* `trip_id` (FK) - Посилання на trip(trip_id)

### Важливі обмеження

* **UNIQUE**: license_number, email, license_plate
* **CHECK**: price > 0 (car, payment), price >= 0 (trip)
* **NOT NULL**: всі FK окрім car.booked_by
* **DEFAULT**: status = 'pending' (booking, payment)

## Доказ заповнення таблиць

### Початкові дані (з Lab2)

Кожна таблиця містить мінімум 5 рядків:

| Таблиця | Кількість рядків |
|---------|------------------|
| driver_license | 5 |
| client | 5 |
| car_location | 5 |
| car | 5 |
| booking | 5 |
| trip | 5 |
| payment | 5 |

### Додані дані

```sql
-- Додано 3 нових водійських посвідчення
INSERT INTO driver_license VALUES 
    ('F67890123', 'C', '2029-06-15'),
    ('G78901234', 'A', '2031-03-20'),
    ('H89012345', 'B', '2030-09-10');

-- Додано 3 нових клієнтів
INSERT INTO client VALUES 
    ('emma.johnson@example.com', 'Emma', 'Johnson', 6),
    ('oliver.davis@example.com', 'Oliver', 'Davis', 7),
    ('sophia.wilson@example.com', 'Sophia', 'Wilson', 8);

-- Додано 1 нову локацію
INSERT INTO car_location VALUES ('303 Beach Rd, Seaside');

-- Додано 1 новий автомобіль
INSERT INTO car VALUES ('PQR678', 'Tesla Model 3', 'Electric', 180.00, ...);
```

### Змінені дані

```sql
-- Оновлено ціни на бензинові автомобілі (+10%)
-- Оновлено email клієнта #1
-- Оновлено статуси бронювань
-- Оновлено дату закінчення посвідчення #1
```

### Видалені дані

```sql
-- Видалено платіж #6
-- Видалено поїздку #6
-- Видалено бронювання клієнта #6
-- Видалено автомобіль #6
-- Видалено клієнта #6
-- Видалено локацію #6
-- Видалено посвідчення #6
-- Видалено всі завершені бронювання
```

## SQL-скрипт з усіма операторами

Файл [`data_manipulation.sql`](./data_manipulation.sql) містить всі операції по порядку:

**SELECT запити (1.1 - 1.11):**

* Фільтрація за типом (`WHERE license_type = 'B'`)
* Пошук за ім'ям (`WHERE firstname = 'John'`)
* Текстовий пошук (`LIKE '%Downtown%'`)
* Складні умови (`WHERE status = 'Available' AND fuel = 'Electric'`)
* Сортування (`ORDER BY price DESC`)
* Фільтрація з IN (`WHERE payment_type IN (...)`)

**INSERT операції (2.1 - 2.8):**

* Одиночні вставки в кожну таблицю
* Масові вставки (2+ рядки одночасно)
* Перевірка після кожного INSERT

**UPDATE операції (3.1 - 3.8):**

* Оновлення одного поля
* Оновлення кількох полів
* Масове оновлення з обчисленнями
* Перевірка ДО та ПІСЛЯ кожного UPDATE

**DELETE операції (4.1 - 4.8):**

* Видалення одного запису за ID
* Умовне видалення за статусом
* Каскадне видалення у правильному порядку
* Перевірка ДО та ПІСЛЯ кожного DELETE
