-- 1. Write a query that displays Full name of an employee who has more than 
--    3 letters in his/her First Name.
SELECT
    CONCAT_WS(' ', Fname, Lname) AS 'Full Name'
FROM
    Employee
WHERE
    LEN(Fname) > 3;

-- 2. Write a query to display the total number of Programming books 
--    available in the library with alias name ‘NO OF PROGRAMMING BOOKS’ 
SELECT
    CONCAT_WS(' ', 'NO OF PROGRAMMING BOOKS', COUNT(B.id))
FROM
    Book B
    JOIN Category C on B.Cat_id = C.Id
WHERE
    C.Cat_name LIKE 'Programming';

-- 3. Write a query to display the number of books published by 
--    (HarperCollins) with the alias name 'NO_OF_BOOKS'.
SELECT
    CONCAT_WS(' ', 'NO_OF_BOOKS', COUNT(B.id))
FROM
    Book B
    JOIN Publisher P on B.Publisher_id = P.Id
WHERE
    P.Name LIKE 'HarperCollins';

-- 4. Write a query to display the User SSN and name, date of borrowing and due date 
--    of the User whose due date is before July 2022.  
SELECT
    U.SSN,
    U.[User_Name],
    B.Borrow_date
FROM
    Users U
    JOIN Borrowing B ON B.User_ssn = U.SSN
WHERE
    B.Due_date < '2022-7-1';

-- 5. Write a query to display book title, author name and display in the 
--    following format,' [Book Title] is written by [Author Name].
SELECT
    CONCAT_WS(' ', B.Title, 'is written by', A.Name)
FROM
    Book B
    JOIN Book_Author BA ON BA.Book_id = B.Id
    JOIN Author A ON A.Id = BA.Author_id;

-- 6. Write a query to display the name of users who have letter 'A' in their names.
SELECT
    U.User_Name
FROM
    Users U
WHERE
    U.User_Name LIKE '%A%';

-- 7. Write a query that display user SSN who makes the most borrowing 
WITH TT AS(
    SELECT
        TOP(1) COUNT(B.User_ssn) AS Counting,
        B.User_ssn
    FROM
        Borrowing B
    GROUP BY
        B.User_ssn
    ORDER BY
        Counting DESC
)
SELECT
    [User_ssn]
FROM
    TT;

-- 8. Write a query that displays the total amount of money that each user paid 
--    for borrowing books.  
SELECT
    SUM(B.Amount) AS 'the total amount of money'
FROM
    Borrowing B
GROUP BY
    B.User_ssn;

-- 9. write a query that displays the category which has the book that has the 
--    minimum amount of money for borrowing.
SELECT
    TOP(1) C.Cat_name
FROM
    Borrowing BR
    JOIN Book BK ON BR.Book_id = BK.Id
    JOIN Category C ON C.Id = BK.Cat_id
ORDER BY
    BR.Amount ASC;

-- 10.write a query that displays the email of an employee if it's not found, 
--    display address if it's not found, display date of birthday. 
SELECT
    COALESCE(E.Email, E.[Address], CONVERT(NVARCHAR, E.DOB))
FROM
    Employee E;

-- 11. Write a query to list the category and number of books in each category 
--     with the alias name 'Count Of Books'.
SELECT
    C.Cat_name,
    CONCAT_WS(' ', 'Count Of Books', COUNT(B.id))
FROM
    Book B
    JOIN Category C ON B.Cat_id = C.Id
GROUP BY
    C.Cat_name;

-- 12. Write a query that display books id which is not found in floor num = 1 
--     and shelf-code = A1.
SELECT
    B.Id
FROM
    Book B
    JOIN Shelf S ON B.Shelf_code = S.Code
    JOIN Floor F ON S.Floor_num = F.Number
WHERE
    F.Number != 1
    AND S.Code != 'A1';

-- 13.Write a query that displays the floor number , Number of Blocks and 
--    number of employees working on that floor.
SELECT
    f.Number,
    F.Num_blocks,
    COUNT(E.Id) AS 'number of employees'
FROM
    [Floor] F
    JOIN Employee E ON E.Floor_no = F.Number
GROUP BY
    F.Number,
    F.Num_blocks;

