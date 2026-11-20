-- BookVerse data validation queries
USE BookVerse_DB;

-- 1. Row counts
SELECT 'Books' AS Table_Name, COUNT(*) AS Total_Records FROM Books
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders;

-- 2. Missing values in important fields
SELECT
    SUM(Book_ID IS NULL) AS Missing_Book_ID,
    SUM(Title IS NULL OR TRIM(Title) = '') AS Missing_Title,
    SUM(Author IS NULL OR TRIM(Author) = '') AS Missing_Author
FROM Books;

SELECT
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Email IS NULL OR TRIM(Email) = '') AS Missing_Email
FROM Customers;

SELECT
    SUM(Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Customer_ID IS NULL) AS Missing_Order_Customer_ID,
    SUM(Book_ID IS NULL) AS Missing_Order_Book_ID,
    SUM(Order_Date IS NULL) AS Missing_Order_Date
FROM Orders;

-- 3. Duplicate primary-key checks
SELECT Book_ID, COUNT(*) AS Duplicate_Count
FROM Books
GROUP BY Book_ID
HAVING COUNT(*) > 1;

SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT Order_ID, COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- 4. Foreign-key consistency checks
SELECT o.*
FROM Orders AS o
LEFT JOIN Customers AS c ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

SELECT o.*
FROM Orders AS o
LEFT JOIN Books AS b ON o.Book_ID = b.Book_ID
WHERE b.Book_ID IS NULL;

-- 5. Duplicate full-row checks (review any returned rows)
SELECT Book_ID, Title, Author, Genre, Published_Year, Price, Stock, COUNT(*) AS Row_Count
FROM Books
GROUP BY Book_ID, Title, Author, Genre, Published_Year, Price, Stock
HAVING COUNT(*) > 1;

SELECT Customer_ID, Name, Email, Phone, City, Country, COUNT(*) AS Row_Count
FROM Customers
GROUP BY Customer_ID, Name, Email, Phone, City, Country
HAVING COUNT(*) > 1;

SELECT Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount, COUNT(*) AS Row_Count
FROM Orders
GROUP BY Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount
HAVING COUNT(*) > 1;
