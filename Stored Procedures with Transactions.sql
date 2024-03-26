--simple view of a Transaction result
USE IQSchool
GO

--ROLLBACK TRANSACTION
-- tables reverts to original state
BEGIN TRANSACTION	--signals the start of an explicit transaction
SELECT * FROM Registration
DELETE Registration
SELECT * FROM Registration
ROLLBACK TRANSACTION --terminates the existing transaction
SELECT * FROM Registration
go
--COMMIT TRANSACTION
-- tables kept the alterations of any executed DML command
BEGIN TRANSACTION	--signals the start of an explicit transaction
SELECT * FROM Registration
DELETE Registration
SELECT * FROM Registration
COMMIT TRANSACTION --terminates the existing transaction
SELECT * FROM Registration
go
DROP PROCEDURE IF EXISTS RegisterStudent
go
CREATE PROCEDURE RegisterStudent (@studentid int = null,
								  @offeringcode int = null)
AS
DECLARE @error int, @rowcount int
DECLARE @maxSize int, @currentSize int

IF @studentid is null or @offeringcode is null
BEGIN
	RAISERROR('You must supply the student id and offering code.',16,1)	
END
ELSE
BEGIN
	IF not EXISTS (SELECT 'x' FROM Student WHERE StudentID = @studentid)
	BEGIN
		-- %i is for an integer variable
		RAISERROR('Student "%i" is not registered in the school',16,1,@studentid) 
	END
	ELSE
	BEGIN
		IF not EXISTS (SELECT 'x' FROM Offering WHERE OfferingCode = @offeringcode)
		BEGIN
			-- %i is for an integer variable
			RAISERROR('Offering "%i" does not exists',16,1,@offeringcode) 
		END
		ELSE
		BEGIN
			-- at this point I know student and offering are good
			-- I need to know the max limit of student for the offering
			SELECT @maxSize = MaxStudents
							  FROM Course
							  WHERE CourseId in (SELECT CourseId
												FROM Offering
												WHERE OfferingCode = @offeringcode)
			-- I need to know the current count of students in the offering
			SELECT @currentSize = COUNT(OfferingCode)
								  FROM Registration
								  WHERE OfferingCode = @offeringcode
								    and WithdrawYN != 'Y'

			-- Is there room for another student?
			IF @currentSize = @maxSize
			BEGIN
				RAISERROR('Offering is full',16,1)
			END
			ELSE
			BEGIN
				--at this point in time, data has been validated and deemed good
				--present checking and business rule checking did not have to belong in the transaction
				--	as they were not altering the database
				--the first physical attempt to alter the database begins the transaction
				--this is the start of the LUW (logical unit of work)
				--once the transaction has started
				--   EITHER a ROLLBACK or COMMIT MUST be executed to terminate the transaction
				BEGIN TRANSACTION
				-- ANY  changes to the database are temporary
				--there is room for another student
				INSERT INTO Registration(OfferingCode,StudentID,Mark,WithdrawYN)
				VALUES (@offeringcode, @studentid,null,'N') --'N' could also be null
				SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
				IF @error <> 0
				BEGIN
					RAISERROR('Registration has failed. Student is already registered for the offering',16,1)
					--terminate the open transaction
					ROLLBACK TRANSACTION
				END
				ELSE
				BEGIN
					UPDATE Student
					SET BalanceOwing = BalanceOwing + (SELECT CourseCost
														FROM Course c inner join Offering o
														         ON c.CourseId = o.CourseId
														WHERE o.OfferingCode = @offeringcode)
					WHERE StudentID = @studentid
					SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
					IF @error <> 0
					BEGIN
						RAISERROR('Unable to update student balance.',16,1)
						--terminate the open transaction
						ROLLBACK TRANSACTION
					END
					ELSE
					BEGIN
						--even though we do know that the student exists and thus
						--	will be update; you SHOULD check to see if the system
						--	actually updated a record
						IF @rowcount = 0
						BEGIN
							RAISERROR('No records were updated.',16,1)
							--terminate the open transaction
							ROLLBACK TRANSACTION
						END
						ELSE
						BEGIN
							--at this point in the transaction, everything has executed as expected
							--the results of the DML commands are to be kept
							--terminate the transaction
							COMMIT TRANSACTION
							--send back as a select record, the new student balance
							SELECT BalanceOwing
							FROM Student
							WHERE StudentID = @studentid
						END
					END
				END
			END
		END
	END