-- 14.Display Book Title and User Name to designate Borrowing that occurred 
--    within the period ‘3/1/2022’ and ‘10/1/2022’.
SELECT
    BK.Title,
    U.[User_Name]
FROM
    Borrowing BR
    JOIN Book BK ON BK.Id = BR.Book_id
    JOIN Users U ON U.SSN = BR.User_ssn
WHERE
    BR.Borrow_date BETWEEN '3/1/2022'
    AND '10/1/2022';

-- 15.Display Employee Full Name and Name Of his/her Supervisor as 
--    Supervisor Name.
SELECT
    CONCAT_WS(' ', E.Fname, E.Lname) AS 'Employee Full Name',
    CONCAT_WS(' ', SV.Fname, SV.Lname) AS 'Supervisor Full Name'
FROM
    Employee E
    JOIN Employee SV ON E.Super_id = SV.Id;

-- 16.Select Employee name and his/her salary but if there is no salary display 
--    Employee bonus. 
SELECT
    CONCAT_WS(' ', E.Fname, E.Lname) AS 'Name',
    COALESCE(E.Salary, E.bouns)
FROM
    Employee E;

-- 17.Display max and min salary for Employees 
SELECT
    MAX(E.salary) AS 'Maximun salary',
    MIN(E.salary) AS 'Minimun salary'
FROM
    Employee E;

------------------------------------------------------------------------------------------
-- 18.Write a function that take Number and display if it is even or odd 
GO 
CREATE OR ALTER FUNCTION Number_Parity(@Num INT)
RETURNS NVARCHAR(5)
BEGIN
	DECLARE @Parity NVARCHAR(5);
	IF(@Num%2 = 0)
	BEGIN
		SET @Parity = 'Even'
	END
	ELSE
	BEGIN
		SET @Parity = 'Odd'
	END
	RETURN @Parity;
END
GO

