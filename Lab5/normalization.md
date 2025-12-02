# Звіт з нормалізації бази даних: Система оренди авто

## 1\. Аналіз функціональних залежностей (FD)

Для кожної таблиці було визначено залежності між первинним ключем (PK) та неключовими атрибутами.

* **Таблиця `User`**
      - PK: `user_id`
      - FD: `user_id` → `email`, `firstname`, `lastname`, `driver_license_id`
* **Таблиця `Driver_License`**
      - PK: `driver_license_id`
      - FD: `driver_license_id` → `license_number`, `license_type`, `expiry_date`
* **Таблиця `Car_Location`**
      - PK: `car_location_id`
      - FD: `car_location_id` → `address`
* **Таблиця `Car`
      - PK: `car_id`
      - FD1 (PK): `car_id` → `license_plate`, `car_type`, `fuel`, `price`, `status`, `booked_by`, `is_in`
      - FD2 (Транзитивна): `car_type` → `fuel`, `price` *(Порушення 3НФ)*
      - **Проблема:** Атрибути `fuel` та `price` залежать від `car_type`, а не безпосередньо від `car_id`
* **Таблиця `Booking`**
      - PK: `book_id`
      - FD: `book_id` → `user_id`, `car_id`, `status`
* **Таблиця `Trip`
      - PK: `trip_id`
      - FD: `trip_id` → `car_id`, `user_id`, `start_time`, `end_time`, `start_location`, `end_location`, `price`
      - **Проблема 1:** Дублювання зв'язків `user_id` та `car_id`, які вже є в `Booking`
      - **Проблема 2:** Можливість створити Trip без відповідного Booking
* **Таблиця `Payment`**
      - PK: `payment_id`
      - FD: `payment_id` → `amount`, `payment_date`, `payment_type`, `transaction_method`, `status`, `trip_id`

## 2\. Покрокове пояснення нормалізації

Процес нормалізації таблиці `Car`:

### Крок 1: Перша нормальна форма (1NF)

* **Вимога:** Атомарність значень, відсутність повторюваних груп.
* **Аналіз:** Таблиця `Trip` мала дублювання зв'язків `user_id` та `car_id`, які вже є в `Booking`
* **Результат:** 1NF виконано.

### Крок 2: Друга нормальна форма (2NF)

* **Вимога:** Відсутність часткових залежностей (неключовий атрибут залежить від частини складеного ключа).
* **Аналіз:** Усі таблиці використовують простий сурогатний ключ (`SERIAL`). Складених ключів немає, тому часткові залежності неможливі.
* **Результат:** 2NF виконано автоматично.

### Крок 3: Третя нормальна форма (3NF)

* **Вимога:** Відсутність транзитивних залежностей (неключовий атрибут залежить від іншого неключового атрибута).
* **Проблема:** У таблиці `Car` виявлено транзитивну залежність:
    `car_id` (Key) → `car_type` (Non-Key) → `fuel`, `price` (Non-Key).
    Це означає, що ціна та тип палива залежать від моделі автомобіля, а не від конкретного фізичного екземпляра.
* **Рішення:**
    1. Створено нову таблицю `car_model` для зберігання атрибутів моделі (`model_name`, `fuel`, `price`).
    2. З таблиці `car` видалено атрибути `car_type`, `fuel`, `price`.
    3. У таблицю `car` додано зовнішній ключ `model_id`.
* **Результат:** Кожна модель автомобіля описується один раз у таблиці `car_model`. Конкретні екземпляри (`car`) лише посилаються на модель через `model_id`.

#### Оптимізація зв'язку Trip-Booking

* **Проблема:** Початкова схема таблиці `Trip` містила поля `user_id` та `car_id`. Це створювало надлишковість:
  - Дані про користувача та авто дублюються (є в `Booking` та в `Trip`)
  - Можливо створити поїздку без відповідного бронювання
  - Можливо вказати в `Trip` інший автомобіль, ніж у `Booking` (порушення логічної цілісності)
* **Рішення:** 
  1. Видалено поля `user_id` та `car_id` з таблиці `Trip`
  2. Додано зовнішній ключ `book_id` → `booking(book_id)`
  3. Інформація про користувача та автомобіль тепер отримується через JOIN з `Booking`