END
RETURN
go
--dmit1508 change MaxStudents to 25 (allows an entry) Offering 1001
UPDATE Course
SET MaxStudents = 25
WHERE CourseId = 'DMIT1508'
go
--dmit1514 8 change MaxStudents to 8 be full Offering 1000
UPDATE Course
SET MaxStudents = 8
WHERE CourseId = 'DMIT1514'
go
exec RegisterStudent
go
exec RegisterStudent 19999999,1000 -- no student
go
exec RegisterStudent 199912010, 2001 --no offering
go
exec RegisterStudent 199912010, 1000 --full
go
exec RegisterStudent 199912010, 1001 --already registered
go
--good run 
-- old balance 0.00 new balance 675.00 for Joe Petroni
-- Registration record (probably line 15 in a Select) 1001,200522220,NULL,N
exec RegisterStudent 200522220, 1001 
go
--reset data
UPDATE Student
SET BalanceOwing = 0.00
WHERE StudentID = 200522220
go
DELETE Registration
WHERE StudentID = 200522220 and OfferingCode = 1001
go

--Create a procedure called ‘StudentPaymentTransaction’  that accepts Student ID and 
--payment amount as parameters. Add the payment to the payment table and adjust the 
--students balance owing to reflect the payment.

DROP PROCEDURE IF EXISTS StudentPaymentTransaction
go
CREATE PROCEDURE StudentPaymentTransaction (@studentid int = null,
										    @payment smallmoney = null)
AS
DECLARE @error int, @rowcount int
DECLARE @paymentid int

IF @studentid is null or @payment is null
BEGIN
	RAISERROR('You must supply the student id and payment amount.',16,1)	
END
ELSE
BEGIN
	IF not EXISTS (SELECT 'x' FROM Student WHERE StudentID = @studentid)
	BEGIN
		-- %i is for an integer variable
		RAISERROR('Student "%i" is not registered in the school',16,1,@studentid) 
	END
	ELSE
	BEGIN
		IF @payment <= 0
		BEGIN
			-- %i is for an integer variable
			RAISERROR('Your payment amount must be greater than 0',16,1) 
		END
		ELSE
		BEGIN
			--beginning of the LUW
			BEGIN TRANSACTION
			SELECT @paymentid = MAX(PaymentID) + 1 FROM Payment
			INSERT INTO Payment (PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
			VALUES(@paymentid, GETDATE(), @payment, 4, @studentid)
			SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
			IF @error <> 0
			BEGIN
				RAISERROR('Payment was not recorded, action failed',16,1)
				ROLLBACK TRANSACTION
			END
			ELSE
			BEGIN
				UPDATE Student
				SET BalanceOwing =BalanceOwing - @payment
				WHERE StudentID = @studentid
				SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
				IF @error <> 0
				BEGIN
					RAISERROR('Student balance not updated, action failed',16,1)
					ROLLBACK TRANSACTION
				END
				ELSE
				BEGIN
					IF @rowcount = 0
					BEGIN
						RAISERROR('Student not found, update action failed',16,1)
						ROLLBACK TRANSACTION
					END
					ELSE
					BEGIN
						--all actions successfully complete
						--commit all changes
						COMMIT TRANSACTION
						--optionally you could return the new balance
					END
				END
			END
		END
	END
END
RETURN
go
exec StudentPaymentTransaction
go
exec StudentPaymentTransaction 19999999,1000 -- no student
go
exec StudentPaymentTransaction 199912010, -120 --bad payment
go
--good payment insert but bad update
exec StudentPaymentTransaction 200522220, 7200.00 
go
--good payment and good balance adjustment
exec StudentPaymentTransaction 200522220, 72.00 
go
--reset data
UPDATE Student
SET BalanceOwing = 87.23
WHERE StudentID = 200522220
go
