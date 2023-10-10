--*Project #11 

--You are to develop SQL statements for each task listed.
--You should type your SQL statements under each task.
/* Submit your .sql file named with your last name, first name and Project # (e.g., Project11.sql).*/
-- It is your responsibility to provide a meaningful column name for the return value of the function
-- and use an appropriate sort order. All joins are to use the ANSI standard syntax.

USE SalesOrdersDb;
-- SalesOrdersDb wants geographic information about its resellers.
-- Be sure to add a meaningful sort as appropriate and give each derived column an alias.

--1a. First check to determine if there are resellers without geography info.
SELECT *
FROM [dbo].[DimReseller]
WHERE [GeographyKey] IS NULL;

--1b. Display a count of resellers in each Country.
-- Show country name and the count of resellers.
SELECT G.EnglishCountryRegionName, COUNT(*) AS ResellerCount
FROM [dbo].[DimReseller] AS R
INNER JOIN [dbo].[DimGeography] AS G
ON G.GeographyKey = R.GeographyKey
GROUP BY G.EnglishCountryRegionName
ORDER BY G.EnglishCountryRegionName;

--1c. Display a count of resellers in each City.
-- Show count of resellers, City name, State name, and Country name.
SELECT COUNT(*) AS ResellerCount, G.City, G.StateProvinceName, G.EnglishCountryRegionName
FROM [dbo].[DimReseller] AS R
INNER JOIN [dbo].[DimGeography] AS G
ON G.GeographyKey = R.GeographyKey
GROUP BY G.City, G.StateProvinceName, G.EnglishCountryRegionName
ORDER BY G.EnglishCountryRegionName ASC, G.StateProvinceName, ResellerCount;

--2. AdventureWorks wants banking and historical information about its resellers.
-- Be sure to add a meaningful sort as appropriate and give each derived column an alias.

--2a. Check to see if there are any resellers without a value in the bank name field.
SELECT *
FROM [dbo].[DimReseller]
WHERE [BankName] IS NULL;

--2b. List the name of each bank and the number of resellers using that bank.
SELECT [BankName], COUNT(*) AS CountOfResellersUsingBank
FROM [dbo].[DimReseller]
GROUP BY [BankName]
ORDER BY [BankName];

--2c. List the year opened and the number of resellers opening in that year.
SELECT [YearOpened], COUNT(*) AS NumberofResellerOpened
FROM [dbo].[DimReseller]
GROUP BY [YearOpened]
ORDER BY [YearOpened];

--2d. List the order frequency and the number of resellers with that order frequency.
SELECT [OrderFrequency], COUNT(*) AS NumberofResellerOrderFrequency
FROM [dbo].[DimReseller]
GROUP BY [OrderFrequency]
ORDER BY [OrderFrequency];

--2e. List the average number of employees in each of the three business types.
SELECT [BusinessType], AVG([NumberEmployees]) AS AverageEmployees
FROM [dbo].[DimReseller]
GROUP BY [BusinessType]
ORDER BY [BusinessType];

--2f. List business type, the count of resellers in that type, and average of Annual Revenue
-- in that business type.
SELECT [BusinessType], COUNT(*) AS NumberofResellers,
round(avg(AnnualRevenue),2) as AverageAnnualRevenue
FROM [dbo].[DimReseller]
GROUP BY [BusinessType]
ORDER BY [BusinessType];

--3. AdventureWorks wants information about sales to its resellers. Be sure to add a
-- meaningful sort and give each derived column an alias. Remember that Annual Revenue
-- is a measure of the size of the business and is NOT the total of the AdventureWorks
-- products sold to the reseller. Be sure to use SalesAmount when total sales are
-- requested.

--3a. List the name of any reseller to which AdventureWorks has not sold a product.
-- Hint: Use a join.
SELECT R.ResellerName
FROM [dbo].[DimReseller] AS R
LEFT OUTER JOIN [dbo].[FactResellerSales] AS RS
ON R.ResellerKey = RS.ResellerKey
LEFT OUTER JOIN [dbo].[DimProduct] AS P
ON P.ProductKey = RS.ProductKey
WHERE RS.ProductKey IS NULL
ORDER BY R.ResellerName;

