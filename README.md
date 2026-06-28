# Hotel Reservation System

A web-based hotel management system built with Flask and Oracle Database, developed as a Database Systems semester project at FAST CFD.

This project manages hotel records, rooms, guests, reservations, services, staff, and payments through a web-based interface.

## Features

* Admin and guest login system
* View hotels, rooms, services, guests, reservations, and payments
* Role-based access for admin and guest users
* Add new guests
* Add and delete reservations
* Update room status
* Oracle database integration
* SQL views for reservation and service details
* Stored procedures for guest, reservation, and room operations
* Triggers to automatically update room status
* ERD for database design

## Technologies Used

* Python
* Flask
* Oracle Database
* SQL
* HTML
* CSS

## Database Design

The system includes the following main entities:

* Hotel
* Room
* Guest
* Staff
* Reservation
* Payment
* Service
* Reservation Service

The database design includes primary keys, foreign keys, constraints, one-to-many relationships, multivalued attributes, and an associative entity for reservation services.

## Project Structure

```text
hotel-reservation-system/
│
├── app.py
├── project.sql
├── eerd.png
├── requirements.txt
└── templates/
    └── index.html
```

## How to Run

1. Install the required Python libraries:

```bash
pip install -r requirements.txt
```

2. Set up Oracle Database and run the SQL script:

```text
project.sql
```

3. Update your database environment variables:

```bash
DB_USER=your_oracle_username
DB_PASSWORD=your_oracle_password
DB_DSN=localhost:1521/xe
SECRET_KEY=your_secret_key
```

4. Run the Flask application:

```bash
python app.py
```

5. Open the application in your browser:

```text
http://127.0.0.1:5000/
```

## Note

This project uses Oracle Database. Oracle Instant Client may be required depending on the system setup.
