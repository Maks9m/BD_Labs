/*
  Warnings:

  - The values [C,D,E] on the enum `license` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "license_new" AS ENUM ('M', 'A', 'A1', 'B1', 'BE', 'B', 'C1', 'D1');
ALTER TABLE "driver_license" ALTER COLUMN "license_type" TYPE "license_new" USING ("license_type"::text::"license_new");
ALTER TYPE "license" RENAME TO "license_old";
ALTER TYPE "license_new" RENAME TO "license";
DROP TYPE "public"."license_old";
COMMIT;
