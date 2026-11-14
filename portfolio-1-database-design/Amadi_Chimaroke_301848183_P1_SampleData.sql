-- Fictional sample records for Gym / Fitness Club Management.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active") VALUES (101, 'Alex Rivera', 'alex.rivera@example.test', '2025-01-15', TRUE);
INSERT INTO portfolio."trainer" ("trainer_id", "full_name", "email", "active") VALUES (201, 'Jordan Lee', 'jordan.lee@example.test', TRUE);
INSERT INTO portfolio."class_session" ("session_id", "trainer_id", "title", "starts_at", "capacity") VALUES (301, 201, 'Morning Strength', '2026-12-01T09:00:00Z', 12);
INSERT INTO portfolio."booking" ("booking_id", "member_id", "session_id", "booked_at", "status") VALUES (401, 101, 301, '2026-11-14T18:00:00Z', 'confirmed');
COMMIT;