--3b. List ALL resellers and total of sales amount to each reseller. Show Reseller
-- name, business type, and total sales with the sales showing two decimal places.
-- Be sure to include resellers for which there were no sales. NULL will appear.
SELECT R.ResellerName, R.BusinessType, ROUND(SUM(RS.SalesAmount),2) AS SalesAmount
FROM [dbo].[DimReseller] AS R
LEFT OUTER JOIN [dbo].[FactResellerSales] AS RS
ON RS. ResellerKey = R.ResellerKey
GROUP BY R.ResellerName, R.BusinessType
ORDER BY R.ResellerName, R.BusinessType;

--3c. List resellers and total sales to each. Show reseller name, business type, and total sales
-- with the sales showing two decimal places. Limit the results to resellers to which
-- total sales are less than $500 and greater than $500,000.
SELECT R.ResellerName, R.BusinessType, ROUND(SUM(RS.SalesAmount),2) AS SalesAmount
FROM [dbo].[DimReseller] AS R
LEFT OUTER JOIN [dbo].[FactResellerSales] AS RS
ON RS. ResellerKey = R.ResellerKey
GROUP BY R.ResellerName, R.BusinessType
HAVING SUM(RS.SalesAmount) < 500 OR SUM(RS.SalesAmount) >500000
ORDER BY R.ResellerName, R.BusinessType;

--3d. List resellers and total sales to each for 2008.
-- Show Reseller name, business type, and total sales with the sales showing two decimal places.
-- Limit the results to resellers to which total sales are between $5,000 and $7,500 and between
-- $50,000 and $75,000
SELECT R.ResellerName, R.BusinessType, ROUND(SUM(RS.SalesAmount),2) AS SalesAmount
FROM [dbo].[DimReseller] AS R
LEFT OUTER JOIN [dbo].[FactResellerSales] AS RS
ON RS. ResellerKey = R.ResellerKey
WHERE YEAR([OrderDate]) = 2008
GROUP BY R.ResellerName, R.BusinessType
HAVING SUM(RS.SalesAmount) BETWEEN 5000 AND 7500 OR SUM(RS.SalesAmount) BETWEEN 50000 AND 75000
ORDER BY R.ResellerName, R.BusinessType;

--4. AdventureWorks wants information about the demographics of its customers.
-- Be sure to add a meaningful sort as appropriate and give each derived column an alias.

--4a. List customer education level (use EnglishEducation) and the number of customers reporting
-- each level of education.
SELECT [EnglishEducation], COUNT(*) AS NumberofCustomersEducationLevel
FROM [dbo].[DimCustomer]
GROUP BY [EnglishEducation]
ORDER BY [EnglishEducation];

--4b. List customer education level (use EnglishEducation), the number of customers reporting
-- each level of education, and the average yearly income for each level of education.
-- Show the average income rounded to two (2) decimal places.
SELECT [EnglishEducation], COUNT(*) AS NumberofCustomersEducationLevel, ROUND(AVG([YearlyIncome]),2) AS AverageYearlyIncome
FROM [dbo].[DimCustomer]
GROUP BY [EnglishEducation]
ORDER BY [EnglishEducation];

--5. List all customers and the most recent date on which they placed an order (2 fields). Show the
-- customer's first name, middle name, and last name in one column with a space between each part of the
-- name. No name should show NULL. Show the date of the most recent order as mm/dd/yyyy.
-- It is your responsibility to make sure you do not miss any customers. If you need to add one
-- more field to the SELECT or the GROUP BY clause, do it. Just don't add more than one.
SELECT CONCAT(C.[FirstName],' ' ,C.[MiddleName], ' ', C.[LastName]) AS FullName, CONVERT(nvarchar,MAX([OrderDate]),101) AS MostRecentOrderDate
FROM [dbo].[DimCustomer] AS C
INNER JOIN [dbo].[FactInternetSales] AS ITS
ON ITS.CustomerKey = C.CustomerKey
GROUP BY C.FirstName, C.MiddleName, C.LastName
ORDER BY C.FirstName, C.MiddleName, C.LastName;