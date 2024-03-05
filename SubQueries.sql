--SubQueries
use IQSchool
go

-- what is a subquery
-- Basically it is a query within a query

--why

-- there will be times when you need to determin some data BEFORE
--		being able to process other data that relies on the firs
--      piece(s) of data

-- 1. Select the payment dates and payment amount for all payments that were Cash

--what is the problem
--Payment has an attribute called PaymentTypeID
--I have no idea the id for Cash

--I could
-- a) do a join because PaymentTypeID is a fkey
--    Use an alias for Payment
--    NOT use an alias for PaymentType

-- to check my query result was correct, I add temporarily
--  additional attributes and/or clauses to view that my
--  results were right
-- I can then REMOVE the attributes and/or clauses

SELECT PaymentDate, Amount --, PaymentTypeDescription
FROM Payment p join PaymentType
		on p.PaymentTypeID = PaymentType.PaymentTypeID
WHERE PaymentTypeDescription = 'Cash'
--ORDER BY PaymentTypeDescription
go

--b using a subquery
-- the subquery will return to me the value of the PaymentTypeID for Cash
-- THEN using this value, check the Payment table
SELECT PaymentDate, Amount 
FROM Payment 
WHERE PaymentTypeID in (SELECT PaymentTypeID
						FROM PaymentType
						WHERE PaymentTypeDescription = 'Cash')

-- 2. Select the Student ID's and fullname of all student that are in the
--    'Association of Computing Machinery' club

-- where does my data come
--  club name is in the club table
--  student id Activity table
--  student id and name are in the Student table

-- possible solutions
-- JOIN? yes   Club <--> Activity <--> Student
SELECT s.StudentId, LastName + ', ' + FirstName 'Name'
FROM Student s inner join Activity a
           on s.StudentID = a.StudentID
		       inner join Club c
		   on a.ClubId = c.ClubId
WHERE ClubName = 'Association of Computing Machinery'
go

-- Subquery? yes  ClubID --> list of student ids --> Student data
SELECT StudentId, LastName + ', ' + FirstName 'Name'
FROM Student 
WHERE StudentID in (SELECT StudentID
					FROM Activity
					WHERE ClubId in (SELECT ClubId
					                 FROM Club
									 WHERE ClubName = 'Association of Computing Machinery'))
go

-- Select all the instructional staff: full names, that have NOT taught the course 1001.

-- What course is 1001?
-- Where is my data Course <--> Offering <--> Staff  (join yes)
--                  CouserID --> List of Offering (staffids) --> Staff (subqueries)
-- What is the instructional staff position id?
-- Position description is in Position table --> PositionID

--in this example for demonstration proposes ONLY, BOTH a subquery AND a join
--	have been used to solve the query
-- NORMALLY, one would use a subquery on BOTH filtering conditions

SELECT LastName + ', ' + FirstName
FROM Staff s 
		join Position p
        on s.PositionID = p.PositionID 
WHERE StaffID NOT in (SELECT StaffID
                  FROM Offering
				  WHERE CourseId in (SELECT CourseId
				                     FROM Course
									 WHERE CourseId like '____1001'))
   and PositionDescription like '%Instr%'
   --and PositionID in (SELECT PositionID
   --                   FROM Position
			--		  WHERE PositionDescription like '%Instr%')
go