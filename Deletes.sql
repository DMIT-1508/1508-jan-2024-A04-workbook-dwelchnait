Use IQSchool
go

--Delete

-- Purpose 
-- to remove rows from a particular table

--NOTE: removing rows from a IDENTITY table
--		DOES NOT reset the identity available values

--To reset the IDENTITY table values you MUST drop the table
--you CANNOT delete a parent row off its table, IF, there are
--		child record(s) existing on the foreign key table

-- syntax DELETE [from] tablename
--			[WHERE condition]

--CAUTION: using DELETE without a WHERE will remove ALL records from the table

INSERT INTO Position
VALUES(10,'President')

DELETE Position
WHERE PositionDescription = 'President'

--failed delete because child record(s) exist
DELETE Position
WHERE PositionID = 4