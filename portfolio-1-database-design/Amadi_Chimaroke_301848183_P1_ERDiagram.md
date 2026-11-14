# Gym / Fitness Club Management — ER diagram

```mermaid
erDiagram
    direction LR
    member {
        bigint member_id PK
        text full_name
        text email UK
        date joined_on
        boolean active
    }
    trainer {
        bigint trainer_id PK
        text full_name
        text email UK
        boolean active
    }
    class_session {
        bigint session_id PK
        bigint trainer_id FK
        text title
        timestamptz starts_at
        integer capacity
    }
    booking {
        bigint booking_id PK
        bigint member_id FK
        bigint session_id FK
        timestamptz booked_at
        text status
    }
    trainer ||--o{ class_session : "trainer_id"
    member ||--o{ booking : "member_id"
    class_session ||--o{ booking : "session_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Amadi_Chimaroke_301848183_ERDiagram.png)
