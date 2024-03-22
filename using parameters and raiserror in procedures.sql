Use IQSchool
go

-- all parameters in this solution will have a default of null
-- all parameters will be checked to see if a value was passed
--		if no parameter was passed; raise an error with an appropriate message
-- all DML statements will be checked for successful execution
--		if there is an error; raise an error with an appropriate message
--      Update/Delete
--		if there is no rows affected by the successful execution of the command;
--			raise an error with an appropriate message

--Create a stored procedure called ‘AddClub’ to add a new club record.
--  Insert
--what is my input? ClubId (PK), ClubName
--any addition important information
--		ClubId is not an identity field
--		Therefore we must supply the value

DROP PROCEDURE IF EXISTS AddClub
go

CREATE PROCEDURE AddClub (@clubid varchar(10) = null, @clubname varchar(50) = null)
AS

--DECLARE any local variables
--Remember parameters are treated as local variables
--need to declare local variables to hold the results of the execution
DECLARE @error int,
		@rowcount int

--first thing to check is, did the procedure receive incoming values
IF @clubid is null or @clubname is null
BEGIN
	--if's true path
	--there is one or both values missing for the procedure
	--you might do a PRINT but this does not go to the calling application
	--instead, use RAISERROR to send the message to the calling application
	RAISERROR('You must provide both ClubId and ClubName',16,1)
	--goto the end of the IF's structure
END
ELSE
BEGIN
	--if's false path
	--execute a DML statement that will insert a new club record
	--this is a transaction: it is an implied transaction
	--this transaction will either work (insert) or fail (aborts)
	--this transcation DOES NOT need the explicit transaction syntax

	INSERT INTO Club (ClubId, ClubName)
	VALUES(@clubid, @clubname)

	--capture the results of this DML command: @@error and @@rowcount
	SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT

	--check the results of the DML execution: Succeed or Fail?
	IF @error <> 0
	BEGIN
		RAISERROR('Insert of club failed.',16,1)
	END
	ELSE
	BEGIN
		--since the insert will either work (1 row affected) or
		--							   abort (@@error is not 0)
		--there is no need to test @@rowcount
		--HOWEVER, if you wish to do so, then you can
		IF @rowcount = 0
		BEGIN
			RAISERROR('Data was not inserted into the table.',16,1)
		END --eof of @rowcount testing
	END --eof of @error testing
END --eof of null testing
RETURN

--test your procedure
exec AddClub
go
exec AddClub 'bobA04'
go
exec AddClub 'bobA04','in your uncle'
go

--Create a stored procedure called ‘DeleteClub’ to delete a club record.
DROP PROCEDURE IF EXISTS DeleteClub
go

CREATE PROCEDURE DeleteClub (@clubid varchar(10) = null)
AS
DECLARE @error int,
		@rowcount int
DECLARE @msg varchar(100)

IF @clubid is null
BEGIN
	RAISERROR('You must provide ClubId',16,1)

END
ELSE
BEGIN
	DELETE Club 
	WHERE ClubId = @clubid

	SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT

	--abort state
	IF @error <> 0
	BEGIN
		--you cannot concatenate within the message area of the RAISERROR
		--to create a message with a concatenate set of strings
		--you will need to create the message separately then use the
		--		variable within RAISERROR
		SET @msg = 'Removal of club ' + @clubid + ' failed.'
		RAISERROR(@msg,16,1)
	END
	ELSE
	BEGIN
		--test the state of non-abort BUT no rows affected
		IF @rowcount = 0
		BEGIN
			RAISERROR('Data was not removed from the table. Club not found',16,1)
		END --eof of @rowcount testing
	END --eof of @error testing
END --eof of null testing
RETURN
go
exec DeleteClub
go
exec DeleteClub 'xxxx'
go
exec DeleteClub 'bobA04'
go



--Create a stored procedure called ‘Updateclub’ to update a club record. 
--Do not update the primary key!
DROP PROCEDURE IF EXISTS UpdateClub
go

CREATE PROCEDURE UpdateClub (@clubid varchar(10) = null, @clubname varchar(50) = null)
AS

DECLARE @error int,
		@rowcount int

IF @clubid is null or @clubname is null
BEGIN
	RAISERROR('You must provide both ClubId and ClubName',16,1)
