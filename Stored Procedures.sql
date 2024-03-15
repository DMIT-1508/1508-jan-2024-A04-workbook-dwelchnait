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

--Create a stored procedure called BalanceOrNoBalance. 
--It will accept a studentID as a parameter. Each course has a cost. 
--If the total of the costs for the courses the student is registered in 
--is more than the total of the payments that student has made, 
--then print ‘balance owing!’ otherwise print ‘Paid in full! Welcome to IQ School!’
--Do Not use the BalanceOwing field in your solution

DROP PROCEDURE BalanceOrNoBalance
go

CREATE PROCEDURE BalanceOrNoBalance (@studentid int)
AS
-- need to get the total payments (Payments)
-- need to get the total course cost (Registration -> Offering -> Course)
DECLARE @totalPayments money,
        @totalCost money

SELECT @totalPayments = sum(Amount)
FROM Payment
WHERE StudentID = @studentid

SELECT @totalCost = sum(CourseCost)
FROM Registration r inner join Offering o
		on r.OfferingCode = o.OfferingCode
		            inner join Course c
		on o.CourseId = c.CourseId
WHERE r.StudentID = @studentid

IF @totalPayments >= @totalCost
BEGIN
	PRINT 'Paid in full! Welcome to IQ School!'
END
ELSE
BEGIN
	PRINT 'balance owing'
END

RETURN
go

exec BalanceOrNoBalance 200495500
go

--Create a stored procedure called ‘DoubleOrNothin’. 
--It will accept a student’s first name and last name as parameters. 
--If the student’s name already is in the table, 
--then print ‘We already have a student with the name firstname lastname!’ 
--Otherwise print ‘Welcome firstname lastname!’

DROP PROCEDURE DoubleOrNothin
go

CREATE PROCEDURE DoubleOrNothin (@firstname varchar(25), @lastname varchar(25))
AS
-- the Exists will use a query to determine if there are any records
--	returned by the query
-- the records are not physically available
-- instead you receive a boolean true or false
-- since no records are physically available, one uses the Select * From ... as the query
IF Exists(SELECT * FROM Student WHERE FirstName = @firstname AND LastName = @lastname)
BEGIN
	PRINT 'We already have a student with the name ' + @firstname + ' ' + @lastname
END
ELSE
BEGIN
	PRINT 'Welcome ' + @firstname + ' ' + @lastname
END

RETURN
go

exec DoubleOrNothin 'Don','Welch'
exec DoubleOrNothin 'Peter','Pan'
go

--Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter. 
--If the number of classes the staff member has ever taught is 
--between 0 and 10 print ‘Well done!’, 
--if it is between 11 and 20 print ‘Exceptional effort!’, 
--if the number is greater than 20 print ‘Totally Awesome Dude!’

DROP PROCEDURE	StaffRewards
go
CREATE PROCEDURE StaffRewards (@staffid smallint)	
AS
-- count of classes Offering
 DECLARE @numberOfClass smallint

 SELECT @numberOfClass = count(*)
 FROM Offering
 WHERE StaffID = @staffid

 IF @numberOfClass <= 10
 BEGIN
	PRINT 'Well done!'  --after executing drop out of IF structure
 END
 ELSE
 BEGIN
	IF @numberOfClass <= 20 --AND @numberOfClass >= 11  due to logic, this second part of condition is not needed 
	BEGIN
		PRINT 'Exceptional effort!' --after executing drop out of IF structure
	END
	ELSE
	BEGIN
		-- only possibility is the count is > 20 
		PRINT 'Totally Awesome Dude!' --after executing drop out of IF structure
	END
 END --end of the IF structure

RETURN
go

exec StaffRewards 5
go