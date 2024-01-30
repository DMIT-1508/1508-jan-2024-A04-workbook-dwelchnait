-- a physical file that contains sql commands to execute
--		is referred to as a script file

-- the command to create a database is:
--CREATE DATABASE MyCompanyA04

--sql requires that certain commands be executed on their own
--sql executes commands within a script file in side what are
--		called batches
--a batch ends with the command go (which causes the execution
--		of the batch


-- we would like to ensure that the correct database for the
--		script file is active for the enclosed commands
-- to command to switch to a particular database is: use databasename

--this is a batch
use MyCompanyA04
go

--this is a batch
--Create command

CREATE TABLE Customers
(
CustomerNumber int IDENTITY(1,1) NOT NULL,
LastName nvarchar(50) NOT NULL,
FirstName nvarchar(20) NOT NULL,
Phone varchar(12) NULL
)
go
