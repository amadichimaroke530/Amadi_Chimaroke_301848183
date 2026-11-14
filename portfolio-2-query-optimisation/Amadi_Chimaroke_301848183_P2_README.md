# Gym / Fitness Club Management — SQL queries

## 1. Show related member, booking, class_session records (up to 20).

```sql
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
```

| member_member_id | member_full_name | booking_booking_id | booking_booked_at | class_session_session_id | class_session_title |
| --- | --- | --- | --- | --- | --- |
| 101 | Alex Rivera | 401 | 2026-11-14T18:00:00+00:00 | 301 | Morning Strength |

## 2. Find trainer records where full_name matches "Jordan Lee" (up to 20).

```sql
SELECT * FROM portfolio."trainer"
WHERE "full_name" IS NOT DISTINCT FROM 'Jordan Lee'
ORDER BY "trainer_id"
LIMIT 20;
```

| trainer_id | full_name | email | active |
| --- | --- | --- | --- |
| 201 | Jordan Lee | jordan.lee@example.test | true |

## 3. Count class_session records for each trainer_id (up to 20 groups).

```sql
SELECT "trainer_id", count(*) AS record_count
FROM portfolio."class_session"
GROUP BY "trainer_id"
ORDER BY record_count DESC, "trainer_id" NULLS LAST
LIMIT 20;
```

| trainer_id | record_count |
| --- | --- |
| 201 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.097 | 1.097, 1.087, 1.097 | Sort → Seq Scan | 131 |
| After index | 0.182 | 0.182, 0.185, 0.179 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.097 ms to 0.182 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.071..1.073 rows=20 loops=1)
  Seq Scan on booking (actual time=0.015..1.037 rows=20 loops=1)
Planning Time: 0.378 ms
Execution Time: 1.097 ms
```

### Before index, run 2

```text
Sort (actual time=1.062..1.063 rows=20 loops=1)
  Seq Scan on booking (actual time=0.015..1.027 rows=20 loops=1)
Planning Time: 0.362 ms
Execution Time: 1.087 ms
```

### Before index, run 3

```text
Sort (actual time=1.069..1.071 rows=20 loops=1)
  Seq Scan on booking (actual time=0.015..1.034 rows=20 loops=1)
Planning Time: 0.369 ms
Execution Time: 1.097 ms
```

### After index, run 1

```text
Sort (actual time=0.133..0.135 rows=20 loops=1)
  Bitmap Heap Scan on booking (actual time=0.027..0.096 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.585 ms
Execution Time: 0.182 ms
```

### After index, run 2

```text
Sort (actual time=0.137..0.138 rows=20 loops=1)
  Bitmap Heap Scan on booking (actual time=0.027..0.101 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.586 ms
Execution Time: 0.185 ms
```

### After index, run 3

```text
Sort (actual time=0.132..0.134 rows=20 loops=1)
  Bitmap Heap Scan on booking (actual time=0.026..0.097 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=20 loops=1)
Planning Time: 0.595 ms
Execution Time: 0.179 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Amadi_Chimaroke_301848183_P2_Queries.sql, then Amadi_Chimaroke_301848183_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Amadi_Chimaroke_301848183_P2_QueryResults.png) · [Index comparison](screenshots/Amadi_Chimaroke_301848183_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

