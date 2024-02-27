use IQSchool
go
--Group By and Having

--Group BY clause
-- divides your whole collection into smaller collections and 
--	applies the aggregate
--rules
--any attribute NOT in an aggregate on the SELECT 
--		MUST be specified on a GROUP BY clause
--One CANNOT use an aggregate on a WHERE clause
-- what is the avg of all students

--NOTE: if your group has a aggregrate containing a null value, that
--       group will NOT be included in your final display BECAUSE
--       aggregates CANNOT handle null values
SELECT avg(Mark)
FROM Registration
go
-- what is the average mark of each student 

SELECT  studentid, avg(Mark), Count(OfferingCode)

FROM Registration
--WHERE avg(mark) >= 80 --this will abort the query NOT ALOLLOWED
WHERE WithdrawYN = 'N'
GROUP BY  studentid

--to filter a group you will need to use the HAVING clause
--you may use aggregates or other attributes on this clause
--typically this is reserved to filtering on aggregrates
HAVING avg(Mark) >= 80
    and count(OfferingCode) >= 5
go

SELECT OfferingCode, Avg(mark), count(studentid)

FROM Registration
WHERE WithdrawYN = 'N' --filtering the data to be used in the query
                       -- the filter would happen before the GROUP BY 
GROUP BY OfferingCode
go