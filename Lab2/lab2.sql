CREATE TABLE IF NOT EXISTS driver_license {
	driver_license_id serial PRIMARY KEY,
	license_number char(10) NOT NULL UNIQUE,
	license_type varchar(3) NOT NULL CHECK (license_type IN ('A', 'B', 'C')),
	expiry_date date NOT NULL
};

CREATE TABLE IF NOT EXISTS user {
	user_id serial PRIMARY KEY,
	email varchar(100) NOT NULL UNIQUE,
	firstname varchar(32) NOT NULL,
	lastname varchar(32) NOT NULL,
	driver_license integer not null references driver_license(driver_license_id)
};

CREATE TABLE IF NOT EXISTS location (
    location_id serial PRIMARY KEY,
    address varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS car (
    car_id serial PRIMARY KEY,
    license_plate varchar(20) NOT NULL UNIQUE,
    car_type varchar(50) NOT NULL,
    fuel varchar(50),
    price decimal(4, 2) NOT NULL CHECK (price > 0),
    status varchar(20) NOT NULL,
	booked_by integer not null references user(user_id),
    is_in integer not null references location(location_id)
);

CREATE TABLE IF NOT EXISTS booking (
    book_id serial PRIMARY KEY,
    user_id integer not null references user(user_id),
    car_id integer not null references car(car_id),
    status varchar(50) DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS trip (
    trip_id serial PRIMARY KEY,
    car_id integer not null references car(car_id),
    car_price integer not null references car(car_id),
    user_id integer not null references user(user_id),
    start_time timestamp NOT NULL DEFAULT NOW(),
    end_time timestamp,
    duration varchar(50),
    cost decimal(4, 2) CHECK (cost >= 0),
    start_location integer not null references location(location_id),
    end_location integer not null references location(location_id)
);

CREATE TABLE IF NOT EXISTS payment (
    payment_id serial PRIMARY KEY,
    date timestamp NOT NULL,
    amount decimal(4, 2) NOT NULL CHECK (amount > 0),
    type varchar(50),
    method varchar(50),
    status varchar(50) DEFAULT 'pending',
    trip_id integer not null references trip(trip_id)
);



