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
CREATE TABLE Customers
(
CustomerNumber int IDENTITY(1,1) NOT NULL
	CONSTRAINT PK_Customers_CustomerNumber primary key clustered,
LastName nvarchar(50) NOT NULL,
FirstName nvarchar(20) NOT NULL,
Phone varchar(12) NULL
)
go

CREATE TABLE Items
(
ItemNumber int IDENTITY(1,1) NOT NULL
	CONSTRAINT PK_Items_ItemNumber primary key clustered,
Description nvarchar(150) NOT NULL,
CurrentPrice smallmoney NOT NULL
)
go

CREATE TABLE Orders
(
OrderNumber int IDENTITY(1,1) NOT NULL,
OrderDate datetime NOT NULL,
SubTotal smallmoney NOT NULL,
GST smallmoney NOT NULL,
Total smallmoney NOT NULL,
CustomerNumber int NOT NULL
	CONSTRAINT FK_OrdersCustomers_CustomerNumber 
		foreign key (CustomerNumber)
		references Customers(CustomerNumber),
CONSTRAINT PK_Orders_OrderNumber primary key clustered (OrderNumber)
)
go
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
Quantity int NOT NULL,
Price smallmoney NOT NULL,
Amount smallmoney NOT NULL,
CONSTRAINT PK_ItemsOnOrder_OrderNumberItemNumber 
		primary key clustered (OrderNumber, ItemNumber)
)
go
