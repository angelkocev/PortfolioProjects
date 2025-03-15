# Library Management System

USE library_db;

-- This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, 
-- performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

# Objectives:

-- Set up the Library Management System Database: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
-- CRUD Operations: Perform Create, Read, Update, and Delete operations on the data.
-- CTAS (Create Table As Select): Utilize CTAS to create new tables based on query results.
-- Advanced SQL Queries: Develop complex queries to analyze and retrieve specific data.

# Creating Tables

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
	(
    branch_id VARCHAR(10) PRIMARY KEY,	
	manager_id VARCHAR(10),	
	branch_address VARCHAR(70),	
	contact_no VARCHAR(10)
    );

ALTER TABLE branch
MODIFY COLUMN contact_no VARCHAR(15);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees
	(
	emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(35),
    position VARCHAR(20),
    salary INT,
    branch_id VARCHAR(10) -- FK
    );
 
 DROP TABLE IF EXISTS books;
 CREATE TABLE books
	 (isbn VARCHAR(20) PRIMARY KEY,
     book_title VARCHAR(75),
     category VARCHAR(20),
     rental_price FLOAT,
     status VARCHAR(10),
     author VARCHAR(25),
     publisher VARCHAR(30)
	 );
    
DROP TABLE IF EXISTS members;
CREATE TABLE members
	(
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(50),
    member_address VARCHAR(70),
    reg_date DATE
    );

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
	(issued_id VARCHAR(10) PRIMARY KEY,	
    issued_member_id VARCHAR(10), -- FK
    issued_book_name VARCHAR(75),	
    issued_date	DATE,
    issued_book_isbn VARCHAR(20), -- FK
    issued_emp_id VARCHAR(10) -- FK
    );

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
	(return_id VARCHAR(10) PRIMARY KEY,	
    issued_id VARCHAR(10), -- FK	
    return_book_name VARCHAR(75), 
    return_date DATE,	
    return_book_isbn VARCHAR(10)
    );
    
-- Foreign Key

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

# Inserting values into tables

-- Insert values into each members table

INSERT INTO members(member_id, member_name, member_address, reg_date) 
VALUES
('C101', 'Alice Johnson', '123 Main St', '2021-05-15'),
('C102', 'Bob Smith', '456 Elm St', '2021-06-20'),
('C103', 'Carol Davis', '789 Oak St', '2021-07-10'),
('C104', 'Dave Wilson', '567 Pine St', '2021-08-05'),
('C105', 'Eve Brown', '890 Maple St', '2021-09-25'),
('C106', 'Frank Thomas', '234 Cedar St', '2021-10-15'),
('C107', 'Grace Taylor', '345 Walnut St', '2021-11-20'),
('C108', 'Henry Anderson', '456 Birch St', '2021-12-10'),
('C109', 'Ivy Martinez', '567 Oak St', '2022-01-05'),
('C110', 'Jack Wilson', '678 Pine St', '2022-02-25'),
('C118', 'Sam', '133 Pine St', '2024-06-01'),    
('C119', 'John', '143 Main St', '2024-05-01');

-- Insert values into each branch table

INSERT INTO branch(branch_id, manager_id, branch_address, contact_no) 
VALUES
('B001', 'E109', '123 Main St', '+919099988676'),
('B002', 'E109', '456 Elm St', '+919099988677'),
('B003', 'E109', '789 Oak St', '+919099988678'),
('B004', 'E110', '567 Pine St', '+919099988679'),
('B005', 'E110', '890 Maple St', '+919099988680');

-- Insert values into each employees table

INSERT INTO employees(emp_id, emp_name, position, salary, branch_id) 
VALUES
('E101', 'John Doe', 'Clerk', 60000.00, 'B001'),
('E102', 'Jane Smith', 'Clerk', 45000.00, 'B002'),
('E103', 'Mike Johnson', 'Librarian', 55000.00, 'B001'),
('E104', 'Emily Davis', 'Assistant', 40000.00, 'B001'),
('E105', 'Sarah Brown', 'Assistant', 42000.00, 'B001'),
('E106', 'Michelle Ramirez', 'Assistant', 43000.00, 'B001'),
('E107', 'Michael Thompson', 'Clerk', 62000.00, 'B005'),
('E108', 'Jessica Taylor', 'Clerk', 46000.00, 'B004'),
('E109', 'Daniel Anderson', 'Manager', 57000.00, 'B003'),
('E110', 'Laura Martinez', 'Manager', 41000.00, 'B005'),
('E111', 'Christopher Lee', 'Assistant', 65000.00, 'B005');

