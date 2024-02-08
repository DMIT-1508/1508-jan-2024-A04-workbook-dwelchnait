--ALTER TABLE command

use MyCompanyA04
go
-- Add a column City to the Customer Table

ALTER TABLE Customers ADD City varchar(50) NULL

ALTER TABLE Customers ADD Province char(2) NULL
	CONSTRAINT CK_Customers_Province 
		CHECK (Province in ('BC', 'AB', 'SK', 'MN'))

ALTER TABLE Orders Add CONSTRAINT
	CK_Orders_SubTotal CHECK (SubTotal >= 0)

ALTER TABLE Customers ADD
	CONSTRAINT DF_Customers_Province DEFAULT 'AB' for Province

ALTER TABLE ItemsOnOrder DROP COLUMN Amount