use IQSchool
go

--1.	Select all the information from the club table
SELECT ClubId, ClubName
FROM Club
go

--short form to access all attributes of the FROM table
--DO NOT USE in this course
--SELECT *
--FROM Club
--go

--2.	Select the FirstNames and LastNames of all the students
-- string concatenation in sql is done using the concatenation
--		operator (+)
--literal strings in sql are within single quotes ('string')
SELECT FirstName, LastName, LastName + ', ' + FirstName
FROM Student
go

--3.	Select all the CourseId and CourseName of all the courses. 
--		Use the column aliases of Course ID and Course Name

--by default the report column header (column name) is the name of
--	the attribute
--this can be altered to a different column header using the "as"
--	modifier on the selected attribute
--the modifier must appear immediately after the attribute
--if the new column header has an embedded blank yur MUST inclose
--	the header in single quotes otherwise the quotes are optional
--the modifier itself (as) is optional
SELECT CourseId as 'Course', CourseName as 'Course Name'
FROM Course
go

--Filtering: WHERE clause
--filtering is the selection of a certain set of records
--	depending of a condition(s)
--filtering conditions are the same as those used on Constraints

-- condition syntax:  WHERE attribute operator argumentvalue
--  relative operators = > < >= <= !=

--4.	Select all the course information for courseID 'DMIT1001'
SELECT CourseId, CourseName, CourseCost, CourseHours, MaxStudents
FROM Course
WHERE CourseId = 'DMIT1001'
go

--5.	Select the Staff names who have positionID of 3
SELECT LastName + ', ' + FirstName as 'Staff Member'
FROM Staff
WHERE PositionId = 3
go

--6.	select the CourseNames whos CourseHours are less than 96.
--      order your coursnames alphabetically

--ORDER BY syntax: ORDER BY attribute [asc | desc][,attribute ....]
--default order is asc
SELECT CourseName
FROM Course
WHERE CourseHours <= 96
ORDER BY CourseName
go

--7.	Select the studentID's, OfferingCode and mark where the 
--      Mark is between 70 and 80

--multiple condition can be joined using the logical operator
--logical operators are: and, or, not

--truth table for multiple conditions

-- cond A   cond B  result
--and operator
--	 T	       T    true all conditions must be true
--   T         F    false not all conditions are true
--   F         T    false not all conditions are true
--   F         F    false not all conditions are true

-- or operator
--   T         T    true all conditions are true
--   T         F    true at least one condition is true
--   F         T    true at least one condition is true
--   F         F    false NO condition is true

--the between allows for range testing
--the between is inclusive of its end points
--syntax:  attribute between arg1 and arg2
SELECT StudentID, OfferingCode, Mark
FROM Registration
--WHERE Mark >= 70 and Mark <= 80
WHERE Mark between 70 and 80  --inclusive
go

--8.	Select the studentID's, Offering Code and mark where the 
--      Mark is between 70 and 80 and the 
--      OfferingCode is 1001 or 1009

--when using multiple conditions you MAY need to group your
--  logical conditions to obtain you indented meaning
SELECT StudentID, OfferingCode, Mark
FROM Registration
WHERE (Mark >= 70 and Mark <= 80)
  and (OfferingCode = 1001 or OfferingCode = 1009)

go

--9.	Select the students first and last names who 
--      have last names starting with S

--pattern conditions
--use the like operator
--your pattern can use the following wild card symbols
-- % any number characters or digits
-- _ (underscore) a character or digit
SELECT FirstName, LastName
FROM Student
WHERE LastName like 'S%'
go

--10.	Select Coursenames whose CourseID  
--      have a 1 as the fifth character
SELECT CourseName --, CourseId
FROM Course
WHERE CourseID like '____1%'
go

--11.	Select the CourseID's and Coursenames 
--      where the CourseName contains the word 'programming'
SELECT CourseName , CourseId
FROM Course
WHERE CourseName like '%programming%'
go

--12.	Select all the ClubNames who start with N or C.
-- the contents of a character can be indicated using [values]
-- ranges can be indicated using a - between the values [a-z]
SELECT ClubName
FROM CLub
WHERE ClubName like '[NC]%'
go