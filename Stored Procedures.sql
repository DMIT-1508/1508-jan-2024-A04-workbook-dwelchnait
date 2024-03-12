use IQSchool
go
--Create a stored procedure called StudentClubCount. 
--It will accept a clubID as a parameter. 
--If the count of students in that club is greater than 2 
--  print ‘A successful club!’. 
--If the count is not greater than 2 print ‘Needs more members!’.


--to delete a procedure use DROP PROCEDURE
DROP PROCEDURE StudentClubCount
go

--creating a stored Procedure (referred to as Procs)
--syntax CREATE PROCEDURE user_proc_name 
--        AS
--          sqal statements
--       RETURN

--Adding a parameter to the stored procedure requires the
--	parameter(S) to be statements as a variable on the
--	CREATE PROCEDURE statement
--syntax CREATE PROCEDURE user_proc_name (@parametername datatype 
--                                           [,@parametername datatype ...])
--        AS
--          sqal statements
--       RETURN
-- NOTE: the parameters are treated as local variables within your
--			procedure
--THEREFORE: you do NOT need to create local variables to store your
--				incoming parameters values

CREATE PROCEDURE StudentClubCount (@clubid varchar(10))
AS
--What is a variable vs a literal
--A literal is a hard-coded value such as 2, or name 'Don Welch'; it does not change
--A variable is a container. This container can hold different values at
--	different times. It has a name. It has a datatype

--create a variable in sql
--requirements 1) starts with @ 2) your desired name 3) datatype
--syntax DECLARE variable datatype [, variable datatype ....]
--You can have multiple DECLARE statement
--DECLARE @clubid varchar(10) --now a parameter
DECLARE @studentCount int

--Assigning a value to the variable
--1) you can assign a value using the SET command
--    SET variable = value
--2) you can use a SELECT command to assign a value
--    rules: the SELECT must return a single value to be assigned
--    SELECT variable = attribute|expression|aggregate [, variable= attribute|expression|aggregate ...]
--          ...rest of the select
--3) assign a incoming value to your stored procedures as a parameter (the parameter is considered
--		a variable)

--set the clubid to CSS (>2) NASA (<2)
--SET @clubid = 'NASA' --value is coming into the proc at execution time

--set the studentCount to the result of a aggregate query saving Count(*)
--use a variable within the SELECT command: on the Where clause
SELECT @studentCount = Count(*)
FROM Activity
WHERE ClubId = @clubid
--same as using a literal in WHERE ClubId = 'CSS'

--Flow of Control
-- determining what actions to take by asking a question
--to ask the question use the IF command
--syntax
--   IF condition
--   BEGIN
--     sql statements executed when condition is true
--   END
--   [ELSE
--   BEGIN
--     sql statements executed when condition is false
--   END]
--optionally if you have a single sql statement for either your true or false path
--	you can omit the BEGIN and END (not recommended)
IF @studentCount > 2
BEGIN
	PRINT 'A successful club!'
END
ELSE
--BEGIN
	PRINT 'Needs more members!'

--END

RETURN --the end of the procedure
go

--how to execute (run) your procedure
--use the the EXECUTE (EXEC)
--if your procedure requires a parameter value, specific
--		the value after the procedure name
--Order of your values MUST match the order requested by the procedure
EXECUTE StudentClubCount 'NAITSA'
go