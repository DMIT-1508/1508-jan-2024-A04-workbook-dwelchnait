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

--Create a stored procedure called ‘RegisterStudent’ that accepts 
--StudentID and OfferingCode as parameters. 
--If the number of students in that Offering is 
--	not greater than the Max Students for that course, 
--  add a record to the Registration table 
--  and add the cost of the course to the student’s balance. 
--If the registration would cause the Offering to have greater 
--	than the MaxStudents raise an error. 
