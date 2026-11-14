# Gym / Fitness Club Management — database design

My case study records member, trainer, class_session, booking.

## Users

- Club administrators
- Trainers
- Members

## Main operations

- Maintain member and trainer records
- Schedule classes and record bookings
- Review class attendance and booking activity

## Entities

| Entity | Information stored |
| --- | --- |
| member | A person registered with the fitness club. |
| trainer | A trainer who leads scheduled class sessions. |
| class_session | A scheduled fitness class led by one trainer. |
| booking | A member's booking for a scheduled class session. |

## member

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| member_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| joined_on | DATE |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (email).

## trainer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| trainer_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (email).

## class_session

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| session_id | BIGINT | PK | Yes |
| trainer_id | BIGINT | FK | Yes |
| title | TEXT |  | Yes |
| starts_at | TIMESTAMPTZ |  | Yes |
| capacity | INTEGER |  | Yes |
- trainer_id → trainer.trainer_id

## booking

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| booking_id | BIGINT | PK | Yes |
| member_id | BIGINT | FK | Yes |
| session_id | BIGINT | FK | Yes |
| booked_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- member_id → member.member_id
- session_id → class_session.session_id

## Relationships and business rules

- Each member email identifies at most one member.
- Each trainer email identifies at most one trainer.
- Every class session refers to an existing trainer.
- A class session capacity must be greater than zero.
- Every booking refers to an existing member.
- Every booking refers to an existing class session.
- Booking status is limited to confirmed or cancelled.
- A partial unique constraint allows at most one confirmed booking per member and class session; cancelled rows are excluded.

## Assumptions

- All IDs are synthetic identifiers and globally unique across entity types.
- A member may have at most one confirmed booking for a given class session; a cancelled booking does not prevent a later confirmed booking.
- A class session has one trainer and a positive capacity; this exercise does not model capacity enforcement across concurrent bookings.
- Normalisation example rooted at booking: booking(booking_id, member_id, session_id, booked_at, status) contains scalar attributes (1NF); with a single-column primary key, non-key attributes depend on the whole key (2NF); member details belong in member and class details belong in class_session rather than being repeated in booking (3NF). The example follows booking to member and class_session, then class_session to trainer, without repeating ancestor roles.
- Separate benchmark plan: generate 20000 synthetic booking rows, run the same status-filter query without and with a B-tree index on booking.status, and compare the plans and measured query work under the same test conditions.

