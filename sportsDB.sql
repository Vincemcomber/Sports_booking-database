#####   SPORTS BOOKING PROJECT   #####


#### ABOUT THE PROJECT ####
# This project requires us to build a simple database to help us manage the booking process of a sports complex. The sports complex has the following facilities: 2 tennis courts, 2 badminton courts, 2 multi-purpose fields and 1 archery range. Each facility can be booked for a duration of one hour.
# Only registered users are allowed to make a booking. After booking, the complex allows users to cancel their bookings latest by the day prior to the booked date. Cancellation is free. However, if this is the third (or more) consecutive cancellations, the complex imposes a $10 fine.

# The database that we build should have the following elements:
# (i) TABLES : members, pending_terminations, rooms and bookings.
# (ii) VIEW : member_bookings.
# (iii) STORED PROCEDURES : insert_new_member, delete_member, update_member_password, update_member_email, make_booking, update_payment, view_bookings, search_room and cancel_booking.
# (iv) TRIGGER : payment_check.
# (v) STORED FUNCTION : check_cancellation.


###  CREATING A DATABASE  ###
# We are going to create a database called sports_booking.
CREATE DATABASE sports_booking;

USE sports_booking;


###  ADDING TABLES  ###
# We need to add four tables: members, pending_terminations, rooms and bookings.

## A: Members
# The members table has five columns:
# (i) id: This column stores the id of each member. The id is alphanumeric (VARCHAR(255) will be a good choice) and uniquely identifies each member (in other words, it is a primary key).
# (ii) password: This column stores the password of each member. It is alphanumeric and cannot be null.
# (iii) email: This column stores the email of each member. It is also alphanumeric and cannot be null.
# (iv) member_since: This column stores the timestamp (consisting of the date and time) that a particular member is added to the table. It cannot be null and uses the NOW() function to get the current date and time as the DEFAULT value.
# (v) payment_due: This column stores the amount of balance that a member has to pay. The amount is in dollars and cents (e.g. 12.50). The column cannot be null and has a default value of 0.

CREATE TABLE members (
id VARCHAR(255) PRIMARY KEY,
password VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL,
member_since TIMESTAMP NOT NULL DEFAULT NOW(),
payment_due DECIMAL(6, 2) NOT NULL DEFAULT 0
);


## B: Pending_terminations
# Records from the members table will be transferred here under certain circumstances.
# The pending_terminations table has four columns: id, email, request_date and payment_due.
# The data types and constraints of the id, password and payment_due columns match that of the same columns in the members table.
# The remaining column, request_date, stores the timestamp that a particular member is added to the table. It cannot be null and uses the NOW() function to get the current date and time as the DEFAULT value.

CREATE TABLE pending_terminations (
id VARCHAR(255) PRIMARY KEY,
email VARCHAR(255) NOT NULL,
request_date TIMESTAMP DEFAULT NOW() NOT NULL,
payment_due DECIMAL(6, 2) NOT NULL DEFAULT 0
);


## C: Room
# This table has three columns:
# (i) id: This column stores the id of each room. It is alphanumeric and uniquely identifies each room.
# (ii) room_type: This column stores a short description of each room. It is also alphanumeric and cannot be null.
# (iii) price: This column stores the price of each room. Prices are stored up to 2 decimal places. It cannot be null.

CREATE TABLE rooms (
id VARCHAR(255) PRIMARY KEY,
room_type VARCHAR(255) NOT NULL,
price DECIMAL(6, 2) NOT NULL
);


## D: Bookings
# The bookings table has 7 columns:
# (i) id: This column stores the id of each booking. It is numeric, auto incremented and uniquely identifies each booking.
# (ii) room_id: This column has the same data type as the id column in the rooms table and cannot be null.
# (iii) booked_date: This column stores a date in the YYYY-MM-DD format (e.g. '2017-10-18') and cannot be null.
# (iv) booked_time: This column stores time in the HH:MM:SS format and cannot be null.
# (v) member_id: This column has the same data type as the id column in the members table and cannot be null.
# (vi) datetime_of_booking: This column stores the timestamp that a particular booking is added to the table. It cannot be null and uses the NOW() function to get the current date and time as the DEFAULT value.
# (vii) payment_status:  This column stores the status of the booking. It is alphanumeric, cannot be null and has a default value of 'Unpaid'.

