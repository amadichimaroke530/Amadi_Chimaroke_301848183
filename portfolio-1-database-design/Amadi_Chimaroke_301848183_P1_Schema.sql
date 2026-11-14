-- Gym / Fitness Club Management: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."member" (
  "member_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "joined_on" date NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_member" PRIMARY KEY ("member_id"),
  CONSTRAINT "uq_member_0" UNIQUE ("email")
);
CREATE TABLE portfolio."trainer" (
  "trainer_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_trainer" PRIMARY KEY ("trainer_id"),
  CONSTRAINT "uq_trainer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."class_session" (
  "session_id" bigint NOT NULL,
  "trainer_id" bigint NOT NULL,
  "title" text NOT NULL,
  "starts_at" timestamptz NOT NULL,
  "capacity" bigint NOT NULL,
  CONSTRAINT "pk_class_session" PRIMARY KEY ("session_id")
);
CREATE TABLE portfolio."booking" (
  "booking_id" bigint NOT NULL,
  "member_id" bigint NOT NULL,
  "session_id" bigint NOT NULL,
  "booked_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_booking" PRIMARY KEY ("booking_id")
);
ALTER TABLE portfolio."class_session" ADD CONSTRAINT "fk_class_session_0" FOREIGN KEY ("trainer_id") REFERENCES portfolio."trainer" ("trainer_id");
ALTER TABLE portfolio."booking" ADD CONSTRAINT "fk_booking_0" FOREIGN KEY ("member_id") REFERENCES portfolio."member" ("member_id");
ALTER TABLE portfolio."booking" ADD CONSTRAINT "fk_booking_1" FOREIGN KEY ("session_id") REFERENCES portfolio."class_session" ("session_id");
ALTER TABLE portfolio."class_session" ADD CONSTRAINT "session_capacity_positive" CHECK ("capacity" > 0);
ALTER TABLE portfolio."booking" ADD CONSTRAINT "booking_status_valid" CHECK (("status" = 'confirmed') OR ("status" = 'cancelled'));
CREATE UNIQUE INDEX "confirmed_booking_unique" ON portfolio."booking" ("member_id", "session_id") WHERE ("status" = 'confirmed');
COMMIT;
