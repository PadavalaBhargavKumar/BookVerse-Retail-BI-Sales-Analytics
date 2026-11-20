-- BookVerse SQL analysis queries
-- These are reproducible portfolio queries authored from the documented
-- BookVerse schema and analysis objectives. They are not represented as
-- a verbatim export of the original working SQL file.
USE BookVerse_DB;

-- =========================================================
-- 1. Basic database exploration
-- =========================================================
SELECT COUNT(*) AS Total_Books FROM Books;
SELECT COUNT(*) AS Total_Customers FROM Customers;
SELECT COUNT(*) AS Total_Orders FROM Orders;
SELECT DISTINCT Genre FROM Books ORDER BY Genre;
SELECT DISTINCT Country FROM Customers ORDER BY Country;

SELECT
    SUM(Quantity) AS Total_Units_Sold,
    SUM(Total_Amount) AS Total_Recorded_Sales,
    AVG(Total_Amount) AS Average_Order_Amount
FROM Orders;

-- =========================================================
-- 2. Sales performance
-- =========================================================
SELECT
    YEAR(Order_Date) AS Order_Year,
    COUNT(*) AS Order_Count,
    SUM(Quantity) AS Units_Sold,
    SUM(Total_Amount) AS Recorded_Sales
FROM Orders
GROUP BY YEAR(Order_Date)
ORDER BY Order_Year;

SELECT
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    COUNT(*) AS Order_Count,
    SUM(Quantity) AS Units_Sold,
    SUM(Total_Amount) AS Recorded_Sales
FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Order_Year, Order_Month;

SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    SUM(o.Quantity) AS Units_Sold,
    SUM(o.Total_Amount) AS Recorded_Revenue
FROM Orders AS o
JOIN Books AS b ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID, b.Title, b.Author
ORDER BY Recorded_Revenue DESC
LIMIT 10;

SELECT
    b.Author,
    SUM(o.Quantity) AS Units_Sold,
    SUM(o.Total_Amount) AS Recorded_Revenue
FROM Orders AS o
JOIN Books AS b ON o.Book_ID = b.Book_ID
GROUP BY b.Author
ORDER BY Recorded_Revenue DESC
LIMIT 10;

-- =========================================================
-- 3. Customer purchasing behaviour
-- =========================================================
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Number_Of_Orders,
    SUM(o.Total_Amount) AS Total_Customer_Spend,
    SUM(o.Quantity) AS Total_Units_Purchased
FROM Customers AS c
JOIN Orders AS o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Customer_Spend DESC;

SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Number_Of_Orders
FROM Customers AS c
JOIN Orders AS o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) > 1
ORDER BY Number_Of_Orders DESC;

SELECT
    c.Country,
    COUNT(DISTINCT c.Customer_ID) AS Active_Customers,
    COUNT(o.Order_ID) AS Order_Count,
    SUM(o.Total_Amount) AS Recorded_Sales
FROM Customers AS c
JOIN Orders AS o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Country
ORDER BY Recorded_Sales DESC;

SELECT
    c.Customer_ID,
    c.Name,
    COUNT(DISTINCT b.Genre) AS Different_Genres_Purchased
FROM Customers AS c
JOIN Orders AS o ON c.Customer_ID = o.Customer_ID
JOIN Books AS b ON o.Book_ID = b.Book_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(DISTINCT b.Genre) > 1
ORDER BY Different_Genres_Purchased DESC;

-- =========================================================
-- 4. Product and genre performance
-- =========================================================
SELECT
    b.Genre,
    SUM(o.Quantity) AS Units_Sold,
    SUM(o.Total_Amount) AS Recorded_Revenue
FROM Books AS b
JOIN Orders AS o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Recorded_Revenue DESC;

SELECT
    b.Book_ID,
    b.Title,
    b.Genre,
    SUM(o.Quantity) AS Units_Sold,
    SUM(o.Total_Amount) AS Recorded_Revenue
FROM Books AS b
JOIN Orders AS o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Genre
ORDER BY Units_Sold DESC
LIMIT 10;

SELECT
    b.Book_ID,
    b.Title,
    b.Genre
FROM Books AS b
LEFT JOIN Orders AS o ON b.Book_ID = o.Book_ID
WHERE o.Order_ID IS NULL
ORDER BY b.Book_ID;

-- =========================================================
-- 5. Inventory position
-- =========================================================
SELECT
    SUM(Stock) AS Total_On_Hand_Units,
    SUM(Price * Stock) AS Catalog_Price_Inventory_Value
FROM Books;

SELECT
    Genre,
    SUM(Stock) AS Total_Stock_Units,
    SUM(Price * Stock) AS Catalog_Price_Inventory_Value
FROM Books
GROUP BY Genre
ORDER BY Catalog_Price_Inventory_Value DESC;

SELECT
    Book_ID,
    Title,
    Genre,
    Stock
FROM Books
WHERE Stock <= 10
ORDER BY Stock ASC, Title;

SELECT
    b.Book_ID,
    b.Title,
    b.Genre,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Units_Sold,
    COALESCE(SUM(o.Total_Amount), 0) AS Recorded_Revenue
FROM Books AS b
LEFT JOIN Orders AS o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Genre, b.Stock
HAVING b.Stock <= 10 AND Units_Sold > 0
ORDER BY Units_Sold DESC;

SELECT
    b.Book_ID,
    b.Title,
    b.Genre,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Units_Sold,
    COALESCE(SUM(o.Total_Amount), 0) AS Recorded_Revenue
FROM Books AS b
LEFT JOIN Orders AS o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Genre, b.Stock
HAVING b.Stock >= 50 AND Units_Sold <= 3
ORDER BY b.Stock DESC, Units_Sold ASC;

-- =========================================================
-- 6. Cross-functional review: sales and inventory
-- =========================================================
-- Review candidates only. Validate stock timing, margin, and business
-- context before making replenishment or markdown decisions.
SELECT
    b.Book_ID,
    b.Title,
    b.Genre,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Units_Sold,
    COALESCE(SUM(o.Total_Amount), 0) AS Recorded_Revenue,
    CASE
        WHEN b.Stock <= 10 AND COALESCE(SUM(o.Quantity), 0) >= 10
            THEN 'Review for possible replenishment'
        WHEN b.Stock >= 50 AND COALESCE(SUM(o.Quantity), 0) <= 3
            THEN 'Review for slow-moving stock'
        ELSE 'Monitor'
    END AS Inventory_Review_Flag
FROM Books AS b
LEFT JOIN Orders AS o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Genre, b.Stock
ORDER BY Inventory_Review_Flag, Units_Sold DESC;