CREATE TABLE bookings (
id INT AUTO_INCREMENT PRIMARY KEY,
room_id VARCHAR(255) NOT NULL,
booked_date DATE NOT NULL,
booked_time TIME NOT NULL,
member_id VARCHAR(255) NOT NULL,
datetime_of_booking TIMESTAMP DEFAULT NOW() NOT NULL,
payment_status VARCHAR(255) NOT NULL DEFAULT 'Unpaid',
CONSTRAINT uc1 UNIQUE (room_id, booked_date, booked_time)
);

# Besides the 7 columns stated above, the bookings table also has a UNIQUE constraint called uc1. This constraint states that the room_id, booked_date and booked_time columns must be unique. In other words, if one row has the values: room_id = 'AR', booked_date = '2017-10-18', booked_time = '11:00:00' no other rows can have the same combination of values for these three columns.


###  ALTERING TABLES  ###
## Next, we need to alter our table to add two foreign keys:
# (i) The first foreign key is called fk1 and links the member_id column with the id column in the members table. In addition, if the record in the parent table is updated or deleted, the record in the child table will also be updated or deleted accordingly.
# (ii) The second foreign key is called fk2 and links the room_id column with the id column in the rooms table. If the record in the parent table is updated or deleted, the record in the child table will also be updated or deleted accordingly.

ALTER TABLE bookings ADD CONSTRAINT fk1 FOREIGN KEY (member_id) REFERENCES members (id) ON DELETE CASCADE ON UPDATE CASCADE, ADD CONSTRAINT fk2 FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE ON UPDATE CASCADE;


