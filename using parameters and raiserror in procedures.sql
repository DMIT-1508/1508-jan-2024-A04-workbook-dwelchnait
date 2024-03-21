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