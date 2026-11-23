CREATE DATABASE CabBookingSystem;
USE CabBookingSystem;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(255)
);

INSERT INTO Customers (name, email, phone, address) VALUES
('Amit Sharma','amit@gmail.com','9876543210','Pune'),
('Neha Verma','neha@gmail.com','9876543211','Mumbai'),
('Rahul Singh','rahul@gmail.com','9876543212','Delhi'),
('Priya Mehta','priya@gmail.com','9876543213','Pune'),
('Rohit Kumar','rohit@gmail.com','9876543214','Nagpur'),
('Sneha Patil','sneha@gmail.com','9876543215','Pune'),
('Vikas Gupta','vikas@gmail.com','9876543216','Delhi'),
('Anjali Desai','anjali@gmail.com','9876543217','Mumbai'),
('Suresh Reddy','suresh@gmail.com','9876543218','Hyderabad'),
('Pooja Shah','pooja@gmail.com','9876543219','Ahmedabad');

select* from Customers;




 
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    phone VARCHAR(15),
    license_number VARCHAR(50),
    experience_years INT
);

INSERT INTO Drivers (name, phone, license_number, experience_years) VALUES
('Ramesh','9000000001','LIC001',5),
('Sanjay','9000000002','LIC002',7),
('Mahesh','9000000003','LIC003',3),
('Dinesh','9000000004','LIC004',10),
('Kiran','9000000005','LIC005',4),
('Arun','9000000006','LIC006',6),
('Vijay','9000000007','LIC007',8),
('Rajesh','9000000008','LIC008',2),
('Manoj','9000000009','LIC009',9),
('Ajay','9000000010','LIC010',5);

select * from Drivers;


CREATE TABLE Cabs (
    cab_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT,
    cab_number VARCHAR(20),
    model VARCHAR(50),
    type VARCHAR(20),
    status VARCHAR(20),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);

INSERT INTO Cabs (driver_id, cab_number, model, type, status) VALUES
(1,'MH12AB1234','Swift','Mini','Available'),
(2,'MH12AB1235','Dzire','Sedan','Booked'),
(3,'MH12AB1236','Ertiga','SUV','Available'),
(4,'MH12AB1237','Innova','SUV','Booked'),
(5,'MH12AB1238','WagonR','Mini','Available'),
(6,'MH12AB1239','Aura','Sedan','Available'),
(7,'MH12AB1240','XUV500','SUV','Booked'),
(8,'MH12AB1241','Alto','Mini','Available'),
(9,'MH12AB1242','Verna','Sedan','Booked'),
(10,'MH12AB1243','Fortuner','SUV','Available');




CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    cab_id INT,
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (cab_id) REFERENCES Cabs(cab_id)
);

INSERT INTO Bookings (customer_id, cab_id, pickup_location, drop_location, status) VALUES
(1,1,'Pune','Mumbai','Completed'),
(2,2,'Mumbai','Pune','Completed'),
(3,3,'Delhi','Noida','Pending'),
(4,4,'Pune','Nashik','Completed'),
(5,5,'Nagpur','Wardha','Cancelled'),
(6,6,'Pune','Satara','Completed'),
(7,7,'Delhi','Gurgaon','Pending'),
(8,8,'Mumbai','Thane','Completed'),
(9,9,'Hyderabad','Secunderabad','Completed'),
(10,10,'Ahmedabad','Surat','Pending');




