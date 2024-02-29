use IQSchool
go

--UNION
-- the joining of several query outputs into on output

-- by default UNION removes duplicate display rows from the output
-- use the modifier ALL (UNION ALL) to include duplicates

--syntax SELECT ....
--       UNION [ALL]
--       SELECT ....
--       [UNION ...]

--rules
-- if you are sorting the final result of the union, the ORDER BY MUST be on the
--		last select
-- if you are using alias column headers, they MUST appear on the first Select
-- your selects MUST have the same number of columns
-- vertically, the column datatype MUST be the same
SELECT LastName, FirstName , StudentID, 'Student' 'Type'
FROM Student
--ORDER BY LastName
UNION --ALL
SELECT LastName, FirstName, StaffId , 'Staff'
FROM Staff
WHERE DateReleased is null
ORDER BY 1 -- ordering can be done by referencing the item by the column number