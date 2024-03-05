use IQSchool
go

--Update

--Purpose
-- Allow the user to change one or more columns
--		on one or more records for a particular table

--Possible Results
--	NO Abort, record(s) have been altered
--  Abort, something is incorrect/ violates a constraint
--  NO Abort, Nothing altered, usually due to your WHERE filter

--increase the number of students allowed in DMIT2015 to 20

UPDATE Course
SET MaxStudents = 20
WHERE CourseId = 'DMIT2015'

-- alter multiple records
--due to COLA all fees for the course must increase by 8%

UPDATE Course
SET CourseCost = CourseCost * 1.08

-- alter multiple attributes
--NOTE: when you have an attribute on the right side of the = side,
--      it takes the original record value BEFORE any alterations by
--      the update command
--example
--  SET Subtotal = qty * Price,
--      GST = Subtotal * 0.05
-- the subtotal on the second line is the value of subtotal PRIOR to qty*price
-- EVERYTHING on the right side of the = sign is set up BEFORE any Update of
--		of attributes
UPDATE Staff
SET FirstName = 'Charity',
    LastName = 'Kase'
WHERE StaffID = 8

--subqueries?
-- MUST return a single value
UPDATE Staff
SET PositionID = (SELECT PositionID FROM Position
					WHERE PositionDescription = 'Assistant Dean')
WHERE LastName = 'Latter'