###  INSERTING DATA  ###
## A: members
# For the members table, we have the following set of data:
INSERT INTO members (id, password, email, member_since,
payment_due) VALUES
('afeil', 'feil1988<3', 'Abdul.Feil@hotmail.com', '2017-04-15
12:10:13', 0),
('amely_18', 'loseweightin18', 'Amely.Bauch91@yahoo.com', '2018-
02-06 16:48:43', 0),
('bbahringer', 'iambeau17', 'Beaulah_Bahringer@yahoo.com', '2017-
12-28 05:36:50', 0),
('little31', 'whocares31', 'Anthony_Little31@gmail.com', '2017-
06-01 21:12:11', 10),
('macejkovic73', 'jadajeda12', 'Jada.Macejkovic73@gmail.com',
'2017-05-30 17:30:22', 0),
('marvin1', 'if0909mar', 'Marvin_Schulist@gmail.com', '2017-09-09
02:30:49', 10),
('nitzsche77', 'bret77@#', 'Bret_Nitzsche77@gmail.com', '2018-01-
09 17:36:49', 0),
('noah51', '18Oct1976#51', 'Noah51@gmail.com', '2017-12-16
22:59:46', 0),
('oreillys', 'reallycool#1', 'Martine_OReilly@yahoo.com', '2017-
10-12 05:39:20', 0),
('wyattgreat', 'wyatt111', 'Wyatt_Wisozk2@gmail.com', '2017-07-18
16:28:35', 0);

# Although member_since and payment_due both have default values, we’ll overwrite them here so that we have some variety in our data to play with later. In addition, note that we enclosed the member_since value in quotation marks. In general, we need to do that for TIMESTAMP, DATETIME, DATE and TIME values.

## I can move on to can move on to the rooms and bookings tables:
# (i) Rooms table:
INSERT INTO rooms (id, room_type, price) VALUES
('AR', 'Archery Range', 120),
('B1', 'Badminton Court', 8),
('B2', 'Badminton Court', 8),
('MPF1', 'Multi Purpose Field', 50),
('MPF2', 'Multi Purpose Field', 60),
('T1', 'Tennis Court', 10),
('T2', 'Tennis Court', 10);

#(ii) Bookings table: 
INSERT INTO bookings (id, room_id, booked_date, booked_time,
member_id, datetime_of_booking, payment_status) VALUES
(1, 'AR', '2017-12-26', '13:00:00', 'oreillys', '2017-12-20
20:31:27', 'Paid'),
(2, 'MPF1', '2017-12-30', '17:00:00', 'noah51', '2017-12-22
05:22:10', 'Paid'),
(3, 'T2', '2017-12-31', '16:00:00', 'macejkovic73', '2017-12-28
18:14:23', 'Paid'),
(4, 'T1', '2018-03-05', '08:00:00', 'little31', '2018-02-22
20:19:17', 'Unpaid'),
(5, 'MPF2', '2018-03-02', '11:00:00', 'marvin1', '2018-03-01
16:13:45', 'Paid'),
(6, 'B1', '2018-03-28', '16:00:00', 'marvin1', '2018-03-23
22:46:36', 'Paid'),
(7, 'B1', '2018-04-15', '14:00:00', 'macejkovic73', '2018-04-12
22:23:20', 'Cancelled'),
(8, 'T2', '2018-04-23', '13:00:00', 'macejkovic73', '2018-04-19
10:49:00', 'Cancelled'),
(9, 'T1', '2018-05-25', '10:00:00', 'marvin1', '2018-05-21
11:20:46', 'Unpaid'),
(10, 'B2', '2018-06-12', '15:00:00', 'bbahringer', '2018-05-30
14:40:23', 'Paid');



#### VIEW ####
# Now that we have created the tables and inserted some data, we are ready to select data from our tables. Specifically, we’ll create a view that shows us all the booking details of a booking.
# If you refer to the bookings table created previously, you can see that it lists the id, room_id, booked_date, booked_time, member_id, datetime_of_booking and payment_status of each booking.

# In order to obtain these information, we have to refer to the rooms table.
# To simplify this process, we are now going to write a SELECT statement to combine the two tables into a single view. This view displays the id (from the bookings table), room_id, room_type, booked_date, booked_time, member_id, datetime_of_booking, price and payment_status of each booking.
# The room_type and price columns are from the rooms table while the remaining columns are from the bookings table.
# In order to combine these two tables, we need a SELECT statement that joins the rooms and bookings tables. In addition, we also want to sort the results by the id column of the bookings table.

# Hint: You need to join the two tables using bookings.room_id = rooms.id.

CREATE VIEW member_bookings AS
SELECT bookings.id, room_id, room_type, booked_date, booked_time,
member_id, datetime_of_booking, price, payment_status
FROM
bookings JOIN rooms
ON
bookings.room_id = rooms.id
ORDER BY
bookings.id;



#### STORED PROCEDURES ####
# In this exercise, we will create a total of nine stored procedures. Before we start coding them, let’s first change the delimiter by adding the line: DELIMITER $$ to our sportsDB.sql file.

## A: insert_new_member
# The first stored procedure is for inserting a new member into the members table.
# If you study the structure of the members table, you can see that it has a total of 5 columns: id, password, email, member_since and payment_due.
# As the last two columns have default values, we only need to provide values for the first three columns when inserting a new member.
# To do that, let’s create a stored procedure called insert_new_member that has three IN parameters, p_id, p_password and p_email. The data types for these parameters should match the data types that you selected for the id, password and email columns of the members table. Try declaring this stored procedure yourself. You can refer to Chapter 10 for reference.
# Next, let’s add the BEGIN and END $$ markers to our stored procedure to define the start and end of this procedure.
# Between the BEGIN and END $$ markers, we need to add an INSERT statement to insert the values of p_id, p_password and p_email to our table. These values will be inserted into the id, password and email columns of the members table respectively.

DELIMITER 
CREATE PROCEDURE insert_new_member (IN p_id VARCHAR(255), IN
p_password VARCHAR(255), IN p_email VARCHAR(255))
BEGIN
INSERT INTO members (id, password, email) VALUES (p_id,
p_password, p_email);
END 


## B:delete_member
# Next, let’s move on to the delete_member procedure. As the name suggests, this procedure is for deleting a member from the members table.
# This stored procedure only has one IN parameter, p_id. Its data type matches that of the id column in the members table.
# Within the procedure, we have a DELETE statement that deletes the member whose id equals p_id. 

DELIMITER 
CREATE PROCEDURE delete_member (IN p_id VARCHAR(255))
BEGIN
DELETE FROM members WHERE id = p_id;
END 


## C and D: update_member_password and update_member_email
# Next, we’ll code two stored procedures to help us update data in the members table.
# The first stored procedure is called update_member_password and has two IN parameters, p_id and p_password.
# The second procedure is called update_member_email and has two IN parameters, p_id and p_email.
# The data types of all parameters match the data types of the corresponding columns in the members table.
# Both procedures use the UPDATE statement to update the password and email of a member with id = p_id.
# Once you are done, we can move on to the make_booking procedure.

# C: update_member_password 
DELIMITER 
CREATE PROCEDURE update_member_password (IN p_id VARCHAR(255), IN
p_password VARCHAR(255))
BEGIN
UPDATE members SET password = p_password WHERE id = p_id;
END 

# D: update_member_email
DELIMITER 
CREATE PROCEDURE update_member_email (IN p_id VARCHAR(255), IN
p_email VARCHAR(255))
BEGIN
UPDATE members SET email = p_email WHERE id = p_id;
END 

## E: make_booking
# The make_booking procedure is for making a new booking. We need to insert the booking into the bookings table and update the members table to reflect the charges that the member making the booking needs to pay.
# The procedure has four IN parameters, p_room_id, p_booked_date, p_booked_time and p_member_id.
# The data types of the parameters match the data types of the room_id, booked_date, booked_time and member_id columns of the bookings table.
# Within the procedure, we first declare two local variables v_price and v_payment_due. The data type of v_price matches the data type of the price column in the rooms table while that of v_payment_due matches the data type of the payment_due column in the members table.

# After declaring the variables, we have the following SELECT statement:
SELECT price INTO v_price FROM rooms WHERE id = p_room_id;

# This statement selects the price of the room with id = p_room_id. This price is then stored into the local variable v_price using the INTO keyword.
# Next, we need an INSERT statement to insert the values of p_room_id, p_booked_date, p_booked_time and p_member_id into the room_id, booked_date, booked_time and member_id columns of the bookings table respectively.

# After updating the bookings table, we need to update the payment_due column of the members table.
# To do that, we need to first get the payment_due value for the member making the booking. We get that from the members table (WHERE id = p_member_id) and store the information into the v_payment_due variable.
# Next, we update the members table and set the payment_due column to v_payment_due + v_price for this particular member (WHERE id = p_member_id).
# Once that is done, the make_booking procedure is complete.

DELIMITER 
CREATE PROCEDURE make_booking (IN p_room_id VARCHAR(255), IN
p_booked_date DATE, IN p_booked_time TIME, IN p_member_id
VARCHAR(255))
BEGIN
DECLARE v_price DECIMAL(6, 2);
DECLARE v_payment_due DECIMAL(6, 2);
SELECT price INTO v_price FROM rooms WHERE id =
p_room_id;
INSERT INTO bookings (room_id, booked_date, booked_time,
member_id) VALUES (p_room_id, p_booked_date, p_booked_time,
p_member_id);
SELECT payment_due INTO v_payment_due FROM members WHERE id
= p_member_id;
UPDATE members SET payment_due = v_payment_due + v_price
WHERE id = p_member_id;
END 


## F: update_payment
# Now, let’s move on to the update_payment procedure.
# This procedure is for updating the bookings and members tables after a member makes payment for his/her booking.
# By default, the payment_status column in the bookings table is 'Unpaid'.
# Once the member makes payment, this status will be updated to 'Paid'.
# After updating the bookings table, the members table will also be updated to reflect the new amount of money (if any) the member has to pay.
# The update_payment procedure has one IN parameter called p_id, whose data type matches the id column of the bookings table.
# Within the procedure, we need to first declare three local variables, v_member_id, v_payment_due and v_price.
# The data types of v_member_id and v_payment_due match the data types of the id and payment_due columns in the members table while the data type of v_price matches the data type of the price column in the rooms table.

# Next, we need to use an UPDATE statement to update the bookings table.
# Specifically, we need to change the payment_status of the specified booking (whose id corresponds to the input parameter p_id) to 'Paid'.

# After updating the bookings table, we need to update the payment_due column of the members table for the member who made the booking.
# To do that, we need to first select the member_id and price columns from the member_bookings view for this particular booking (WHERE id = p_id) and store the information into the v_member_id and v_price variables respectively.
# In addition, we need to select the payment_due column from the members table for the member who made the booking and store the information into the v_payment_due variable. Note that the local variable v_member_id stores the id of the member who made the booking.
# After gathering the information that we need, we are now ready to update the members table. We’ll use the UPDATE statement to set the payment_due column to v_payment_due - v_price for the member who made the booking (WHERE id = v_member_id).

DELIMITER 
CREATE PROCEDURE update_payment (IN p_id INT)
BEGIN
DECLARE v_member_id VARCHAR(255);
DECLARE v_payment_due DECIMAL(6, 2);
DECLARE v_price DECIMAL(6, 2);
UPDATE bookings SET payment_status = 'Paid' WHERE id =
p_id;
SELECT member_id, price INTO v_member_id, v_price FROM
member_bookings WHERE id = p_id;
SELECT payment_due INTO v_payment_due FROM members WHERE id
= v_member_id;
UPDATE members SET payment_due = v_payment_due - v_price
WHERE id = v_member_id;
END 


## G: view_bookings
# Next, let’s move on to the view_bookings procedure.
# This procedure allows us to view all the bookings made by a particular member and has one IN parameter called p_id that identifies the member. Decide on the appropriate data type for this parameter and declare the procedure yourself.
# Within the procedure, we have a simple SELECT statement that selects everything from the member_bookings view for that particular member.

DELIMITER 
CREATE PROCEDURE view_bookings (IN p_id VARCHAR(255))
BEGIN
SELECT * FROM member_bookings WHERE id = p_id;
END 


## H: search_room
# Now, let's move on to the seach_room procedure. This procedure allows us to search for available rooms.
# It has three IN parameters, p_room_type, p_booked_date and p_booked_time. Choose an appropriate data type for each parameter based on the room_type column in the rooms table (for p_room_type) and the booked_date and booked_time columns in bookings table (for p_booked_date and p_booked_time respectively).
# Within the procedure, we have a single SELECT statement to check if a certain room is available for booking on a specific date and time. Let’s work on this SELECT statement now.

# Now, let’s do some filtering. Suppose we are only interested in bookings where: 
booked_date = '2017-12-26' AND booked_time = '13:00:00' AND
payment_status != 'Cancelled'

# Finally, modify the statement such that only the room_id column is displayed.
# If you execute the statement, you should just get AR as the result. 
# Got it? Now we have the ids of all the rooms that have been booked on 2017- 12-26 at 1pm and have not been cancelled.
# Suppose we want to book a tennis court on 2017-12-26 at 1pm, all we need to do is select rooms from the rooms table whose ids are not in the results above AND are of the room type that we want (i.e. room_type = 'Tennis Court').

# Once you get the correct result, you are ready to get back to the search_room stored procedure.
# For this stored procedure, you simply need to paste the previous SELECT statement into the procedure (between the BEGIN and END $$ markers) and change
'Tennis Court' to p_room_type,
'2017-12-26' to p_booked_date, and
'13:00:00' to p_booked_time.

# Once you are done, we can move on to the most complicated procedure.

DELIMITER 
CREATE PROCEDURE search_room (IN p_room_type VARCHAR(255), IN
p_booked_date DATE, IN p_booked_time TIME)
BEGIN
SELECT * FROM rooms WHERE id NOT IN (SELECT room_id FROM
bookings WHERE booked_date = p_booked_date AND booked_time =
p_booked_time AND payment_status != 'Cancelled') AND room_type =
p_room_type;
END 


## I: cancel_booking
# This last procedure is for making a booking cancellation. This procedure requires the use of an IF statement.
# First, let’s name the procedure cancel_booking. This procedure has an IN parameter called p_booking_id (whose data type corresponds to the data type of the id column in the bookings table) and an OUT parameter called p_message (that is of VARCHAR(255) type).
# Within the procedure, we need to declare 6 local variables - v_cancellation, v_member_id, v_payment_status, v_booked_date, v_price and v_payment_due.
# The data type of v_cancellation is INT while those of v_member_id, v_payment_status and v_booked_date match the data types of the member_id, payment_status and booked_date columns in the bookings table respectively.
# In addition, the data type of v_price matches the data type of the price column in the rooms table and the data type of v_payment_due matches the data type of the payment_due column in the members table.

# Next, let’s set the value of v_cancellation to 0 using the SET keyword.

# Now, we need to select the member_id, booked_date, price and payment_status columns from the member_bookings view where id = p_booking_id and store them into the v_member_id, v_booked_date, v_price and v_payment_status variables respectively.
# In addition, we need to select the payment_due column from the members table for the member making the cancellation (WHERE id = v_member_id) and store the result into the v_payment_due variable.

# Once you are done, we are ready to work on the IF statement.
# The sports complex allows members to cancel their bookings latest by the day prior to the booked date.
# For instance, if the booked date is 17th Sep 2018 and the current date is 16th Sep 2018, members will be allowed to cancel their booking. However, if the current date is 17th Sep 2018 or later, members will not be allowed to cancel the booking.
# In addition, members are not allowed to cancel bookings that have already been cancelled or paid for.

# To enforce these rules, we’ll use the following IF statement:
IF curdate() >= v_booked_date THEN
SELECT 'Cancellation cannot be done on/after the booked
date' INTO p_message;
ELSEIF v_payment_status = 'Cancelled' OR v_payment_status =
'Paid' THEN
SELECT 'Booking has already been cancelled or paid'
INTO p_message;
ELSE
-- Code to handle cancellation
END IF;

## Let’s analyze this IF statement.
# In the IF clause, we first use the built-in CURDATE() function to get the current date.
# If the current date is greater than or equal to the booked date, we use a SELECT statement to store the message: 'Cancellation cannot be done on/after the booked date' into the OUT parameter p_message.

# Next, we proceed to the ELSEIF clause. Here, we use the v_payment_status variable to check if the booking has already been cancelled or paid for. If it has, we store the message : 'Booking has already been cancelled or paid' into the OUT parameter.
# Finally, we proceed to the ELSE clause. This is where we handle the actual cancellation.

# Now that we are clear about the IF statement, let’s work on the cancellation code for the ELSE clause. You can replace the comment
-- Code to handle cancellation : with code that we’ll be writing next.
# To handle the cancellation, we need to do a couple of steps:
# (i)First, we need to update the bookings table to change the payment_status column to 'Cancelled' for this particular booking.
# (ii) Next, we need to calculate the new amount that the member who made this booking has to pay and update the payment_due column for this member in the members table.
# (iii) Finally, we need to store the message 'Booking Cancelled' into the OUT parameter to indicate that the booking has been cancelled.

## Step 1
# To update the bookings table, we simply need to write an UPDATE statement to change the payment_status column to 'Cancelled' for this particular booking (WHERE id = p_booking_id).

## Step 2
# Next, we need to calculate how much the member owes the sports complex now.
# As the booking has been cancelled, the member no longer needs to pay for the booking. Hence, we need to first set the value of v_payment_due to v_payment_due - v_price using a SET statement.
# Next, we need to check if this is the third consecutive cancellation by the member. If it is, we’ll impose a $10 fine on the member.
# To do that, we’ll use a function called check_cancellation. We’ll code this function later. For now, we simply need to use the function in our stored procedure.
# This function takes in one value - the booking id.
# Try calling the function, passing in the booking id (p_booking_id) and assigning the result of the function to the local variable v_cancellation. (Recall: You need to use the SET keyword to assign the result of the function to the variable.)
# Next, we need another IF statement. This inner IF statement checks if v_cancellation is greater than or equal to 2. If it is, we have to add 10 to v_payment_due and assign it back to v_payment_due.
# Try coding the IF statement yourself.
# v_payment_due now stores the final updated amount that the member has to pay the complex.
# Now, we simply need to use an UPDATE statement to update the value of payment_due in the members table for this particular member (WHERE id = v_member_id).

## Step 3
# For the last step, we simply need to use a SELECT statement to store the message 'Booking Cancelled' into the OUT parameter.

DELIMITER 
CREATE PROCEDURE cancel_booking (IN p_booking_id INT, OUT
p_message VARCHAR(255))
BEGIN
DECLARE v_cancellation INT;
DECLARE v_member_id VARCHAR(255);
DECLARE v_payment_status VARCHAR(255);
DECLARE v_booked_date DATE;
DECLARE v_price DECIMAL(6, 2);
DECLARE v_payment_due VARCHAR(255);
SET v_cancellation = 0;
SELECT member_id, booked_date, price, payment_status INTO
v_member_id, v_booked_date, v_price, v_payment_status FROM
member_bookings WHERE id = p_booking_id;
SELECT payment_due INTO v_payment_due FROM members WHERE id
= v_member_id;
IF curdate() >= v_booked_date THEN
SELECT 'Cancellation cannot be done on/after the
booked date' INTO p_message;
ELSEIF v_payment_status = 'Cancelled' OR
v_payment_status = 'Paid' THEN
SELECT 'Booking has already been cancelled or
paid' INTO p_message;
ELSE
UPDATE bookings SET payment_status = 'Cancelled'
WHERE id = p_booking_id;
SET v_payment_due = v_payment_due -
v_price;
SET v_cancellation = check_cancellation
(p_booking_id);
IF v_cancellation >= 2 THEN SET v_payment_due =
v_payment_due + 10;
END IF;
UPDATE members SET payment_due = v_payment_due
WHERE id = v_member_id;
SELECT 'Booking Cancelled' INTO p_message;
END IF;
END 


####  TRIGGER ####
# This trigger checks the outstanding balance of a member, which is recorded in the payment_due column of the members table.
# If payment_due is more than $0 and the member terminates his/her account, we’ll transfer the data to the pending_terminations table. This table records all the termination requests that are pending due to an outstanding payment.
# Let’s first declare the trigger as follows: CREATE TRIGGER payment_check BEFORE DELETE ON members FOR EACH ROW
# As you can see, this trigger is activated when we try to delete a record from the members table.
# Next, between the BEGIN and END $$ markers, we need to do a few things:
#(i) First, we need to declare a local variable called v_payment_due. The data type of v_payment_due matches that of the payment_due column in the members table.
#(ii) Next, we need to select the payment_due column from the members table for the member that we are trying to delete and store that data into the v_payment_due variable. (Hint: As this trigger is activated by a DELETE event, we need to use OLD.id to retrieve his/her id.)
#(iii) After getting the v_payment_due value, we’ll use an IF statement to check if v_payment_due is greater than 0.
# If it is, we’ll use an INSERT statement to insert a new record into the pending_terminations table. This new record contains the id, email and payment_due values of the member that we are trying to delete.
# Once that is done, the trigger is complete.

CREATE TRIGGER payment_check BEFORE DELETE ON members FOR EACH
ROW
BEGIN
DECLARE v_payment_due DECIMAL(6, 2);
SELECT payment_due INTO v_payment_due FROM members WHERE id
= OLD.id;
IF v_payment_due > 0 THEN
INSERT INTO pending_terminations (id, email,
payment_due) VALUES (OLD.id, OLD.email, OLD.payment_due);
END IF;
END 


####  STORED FUNCTION ####
# The final thing that we need to code is the check_cancellation function.
# This function checks the number of consecutive cancellations made by the member who's trying to cancel a booking. It has one parameter p_booking_id whose data type matches that of the id column in the bookings table. In addition, it returns an integer and is deterministic.
# Within the function (between the BEGIN and END $$ markers), we need to use a cursor to loop through the bookings table vertically. To begin, let’s first declare three local variables called v_done, v_cancellation and v_current_payment_status.
# Both v_done and v_cancellation are of INT type. 
# v_current_payment_status, on the other hand, has a data type that matches the data type of the payment_status column in the bookings table.
# Next, we need to use a SELECT statement to select the payment_status column (from the bookings table) of the member who’s trying to do a cancellation.
# Suppose we are trying to do a cancellation of the booking with id = 5. We need to first get the member_id of the member who made this booking. Try writing a SELECT statement to get the member_id from the bookings table.
# Next, using this member_id, we need to get the payment_status of all the bookings made by this member.
# To do that, you need to select the payment_status column from the bookings table, using the previous SELECT statement as a subquery. 
# Finally, we need to order the results by datetime_of_booking in descending order so that we get the latest payment_status first.

# Once you are done, execute the statement. You should get the following results: Unpaid, Paid and Paid.

# Once you have declared the cursor, you need to declare a CONTINUE HANDLER for this cursor. This can be done using the statement below: DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
# Now, we need to set the values of v_done and v_cancellation to 0 using the SET keyword.
# Once we have declared and set everything that we need, we are ready to start looping through the payment_status column.

# We need to do the following 4 things:
#1. Open the cursor
#2. Use the cursor to loop through the payment_status column and increment v_cancellation by 1 for each consecutive cancellation
#3. Close the cursor
#4. Return the value of v_cancellation

# After fetching the value, we’ll use an IF statement to check the values of v_current_payment_status and v_done.
# If v_current_payment_status does not equal 'Cancelled' or v_done equals 1, we can leave the loop. This is because once we find a v_current_payment_status that is not equal to 'Cancelled', the string of consecutive cancellations (if any) has ended.
# In addition, if v_done equals 1, we have come to the end of the result set from the SELECT statement and can also leave the loop.
# Once you are done with the IF clause, you can work on the ELSE clause.
# Within the ELSE clause, we simply increment the value of v_cancellation by 1 using the SET keyword.
# Once you are done, you can end the IF statement, end the loop, close the cursor and return the value of v_cancellation.


CREATE FUNCTION check_cancellation (p_booking_id INT) RETURNS INT
DETERMINISTIC
BEGIN
DECLARE v_done INT;
DECLARE v_cancellation INT;
DECLARE v_current_payment_status VARCHAR(255);
DECLARE cur CURSOR FOR
SELECT payment_status FROM bookings WHERE member_id =
(SELECT member_id FROM bookings WHERE id = p_booking_id) ORDER BY
datetime_of_booking DESC;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
SET v_done = 0;
SET v_cancellation = 0;
OPEN cur;
cancellation_loop : LOOP
FETCH cur INTO v_current_payment_status;
IF v_current_payment_status != 'Cancelled' OR v_done =
1 THEN LEAVE cancellation_loop;
ELSE SET v_cancellation = v_cancellation + 1;
END IF;
END LOOP;
CLOSE cur;
RETURN v_cancellation;
END 

DELIMITER ;

# Once that is complete, we have finished coding our stored routines. We can now change the delimiter back to a semi-colon using the statement below: DELIMITER ;
# With that, we have come to the end of our project coding.


