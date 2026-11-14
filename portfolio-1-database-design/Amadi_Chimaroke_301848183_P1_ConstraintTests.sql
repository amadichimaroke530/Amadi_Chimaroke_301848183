-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. duplicate member pk. Expected: pk_member, SQLSTATE 23505.
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active")
VALUES (101, 'Morgan Chen', 'morgan.chen@example.test', '2025-02-01', TRUE);

-- 2. duplicate member email. Expected: uq_member_0, SQLSTATE 23505.
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active")
VALUES (1001, 'Taylor Park', 'alex.rivera@example.test', '2025-03-01', TRUE);

-- 3. null member id. Expected: member_id, SQLSTATE 23502.
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active")
VALUES (NULL, 'Casey Patel', 'casey.patel@example.test', '2025-04-01', TRUE);

-- 4. duplicate trainer pk. Expected: pk_trainer, SQLSTATE 23505.
INSERT INTO portfolio."trainer" ("trainer_id", "full_name", "email", "active")
VALUES (201, 'Riley Kim', 'riley.kim@example.test', TRUE);

-- 5. duplicate trainer email. Expected: uq_trainer_0, SQLSTATE 23505.
INSERT INTO portfolio."trainer" ("trainer_id", "full_name", "email", "active")
VALUES (1002, 'Sam Brooks', 'jordan.lee@example.test', FALSE);

-- 6. duplicate session pk. Expected: pk_class_session, SQLSTATE 23505.
INSERT INTO portfolio."class_session" ("session_id", "trainer_id", "title", "starts_at", "capacity")
VALUES (301, 201, 'Evening Mobility', '2026-12-02T18:00:00Z', 8);

-- 7. missing session trainer. Expected: fk_class_session_0, SQLSTATE 23503.
INSERT INTO portfolio."class_session" ("session_id", "trainer_id", "title", "starts_at", "capacity")
VALUES (1003, 1004, 'Core Basics', '2026-12-03T10:00:00Z', 10);

-- 8. nonpositive session capacity. Expected: session_capacity_positive, SQLSTATE 23514.
INSERT INTO portfolio."class_session" ("session_id", "trainer_id", "title", "starts_at", "capacity")
VALUES (1005, 201, 'Low Impact Fitness', '2026-12-04T11:00:00Z', 0);

-- 9. duplicate booking pk. Expected: pk_booking, SQLSTATE 23505.
INSERT INTO portfolio."booking" ("booking_id", "member_id", "session_id", "booked_at", "status")
VALUES (401, 101, 301, '2026-11-14T18:30:00Z', 'cancelled');

-- 10. missing booking member. Expected: fk_booking_0, SQLSTATE 23503.
INSERT INTO portfolio."booking" ("booking_id", "member_id", "session_id", "booked_at", "status")
VALUES (1006, 1007, 301, '2026-11-14T18:35:00Z', 'cancelled');

-- 11. missing booking session. Expected: fk_booking_1, SQLSTATE 23503.
INSERT INTO portfolio."booking" ("booking_id", "member_id", "session_id", "booked_at", "status")
VALUES (1008, 101, 1009, '2026-11-14T18:40:00Z', 'cancelled');

-- 12. invalid booking status. Expected: booking_status_valid, SQLSTATE 23514.
INSERT INTO portfolio."booking" ("booking_id", "member_id", "session_id", "booked_at", "status")
VALUES (1010, 101, 301, '2026-11-14T18:45:00Z', 'pending');

-- 13. duplicate confirmed booking. Expected: confirmed_booking_unique, SQLSTATE 23505.
INSERT INTO portfolio."booking" ("booking_id", "member_id", "session_id", "booked_at", "status")
VALUES (1011, 101, 301, '2026-11-14T18:50:00Z', 'confirmed');