CREATE TABLE TripDetails (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    distance_km DECIMAL(5,2),
    fare DECIMAL(8,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

INSERT INTO TripDetails (booking_id, distance_km, fare, payment_status) VALUES
(1,150,2000,'Paid'),
(2,150,2100,'Paid'),
(3,20,300,'Unpaid'),
(4,200,2500,'Paid'),
(5,50,800,'Refunded'),
(6,120,1800,'Paid'),
(7,30,500,'Unpaid'),
(8,25,400,'Paid'),
(9,15,250,'Paid'),
(10,300,3500,'Unpaid');

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    trip_id INT,
    customer_id INT,
    rating INT,
    comments VARCHAR(255),
    FOREIGN KEY (trip_id) REFERENCES TripDetails(trip_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Feedback (trip_id, customer_id, rating, comments) VALUES
(1,1,5,'Excellent service'),
(2,2,4,'Good ride'),
(3,3,3,'Average'),
(4,4,5,'Very comfortable'),
(5,5,2,'Driver was late'),
(6,6,4,'Nice trip'),
(7,7,3,'Okay service'),
(8,8,5,'Great experience'),
(9,9,4,'Smooth ride'),
(10,10,3,'Satisfactory');

select*from feedback;

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    trip_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_status varchar(20),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES TripDetails(trip_id)
);
INSERT INTO Payments (trip_id, amount, payment_method, payment_status, payment_date) VALUES
(1,2500,'UPI','Paid',NOW()),
(2,2400,'Card','Paid',NOW()),
(3,400,'Cash','Paid',NOW()),
(4,3000,'UPI','Pending',NOW()),
(5,7000,'Card','Paid',NOW()),
(6,2800,'UPI','Paid',NOW()),
(7,3500,'Cash','Pending',NOW()),
(8,3200,'Card','Paid',NOW()),
(9,5000,'UPI','Paid',NOW()),
(10,300,'Cash','Pending',NOW());
 

use CabBookingSystem; 
show tables;
select* from payments;
  
  -- Q1.CUSTOMERS WHO HAVE COMPLETED THE MOST BOOKINGS 

SELECT 
    c.customer_id,
    c.name,
    COUNT(*) AS total_completed
FROM Customers c
JOIN Bookings b 
    ON c.customer_id = b.customer_id
WHERE b.status = 'Completed'
GROUP BY c.customer_id, c.name
ORDER BY total_completed DESC;

-- Q2.Customers Cancelling >30% Bookings

SELECT 
    c.customer_id,
    c.name,
    COUNT(CASE WHEN b.status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*) AS cancel_percentage
FROM Customers c
JOIN Bookings b 
    ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.name
HAVING cancel_percentage > 30;

-- Q3. Busiest Day of the Week

SELECT 
    DAYNAME(booking_date) AS day,
    COUNT(*) AS total_bookings
FROM Bookings
GROUP BY day
ORDER BY total_bookings DESC;

-- DRIVER PERFORMANCE & EFFICIENCY

-- Drivers with Avg Rating < 3 (Last 3 Months)

SELECT d.name, AVG(f.rating) AS avg_rating
FROM Drivers d
JOIN Cabs c ON d.driver_id = c.driver_id
JOIN Bookings b ON c.cab_id = b.cab_id
JOIN TripDetails t ON b.booking_id = t.booking_id
JOIN Feedback f ON t.trip_id = f.trip_id
WHERE f.feedback_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY d.driver_id
HAVING avg_rating < 3;

-- Top 5 Drivers with Longest Trips

SELECT d.name, SUM(t.distance_km) AS total_distance
FROM Drivers d
JOIN Cabs c ON d.driver_id = c.driver_id
JOIN Bookings b ON c.cab_id = b.cab_id
JOIN TripDetails t ON b.booking_id = t.booking_id
GROUP BY d.driver_id
ORDER BY total_distance DESC
LIMIT 5;

-- Drivers with High Cancellation %

SELECT d.name,
COUNT(CASE WHEN b.status='Cancelled' THEN 1 END)*100.0/COUNT(*) AS cancel_rate
FROM Drivers d
JOIN Cabs c ON d.driver_id = c.driver_id
JOIN Bookings b ON c.cab_id = b.cab_id
GROUP BY d.driver_id
HAVING cancel_rate > 30;

-- Total Revenue (Last 6 Months)
SELECT SUM(p.amount) AS total_revenue
FROM Payments p
WHERE p.payment_status = 'Paid'
AND p.payment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 💡 Trend Insight:
SELECT SUM(p.amount) AS total_revenue
FROM Payments p
WHERE p.payment_status = 'Paid'
AND p.payment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

SELECT MONTH(payment_date) AS month, SUM(amount) AS revenue
FROM Payments
WHERE payment_status='Paid'
GROUP BY month;

-- Top 3 Frequent Routes

SELECT pickup_location, drop_location, COUNT(*) AS total_trips
FROM Bookings
GROUP BY pickup_location, drop_location
ORDER BY total_trips DESC
LIMIT 3;

-- Correlation: Rating vs Earnings

SELECT d.name,
AVG(f.rating) AS avg_rating,
SUM(t.fare) AS total_earnings,
COUNT(t.trip_id) AS trips
FROM Drivers d
JOIN Cabs c ON d.driver_id = c.driver_id
JOIN Bookings b ON c.cab_id = b.cab_id
JOIN TripDetails t ON b.booking_id = t.booking_id
JOIN Feedback f ON t.trip_id = f.trip_id
GROUP BY d.driver_id;

-- Average Waiting Time

SELECT
 pickup_location,
AVG(TIMESTAMPDIFF(MINUTE, b.booking_date, t.start_time)) avg_wait
FROM Bookings b
JOIN TripDetails t ON b.booking_id=t.booking_id
GROUP BY pickup_location;

-- Cancellation Reasons

SELECT comment, COUNT(*) total
FROM Feedback
GROUP BY comment
ORDER BY total DESC;

-- Short Trips Revenue Contribution
SELECT 
SUM(CASE WHEN distance_km < 5 THEN fare ELSE 0 END) short_revenue,
SUM(fare) total_revenue
FROM TripDetails;

-- Sedan vs SUV Revenue

SELECT c.type, SUM(t.fare) revenue
FROM Cabs c
JOIN Bookings b ON c.cab_id=b.cab_id
JOIN TripDetails t ON b.booking_id=t.booking_id
GROUP BY c.type;

-- Churn Prediction

SELECT c.name, MAX(b.booking_date) last_booking,
COUNT(*) total_rides
FROM Customers c
JOIN Bookings b ON c.customer_id=b.customer_id
GROUP BY c.name
HAVING last_booking < DATE_SUB(CURDATE(), INTERVAL 2 MONTH);

-- Weekend vs Weekday

SELECT 
CASE WHEN DAYOFWEEK(booking_date) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END type,
COUNT(*) total
FROM Bookings
GROUP BY type;



    


