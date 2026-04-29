-- Project - Data Analytics Capstone 1
-- Territory - Territory 10 managed by Jim Heck in the West Region
-- Description - Analysis of store and online sales performance.

USE sample_sales;
-- I used DESCRIBE command to make sure I was using the correct column names
describe store_sales;
describe online_sales;
describe management;

-- I used the SELECT command to audit the management table and discovered that Jim Heck's unique ID is 10.

select * from sample_sales.management;

-- Question 1: Total Revenue and Date Range(start date and end date) for Jim Heck
-- I use MIN() for the start date and MAX() for the end date

SELECT 
    SUM(total.Money) AS Total_Revenue,
    MIN(total.T_Date) AS Start_Date,
    MAX(total.T_Date) AS End_Date
FROM (
    SELECT Sale_Amount AS Money, Transaction_Date AS T_Date, Store_ID FROM store_sales
    UNION ALL
    SELECT SalesTotal AS Money, Date AS T_Date, 10 AS Store_ID FROM online_sales
) AS total
JOIN management ON total.Store_ID = management.id
WHERE management.id = 10;

-- Question 2: Month-by-Month Revenue Breakdown
-- This combines both store and online sales, then groups them by month.

SELECT 
    DATE_FORMAT(total.T_Date, '%M %Y') AS Sales_Month,
    SUM(total.Money) AS Monthly_Revenue
FROM (
    SELECT Sale_Amount AS Money, Transaction_Date AS T_Date, Store_ID FROM store_sales
    UNION ALL
    SELECT SalesTotal AS Money, Date AS T_Date, 10 AS Store_ID FROM online_sales
) AS total
WHERE total.Store_ID = 10
GROUP BY Sales_Month
ORDER BY MIN(total.T_Date);


-- Question 3 Territory vs. Region Comparison
--  Compare Jim Heck's specific revenue to the entire West Region.
-- I combined Store and Online sales for Jim (ID 10) 
-- and compared them to the total for all West IDs (10, 11, 12).

-- Identify all Sales Managers assigned to the West Region
SELECT 
    id, SalesManager,Region,State
FROM management 
WHERE Region = 'West';

-- ROW 1: Jim's Total
SELECT 
    'Jim Heck (Territory 10)' AS Level, 
    SUM(total.Money) AS Total_Revenue
FROM (
    SELECT Sale_Amount AS Money, Store_ID FROM store_sales
    UNION ALL
    SELECT SalesTotal AS Money, 10 AS Store_ID FROM online_sales
) AS total
WHERE total.Store_ID = 10

UNION ALL

-- ROW 2: Entire West Region Total
SELECT 
    'West Region Total' AS Level, 
    SUM(total.Money) AS Total_Revenue
FROM (
    SELECT Sale_Amount AS Money, Store_ID FROM store_sales
    UNION ALL
    SELECT SalesTotal AS Money, 10 AS Store_ID FROM online_sales
) AS total
WHERE total.Store_ID IN (10, 11, 12);


-- Question 4: Sales Trends by Month and Category
-- Joining the sales tables to the product and category tables

SELECT 
    DATE_FORMAT(total.T_Date, '%M %Y') AS Sales_Month,
    c.Category AS Product_Category,
    COUNT(*) AS Number_of_Transactions,
    ROUND(AVG(total.Money), 2) AS Avg_Transaction_Size
FROM (
    SELECT Sale_Amount AS Money, Transaction_Date AS T_Date, Prod_Num AS Product_ID, Store_ID FROM store_sales
    UNION ALL
    SELECT SalesTotal AS Money, Date AS T_Date, ProdNum AS Product_ID, 10 AS Store_ID FROM online_sales
) AS total
JOIN products p ON total.Product_ID = p.ProdNum
JOIN inventory_categories c ON p.Categoryid = c.Categoryid
WHERE total.Store_ID = 10
GROUP BY Sales_Month, Product_Category
ORDER BY MIN(total.T_Date), Product_Category;


-- Question 5: Ranking Online Sales by State
-- This shows which states are buying the most from the online portal

SELECT 
    ShiptoState AS State, 
    SUM(SalesTotal) AS Total_Online_Sales
FROM online_sales
GROUP BY State
ORDER BY Total_Online_Sales DESC;

-- Question 6: My Recommendation 

-- my recommendation for the next quarter is focused on four main things I found in the data

-- ​1. Keep California as the Priority Since my Question 5 results showed California is our #1 state for online sales, we should focus our
--  biggest marketing efforts there. It's our most reliable source of income.
-- 2. I've also identified our lowest performing states, such as Minnesota and Montana, which may require a different strategy.
-- ​3. Promote Technology Products My analysis for Question 4 showed that Technology products have the highest average sales. I recommend we 
-- create a special promotion for these items to increase our total revenue even more.
-- ​4. Support the West Team I noticed that the other managers in the West aren't showing any sales yet.They are Categorized as online sales  
-- without a specific territory. I recommend assigning them specific states to manage, just like Jim Heck has Colorado. My final recommendation   
-- is to share Jim Heck's successful online strategies with the rest of the West team so the whole region can grow.