-- Inserting into books table 
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) 
VALUES
('978-0-553-29698-2', 'The Catcher in the Rye', 'Classic', 7.00, 'yes', 'J.D. Salinger', 'Little, Brown and Company'),
('978-0-330-25864-8', 'Animal Farm', 'Classic', 5.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-14-118776-1', 'One Hundred Years of Solitude', 'Literary Fiction', 6.50, 'yes', 'Gabriel Garcia Marquez', 'Penguin Books'),
('978-0-525-47535-5', 'The Great Gatsby', 'Classic', 8.00, 'yes', 'F. Scott Fitzgerald', 'Scribner'),
('978-0-141-44171-6', 'Jane Eyre', 'Classic', 4.00, 'yes', 'Charlotte Bronte', 'Penguin Classics'),
('978-0-307-37840-1', 'The Alchemist', 'Fiction', 2.50, 'yes', 'Paulo Coelho', 'HarperOne'),
('978-0-679-76489-8', 'Harry Potter and the Sorcerers Stone', 'Fantasy', 7.00, 'yes', 'J.K. Rowling', 'Scholastic'),
('978-0-7432-4722-4', 'The Da Vinci Code', 'Mystery', 8.00, 'yes', 'Dan Brown', 'Doubleday'),
('978-0-09-957807-9', 'A Game of Thrones', 'Fantasy', 7.50, 'yes', 'George R.R. Martin', 'Bantam'),
('978-0-393-05081-8', 'A Peoples History of the United States', 'History', 9.00, 'yes', 'Howard Zinn', 'Harper Perennial'),
('978-0-19-280551-1', 'The Guns of August', 'History', 7.00, 'yes', 'Barbara W. Tuchman', 'Oxford University Press'),
('978-0-307-58837-1', 'Sapiens: A Brief History of Humankind', 'History', 8.00, 'no', 'Yuval Noah Harari', 'Harper Perennial'),
('978-0-375-41398-8', 'The Diary of a Young Girl', 'History', 6.50, 'no', 'Anne Frank', 'Bantam'),
('978-0-14-044930-3', 'The Histories', 'History', 5.50, 'yes', 'Herodotus', 'Penguin Classics'),
('978-0-393-91257-8', 'Guns, Germs, and Steel: The Fates of Human Societies', 'History', 7.00, 'yes', 'Jared Diamond', 'W. W. Norton & Company'),
('978-0-7432-7357-1', '1491: New Revelations of the Americas Before Columbus', 'History', 6.50, 'no', 'Charles C. Mann', 'Vintage Books'),
('978-0-679-64115-3', '1984', 'Dystopian', 6.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-14-143951-8', 'Pride and Prejudice', 'Classic', 5.00, 'yes', 'Jane Austen', 'Penguin Classics'),
('978-0-452-28240-7', 'Brave New World', 'Dystopian', 6.50, 'yes', 'Aldous Huxley', 'Harper Perennial'),
('978-0-670-81302-4', 'The Road', 'Dystopian', 7.00, 'yes', 'Cormac McCarthy', 'Knopf'),
('978-0-385-33312-0', 'The Shining', 'Horror', 6.00, 'yes', 'Stephen King', 'Doubleday'),
('978-0-451-52993-5', 'Fahrenheit 451', 'Dystopian', 5.50, 'yes', 'Ray Bradbury', 'Ballantine Books'),
('978-0-345-39180-3', 'Dune', 'Science Fiction', 8.50, 'yes', 'Frank Herbert', 'Ace'),
('978-0-375-50167-0', 'The Road', 'Dystopian', 7.00, 'yes', 'Cormac McCarthy', 'Vintage'),
('978-0-06-025492-6', 'Where the Wild Things Are', 'Children', 3.50, 'yes', 'Maurice Sendak', 'HarperCollins'),
('978-0-06-112241-5', 'The Kite Runner', 'Fiction', 5.50, 'yes', 'Khaled Hosseini', 'Riverhead Books'),
('978-0-06-440055-8', 'Charlotte''s Web', 'Children', 4.00, 'yes', 'E.B. White', 'Harper & Row'),
('978-0-679-77644-3', 'Beloved', 'Fiction', 6.50, 'yes', 'Toni Morrison', 'Knopf'),
('978-0-14-027526-3', 'A Tale of Two Cities', 'Classic', 4.50, 'yes', 'Charles Dickens', 'Penguin Books'),
('978-0-7434-7679-3', 'The Stand', 'Horror', 7.00, 'yes', 'Stephen King', 'Doubleday'),
('978-0-451-52994-2', 'Moby Dick', 'Classic', 6.50, 'yes', 'Herman Melville', 'Penguin Books'),
('978-0-06-112008-4', 'To Kill a Mockingbird', 'Classic', 5.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'),
('978-0-553-57340-1', '1984', 'Dystopian', 6.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-7432-4722-5', 'Angels & Demons', 'Mystery', 7.50, 'yes', 'Dan Brown', 'Doubleday'),
('978-0-7432-7356-4', 'The Hobbit', 'Fantasy', 7.00, 'yes', 'J.R.R. Tolkien', 'Houghton Mifflin Harcourt');

-- Inserting into issued table

INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id) 
VALUES
('IS106', 'C106', 'Animal Farm', '2024-03-10', '978-0-330-25864-8', 'E104'),
('IS107', 'C107', 'One Hundred Years of Solitude', '2024-03-11', '978-0-14-118776-1', 'E104'),
('IS108', 'C108', 'The Great Gatsby', '2024-03-12', '978-0-525-47535-5', 'E104'),
('IS109', 'C109', 'Jane Eyre', '2024-03-13', '978-0-141-44171-6', 'E105'),
('IS110', 'C110', 'The Alchemist', '2024-03-14', '978-0-307-37840-1', 'E105'),
('IS111', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-03-15', '978-0-679-76489-8', 'E105'),
('IS112', 'C109', 'A Game of Thrones', '2024-03-16', '978-0-09-957807-9', 'E106'),
('IS113', 'C109', 'A Peoples History of the United States', '2024-03-17', '978-0-393-05081-8', 'E106'),
('IS114', 'C109', 'The Guns of August', '2024-03-18', '978-0-19-280551-1', 'E106'),
('IS115', 'C109', 'The Histories', '2024-03-19', '978-0-14-044930-3', 'E107'),
('IS116', 'C110', 'Guns, Germs, and Steel: The Fates of Human Societies', '2024-03-20', '978-0-393-91257-8', 'E107'),
('IS117', 'C110', '1984', '2024-03-21', '978-0-679-64115-3', 'E107'),
('IS118', 'C101', 'Pride and Prejudice', '2024-03-22', '978-0-14-143951-8', 'E108'),
('IS119', 'C110', 'Brave New World', '2024-03-23', '978-0-452-28240-7', 'E108'),
('IS120', 'C110', 'The Road', '2024-03-24', '978-0-670-81302-4', 'E108'),
('IS121', 'C102', 'The Shining', '2024-03-25', '978-0-385-33312-0', 'E109'),
('IS122', 'C102', 'Fahrenheit 451', '2024-03-26', '978-0-451-52993-5', 'E109'),
('IS123', 'C103', 'Dune', '2024-03-27', '978-0-345-39180-3', 'E109'),
('IS124', 'C104', 'Where the Wild Things Are', '2024-03-28', '978-0-06-025492-6', 'E110'),
('IS125', 'C105', 'The Kite Runner', '2024-03-29', '978-0-06-112241-5', 'E110'),
('IS126', 'C105', 'Charlotte''s Web', '2024-03-30', '978-0-06-440055-8', 'E110'),
('IS127', 'C105', 'Beloved', '2024-03-31', '978-0-679-77644-3', 'E110'),
('IS128', 'C105', 'A Tale of Two Cities', '2024-04-01', '978-0-14-027526-3', 'E110'),
('IS129', 'C105', 'The Stand', '2024-04-02', '978-0-7434-7679-3', 'E110'),
('IS130', 'C106', 'Moby Dick', '2024-04-03', '978-0-451-52994-2', 'E101'),
('IS131', 'C106', 'To Kill a Mockingbird', '2024-04-04', '978-0-06-112008-4', 'E101'),
('IS132', 'C106', 'The Hobbit', '2024-04-05', '978-0-7432-7356-4', 'E106'),
('IS133', 'C107', 'Angels & Demons', '2024-04-06', '978-0-7432-4722-5', 'E106'),
('IS134', 'C107', 'The Diary of a Young Girl', '2024-04-07', '978-0-375-41398-8', 'E106'),
('IS135', 'C107', 'Sapiens: A Brief History of Humankind', '2024-04-08', '978-0-307-58837-1', 'E108'),
('IS136', 'C107', '1491: New Revelations of the Americas Before Columbus', '2024-04-09', '978-0-7432-7357-1', 'E102'),
('IS137', 'C107', 'The Catcher in the Rye', '2024-04-10', '978-0-553-29698-2', 'E103'),
('IS138', 'C108', 'The Great Gatsby', '2024-04-11', '978-0-525-47535-5', 'E104'),
('IS139', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-04-12', '978-0-679-76489-8', 'E105'),
('IS140', 'C110', 'Animal Farm', '2024-04-13', '978-0-330-25864-8', 'E102');

-- Inserting into return table

INSERT INTO return_status(return_id, issued_id, return_date) 
VALUES
('RS104', 'IS106', '2024-05-01'),
('RS105', 'IS107', '2024-05-03'),
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');

# Data Exploration

SELECT *
FROM books;

SELECT *
FROM branch;

SELECT *
FROM issued_status;

SELECT *
FROM return_status;

SELECT *
FROM employees;

SELECT *
FROM members;

# CRUD Operations

-- Create: Inserted sample records into the books table.
-- Read: Retrieved and displayed data from various tables.
-- Update: Updated records in the employees table.
-- Delete: Removed records from the members table as needed.

-- Project tasks

-- Task 1: Create a New Book Record: "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co."

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ("978-1-60129-456-2", "To Kill a Mockingbird", "Classic", 6.00, "yes", "Harper Lee", "J.B. Lippincott & Co.");

-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = "125 Main St"
WHERE member_id = "C101";

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = "IS121";

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT issued_book_name
FROM issued_status
WHERE issued_emp_id = "E101";

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

WITH CTE AS (
	SELECT issued_member_id, 
		COUNT(*) AS number_of_issued_books
	FROM issued_status
	GROUP BY issued_member_id
	HAVING number_of_issued_books > 1)
SELECT issued_member_id
FROM CTE;

-- CTAS (Create Table As Select)

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_counts
AS 
SELECT b.isbn, b.book_title, 
	COUNT(st.issued_id) AS number_issued
FROM books AS b
LEFT JOIN issued_status AS st
	ON b.isbn = st.issued_book_isbn
GROUP BY b.isbn, b.book_title;

SELECT *
FROM book_counts;

-- Data Analysis & Findings

-- The following SQL queries were used to address specific questions
-- Task 7. Retrieve All Books in a Specific Category

SELECT *
FROM books
WHERE category = "History";

-- Task 8: Find Total Rental Income by Category:

SELECT b.category,
	SUM(b.rental_price) AS total_rental_income
FROM issued_status AS st
INNER JOIN books AS b
	ON st.issued_book_isbn = b.isbn
GROUP BY b.category;

-- Task 9: List Members Who Registered in the Last Year

SELECT * 
FROM members
WHERE reg_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);

-- Task 10: List Employees with Their Branch Manager's Name and their branch details

SELECT 
	e.emp_id,
    e.emp_name, 
	e.position, 
    e.salary,
    emp.emp_name AS manager_name,
    b.branch_address,
    b.contact_no
FROM employees AS e
INNER JOIN branch AS b
	ON e.branch_id = b.branch_id
INNER JOIN employees AS emp
	ON emp.emp_id = b.manager_id;
    
-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold

CREATE TABLE expensive_books
AS
SELECT *
FROM books
WHERE rental_price > 7;

SELECT *
FROM expensive_books;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT st.issued_book_name
FROM issued_status AS st
LEFT JOIN return_status AS rs
	ON st.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;

# Inserting values into book issued (issued_status) table in last 30 days

INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 DAY,  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 DAY,  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL 7 DAY,  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL 32 DAY,  '978-0-375-50167-0', 'E101');

# Adding new column in returned books (return_status) table and updating values in that column

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');

# Data Exploration after modifying tables

SELECT *
FROM issued_status;

SELECT *
FROM return_status;

# Advanced SQL Operations

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). 
		-- Display the member's_id, member's name, book title, issue date, and days overdue.
        
SELECT CURRENT_DATE - issued_date
FROM issued_status;

SELECT st.issued_member_id, m.member_name, st.issued_book_name, st.issued_date, rs.return_date,
	CASE 
		WHEN rs.return_date IS NOT NULL THEN ABS(DATEDIFF(st.issued_date, rs.return_date))
        WHEN rs.return_date IS NULL THEN DATEDIFF(CURRENT_DATE, st.issued_date)
        END AS overdue_days
FROM issued_status AS st
INNER JOIN members AS m
	ON st.issued_member_id = m.member_id
LEFT JOIN return_status AS rs
	ON st.issued_id = rs.issued_id
HAVING overdue_days > 30
ORDER BY overdue_days DESC;

-- Task 14: Populating values in two columns based on the data in another tables

UPDATE return_status
INNER JOIN issued_status 
	ON return_status.issued_id = issued_status.issued_id
SET return_status.return_book_name = issued_status.issued_book_name;

DESCRIBE issued_status;
DESCRIBE return_status;

ALTER TABLE return_status
MODIFY COLUMN return_book_isbn VARCHAR(20);

UPDATE return_status 
INNER JOIN issued_status 
	ON return_status.issued_id = issued_status.issued_id
SET return_status.return_book_isbn = issued_status.issued_book_isbn; 

SELECT *
FROM return_status;

-- Task 15: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

SELECT *
FROM books;

DELIMITER $$
CREATE TRIGGER update_books_status
	AFTER INSERT ON return_status
    FOR EACH ROW
BEGIN
	-- Update the status of the book to 'yes' in the books table
	UPDATE books
    SET status = "yes"
    WHERE isbn = NEW.return_book_isbn;
END $$

DELIMITER ;

INSERT INTO return_status
VALUES ("RS119","IS136","1491: New Revelations of the Americas Before Columbus","2025-03-14","978-0-7432-7357-1","Good");

SELECT *
FROM return_status;

SELECT *
FROM books;

-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, 
			-- and the total revenue generated from book rentals.

SELECT br.branch_id, 
	COUNT(ist.issued_id) AS number_books_issued,
    COUNT(rs.return_id) AS number_books_returned,
    SUM(b.rental_price) AS total_revenue
FROM issued_status AS ist
LEFT JOIN return_status AS rs
	ON ist.issued_id = rs.issued_id
INNER JOIN books AS b
	ON ist.issued_book_isbn = b.isbn
INNER JOIN employees AS e
	ON ist.issued_emp_id = e.emp_id
INNER JOIN branch AS br
	ON e.branch_id = br.branch_id
GROUP BY br.branch_id;
            
-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

CREATE TABLE active_members
AS
SELECT m.member_id, m.member_name, m.member_address, m.reg_date, ist.issued_date, ist.issued_id
FROM issued_status AS ist
INNER JOIN members AS m
	ON ist.issued_member_id = m.member_id
WHERE ist.issued_date >= DATE_SUB(CURRENT_DATE, INTERVAL 2 MONTH);

SELECT *
FROM active_members;

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

SELECT e.emp_name, 
    br.branch_id,
    COUNT(ist.issued_id) AS number_books_processed
FROM issued_status AS ist
INNER JOIN employees AS e
	ON ist.issued_emp_id = e.emp_id
INNER JOIN branch AS br
	ON e.branch_id = br.branch_id
GROUP BY e.emp_name, br.branch_id
ORDER BY number_books_processed DESC
LIMIT 3;
    
-- Task 18: Identify Members Issuing High-Risk Books
-- Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. 
					-- Display the member name, book title, and the number of times they've issued damaged books.

SELECT m.member_name, ist.issued_book_name,
	COUNT(ist.issued_id) AS number_issued_books
FROM issued_status AS ist
LEFT JOIN return_status AS rs
	ON ist.issued_id = rs.issued_id
INNER JOIN members AS m
	ON m.member_id = ist.issued_member_id
WHERE rs.book_quality = "Damaged"
GROUP BY m.member_name, ist.issued_book_name
HAVING number_issued_books > 2;

-- Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
-- Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
				-- The procedure should function as follows: 
					-- The stored procedure should take the book_id as an input parameter. 
					-- The procedure should first check if the book is available (status = 'yes'). 
					-- If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
					-- If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

DELIMITER $$
CREATE PROCEDURE managing_status_of_books(IN b_isbn VARCHAR(20))
BEGIN
	DECLARE book_status VARCHAR(10);
    
    -- Check the current status of the book
    SELECT status INTO book_status
    FROM books
    WHERE isbn = b_isbn;
    
    -- If the book is available, issue it and update the status
    IF book_status = "yes" THEN
		update books
        SET status = "no"
        WHERE isbn = b_isbn;
        SELECT CONCAT("Book with ISBN", b_isbn, " has been issued.") AS message;
	
    -- If the book is not available, return an error message
    ELSE 
		SELECT CONCAT("Book with ISBN", b_isbn, " is currently not available.") AS message;
	END IF;
END $$;

DELIMITER ;

-- Testing the Procedure

CALL managing_status_of_books('978-0-06-440055-8');

CALL managing_status_of_books('978-0-307-58837-1');

-- Task 20: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
-- Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. 
					-- The table should include: 
						-- The number of overdue books. 
                        -- The total fines, with each day's fine calculated at $0.50. 
						-- The number of books issued by each member. 
                        -- The resulting table should show: Member ID Number of overdue books Total fines
                    
CREATE TABLE overdue_books
AS
WITH unresponsible_members AS (
	SELECT m.member_id, ist.issued_date,
		DATEDIFF(CURRENT_DATE, ist.issued_date) AS time_difference,
        (DATEDIFF(CURRENT_DATE, ist.issued_date) - 30) * 0.5 AS fine
	FROM issued_status AS ist
	INNER JOIN members AS m
		ON ist.issued_member_id = m.member_id
	LEFT JOIN return_status AS rs
		ON ist.issued_id = rs.issued_id
	WHERE rs.return_id IS NULL -- Books not returned
	HAVING time_difference > 30) -- Overdue by more than 30 days
SELECT member_id,
	COUNT(issued_date) AS overdue_books,
    SUM(fine) AS total_fine,
    (SELECT COUNT(*) FROM issued_status AS ist2 WHERE ist2.issued_member_id = member_id) AS number_of_issued_books
FROM unresponsible_members
GROUP BY member_id;

SELECT *
FROM overdue_books;

-- Task 21: Find the most popular book
				-- Write a query to find the most popular book (the book that has been issued the most number of times). 
						-- Display the book title, author, and the number of times it has been issued. 
                        
SELECT ist.issued_book_name, 
	b.author,
    COUNT(ist.issued_date) AS times_issued
FROM issued_status AS ist
INNER JOIN books AS b
	ON ist.issued_book_isbn = b.isbn
GROUP BY ist.issued_book_name, b.author
ORDER BY times_issued DESC
LIMIT 1;

-- Task 22: Identify members with no issued books
				-- Write a query to identify members who have not issued any books. Display the member ID and member name.

SELECT m.member_id, m.member_name
FROM members AS m
LEFT JOIN issued_status AS ist
	ON m.member_id = ist.issued_member_id
WHERE ist.issued_id IS NULL;

-- Task 23: Calculate average rental price by category
				-- Write a query to calculate the average rental price of books in each category. Display the category and average rental price.

SELECT category,
	ROUND(AVG(rental_price),1) AS average_rental_price
FROM books
GROUP BY category
ORDER BY average_rental_price DESC;

-- Task 24: Identify books never issued
				-- Write a query to identify books that have never been issued. Display the book title and author.

SELECT b.book_title, b.author
FROM books AS b
LEFT JOIN issued_status AS ist
	ON b.isbn = ist.issued_book_isbn
WHERE ist.issued_id IS NULL;

-- Task 25: Calculate total revenue by month
				-- Write a query to calculate the total revenue generated from book rentals for each month. Display the month and total revenue.

SELECT 
	DATE_FORMAT(ist.issued_date, "%Y-%m") AS month,
	SUM(rental_price) AS total_revenue
FROM issued_status AS ist
INNER JOIN books AS b
	ON ist.issued_book_isbn = b.isbn
GROUP BY month;

-- Task 26: Identify employees with the highest salary
				-- Write a query to identify the employee(s) with the highest salary. Display the employee ID, employee name, and salary.

SELECT emp_id, emp_name, salary
FROM employees
ORDER BY salary DESC;

SELECT emp_id, emp_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- Task 27: Identify members with expired memberships
				-- Write a query to identify members whose registration date is more than 3 years ago. Display the member ID, member name, and registration date.
		
SELECT *
FROM members
WHERE reg_date < DATE_SUB(CURRENT_DATE, INTERVAL 3 YEAR);

# End of project
