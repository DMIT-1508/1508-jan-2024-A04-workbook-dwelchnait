use IQSchool
go
/*
* Joins
*/

/*
* Who is the student? What is their name?
* 
* Problem: the student name is on another table
* Solution:
*   is to use the other table on the FROM clause
*   one can place multiple table on a single FROM clause
* When?
*  IF you have attributes that is on your query that come
*     from multiple sources (tables)
*
* syntax:  FROM tableA [Left outer | inner | Right outer] join tableB
*                    on tableA.attribute = tableB.attribute
*                 [[Left outter | inner | Right outter] join tableC
*                    on tableA/B.attribute = tableC.attribute .... ]
* 
*  INNER is the default join, the word inner can be omitted
*
* Determine where your attributes on the SELECt exist
* This will determine the table(s) that need to be on your Join
* Registration -> studentid, Mark, OfferingCode
* Student -> lastname, firstname
*
* how does not setup the condition for the join
* typically done on table relationships (pkey <--> fkey)
*
* IF you have an attribute in your query that appears on
*    2 or more of your joining tables, you MUST fully qualify the
*    attribute by inidcating which table the attribute is to be taken from
*
* Tables can be given an alias. IF a table is given an alias then the alias
*		MUST be used through the query
*
*/
SELECT  s.studentid, LastName + ', ' + FirstName 'Name', avg(Mark) 'Average', Count(OfferingCode) 'Course Count'
FROM Registration inner join Student s
            on Registration.StudentID = s.StudentID
WHERE WithdrawYN = 'N'
GROUP BY  s.studentid, LastName, FirstName
HAVING avg(Mark) >= 80
    and count(OfferingCode) >= 5
ORDER BY 3 desc
go

-- more than 2 tables
--2. Select	the average mark for each course. Display the CourseName and 
-- the average mark

--What is the needed data for this query
-- coursename in the Course table
-- mark in the Registration table (avg(mark))

--Problem: ther is no directly relationship between Course and Registration
--Solution: look at the ERD, can I create a combination of relationships to
--			tie the table together
--   Course <--> Offering <--> Registration

-- NOTICE in this example that NO data was taken from the Offering table
-- you are NOT required to use data from all the tables involved in a join
SELECT courseName, avg(Mark) 'Average'
FROM Course join Offering
		on Course.CourseId = Offering.CourseId
		    join Registration
		on Offering.OfferingCode = Registration.OfferingCode
GROUP BY CourseName
Order BY 1

-- there will be times that you require all the data from TableA BUT only
--    the match attribute records from TableB
--
-- look for keys words such as: ALL, Every, EACH

--1. Select All position descriptions and the staff ID's that are in those positions

-- Problem: only 6 of the 7 positions have an associated record in the staff table
-- inner join matches records within BOTH tables
-- Assistent Dean position has NO match staff record
--  therefore the inner join would NOT include the Assistent Dean position
--Solution: include all records from one table and the matching records from
--				the other table
--This is done using an Left|Right outer join
--syntax  left tableA Left|Right outer join right tableB
-- using Left or Right indicate which of the two tables will use the ALL records
SELECT PositionDescription, StaffId
FROM Staff s right outer join Position p  --Position is the left table, Staf is the right table
      on  p.PositionID = s.PositionID
ORDER BY PositionDescription