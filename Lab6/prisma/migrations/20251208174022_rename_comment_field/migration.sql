/*
  Warnings:

  - You are about to drop the column `content` on the `comment` table. All the data in the column will be lost.
  - Added the required column `text` to the `comment` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "comment" DROP COLUMN "content",
ADD COLUMN     "text" VARCHAR(500) NOT NULL;
