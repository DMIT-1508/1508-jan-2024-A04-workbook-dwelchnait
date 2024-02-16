use IQSchool
go

--Aggregates
-- summary piece of information created from a collection of records
-- Count(): counts the number of records from collection (3 Versions)
-- Sum(numeric): totals the desired numeric attribute from the record collection
-- Avg(numeric): calculates the averge of the desired numeric attribute from the record collection
-- Min(attribute): find the minimum value of the desired attribute from the record collection
-- Max(attribute): find the maximum value of the desired attribute from the record collection

--the count is used in 3 versions
-- count(*) count the number of rows regardless of data present
-- count(attribute) count the number of rows containing a data value
-- count (distinct attribute) count the number of unique distinct values in the collection

-- Find the number of students in the Offering 1001
SELECT count(*)
FROM Registration
WHERE OfferingCode = 1001

-- How many staff have been released.
SELECT count(DateReleased)
FROM Staff

-- How many different provinces do our students come from?
SELECT count(distinct Province) as 'Provinces',
		count(distinct City) as 'City',
		count(*) as 'Students'
FROM Student

--Sum
-- needs a specified numeric attribute

SELECT sum(Amount) as 'Total Payments'
FROM Payment
WHERE DATEPART(yy,PaymentDate) = 2020
   or YEAR(PaymentDate) = 2019

SELECT sum(Amount) as 'Total Payments'
FROM Payment
WHERE Year(PaymentDate) = 2020
   and MONTH(PaymentDate) = 01
   and DAY(PaymentDate) = 01

-- Average
-- needs a specified numeric attribute

-- what is the average mark in 1001

SELECT avg(Mark)
FROM Registration
WHERE OfferingCode = 1001

-- Min / Max
-- what is the lowest and highest payment for 2020


SELECT min(Amount) as 'Lowest', max(Amount) as 'Highest'
FROM Payment
WHERE Year(PaymentDate) = 2020
   

SELECT min(Province) as 'Lowest', max(Province) as 'Highest'
FROM Student

--Group BY clause
-- divides your whole collection into smaller collections and 
--	applies the aggregate

-- what is the average mark of each student 

SELECT studentid, avg(Mark)
FROM Registration
GROUP BY StudentID

--String Functions
--List the students with first names with only 3 characters

--LEN(attribute): return the length of an attribute
SELECT firstname
FROM Student
WHERE LEN(firstname) = 3

SELECT firstname
FROM Student
WHERE FirstName like '___'

SELECT REVERSE(lastname)
FROM Student

SELECT LastName + ' ' + SUBSTRING(FirstName,1,1) as 'Student List'
FROM Student