-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "car_status" AS ENUM ('Available', 'Booked', 'Repaired');

-- CreateEnum
CREATE TYPE "fuel" AS ENUM ('Petrol', 'Diesel', 'Electric', 'Hybrid');

-- CreateEnum
CREATE TYPE "license" AS ENUM ('A', 'B', 'C', 'D', 'E');

-- CreateEnum
CREATE TYPE "payment_type" AS ENUM ('Credit Card', 'Debit Card', 'Gift Card');

-- CreateEnum
CREATE TYPE "status" AS ENUM ('pending', 'confirmed', 'completed');

-- CreateEnum
CREATE TYPE "transaction" AS ENUM ('Online', 'POS');

-- CreateTable
CREATE TABLE "booking" (
    "book_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "car_id" INTEGER,
    "status" "status" DEFAULT 'pending',

    CONSTRAINT "booking_pkey" PRIMARY KEY ("book_id")
);

-- CreateTable
CREATE TABLE "car" (
    "car_id" SERIAL NOT NULL,
    "model_id" INTEGER,
    "location" INTEGER,
    "license_plate" VARCHAR(20) NOT NULL,
    "status" "car_status" NOT NULL,

    CONSTRAINT "car_pkey" PRIMARY KEY ("car_id")
);

-- CreateTable
CREATE TABLE "car_location" (
    "car_location_id" SERIAL NOT NULL,
    "address" VARCHAR(255) NOT NULL,

    CONSTRAINT "car_location_pkey" PRIMARY KEY ("car_location_id")
);

-- CreateTable
CREATE TABLE "car_model" (
    "model_id" SERIAL NOT NULL,
    "model_name" VARCHAR(50) NOT NULL,
    "fuel_type" "fuel" NOT NULL,
    "base_price" DECIMAL(8,2) NOT NULL,

    CONSTRAINT "car_model_pkey" PRIMARY KEY ("model_id")
);

-- CreateTable
CREATE TABLE "driver_license" (
    "driver_license_id" SERIAL NOT NULL,
    "license_number" CHAR(10) NOT NULL,
    "license_type" "license" NOT NULL,
    "expiry_date" DATE NOT NULL,

    CONSTRAINT "driver_license_pkey" PRIMARY KEY ("driver_license_id")
);

-- CreateTable
CREATE TABLE "payment" (
    "payment_id" SERIAL NOT NULL,
    "trip_id" INTEGER,
    "payment_date" TIMESTAMP(6) NOT NULL,
    "amount" DECIMAL(8,2) NOT NULL,
    "payment_type" "payment_type",
    "transaction_method" "transaction",
    "status" "status" DEFAULT 'pending',

    CONSTRAINT "payment_pkey" PRIMARY KEY ("payment_id")
);

-- CreateTable
CREATE TABLE "trip" (
    "trip_id" SERIAL NOT NULL,
    "book_id" INTEGER,
    "start_location" INTEGER,
    "end_location" INTEGER,
    "start_time" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end_time" TIMESTAMP(6),
    "price" DECIMAL(8,2),

    CONSTRAINT "trip_pkey" PRIMARY KEY ("trip_id")
);

-- CreateTable
CREATE TABLE "user" (
    "user_id" SERIAL NOT NULL,
    "driver_license_id" INTEGER,
    "email" VARCHAR(100) NOT NULL,
    "firstname" VARCHAR(32) NOT NULL,
    "lastname" VARCHAR(32) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("user_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "car_license_plate_key" ON "car"("license_plate");

-- CreateIndex
CREATE UNIQUE INDEX "car_model_model_name_key" ON "car_model"("model_name");

-- CreateIndex
CREATE UNIQUE INDEX "driver_license_license_number_key" ON "driver_license"("license_number");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_car_id_fkey" FOREIGN KEY ("car_id") REFERENCES "car"("car_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "car" ADD CONSTRAINT "car_location_fkey" FOREIGN KEY ("location") REFERENCES "car_location"("car_location_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "car" ADD CONSTRAINT "car_model_id_fkey" FOREIGN KEY ("model_id") REFERENCES "car_model"("model_id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_trip_id_fkey" FOREIGN KEY ("trip_id") REFERENCES "trip"("trip_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "trip" ADD CONSTRAINT "trip_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "booking"("book_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "trip" ADD CONSTRAINT "trip_end_location_fkey" FOREIGN KEY ("end_location") REFERENCES "car_location"("car_location_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "trip" ADD CONSTRAINT "trip_start_location_fkey" FOREIGN KEY ("start_location") REFERENCES "car_location"("car_location_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_driver_license_id_fkey" FOREIGN KEY ("driver_license_id") REFERENCES "driver_license"("driver_license_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- These constraints are not natively supported by Prisma Schema yet.
-- Add these to your migration.sql file to enforce them in the database.

ALTER TABLE "car_model" ADD CONSTRAINT "car_model_base_price_check" CHECK (base_price > 0);
ALTER TABLE "payment" ADD CONSTRAINT "payment_amount_check" CHECK (amount > 0);
ALTER TABLE "trip" ADD CONSTRAINT "trip_price_check" CHECK (price >= 0);
