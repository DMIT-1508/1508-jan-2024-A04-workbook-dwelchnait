use IQSchool
go

--Insert

--Purpose
-- is to add a record(s) to a table

--Knowledge
--What type of primary key does the table have?

-- NON-IDENTITY
-- you  MUST supply the pkey value
-- you must ensure that the value is unique to the table
-- non-numeric pkey values are supplied by the user
-- numeric pkey values can be
--		a) supplied by the user
--		b) created by some logical code

--IDENTITY (seed, increment)
-- you generally allow the system to generate the value
-- you CAN via special commands override the generation of a value
--    using the IDENTITY-INSERT command

-- Single Record inserts

-- Add a record to the Staff table
-- numeric pkey, NON_IDENTITY

-- syntax  INSERT INTO tablename (list of columns)
--         VALUES (list of values)

-- Are the column names required
--   NO
--	 the column names are option, however, if you omit the columns the order
--		of your values must match the order of the columns on the table
--	IF, columns are supplied, the order of the values MUST match the order
--		of the specified columns
--      and
--      the column name list order DOES NOT need to match to order of the 
--			columns on the table

--COURSE STANDARD: you will use a list of column names on your inserts

-- Are values required?

--DEPENDS

--  Any column that has a default CAN be omitted from the list and
--		NO values is supplied, in which case, the default of the attribute is used
--  ANY column that is nullable can have a value of null used if there is no
--		data to supply
--	OTHERWISE: the datatype of the value MUST match the table attribute datatype

INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID,LoginID)
VALUES(11,'Don','Welch','1986-01-06',null,4,null)
go
--order example
INSERT INTO Staff (DateReleased, StaffID, DateHired,  PositionID, FirstName, LastName, LoginID)
VALUES(null,12,'1986-01-06',5,'Shirely','Ujest',null)

INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID,LoginID)
VALUES(13,'Pat','Downe','1986-01-06',null,
  (SELECT PositionId FROM Position WHERE PositionDescription = 'Assistant Dean'),null)
go
INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID,LoginID)
VALUES(14,'Jerry','Kan','2003-07-17',null,4,null),
	   (15,'Lowan','Behold','2013-07-17',null,5,null)
go
INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID,LoginID)
VALUES(14,'bad','pkey','2003-07-17',null,4,null),
	   (16,'good','pkey','2013-07-17',null,5,null)
go

use MyCompanyA04
go
--use Items tables
--this table has an IDENTITY pkey
--you DO NOT include the pkey field as an insert column/value
--REMEMBER the system will generate the pkey value for you on successful insertion

--NOTE: if your insertion does NOT WORK, the pkey value will still be used by the system
--      this will leave 'holes' in your pkey sequence

INSERT INTO Items (Description, CurrentPrice)
VALUES('Baby Back Ribs, Full Rack', 27.89)
INSERT INTO Items (Description, CurrentPrice)
VALUES('Baby Back Ribs, Half Rack', -17.89)
INSERT INTO Items (Description, CurrentPrice)
VALUES('Pork Ribs, Full Rack', 27.89)
go

ALTER Table Items ADD Constraint CK_Items_CurrentPrice 
CHECK (CurrentPrice >= 0.00)