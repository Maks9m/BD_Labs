import { Prisma, license, car_status, fuel, payment_type, transaction, status } from '@prisma/client';
import prisma from './client';

async function main() {
  console.log('Clean existing tables...');
  // We delete child tables first.
  await prisma.payment.deleteMany();
  await prisma.trip.deleteMany();
  await prisma.booking.deleteMany();
  await prisma.car.deleteMany();
  await prisma.user.deleteMany();
  await prisma.driver_license.deleteMany();
  await prisma.car_model.deleteMany();
  await prisma.car_location.deleteMany();

  console.log('Seeding data...');

  
  await prisma.driver_license.createMany({
    data: [
      { driver_license_id: 1, license_number: 'DL10000001', license_type: license.B, expiry_date: new Date('2026-01-15') },
      { driver_license_id: 2, license_number: 'DL10000002', license_type: license.B, expiry_date: new Date('2027-03-22') },
      { driver_license_id: 3, license_number: 'DL10000003', license_type: license.A1, expiry_date: new Date('2025-11-30') },
      { driver_license_id: 4, license_number: 'DL10000004', license_type: license.C1, expiry_date: new Date('2028-07-10') },
      { driver_license_id: 5, license_number: 'DL10000005', license_type: license.B, expiry_date: new Date('2026-09-05') },
      { driver_license_id: 6, license_number: 'DL10000006', license_type: license.B, expiry_date: new Date('2029-02-14') },
      { driver_license_id: 7, license_number: 'DL10000007', license_type: license.D1, expiry_date: new Date('2025-12-25') },
      { driver_license_id: 8, license_number: 'DL10000008', license_type: license.B, expiry_date: new Date('2027-06-18') },
      { driver_license_id: 9, license_number: 'DL10000009', license_type: license.BE, expiry_date: new Date('2030-01-01') },
      { driver_license_id: 10, license_number: 'DL10000010', license_type: license.B, expiry_date: new Date('2026-04-12') },
      { driver_license_id: 11, license_number: 'DL10000011', license_type: license.A1, expiry_date: new Date('2028-08-30') },
      { driver_license_id: 12, license_number: 'DL10000012', license_type: license.B, expiry_date: new Date('2027-10-05') },
    ],
  });

  // 2. Users
  await prisma.user.createMany({
    data: [
      { user_id: 1, email: 'john.doe@example.com', firstname: 'John', lastname: 'Doe', driver_license_id: 1 },
      { user_id: 2, email: 'jane.smith@example.com', firstname: 'Jane', lastname: 'Smith', driver_license_id: 2 },
      { user_id: 3, email: 'mike.jones@example.com', firstname: 'Mike', lastname: 'Jones', driver_license_id: 3 },
      { user_id: 4, email: 'sarah.connor@example.com', firstname: 'Sarah', lastname: 'Connor', driver_license_id: 4 },
      { user_id: 5, email: 'bruce.wayne@example.com', firstname: 'Bruce', lastname: 'Wayne', driver_license_id: 5 },
      { user_id: 6, email: 'clark.kent@example.com', firstname: 'Clark', lastname: 'Kent', driver_license_id: 6 },
      { user_id: 7, email: 'diana.prince@example.com', firstname: 'Diana', lastname: 'Prince', driver_license_id: 7 },
      { user_id: 8, email: 'peter.parker@example.com', firstname: 'Peter', lastname: 'Parker', driver_license_id: 8 },
      { user_id: 9, email: 'tony.stark@example.com', firstname: 'Tony', lastname: 'Stark', driver_license_id: 9 },
      { user_id: 10, email: 'natasha.romanoff@example.com', firstname: 'Natasha', lastname: 'Romanoff', driver_license_id: 10 },
      { user_id: 11, email: 'steve.rogers@example.com', firstname: 'Steve', lastname: 'Rogers', driver_license_id: 11 },
      { user_id: 12, email: 'wanda.maximoff@example.com', firstname: 'Wanda', lastname: 'Maximoff', driver_license_id: 12 },
    ],
  });

  // 3. Car Locations
  await prisma.car_location.createMany({
    data: [
      { car_location_id: 1, address: '123 Main St, New York, NY' },
      { car_location_id: 2, address: '456 Elm St, Los Angeles, CA' },
      { car_location_id: 3, address: '789 Oak St, Chicago, IL' },
      { car_location_id: 4, address: '101 Pine St, Houston, TX' },
      { car_location_id: 5, address: '202 Maple St, Phoenix, AZ' },
      { car_location_id: 6, address: '303 Cedar St, Philadelphia, PA' },
      { car_location_id: 7, address: '404 Birch St, San Antonio, TX' },
      { car_location_id: 8, address: '505 Walnut St, San Diego, CA' },
      { car_location_id: 9, address: '606 Ash St, Dallas, TX' },
      { car_location_id: 10, address: '707 Cherry St, San Jose, CA' },
      { car_location_id: 11, address: '808 Spruce St, Austin, TX' },
      { car_location_id: 12, address: '909 Fir St, Jacksonville, FL' },
    ],
  });

  // 4. Car Models
  await prisma.car_model.createMany({
    data: [
      { model_id: 1, model_name: 'Toyota Corolla', fuel_type: fuel.Petrol, base_price: new Prisma.Decimal(50.00) },
      { model_id: 2, model_name: 'Honda Civic', fuel_type: fuel.Petrol, base_price: new Prisma.Decimal(55.00) },
      { model_id: 3, model_name: 'Tesla Model 3', fuel_type: fuel.Electric, base_price: new Prisma.Decimal(80.00) },
      { model_id: 4, model_name: 'Ford Mustang', fuel_type: fuel.Petrol, base_price: new Prisma.Decimal(90.00) },
      { model_id: 5, model_name: 'Chevrolet Bolt', fuel_type: fuel.Electric, base_price: new Prisma.Decimal(70.00) },
      { model_id: 6, model_name: 'Toyota Prius', fuel_type: fuel.Hybrid, base_price: new Prisma.Decimal(60.00) },
      { model_id: 7, model_name: 'BMW 3 Series', fuel_type: fuel.Diesel, base_price: new Prisma.Decimal(85.00) },
      { model_id: 8, model_name: 'Audi A4', fuel_type: fuel.Diesel, base_price: new Prisma.Decimal(88.00) },
      { model_id: 9, model_name: 'Nissan Leaf', fuel_type: fuel.Electric, base_price: new Prisma.Decimal(65.00) },
      { model_id: 10, model_name: 'Hyundai Elantra', fuel_type: fuel.Hybrid, base_price: new Prisma.Decimal(52.00) },
      { model_id: 11, model_name: 'Kia Forte', fuel_type: fuel.Petrol, base_price: new Prisma.Decimal(48.00) },
      { model_id: 12, model_name: 'Mercedes C-Class', fuel_type: fuel.Diesel, base_price: new Prisma.Decimal(95.00) },
    ],
  });

  // 5. Cars
  await prisma.car.createMany({
    data: [
      { car_id: 1, model_id: 1, location: 1, license_plate: 'ABC-1234', status: car_status.Available },
      { car_id: 2, model_id: 2, location: 2, license_plate: 'DEF-5678', status: car_status.Booked },
      { car_id: 3, model_id: 3, location: 3, license_plate: 'GHI-9012', status: car_status.Available },
      { car_id: 4, model_id: 4, location: 4, license_plate: 'JKL-3456', status: car_status.Repaired },
      { car_id: 5, model_id: 5, location: 5, license_plate: 'MNO-7890', status: car_status.Available },
      { car_id: 6, model_id: 6, location: 6, license_plate: 'PQR-1234', status: car_status.Booked },
      { car_id: 7, model_id: 7, location: 7, license_plate: 'STU-5678', status: car_status.Available },
      { car_id: 8, model_id: 8, location: 8, license_plate: 'VWX-9012', status: car_status.Available },
      { car_id: 9, model_id: 9, location: 9, license_plate: 'YZA-3456', status: car_status.Booked },
      { car_id: 10, model_id: 10, location: 10, license_plate: 'BCD-7890', status: car_status.Available },
      { car_id: 11, model_id: 11, location: 11, license_plate: 'EFG-1234', status: car_status.Repaired },
      { car_id: 12, model_id: 12, location: 12, license_plate: 'HIJ-5678', status: car_status.Available },
    ],
  });

  // 6. Bookings
  await prisma.booking.createMany({
    data: [
      { book_id: 1, user_id: 1, car_id: 1, status: status.completed },
      { book_id: 2, user_id: 2, car_id: 2, status: status.confirmed },
      { book_id: 3, user_id: 3, car_id: 3, status: status.completed },
      { book_id: 4, user_id: 4, car_id: 4, status: status.pending },
      { book_id: 5, user_id: 5, car_id: 5, status: status.completed },
      { book_id: 6, user_id: 6, car_id: 6, status: status.confirmed },
      { book_id: 7, user_id: 7, car_id: 7, status: status.completed },
      { book_id: 8, user_id: 8, car_id: 8, status: status.completed },
      { book_id: 9, user_id: 9, car_id: 9, status: status.confirmed },
      { book_id: 10, user_id: 10, car_id: 10, status: status.completed },
      { book_id: 11, user_id: 11, car_id: 11, status: status.pending },
      { book_id: 12, user_id: 12, car_id: 12, status: status.completed },
      { book_id: 13, user_id: 1, car_id: 3, status: status.completed },
      { book_id: 14, user_id: 2, car_id: 4, status: status.completed },
      { book_id: 15, user_id: 3, car_id: 5, status: status.completed },
    ],
  });

  // 7. Trips
  await prisma.trip.createMany({
    data: [
      { trip_id: 1, book_id: 1, start_location: 1, end_location: 2, start_time: new Date('2025-11-01T10:00:00'), end_time: new Date('2025-11-01T12:00:00'), price: new Prisma.Decimal(100.00) },
      { trip_id: 2, book_id: 3, start_location: 3, end_location: 4, start_time: new Date('2025-11-02T14:00:00'), end_time: new Date('2025-11-02T16:00:00'), price: new Prisma.Decimal(160.00) },
      { trip_id: 3, book_id: 5, start_location: 5, end_location: 6, start_time: new Date('2025-11-03T09:00:00'), end_time: new Date('2025-11-03T11:00:00'), price: new Prisma.Decimal(140.00) },
      { trip_id: 4, book_id: 7, start_location: 7, end_location: 8, start_time: new Date('2025-11-04T13:00:00'), end_time: new Date('2025-11-04T15:00:00'), price: new Prisma.Decimal(170.00) },
      { trip_id: 5, book_id: 8, start_location: 8, end_location: 9, start_time: new Date('2025-11-05T08:00:00'), end_time: new Date('2025-11-05T10:00:00'), price: new Prisma.Decimal(176.00) },
      { trip_id: 6, book_id: 10, start_location: 10, end_location: 11, start_time: new Date('2025-11-06T15:00:00'), end_time: new Date('2025-11-06T17:00:00'), price: new Prisma.Decimal(104.00) },
      { trip_id: 7, book_id: 12, start_location: 12, end_location: 1, start_time: new Date('2025-11-07T11:00:00'), end_time: new Date('2025-11-07T13:00:00'), price: new Prisma.Decimal(190.00) },
      { trip_id: 8, book_id: 2, start_location: 2, end_location: 3, start_time: new Date('2025-11-08T10:00:00'), end_time: null, price: new Prisma.Decimal(110.00) },
      { trip_id: 9, book_id: 6, start_location: 6, end_location: 7, start_time: new Date('2025-11-09T12:00:00'), end_time: null, price: new Prisma.Decimal(120.00) },
      { trip_id: 10, book_id: 9, start_location: 9, end_location: 10, start_time: new Date('2025-11-10T14:00:00'), end_time: null, price: new Prisma.Decimal(130.00) },
      { trip_id: 11, book_id: 13, start_location: 3, end_location: 1, start_time: new Date('2025-11-12T08:00:00'), end_time: new Date('2025-11-12T09:00:00'), price: new Prisma.Decimal(80.00) },
      { trip_id: 12, book_id: 14, start_location: 4, end_location: 2, start_time: new Date('2025-11-13T10:00:00'), end_time: new Date('2025-11-13T11:00:00'), price: new Prisma.Decimal(90.00) },
    ],
  });

  // 8. Payments
  await prisma.payment.createMany({
    data: [
      { payment_id: 1, trip_id: 1, payment_date: new Date('2025-11-01T12:05:00'), amount: new Prisma.Decimal(100.00), payment_type: payment_type.Credit_Card, transaction_method: transaction.Online, status: status.completed },
      { payment_id: 2, trip_id: 2, payment_date: new Date('2025-11-02T16:05:00'), amount: new Prisma.Decimal(160.00), payment_type: payment_type.Debit_Card, transaction_method: transaction.POS, status: status.completed },
      { payment_id: 3, trip_id: 3, payment_date: new Date('2025-11-03T11:05:00'), amount: new Prisma.Decimal(140.00), payment_type: payment_type.Credit_Card, transaction_method: transaction.Online, status: status.completed },
      { payment_id: 4, trip_id: 4, payment_date: new Date('2025-11-04T15:05:00'), amount: new Prisma.Decimal(170.00), payment_type: payment_type.Gift_Card, transaction_method: transaction.Online, status: status.completed },
      { payment_id: 5, trip_id: 5, payment_date: new Date('2025-11-05T10:05:00'), amount: new Prisma.Decimal(176.00), payment_type: payment_type.Debit_Card, transaction_method: transaction.POS, status: status.completed },
      { payment_id: 6, trip_id: 6, payment_date: new Date('2025-11-06T17:05:00'), amount: new Prisma.Decimal(104.00), payment_type: payment_type.Credit_Card, transaction_method: transaction.Online, status: status.completed },
      { payment_id: 7, trip_id: 7, payment_date: new Date('2025-11-07T13:05:00'), amount: new Prisma.Decimal(190.00), payment_type: payment_type.Credit_Card, transaction_method: transaction.POS, status: status.completed },
      { payment_id: 8, trip_id: 8, payment_date: new Date('2025-11-08T10:05:00'), amount: new Prisma.Decimal(110.00), payment_type: payment_type.Debit_Card, transaction_method: transaction.Online, status: status.pending },
      { payment_id: 9, trip_id: 9, payment_date: new Date('2025-11-09T12:05:00'), amount: new Prisma.Decimal(120.00), payment_type: payment_type.Credit_Card, transaction_method: transaction.Online, status: status.pending },
      { payment_id: 10, trip_id: 10, payment_date: new Date('2025-11-10T14:05:00'), amount: new Prisma.Decimal(130.00), payment_type: payment_type.Gift_Card, transaction_method: transaction.POS, status: status.pending },
      { payment_id: 11, trip_id: 11, payment_date: new Date('2025-11-12T09:05:00'), amount: new Prisma.Decimal(80.00), payment_type: payment_type.Credit_Card, transaction_method: transaction.Online, status: status.completed },
      { payment_id: 12, trip_id: 12, payment_date: new Date('2025-11-13T11:05:00'), amount: new Prisma.Decimal(90.00), payment_type: payment_type.Debit_Card, transaction_method: transaction.POS, status: status.completed },
    ],
  });

  // Reset sequences
  const tables = [
    { name: 'driver_license', pk: 'driver_license_id' },
    { name: 'user', pk: 'user_id' },
    { name: 'car_location', pk: 'car_location_id' },
    { name: 'car_model', pk: 'model_id' },
    { name: 'car', pk: 'car_id' },
    { name: 'booking', pk: 'book_id' },
    { name: 'trip', pk: 'trip_id' },
    { name: 'payment', pk: 'payment_id' },
  ];

  for (const table of tables) {
    await prisma.$executeRawUnsafe(
      `SELECT setval(pg_get_serial_sequence('"${table.name}"', '${table.pk}'), coalesce(max("${table.pk}")+1, 1), false) FROM "${table.name}";`
    );
  }

  console.log('Seeding finished.');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });