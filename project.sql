----creating tables

CREATE TABLE HOTEL (
    hotel_id NUMBER PRIMARY KEY,
    hotel_name VARCHAR2(100) NOT NULL,
    star_rating NUMBER CHECK (star_rating BETWEEN 1 AND 5),
    city VARCHAR2(50) NOT NULL,
    country VARCHAR2(50) NOT NULL
);

CREATE TABLE HOTEL_PHONE (
    hotel_id NUMBER NOT NULL,
    phone VARCHAR2(15) NOT NULL,
    PRIMARY KEY (hotel_id, phone),
    FOREIGN KEY (hotel_id) REFERENCES HOTEL(hotel_id) ON DELETE CASCADE
);

CREATE TABLE GUEST (
    guest_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    street VARCHAR2(100),
    city VARCHAR2(50),
    country VARCHAR2(50)
);

CREATE TABLE GUEST_PHONE (
    guest_id NUMBER NOT NULL,
    phone VARCHAR2(15) NOT NULL,
    PRIMARY KEY (guest_id, phone),
    FOREIGN KEY (guest_id) REFERENCES GUEST(guest_id) ON DELETE CASCADE
);

CREATE TABLE SERVICE (
    service_id NUMBER PRIMARY KEY,
    service_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(200),
    price NUMBER(10,2) CHECK (price > 0)
);

CREATE TABLE ROOM (
    room_id NUMBER PRIMARY KEY,
    hotel_id NUMBER NOT NULL,
    room_number NUMBER NOT NULL,
    room_type VARCHAR2(30) NOT NULL,
    capacity NUMBER CHECK (capacity > 0),
    price_per_night NUMBER(10,2) CHECK (price_per_night > 0),
    status VARCHAR2(20),
    UNIQUE (hotel_id, room_number),
    FOREIGN KEY (hotel_id) REFERENCES HOTEL(hotel_id) ON DELETE CASCADE
);

CREATE TABLE STAFF (
    staff_id NUMBER PRIMARY KEY,
    hotel_id NUMBER NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    role VARCHAR2(50),
    salary NUMBER(10,2) CHECK (salary > 0),
    phone VARCHAR2(15) UNIQUE,
    FOREIGN KEY (hotel_id) REFERENCES HOTEL(hotel_id) ON DELETE CASCADE
);

CREATE TABLE RESERVATION (
    reservation_id NUMBER PRIMARY KEY,
    guest_id NUMBER NOT NULL,
    room_id NUMBER NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status VARCHAR2(20),
    total_amount NUMBER(10,2),
    FOREIGN KEY (guest_id) REFERENCES GUEST(guest_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES ROOM(room_id),
    CHECK (check_out_date > check_in_date)
);

CREATE TABLE PAYMENT (
    payment_id NUMBER PRIMARY KEY,
    reservation_id NUMBER NOT NULL,
    amount NUMBER(10,2) CHECK (amount > 0),
    method VARCHAR2(30),
    payment_date DATE,
    payment_status VARCHAR2(20),
    FOREIGN KEY (reservation_id) REFERENCES RESERVATION(reservation_id) ON DELETE CASCADE
);

CREATE TABLE RES_SERVICE (
    res_service_id NUMBER PRIMARY KEY,
    reservation_id NUMBER NOT NULL,
    service_id NUMBER NOT NULL,
    quantity NUMBER CHECK (quantity > 0),
    subtotal NUMBER(10,2),
    FOREIGN KEY (reservation_id) REFERENCES RESERVATION(reservation_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES SERVICE(service_id)
);


----inserting data

-- HOTEL
INSERT INTO HOTEL VALUES (1,'Grand Palace Hotel',5,'Dubai','UAE');
INSERT INTO HOTEL VALUES (2,'Ocean View Resort',4,'Karachi','Pakistan');
INSERT INTO HOTEL VALUES (3,'Mountain Retreat',3,'Murree','Pakistan');
INSERT INTO HOTEL VALUES (4,'Royal Garden Hotel',5,'Istanbul','Turkey');
INSERT INTO HOTEL VALUES (5,'City Comfort Inn',4,'Lahore','Pakistan');

-- HOTEL_PHONE
INSERT INTO HOTEL_PHONE VALUES (1,'971501234567');
INSERT INTO HOTEL_PHONE VALUES (2,'923001112233');
INSERT INTO HOTEL_PHONE VALUES (3,'923334445566');
INSERT INTO HOTEL_PHONE VALUES (4,'905551112233');
INSERT INTO HOTEL_PHONE VALUES (5,'923456789012');

-- GUEST
INSERT INTO GUEST VALUES (1,'Ali','Khan','ali@example.com','DHA','Lahore','Pakistan');
INSERT INTO GUEST VALUES (2,'Sara','Ahmed','sara@example.com','Model Town','Karachi','Pakistan');
INSERT INTO GUEST VALUES (3,'John','Smith','john@example.com','Baker Street','London','UK');
INSERT INTO GUEST VALUES (4,'Ayesha','Malik','ayesha@example.com','Gulberg','Lahore','Pakistan');
INSERT INTO GUEST VALUES (5,'Usman','Raza','usman@example.com','F-8','Islamabad','Pakistan');
INSERT INTO GUEST VALUES (6,'Emma','Wilson','emma@example.com','Oxford Road','Manchester','UK');
INSERT INTO GUEST VALUES (7,'Hamza','Ali','hamza@example.com','Satellite Town','Rawalpindi','Pakistan');
INSERT INTO GUEST VALUES (8,'Sophia','Brown','sophia@example.com','King Street','Birmingham','UK');
INSERT INTO GUEST VALUES (9,'Bilal','Iqbal','bilal@example.com','Cantt','Peshawar','Pakistan');
INSERT INTO GUEST VALUES (10,'Noah','Davis','noah@example.com','Queen Road','Liverpool','UK');
INSERT INTO GUEST VALUES (11,'Zain','Hassan','zain@example.com','Johar Town','Lahore','Pakistan');

-- GUEST_PHONE
INSERT INTO GUEST_PHONE VALUES (1,'923111111111');
INSERT INTO GUEST_PHONE VALUES (2,'923222222222');
INSERT INTO GUEST_PHONE VALUES (3,'447700123456');
INSERT INTO GUEST_PHONE VALUES (4,'923333111111');
INSERT INTO GUEST_PHONE VALUES (5,'923444111111');
INSERT INTO GUEST_PHONE VALUES (6,'447700222333');
INSERT INTO GUEST_PHONE VALUES (7,'923555111111');
INSERT INTO GUEST_PHONE VALUES (8,'447700555666');
INSERT INTO GUEST_PHONE VALUES (9,'923666111111');
INSERT INTO GUEST_PHONE VALUES (10,'447700777888');
INSERT INTO GUEST_PHONE VALUES (11,'923777777777');

-- SERVICE
INSERT INTO SERVICE VALUES (1,'Laundry','Clothes washing service',20);
INSERT INTO SERVICE VALUES (2,'Room Service','Food delivery',35);
INSERT INTO SERVICE VALUES (3,'Airport Pickup','Airport transport',50);
INSERT INTO SERVICE VALUES (4,'Spa','Relaxation treatment',80);
INSERT INTO SERVICE VALUES (5,'Breakfast','Morning buffet',15);
INSERT INTO SERVICE VALUES (6,'Gym Access','Fitness center',25);
INSERT INTO SERVICE VALUES (7,'Car Rental','Vehicle service',100);
INSERT INTO SERVICE VALUES (8,'Conference Hall','Meeting room',200);

-- ROOM
INSERT INTO ROOM VALUES (1,1,101,'Single',1,100,'Available');
INSERT INTO ROOM VALUES (2,1,102,'Double',2,180,'Occupied');
INSERT INTO ROOM VALUES (3,1,103,'Suite',4,300,'Available');
INSERT INTO ROOM VALUES (4,2,201,'Single',1,120,'Occupied');
INSERT INTO ROOM VALUES (5,2,202,'Double',2,200,'Available');
INSERT INTO ROOM VALUES (6,2,203,'Suite',4,350,'Available');
INSERT INTO ROOM VALUES (7,3,301,'Single',1,90,'Available');
INSERT INTO ROOM VALUES (8,3,302,'Double',2,150,'Occupied');
INSERT INTO ROOM VALUES (9,3,303,'Deluxe',3,220,'Available');
INSERT INTO ROOM VALUES (10,4,401,'Suite',4,400,'Available');
INSERT INTO ROOM VALUES (11,4,402,'Deluxe',3,250,'Occupied');
INSERT INTO ROOM VALUES (12,4,403,'Double',2,190,'Available');
INSERT INTO ROOM VALUES (13,5,501,'Single',1,110,'Available');
INSERT INTO ROOM VALUES (14,5,502,'Double',2,170,'Available');
INSERT INTO ROOM VALUES (15,5,503,'Suite',4,320,'Occupied');

-- STAFF
INSERT INTO STAFF VALUES (1,1,'Ahmed','Raza','Manager',5000,'923900000001');
INSERT INTO STAFF VALUES (2,1,'Fatima','Noor','Receptionist',2500,'923900000002');
INSERT INTO STAFF VALUES (3,2,'David','Clark','Chef',3500,'923900000003');
INSERT INTO STAFF VALUES (4,2,'Hina','Ali','Receptionist',2400,'923900000004');
INSERT INTO STAFF VALUES (5,3,'Omar','Khan','Manager',4500,'923900000005');
INSERT INTO STAFF VALUES (6,3,'Zara','Iqbal','Cleaner',1800,'923900000006');
INSERT INTO STAFF VALUES (7,4,'James','Lee','Chef',3700,'923900000007');
INSERT INTO STAFF VALUES (8,4,'Maya','Brown','Manager',5500,'923900000008');
INSERT INTO STAFF VALUES (9,5,'Saad','Malik','Receptionist',2300,'923900000009');
INSERT INTO STAFF VALUES (10,5,'Areeba','Shah','Cleaner',1700,'923900000010');

-- RESERVATION
INSERT INTO RESERVATION VALUES (1,1,2,TO_DATE('2026-05-01','YYYY-MM-DD'),TO_DATE('2026-05-05','YYYY-MM-DD'),'Confirmed',720);
INSERT INTO RESERVATION VALUES (2,2,4,TO_DATE('2026-05-03','YYYY-MM-DD'),TO_DATE('2026-05-07','YYYY-MM-DD'),'Confirmed',480);
INSERT INTO RESERVATION VALUES (3,3,8,TO_DATE('2026-05-06','YYYY-MM-DD'),TO_DATE('2026-05-10','YYYY-MM-DD'),'Pending',600);
INSERT INTO RESERVATION VALUES (4,4,11,TO_DATE('2026-05-08','YYYY-MM-DD'),TO_DATE('2026-05-12','YYYY-MM-DD'),'Confirmed',1000);
INSERT INTO RESERVATION VALUES (5,5,15,TO_DATE('2026-05-10','YYYY-MM-DD'),TO_DATE('2026-05-13','YYYY-MM-DD'),'Confirmed',960);
INSERT INTO RESERVATION VALUES (6,6,1,TO_DATE('2026-05-14','YYYY-MM-DD'),TO_DATE('2026-05-16','YYYY-MM-DD'),'Pending',200);
INSERT INTO RESERVATION VALUES (7,7,5,TO_DATE('2026-05-15','YYYY-MM-DD'),TO_DATE('2026-05-18','YYYY-MM-DD'),'Confirmed',600);
INSERT INTO RESERVATION VALUES (8,8,9,TO_DATE('2026-05-16','YYYY-MM-DD'),TO_DATE('2026-05-20','YYYY-MM-DD'),'Confirmed',880);
INSERT INTO RESERVATION VALUES (9,9,12,TO_DATE('2026-05-18','YYYY-MM-DD'),TO_DATE('2026-05-22','YYYY-MM-DD'),'Pending',760);
INSERT INTO RESERVATION VALUES (10,10,13,TO_DATE('2026-05-20','YYYY-MM-DD'),TO_DATE('2026-05-22','YYYY-MM-DD'),'Confirmed',220);
INSERT INTO RESERVATION VALUES (11,2,3,TO_DATE('2026-05-24','YYYY-MM-DD'),TO_DATE('2026-05-28','YYYY-MM-DD'),'Confirmed',1200);
INSERT INTO RESERVATION VALUES (12,5,10,TO_DATE('2026-05-26','YYYY-MM-DD'),TO_DATE('2026-05-30','YYYY-MM-DD'),'Pending',1600);

-- PAYMENT
INSERT INTO PAYMENT VALUES (1,1,720,'Credit Card',TO_DATE('2026-04-30','YYYY-MM-DD'),'Paid');
INSERT INTO PAYMENT VALUES (2,2,480,'Cash',TO_DATE('2026-05-02','YYYY-MM-DD'),'Paid');
INSERT INTO PAYMENT VALUES (3,3,600,'Online Transfer',TO_DATE('2026-05-05','YYYY-MM-DD'),'Pending');
INSERT INTO PAYMENT VALUES (4,4,1000,'Credit Card',TO_DATE('2026-05-07','YYYY-MM-DD'),'Paid');
INSERT INTO PAYMENT VALUES (5,5,960,'Cash',TO_DATE('2026-05-09','YYYY-MM-DD'),'Paid');
INSERT INTO PAYMENT VALUES (6,6,200,'Cash',TO_DATE('2026-05-13','YYYY-MM-DD'),'Pending');
INSERT INTO PAYMENT VALUES (7,7,600,'Credit Card',TO_DATE('2026-05-14','YYYY-MM-DD'),'Paid');
INSERT INTO PAYMENT VALUES (8,8,880,'Online Transfer',TO_DATE('2026-05-15','YYYY-MM-DD'),'Paid');
INSERT INTO PAYMENT VALUES (9,9,760,'Cash',TO_DATE('2026-05-17','YYYY-MM-DD'),'Pending');
INSERT INTO PAYMENT VALUES (10,10,220,'Credit Card',TO_DATE('2026-05-19','YYYY-MM-DD'),'Paid');
INSERT INTO PAYMENT VALUES (11,11,1200,'Cash',TO_DATE('2026-05-23','YYYY-MM-DD'),'Paid');
INSERT INTO PAYMENT VALUES (12,12,1600,'Online Transfer',TO_DATE('2026-05-25','YYYY-MM-DD'),'Pending');

-- RES_SERVICE
INSERT INTO RES_SERVICE VALUES (1,1,1,2,40);
INSERT INTO RES_SERVICE VALUES (2,1,2,1,35);
INSERT INTO RES_SERVICE VALUES (3,2,5,4,60);
INSERT INTO RES_SERVICE VALUES (4,3,3,1,50);
INSERT INTO RES_SERVICE VALUES (5,4,4,2,160);
INSERT INTO RES_SERVICE VALUES (6,5,2,3,105);
INSERT INTO RES_SERVICE VALUES (7,6,6,2,50);
INSERT INTO RES_SERVICE VALUES (8,7,1,1,20);
INSERT INTO RES_SERVICE VALUES (9,8,7,1,100);
INSERT INTO RES_SERVICE VALUES (10,9,5,2,30);
INSERT INTO RES_SERVICE VALUES (11,10,2,1,35);
INSERT INTO RES_SERVICE VALUES (12,11,8,1,200);
INSERT INTO RES_SERVICE VALUES (13,11,4,1,80);
INSERT INTO RES_SERVICE VALUES (14,12,3,1,50);
INSERT INTO RES_SERVICE VALUES (15,12,6,2,50);

COMMIT;


--tables

SELECT * FROM HOTEL;
SELECT * FROM HOTEL_PHONE;
SELECT * FROM GUEST;
SELECT * FROM GUEST_PHONE;
SELECT * FROM SERVICE;
SELECT * FROM ROOM;
SELECT * FROM STAFF;
SELECT * FROM RESERVATION;
SELECT * FROM PAYMENT;
SELECT * FROM RES_SERVICE;


----subqueries

SELECT room_id, room_number, price_per_night
FROM ROOM
WHERE price_per_night > (
    SELECT AVG(price_per_night)
    FROM ROOM
);

SELECT first_name, last_name
FROM GUEST
WHERE guest_id IN (
    SELECT guest_id
    FROM RESERVATION
    GROUP BY guest_id
    HAVING COUNT(reservation_id) > 1
);

SELECT first_name, last_name
FROM GUEST
WHERE guest_id NOT IN (
    SELECT guest_id
    FROM RESERVATION
);

SELECT first_name, last_name
FROM GUEST
WHERE guest_id IN (
    SELECT guest_id
    FROM RESERVATION
    WHERE total_amount > (
        SELECT AVG(total_amount)
        FROM RESERVATION
    )
);


----joins

SELECT g.first_name, g.last_name, r.reservation_id, r.check_in_date, r.check_out_date, r.total_amount
FROM GUEST g
JOIN RESERVATION r
ON g.guest_id = r.guest_id;

SELECT g.first_name, g.last_name, ro.room_number, h.hotel_name, h.country
FROM RESERVATION r
JOIN GUEST g ON r.guest_id = g.guest_id
JOIN ROOM ro ON r.room_id = ro.room_id
JOIN HOTEL h ON ro.hotel_id = h.hotel_id;

SELECT r.reservation_id, s.service_name, rs.quantity, rs.subtotal
FROM RES_SERVICE rs
JOIN RESERVATION r ON rs.reservation_id = r.reservation_id
JOIN SERVICE s ON rs.service_id = s.service_id;

SELECT g.first_name, g.last_name, r.reservation_id, r.total_amount
FROM GUEST g
LEFT JOIN RESERVATION r
ON g.guest_id = r.guest_id;

SELECT r.reservation_id, r.total_amount AS reservation_amount, p.amount AS paid_amount, p.method, p.payment_date, p.payment_status
FROM RESERVATION r
JOIN PAYMENT p
ON r.reservation_id = p.reservation_id;


----views

CREATE VIEW reservation_details_view  AS
SELECT g.first_name, g.last_name, h.hotel_name, ro.room_number, r.reservation_id, r.check_in_date, r.check_out_date, r.total_amount
FROM RESERVATION r
JOIN GUEST g ON r.guest_id = g.guest_id
JOIN ROOM ro ON r.room_id = ro.room_id
JOIN HOTEL h ON ro.hotel_id = h.hotel_id;

SELECT * FROM reservation_details_view;

CREATE VIEW service_usage_view AS
SELECT r.reservation_id, s.service_name, rs.quantity, rs.subtotal
FROM RES_SERVICE rs
JOIN RESERVATION r ON rs.reservation_id = r.reservation_id
JOIN SERVICE s ON rs.service_id = s.service_id;

SELECT * FROM service_usage_view;


----procedures

-- Add Guest
CREATE OR REPLACE PROCEDURE add_guest(
    p_guest_id NUMBER,
    p_first_name VARCHAR2,
    p_last_name VARCHAR2,
    p_email VARCHAR2,
    p_street VARCHAR2,
    p_city VARCHAR2,
    p_country VARCHAR2
)
AS
BEGIN
    INSERT INTO GUEST
    VALUES (p_guest_id, p_first_name, p_last_name, p_email, p_street, p_city, p_country);
END;
/

BEGIN
    add_guest(12, 'Hassan', 'Ali', 'hassan@example.com', 'DHA', 'Karachi', 'Pakistan');
END;
/

SELECT * FROM GUEST;

-- Update Room Status
CREATE OR REPLACE PROCEDURE update_room_status(p_hotel_id NUMBER, p_room_number NUMBER, p_status VARCHAR2
)
AS
BEGIN
    UPDATE ROOM
    SET status = p_status
    WHERE hotel_id = p_hotel_id
      AND room_number = p_room_number;
END;
/

BEGIN
    update_room_status(1, 101, 'Occupied');
END;
/

-- Delete Reservation
CREATE OR REPLACE PROCEDURE delete_reservation( p_reservation_id NUMBER)
AS
BEGIN
    DELETE FROM RESERVATION
    WHERE reservation_id = p_reservation_id;
END;
/

BEGIN
    delete_reservation(3);
END;
/

SELECT * FROM RESERVATION;

----trigger

--update room status when reservation made
CREATE OR REPLACE TRIGGER trg_room_occupied
AFTER INSERT ON RESERVATION
FOR EACH ROW
BEGIN
    UPDATE ROOM
    SET status = 'Occupied'
    WHERE room_id = :NEW.room_id;
END;
/
--test trigger
INSERT INTO RESERVATION 
VALUES (13, 1, 1, TO_DATE('2026-06-01','YYYY-MM-DD'), TO_DATE('2026-06-05','YYYY-MM-DD'), 'Confirmed', 400);

SELECT room_id, status FROM ROOM WHERE room_id = 1;


--update room status when reservation made
CREATE OR REPLACE TRIGGER trg_room_available
AFTER DELETE ON RESERVATION
FOR EACH ROW
BEGIN
    UPDATE ROOM
    SET status = 'Available'
    WHERE room_id = :OLD.room_id;
END;
/

--test trigger
SELECT room_id, status FROM ROOM WHERE room_id = 1;
BEGIN
    delete_reservation(13);
END;
/
SELECT room_id, status FROM ROOM WHERE room_id = 1;

