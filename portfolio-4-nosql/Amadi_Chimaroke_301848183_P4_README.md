# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection booking_events for booking_created and booking_confirmed events. These are fictional event examples based on booking, member, class_session, trainer.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related member, class_session, trainer details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "booking_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "booking",
        "key": {
            "booking_id": 401
        },
        "snapshot": {
            "booking_id": 401,
            "member_id": 101,
            "session_id": 301,
            "booked_at": "2026-11-14T18:00:00Z",
            "status": "confirmed"
        }
    },
    "embedded": {
        "member": [
            {
                "key": {
                    "member_id": 101
                },
                "snapshot": {
                    "member_id": 101,
                    "full_name": "Alex Rivera",
                    "email": "alex.rivera@example.test",
                    "joined_on": "2025-01-15",
                    "active": true
                },
                "via": [
                    "booking.member_id → member"
                ]
            }
        ],
        "class_session": [
            {
                "key": {
                    "session_id": 301
                },
                "snapshot": {
                    "session_id": 301,
                    "trainer_id": 201,
                    "title": "Morning Strength",
                    "starts_at": "2026-12-01T09:00:00Z",
                    "capacity": 12
                },
                "via": [
                    "booking.session_id → class_session"
                ]
            }
        ],
        "trainer": [
            {
                "key": {
                    "trainer_id": 201
                },
                "snapshot": {
                    "trainer_id": 201,
                    "full_name": "Jordan Lee",
                    "email": "jordan.lee@example.test",
                    "active": true
                },
                "via": [
                    "booking.session_id → class_session.trainer_id → trainer"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("booking_events").find({"eventType":"booking_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "booking_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "booking_id": 401
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("booking_events").find({"source.key.booking_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "booking_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "booking_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "booking_confirmed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "booking_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("booking_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "booking_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "booking_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "booking_confirmed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "booking_id": 401
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("booking_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| booking_confirmed | 1 |
| booking_created | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Amadi_Chimaroke_301848183_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Amadi_Chimaroke_301848183_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