END
ELSE
BEGIN

	UPDATE Club
	SET ClubName = @clubname
	WHERE ClubId = @clubid

	SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT

	IF @error <> 0
	BEGIN
		RAISERROR('Update of club failed.',16,1)
	END
	ELSE
	BEGIN
		IF @rowcount = 0
		BEGIN
			--substituting a value for a placeholder in your error message
			--%i number
			--%s string
			--syntax: RAISERROR('some message with value "%s" is incorrect',16,1,valuetoinsert)
			RAISERROR('Data was not updated on the table. Club: "%s" not found',16,1,@clubid)
		END --eof of @rowcount testing
	END --eof of @error testing
END --eof of null testing
RETURN
go
exec UpdateClub
go
exec UpdateClub 'bobA04'
go
exec UpdateClub 'bobA03','is your cousin'
go
exec UpdateClub 'bobA04','is your cousin'
go

--Create a stored procedure called ‘ClubMaintenance’. 
--It will accept parameters for both ClubID and ClubName as well as 
--a parameter to indicate if it is an insert, update or delete. 
--This parameter will be ‘I’, ‘U’ or ‘D’.  
--Insert, update, or delete a record accordingly. 
--Focus on making your code as efficient and maintainable as possible.
DROP PROCEDURE IF EXISTS ClubMaintenance
go
CREATE PROCEDURE ClubMaintenance(@clubid varchar(10) = null, 
								 @clubname varchar(50) = null,
								 @type char(1) = null)
AS
DECLARE @error int, @rowcount int
DECLARE @exists bit -- true or false value

IF @clubid is null or @clubname is null or @type is null
BEGIN
	RAISERROR('you must provide values for clubid, clubname and type of maintenance (I,U or D)',16,1)
END
ELSE
BEGIN
	IF @type not in ('I', 'U', 'D')
	BEGIN
		RAISERROR('The type of maintenance must be (I,U or D)',16,1)
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 'x' FROM Club WHERE ClubId = @clubid)
		BEGIN
			SET @exists = 1 --true
		END
		ELSE
		BEGIN
			SET @exists = 0 --false
		END
		IF @type = 'I'
		BEGIN
			--INSERT, club should not exists
			if @exists = 1
			BEGIN
				RAISERROR('Club Id %s is already on the database. Insert fails',16,1,@clubid)
			END
			ELSE
			BEGIN
				-- insert can happen
				--do I code the insert logical OR call an existing method?
				--if there is NO existing method to do a insert, you must code it here
				--HOWEVER, if there IS an existing method then you CAN call the method
				exec AddClub @clubid, @clubname
			END
		END
		ELSE
		BEGIN
			if @exists = 0
			BEGIN
				RAISERROR('Club Id %s is not on the database. Update/Delete fails',16,1,@clubid)
			END
			ELSE
			BEGIN
				IF @type = 'U'
				BEGIN
					exec UpdateClub @clubid, @clubname
				END
				ELSE
				BEGIN
					exec DeleteClub @clubid
				END
			END
		END
	END
END

RETURN
go
exec ClubMaintenance
go
exec ClubMaintenance 'bobA04', 'is your uncle', 'g'
go
exec ClubMaintenance 'bobA04', 'is your uncle', 'I'
go
exec ClubMaintenance 'bobA04C', 'is your cousin', 'I'
go
exec ClubMaintenance 'bobA04Bad', 'is not your cousin', 'U'
go
exec ClubMaintenance 'bobA04Bad', 'is not your cousin', 'D'
go
exec ClubMaintenance 'bobA04C', 'is  your aunt', 'U'
go
exec ClubMaintenance 'bobA04', 'is unecessary parameter value', 'D'
go


--Create a stored procedure called ‘RegisterStudent’ that accepts 
--StudentID and OfferingCode as parameters. 
--If the number of students in that Offering is 
--	not greater than the Max Students for that course, 
--  add a record to the Registration table 
--  and add the cost of the course to the student’s balance. 
--If the registration would cause the Offering to have greater 
--	than the MaxStudents raise an error. 
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
				--there is room for another student
				INSERT INTO Registration(OfferingCode,StudentID,Mark,WithdrawYN)
				VALUES (@offeringcode, @studentid,null,'N') --'N' could also be null
				SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
				IF @error <> 0
				BEGIN
					RAISERROR('Registration has failed. Student is already registered for the offering',16,1)
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
					END
					ELSE
					BEGIN
						--even though we do know that the student exists and thus
						--	will be update; you SHOULD check to see if the system
						--	actually updated a record
						IF @rowcount = 0
						BEGIN
							RAISERROR('No records were updated.',16,1)
						END
						ELSE
						BEGIN
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