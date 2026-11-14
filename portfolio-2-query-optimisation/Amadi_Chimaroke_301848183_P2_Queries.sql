-- Show related member, booking, class_session records (up to 20).
SELECT t0."member_id" AS "member_member_id",
       t0."full_name" AS "member_full_name",
       t1."booking_id" AS "booking_booking_id",
       t1."booked_at" AS "booking_booked_at",
       t2."session_id" AS "class_session_session_id",
       t2."title" AS "class_session_title"
FROM portfolio."member" t0
JOIN portfolio."booking" t1 ON t1."member_id" = t0."member_id"
JOIN portfolio."class_session" t2 ON t1."session_id" = t2."session_id"
ORDER BY t0."member_id", t1."booking_id", t2."session_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."member_id" AS "member_member_id",
       t0."full_name" AS "member_full_name",
       t1."booking_id" AS "booking_booking_id",
       t1."booked_at" AS "booking_booked_at",
       t2."session_id" AS "class_session_session_id",
       t2."title" AS "class_session_title"
FROM portfolio."member" t0
JOIN portfolio."booking" t1 ON t1."member_id" = t0."member_id"
JOIN portfolio."class_session" t2 ON t1."session_id" = t2."session_id"
ORDER BY t0."member_id", t1."booking_id", t2."session_id"
LIMIT 20;

-- Find trainer records where full_name matches "Jordan Lee" (up to 20).
SELECT * FROM portfolio."trainer"
WHERE "full_name" IS NOT DISTINCT FROM 'Jordan Lee'
ORDER BY "trainer_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."trainer"
WHERE "full_name" IS NOT DISTINCT FROM 'Jordan Lee'
ORDER BY "trainer_id"
LIMIT 20;

-- Count class_session records for each trainer_id (up to 20 groups).
SELECT "trainer_id", count(*) AS record_count
FROM portfolio."class_session"
GROUP BY "trainer_id"
ORDER BY record_count DESC, "trainer_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "trainer_id", count(*) AS record_count
FROM portfolio."class_session"
GROUP BY "trainer_id"
ORDER BY record_count DESC, "trainer_id" NULLS LAST
LIMIT 20;
