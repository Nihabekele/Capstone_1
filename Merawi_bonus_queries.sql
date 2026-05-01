use sample_sales;

-- SELECT, Filtering & Sorting

-- Question 1.Create a list of all transactions that took place on January 15, 2024, sorted by sale amount from
-- highest to lowest

SELECT 
    'Store' AS Source,
    Sale_Amount AS Amount, 
    Transaction_Date AS T_Date, 
    Prod_Num AS Product_ID
FROM store_sales
WHERE Transaction_Date = '2024-01-15'

UNION ALL

SELECT 
    'Online' AS Source,
    SalesTotal AS Amount, 
    Date AS T_Date, 
    ProdNum AS Product_ID
FROM online_sales
WHERE Date = '2024-01-15'

ORDER BY Amount DESC;

-- Aggregation

-- Question 4. What is the total sales revenue across all transactions? What is the average transaction amount?

SELECT 
    SUM(total_combined.amount) AS Total_Revenue,
    AVG(total_combined.amount) AS Average_Transaction_Size
FROM (
    SELECT Sale_Amount AS amount FROM store_sales
    UNION ALL
    SELECT SalesTotal AS amount FROM online_sales
) AS total_combined;

-- Joins

-- Question 9. Find all sales records where the category is either "Textbooks" or "Technology & Accessories."

SELECT 
    c.Category AS Category_Name, 
    s.Prod_Num, 
    s.Sale_Amount, 
    s.Transaction_Date
FROM store_sales AS s
JOIN products AS p 
    ON s.Prod_Num = p.ProdNum
JOIN inventory_categories AS c 
    ON p.Categoryid = c.Categoryid
WHERE c.Category = 'Textbooks' 
   OR c.Category = 'Technology & Accessories'
ORDER BY c.Category;

-- Subqueries

-- Question 17. Using a subquery, find all transactions from stores located in Texas.

SELECT * FROM management WHERE State = 'Texas';

SELECT * FROM store_sales
WHERE Store_ID IN (
    SELECT (id + 700)
    FROM management
    WHERE State = 'Texas'
);

-- Question 18. Which stores had total sales above the average store revenue? (Hint: use a subquery to calculate the
-- average first.)

SELECT * FROM store_sales
WHERE Sale_Amount > (
    SELECT AVG(Sale_Amount) 
    FROM store_sales
);