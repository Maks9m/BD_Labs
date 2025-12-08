-- CreateTable
CREATE TABLE "comment" (
    "comment_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "trip_id" INTEGER,
    "content" VARCHAR(500) NOT NULL,

    CONSTRAINT "comment_pkey" PRIMARY KEY ("comment_id")
);

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_trip_id_fkey" FOREIGN KEY ("trip_id") REFERENCES "trip"("trip_id") ON DELETE SET NULL ON UPDATE NO ACTION;
