# Gym / Fitness Club Management — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| member_id | booking records (list) |
| --- | --- |
| 101 | [401] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| booking.booking_id | booking.member_id | booking.session_id | booking.status | member.member_id | member.full_name | class_session.session_id | class_session.trainer_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 101 | 301 | confirmed | 101 | Alex Rivera | 301 | 201 |

Key: booking_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## booking_example

| booking.booking_id | booking.member_id | booking.session_id | booking.status | member.member_id | member.full_name | class_session.session_id | class_session.trainer_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 101 | 301 | confirmed | 101 | Alex Rivera | 301 | 201 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## member

| member_id | full_name | email | joined_on | active |
| --- | --- | --- | --- | --- |
| 101 | Alex Rivera | alex.rivera@example.test | 2025-01-15 | true |

## trainer

| trainer_id | full_name | email | active |
| --- | --- | --- | --- |
| 201 | Jordan Lee | jordan.lee@example.test | true |

## class_session

| session_id | trainer_id | title | starts_at | capacity |
| --- | --- | --- | --- | --- |
| 301 | 201 | Morning Strength | 2026-12-01T09:00:00+00:00 | 12 |

## booking

| booking_id | member_id | session_id | booked_at | status |
| --- | --- | --- | --- | --- |
| 401 | 101 | 301 | 2026-11-14T18:00:00+00:00 | confirmed |

## Dependencies

- member: (member_id) → full_name, email, joined_on, active
- trainer: (trainer_id) → full_name, email, active
- class_session: (session_id) → trainer_id, title, starts_at, capacity
- booking: (booking_id) → member_id, session_id, booked_at, status

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
