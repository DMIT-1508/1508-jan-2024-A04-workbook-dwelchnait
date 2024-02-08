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

-- Indexes
--normally applied to foreign keys
Create nonclustered INDEX IX_OrdersCustomers_CustomerNumber
		ON Orders(CustomerNumber)

--how to remove an index
DROP INDEX IX_OrdersCustomers_CustomerNumber on Orders

--can one create an index on part of a compound key
CREATE nonclustered INDEX IX_ItemsOnOrderItems_ItemNumber
		ON ItemsOnOrder(ItemNumber)

-- ensure your Item Description is unique
-- do it with a constraint or index
CREATE unique nonclustered INDEX IX_Items_Description
		ON Items(Description)
