-- Views
use IQSchool
go

--BENEFITS
-- Some common uses for SQL Views are:
--	Simplifying data retrieval from complex queries
--  hiding the underlying table structure
--  controlling of access to data for different users

--Views are vitrual tables created by other SELECTs
--Views return a raw data set for use by the caller
--  who can modify the display of the data return
--  therefore the display clause ORDER BY is not allowed
--  on a View

-- to drop a view
DROP View StudentAverages
go

--syntax to create a view
--    CREATE View viewname AS
--        select view

CREATE VIEW StudentAverages
AS
SELECT  s.studentid, LastName + ', ' + FirstName 'Name', 
        avg(Mark) 'Average', Count(OfferingCode) 'Course Count'
FROM Registration inner join Student s
            on Registration.StudentID = s.StudentID
WHERE WithdrawYN = 'N'
GROUP BY  s.studentid, LastName, FirstName
HAVING avg(Mark) >= 80
    and count(OfferingCode) >= 5
go

-- to use a View, use it just like a table on your query
SELECT *
FROM StudentAverages
go

SELECT Name, Average
FROM StudentAverages
ORDER BY Average desc
go