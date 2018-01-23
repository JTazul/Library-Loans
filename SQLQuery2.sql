-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

GO
CREATE PROCEDURE db_skill1
AS
SELECT 'Sharpstown Branch' AS '"The Lost Tribe" (All Editions)', SUM(copies_count)
AS'# of Copies'
FROM tbl_copies
WHERE copies_bookid LIKE 'Lost%' AND copies_branchiD LIKE'Sharp'
GO


--2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

GO
CREATE PROCEDURE db_skill2
AS
SELECT
	a1.branch_name AS 'Branch Name', SUM (a2.copies_count) AS '"The Lost Tribe" (All Editions)'
FROM tbl_branch a1
	INNER JOIN tbl_copies a2 ON a2.copies_branchid = a1.branch_branchid
WHERE a2.copies_bookid LIKE 'Lost%'
GROUP BY a1.branch_name
GO


--3. Retrieve the names of all borrowers who do not have any books checked out.
GO
CREATE PROCEDURE db_skill3
AS
SELECT
	a1.borrower_name AS 'Members Without Book Loans'
FROM tbl_borrower a1 
	LEFT JOIN tbl_loans a2 ON a2.loans_cardnum = a1.borrower_cardnum
WHERE a2.loans_outdate IS NULL
GO

/*4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is today, 
retrieve the book title, the borrower's name, and the borrower's address.
*/

GO
CREATE PROCEDURE db_skill4
AS
SELECT
	a1.borrower_name AS 'Borrower', a1.borrower_address AS 'Address', a3.book_title AS 'Books Due Today' 
FROM tbl_borrower a1 
	INNER JOIN tbl_loans a2 ON a2.loans_cardnum = a1.borrower_cardnum
	INNER JOIN tbl_book a3 ON a3.book_bookid = a2.loans_bookid
WHERE a2.loans_duedate = '01-22-2018' AND a2.loans_branchid LIKE 'Sharp%'
GO

/* 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.*/


GO
CREATE PROCEDURE db_skill5
AS
SELECT
	a1.branch_name AS 'Branch', COUNT(a2.loans_bookid) AS 'Books on Loan'
FROM tbl_branch a1 
	INNER JOIN tbl_loans a2 ON a2.loans_branchid = a1.branch_branchid
GROUP BY a1.branch_name
GO


/* 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.*/


GO
CREATE PROCEDURE db_skill6
AS
SELECT
	 COUNT(a1.loans_cardnum) AS 'Books Checked Out', a2.borrower_name AS 'Borrower', a2.borrower_address
FROM tbl_loans a1 
	INNER JOIN tbl_borrower a2 ON a2.borrower_cardnum = a1.loans_cardnum
GROUP BY a2.borrower_name, a2.borrower_address
HAVING COUNT(a1.loans_cardnum) >= 5
GO

/* 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".*/

GO
CREATE PROCEDURE db_skill7
AS
SELECT
	a1.book_title AS 'Book Title', COUNT(a2.copies_bookid) AS 'Books Checked Out', a4.branch_name AS 'Branch Name'
FROM tbl_book a1 
	INNER JOIN tbl_copies a2 ON a2.copies_bookid = a1.book_bookid
	INNER JOIN tbl_authors a3 ON a3.authors_bookid = a1.book_bookid
	INNER JOIN tbl_branch a4 ON a2.copies_branchid = a4.branch_branchid
WHERE a3.authors_name LIKE 'Stephen King' AND a4.branch_name = 'Central'
GROUP BY a1.book_title, a4.branch_name
GO