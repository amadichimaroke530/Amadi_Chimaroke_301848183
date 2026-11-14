# Portfolio 1 — Database Design and Modelling

I organised the data into member, trainer, class_session, booking. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| member | 1 |
| trainer | 1 |
| class_session | 1 |
| booking | 1 |

The 13 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Amadi_Chimaroke_301848183_P1_Design.md)
- [ER diagram](Amadi_Chimaroke_301848183_P1_ERDiagram.md)
- [Normalisation](Amadi_Chimaroke_301848183_P1_Normalisation.md)
- [Schema](Amadi_Chimaroke_301848183_P1_Schema.sql)
- [Sample data](Amadi_Chimaroke_301848183_P1_SampleData.sql)
- [Constraint tests](Amadi_Chimaroke_301848183_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Amadi_Chimaroke_301848183_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

