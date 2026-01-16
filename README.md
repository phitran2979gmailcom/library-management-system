# 📚 Library Management System (PostgreSQL)

A relational **Library Management System** built with PostgreSQL, focusing on
data integrity, automation via triggers, and reporting through views.

This project demonstrates practical database design for real-world scenarios
such as stock tracking, loan management, and analytical queries.
 

## Features
- Real-time book stock management (`available_copies`)
- Automatic stock updates using PostgreSQL triggers
- Member and loan management
- Multi-author book support (many-to-many)
- Data integrity via constraints, checks, and partial unique indexes
- Foreign key constraints with `ON DELETE` rules to maintain referential integrity
- Partial indexes to optimize active loan queries
- Reporting views for:
  - Active loans
  - Overdue loans
  - Most popular books (top 10)
  - Member loan history
- Audit logging for loan creation and book returns
- Optional stored procedures for core business operations
- Indexes for query performance

---

## Database Structure
### Core Tables
- `authors` – Stores author information
- `categories` – Book categories
- `books` – Book details, total & available copies, category
- `book_authors` – Many-to-many link between books and authors
- `members` – Library members
- `loans` – Tracks book loans
- `loan_logs` – Logs loan creation and book returns
### Automation
- Triggers enforce business rules:
  - Stock decreases on loan creation
  - Stock increases on book return
  - Audit logging of loan events
### Reporting
- Views provide ready-to-use reports:
  - Active loans
  - Overdue loans
  - Most popular books
  - Member loan history


## Setup
Run SQL scripts in order:
```bash
psql -U <user> -d <database> -f sql/01_schema.sql
psql -U <user> -d <database> -f sql/02_triggers.sql
psql -U <user> -d <database> -f sql/03_views.sql
psql -U <user> -d <database> -f sql/04_sample_data.sql
```


## Possible Improvements
- Fine/penalty system for overdue loans
- Role-based access control
- REST API integration
- Transaction-level concurrency handling
- Materialized views for very large datasets


## Design Notes
Fully normalized relational database (3NF)
Triggers handle stock management and logging at the database level
Partial unique index prevents multiple active loans of the same book per member
Reporting views allow analytical queries without writing complex SQL
Indexes improve query performance
Optional stored procedures encapsulate business logic


## Key Takeaways
### This project helped reinforce:
- Database normalization principles (3NF)
- Trigger-based automation for business rules
- Index optimization for performance
- Business-oriented SQL reporting and analytical queries
- Data consistency and integrity through constraints and partial indexes
- Audit logging best practices
- Structuring a real-world relational database project for maintainability
  

## Example Queries;
-- active loans
- ```SELECT * FROM active_loans;```

-- overdue loans
- ```SELECT * FROM overdue_loans;```

-- available books
- ```SELECT title, available_copies 
FROM books 
WHERE available_copies > 0; ```

-- member loan history
- ```SELECT b.title, l.loan_date, l.return_date
FROM loans l
JOIN books b ON l.book_id = b.book_ID
WHERE l.member_ID = 1;```