* **Результат:** 
  - Усунено дублювання даних
  - Гарантовано цілісність: кожна поїздка прив'язана до конкретного бронювання
  - Спрощено логіку: неможливо створити Trip без Booking

**Підсумок нормалізації:** Усі таблиці знаходяться в 3НФ. Створено нову таблицю `car_model`, оптимізовано зв'язок `Trip` → `Booking`.

**SQL-команди для зміни структури (ALTER TABLE):**

```sql
/* 1. Створення нової довідкової таблиці */
CREATE TABLE car_model (
    model_id SERIAL PRIMARY KEY,
    model_name VARCHAR(50) NOT NULL UNIQUE,
    fuel_type fuel NOT NULL,
    base_price DECIMAL(8, 2) NOT NULL
);

/* 2. Наповнення нової таблиці унікальними даними з існуючої (Migration Data) */
INSERT INTO car_model (model_name, fuel_type, base_price)
SELECT DISTINCT car_type, fuel, price FROM car;

/* 3. Додавання зовнішнього ключа до таблиці Car */
ALTER TABLE car ADD COLUMN model_id INTEGER REFERENCES car_model(model_id);

/* 4. Оновлення зовнішнього ключа на основі існуючих даних */
UPDATE car
SET model_id = car_model.model_id
FROM car_model
WHERE car.car_type = car_model.model_name;

/* 5. Встановлення обмеження NOT NULL після заповнення даних */
ALTER TABLE car ALTER COLUMN model_id SET NOT NULL;

/* 6. Видалення надлишкових колонок (Cleanup) */
ALTER TABLE car DROP COLUMN car_type;
ALTER TABLE car DROP COLUMN fuel;
ALTER TABLE car DROP COLUMN price;

/* 1. Додаємо колонку book_id */
ALTER TABLE trip ADD COLUMN book_id INTEGER REFERENCES booking(book_id) ON DELETE SET NULL;

/* 2. (Опціонально) Якщо є дані, спробуємо знайти відповідні бронювання */
-- Це спрацює, тільки якщо у користувача лише одне бронювання на цю машину
UPDATE trip
SET book_id = booking.book_id
FROM booking
WHERE trip.user_id = booking.user_id AND trip.car_id = booking.car_id;

/* 3. Видаляємо старі колонки (тепер ці дані беруться через JOIN з booking) */
ALTER TABLE trip DROP COLUMN car_id;
ALTER TABLE trip DROP COLUMN user_id;
```

-----

### 3\. SQL-скрипти (`final_schema.sql`)

Це повний файл для створення чистої, нормалізованої бази даних.

```sql
-- 1. ENUM Types
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
    email VARCHAR(100) NOT NULL UNIQUE,
    firstname VARCHAR(32) NOT NULL,
    lastname VARCHAR(32) NOT NULL,
    driver_license_id INTEGER REFERENCES driver_license(driver_license_id) ON DELETE SET NULL
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
    booked_by INTEGER REFERENCES "user"(user_id) ON DELETE SET NULL,
    car_location INTEGER REFERENCES car_location(car_location_id) ON DELETE SET NULL
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    status car_status NOT NULL,
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
    book_id INTEGER REFERENCES booking(book_id) ON DELETE SET NULL, -- Замість car_id та user_id
    start_location INTEGER REFERENCES car_location(car_location_id) ON DELETE SET NULL,
    end_location INTEGER REFERENCES car_location(car_location_id) ON DELETE SET NULL
    start_time TIMESTAMP NOT NULL DEFAULT NOW(),
    end_time TIMESTAMP,
    price DECIMAL(8, 2) CHECK (price >= 0),
);

-- 9. Payment
CREATE TABLE IF NOT EXISTS payment (
    payment_id SERIAL PRIMARY KEY,
    trip_id INTEGER REFERENCES trip(trip_id) ON DELETE SET NULL
    payment_date TIMESTAMP NOT NULL,
    amount DECIMAL(8, 2) NOT NULL CHECK (amount > 0),
    payment_type payment_type,
    transaction_method transaction,
    status status DEFAULT 'pending',
);
```