-- 19.write a function that take category name and display Title of books in that category 
GO
CREATE OR ALTER FUNCTION Book_Title(@category NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN (
	SELECT B.Title
	FROM Book B JOIN 
	Category C ON C.Id = B.Cat_id
	WHERE C.Cat_name = @category
);
GO
SELECT *FROM dbo.Book_Title('Mathematics');
-- 20. write a function that takes the phone of the user and displays Book Title ,
--     user-name,  amount of money and due-date.
GO
CREATE OR ALTER FUNCTION User_With_Phone(@Phone NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN (
	SELECT BK.Title,
			U.[User_Name],
			BR.Amount,
			BR.Due_date
	FROM User_phones UP JOIN 
	Users U ON UP.User_ssn = U.SSN
	JOIN 
	Borrowing BR ON BR.User_ssn = U.SSN
	JOIN 
	Book BK ON BK.Id = BR.Book_id
	WHERE UP.Phone_num = @Phone
)
GO

SELECT * FROM dbo.User_With_Phone('0102302155');

-- 21.Write a function that take user name and check if it's duplicated 
--    return Message in the following format ([User Name] is Repeated 
--    [Count] times) if it's not duplicated display msg with this format [user name]
--    is not duplicated,if it's not Found Return [User Name] is Not Found 
GO
CREATE OR ALTER FUNCTION Count_User_Name(@Name NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @MESSAGE NVARCHAR(MAX);
	DECLARE @Name_counter INT =(SELECT  COUNT(U.[User_Name])
		FROM [Users] U
		WHERE U.[User_Name] = @Name);
	IF(@Name_counter) > 1
		BEGIN 
			SET @MESSAGE = CONCAT_WS(' ', @Name,'is Repeated',@Name_counter,'times')
		END
	ELSE IF (@Name_counter) = 1
		BEGIN 
			SET @MESSAGE = CONCAT_WS(' ', @Name,'is not duplicated')
		END
	ELSE
		BEGIN 
			SET @MESSAGE = CONCAT_WS(' ', @Name,'is Not Found')
		END
	RETURN @MESSAGE;
END
GO

-- 22.Create a scalar function that takes date and Format to return Date With 
--    That Format. 
GO
CREATE OR ALTER FUNCTION FormatDate(@Date DATE ,@FORMAT NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
	RETURN FORMAT(@Date,@FORMAT)
END
GO

SELECT dbo.FormatDate(GETDATE(), 'yyyy-MM-dd'); 
SELECT dbo.FormatDate(GETDATE(), 'MMMM dd, yyyy');
SELECT dbo.FormatDate(GETDATE(), 'MM/dd/yyyy');
-----------------------------------------------------------------------------------
-- 23.Create a stored procedure to show the number of books per Category.
GO
CREATE PROCEDURE ShowBooksPerCategory
AS
BEGIN
    SELECT B.Cat_id AS 'Category', COUNT(B.Id) AS NumberOfBooks
    FROM Book B
    GROUP BY B.Cat_id
END;
GO


-- 24.Create a stored procedure that will be used in case there is an old manager 
--    who has left the floor and a new one becomes his replacement. The 
--    procedure should take 3 parameters (old Emp.id, new Emp.id and the 
--    floor number) and it will be used to update the floor table.
GO
CREATE PROCEDURE UpdateManagerForFloor
    @OldEmpID INT,      
    @NewEmpID INT,      
    @FloorNumber INT    
AS
BEGIN
    UPDATE Floor 
    SET MG_ID = @NewEmpID
    WHERE MG_ID = @OldEmpID
    AND Number = @FloorNumber;
    
END;
GO

----------------------------------------------------------------------------
-- 25.Create a view AlexAndCairoEmp that displays Employee data for users 
--    who live in Alex or Cairo. 
GO
CREATE OR ALTER VIEW AlexAndCairoEmp
AS
	SELECT *
	FROM Employee E 
	WHERE E.[Address] in ('Alex','Cairo');
GO

SELECT * FROM AlexAndCairoEmp ;

-- 26.create a view "V2" That displays number of books per shelf 
GO
CREATE OR ALTER VIEW V2
AS
	SELECT B.Shelf_code , COUNT(B.Id) AS 'Books_per_shelf'
	FROM Book B
	GROUP BY B.Shelf_code;
GO

SELECT * FROM V2;

-- 27.create a view "V3" That display  the shelf code that have maximum 
--    number of  books using the previous view "V2"
GO
CREATE OR ALTER VIEW V3
AS
	SELECT Shelf_code
    FROM V2
    WHERE Books_per_shelf = (
        SELECT MAX(Books_per_shelf)
        FROM V2
    );
GO

SELECT * FROM V3;

-----------------------------------------------------------------------------------
-- 28.Create a table named ‘ReturnedBooks’ With the Following Structure : 
-- User SSN - Book Id - Due Date - fees - Return Date 
GO
CREATE TABLE ReturnedBooks
(
	User_SSN VARCHAR(50) ,
	Book_id INT ,
	Due_Date DATE ,
	Fees INT,
	Return_Date DATE
	PRIMARY KEY (User_SSN, Book_id),
    FOREIGN KEY (User_SSN) REFERENCES Users(SSN),
    FOREIGN KEY (Book_id) REFERENCES Book(id)
)
GO
-- then create A trigger that instead of inserting the data of returned book 
-- checks if the return date is the due date  or not if not so the user must pay 
-- a fee and it will be 20% of the amount that was paid before. 
GO
CREATE TRIGGER trg_CheckReturnDate
ON ReturnedBooks
INSTEAD OF INSERT
AS
BEGIN 
	DECLARE @User_SSN VARCHAR(50);
    DECLARE @Book_id INT;
    DECLARE @Return_Date DATE;
    DECLARE @Due_Date DATE;
    DECLARE @Fees INT;
    DECLARE @AmountPaid INT;

    SELECT @User_SSN = User_SSN, @Book_id = Book_id, @Return_Date = Return_Date, @Due_Date = Due_Date
    FROM inserted;


	IF @Return_Date > @Due_Date
	BEGIN 
		SELECT @AmountPaid = Amount
			FROM Borrowing
			WHERE User_SSN = @User_SSN AND Book_id = @Book_id;
		IF @AmountPaid IS NOT NULL
        BEGIN
            SET @Fees = @AmountPaid * 0.2;
        END
	END
	INSERT INTO ReturnedBooks (User_SSN, Book_id, Due_Date, Fees, Return_Date)
    VALUES (@User_SSN, @Book_id, @Due_Date, @Fees, @Return_Date);

END
GO

-- 29.In the Floor table insert new Floor With Number of blocks 2 , employee 
--	  with SSN = 20 as a manager for this Floor,The start date for this manager 
--    is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5) 
--    moved to be the manager of the new Floor (id = 7), and they give Mr. Ali 
--    Mohamed(his SSN =12) His position . 
INSERT INTO Floor (Number,Num_blocks,MG_ID,Hiring_Date)
VALUES (7,2,20,GETDATE());

UPDATE  Floor
SET MG_ID =12
WHERE MG_ID =5;

UPDATE  Floor
SET MG_ID =5
WHERE Number = 7;

-- 30. Create view name (v_2006_check)  that will display Manager id, Floor 
--	   Number where he/she works , Number of Blocks and the Hiring Date 
--	   which must be from the first of March and the end of May 2022.this view 
--	   will be used to insert data so make sure that the coming new data must 
--	   match the condition then try to insert this 2 rows and Mention What will happen

--		Employee Id  Floor Number - Number of Blocks - Hiring Date 
--			2				6				2			7-8-2023
--			4				7				1			4-8-2022 
GO
CREATE OR ALTER VIEW v_2006_check AS
SELECT 
    Number, 
    MG_ID, 
    Num_blocks, 
    Hiring_Date
FROM Floor
WHERE Hiring_Date BETWEEN '2022-03-01' AND '2022-05-31' WITH CHECK option;
GO

INSERT INTO v_2006_check (MG_ID, Number, Num_blocks, Hiring_Date)
VALUES 
(2, 8, 2, '2023-07-08'),
(4, 9, 1, '2022-04-08');
-- The attempted insert or update failed because the target view either specifies 
-- WITH CHECK OPTION or spans a view that specifies WITH CHECK OPTION and one or 
-- more rows resulting from the operation did not qualify under the CHECK OPTION constraint.


-- 31.Create a trigger to prevent anyone from Modifying or Delete or Insert in 
--	  the Employee table ( Display a message for user to tell him that he can’t 
--	  take any action with this Table)
GO
CREATE TRIGGER TR_Prevent_EmployeeInsert
ON dbo.Employee
INSTEAD OF INSERT , DELETE , UPDATE
AS
	BEGIN
		PRINT('You can’t take any action with this Table');
		ROLLBACK
	END;
GO

DISABLE TRIGGER TR_Prevent_EmployeeInsert
ON dbo.Employee
-- 32.Testing Referential Integrity , Mention What Will Happen When: 
--    A. Add a new User Phone Number with User_SSN = 50 in User_Phones Table
INSERT INTO User_Phones (User_SSN,Phone_num)
VALUES (50, '1234567890');

-- The INSERT statement conflicted with the FOREIGN KEY constraint "FK_User_phones_User". 
-- The conflict occurred in database "Libary2", table "dbo.Users", column 'SSN'.

--    B. Modify the employee id 20 in the employee table to 21
UPDATE Employee
SET Id = 21
WHERE Id = 20;
-- Cannot update identity column 'Id'.

--    C. Delete the employee with id 1 

DELETE FROM Employee
WHERE Id = 1;
-- The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee".
-- The conflict occurred in database "Libary2", table "dbo.Borrowing", column 'Emp_id'.

--    D. Delete the employee with id 12 

DELETE FROM Employee
WHERE Id = 12;
-- The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee".
-- The conflict occurred in database "Libary2", table "dbo.Borrowing", column 'Emp_id'.

--    E. Create an index on column (Salary) that allows you to cluster the data in table Employee.

-- CREATE CLUSTERED INDEX idx_salary
-- ON Employee(Salary);
-- Cannot create more than one clustered index on table 'Employee'. 
-- Drop the existing clustered index 'PK_Employee' before creating another.


-- 33.Try to Create Login With Your Name And give yourself access Only to 
--    Employee and Floor tables then allow this login to select and insert data 
--    into tables and deny Delete and update (Don't Forget To take screenshot to every step) 

-- USING GUI