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

--this batch will remove the database tables so that
--	the new table versions can be built

drop table ItemsOnOrder
drop table Items
drop table Orders
drop table Customers
go

--this is a batch
--Create command
--CONSTRAINTS
--	there are serval type of CONSTRAINTS
--  CONSTRAINTS are busines rules incorporated into your database
--	each table requires a primary key
--  CONSTRAINTS can be done at:
--		the attribute level (the constraint is restricted to that attribute)
--		at the table level (a constraint can use multiple attributes
--							within the same database)

--checks: compound check on AGE
--        regular expression (pattern/regex) on Phone
CREATE TABLE Customers
(
CustomerNumber int IDENTITY(1,1) NOT NULL
	CONSTRAINT PK_Customers_CustomerNumber primary key clustered,
LastName nvarchar(50) NOT NULL,
FirstName nvarchar(20) NOT NULL,
Phone char(12) NULL
	CONSTRAINT CK_Customers_Phone CHECK (Phone like '[1-9][0-9][0-9][ -][1-9][0-9][0-9][ -][0-9][0-9][0-9][0-9]'),
Age int NOT NULL
	CONSTRAINT CK_Customers_Age CHECK (Age BETWEEN 18 and 120)
	--CONSTRAINT CK_Customers_Age CHECK (Age >= 18 and Age <= 120)
)
go

-- CurrentPrice must be 0 or greater (Domain check/business rule)
CREATE TABLE Items
(
ItemNumber int IDENTITY(1,1) NOT NULL
	CONSTRAINT PK_Items_ItemNumber primary key clustered,
Description nvarchar(150) NOT NULL,
CurrentPrice smallmoney NOT NULL
	CONSTRAINT CK_Items_CurrentPrice CHECK (CurrentPrice >= 0.00)
)
go


--table level check constraints can check multiple attributes of the SAME table
--	BUT need to be code at the table level

--a default constrait allows the attribute to have a value when a value
--		was NOT supplied
--on the ShippedDate date, I could default the date to the current date
--getdate() is a sql method that goes to the operating system and obtains the
--		current date
CREATE TABLE Orders
(
OrderNumber int IDENTITY(1,1) NOT NULL,
OrderDate datetime NOT NULL,
ShippedDate datetime NOT NULL
	CONSTRAINT DF_Orders_ShippedDate DEFAULT getdate(),
SubTotal smallmoney NOT NULL,
GST smallmoney NOT NULL,
Total smallmoney NOT NULL,
CustomerNumber int NOT NULL
	CONSTRAINT FK_OrdersCustomers_CustomerNumber 
		foreign key (CustomerNumber)
		references Customers(CustomerNumber),
CONSTRAINT PK_Orders_OrderNumber primary key clustered (OrderNumber),
CONSTRAINT CK_Orders_OrderDateShippedDate CHECK (ShippedDate >= OrderDate) 
)
go

--compound primary keys need to be coded at the table level
--why they contain 2 or more attributes
CREATE TABLE ItemsOnOrder
(
OrderNumber int NOT NULL
	CONSTRAINT FK_ItemsOnOrderOrders_OrderNumber 
		foreign key (OrderNumber)
		references Orders(OrderNumber),
ItemNumber int NOT NULL
	CONSTRAINT FK_ItemsOnOrderItems_ItemNumber 
		foreign key (ItemNumber)
		references Items(ItemNumber),
Quantity int NOT NULL
	CONSTRAINT DF_ItemsOnOrder DEFAULT 1,
Price smallmoney NOT NULL,
Amount smallmoney NOT NULL,
CONSTRAINT PK_ItemsOnOrder_OrderNumberItemNumber 
		primary key clustered (OrderNumber, ItemNumber)
)
go
