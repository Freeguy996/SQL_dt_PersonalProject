-- Working with video game sales across the world from Kaggle.com
-- Note that sales are in million dollars

--Retrieving the video game data from dt_personal database
SELECT * 
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND
Platform IS NOT NULL 
ORDER BY Year
  
--Looking at the total sales in each region over the years
-- Total sales in NORTH AMERICA...
SELECT Name, Publisher, Genre, Year, NA_Sales,
SUM(NA_Sales) OVER (PARTITION BY Year ORDER BY YEAR) AS TotalNA_SalesOverTheYears
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND
Platform IS NOT NULL 

-- Total sales in EUROPE Partition by Genre
SELECT Name, Publisher, Genre, Year, EU_Sales,
SUM(EU_Sales) OVER (PARTITION BY Genre ORDER BY Publisher) AS TotalEU_SalesOverTheYears
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND
Platform IS NOT NULL 

-- Looking at the Genre that has highest sales in Europe over the years
SELECT  Genre, SUM(EU_Sales) AS TotalEU_SalesOverTheYears
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND Platform IS NOT NULL 
GROUP BY  Genre
HAVING SUM(EU_Sales) > 100
ORDER BY 2

-- Looking at the Genre that has highest sales Globally over the years
SELECT  Genre, SUM(Global_Sales) AS TotalEU_SalesOverTheYears
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND Platform IS NOT NULL AND 
Year BETWEEN 2000 AND 2017
GROUP BY  Genre
ORDER BY 2


--Looking at percentage sales in Europe vs Global by Genre
SELECT  Genre, SUM(EU_Sales) AS EU_TotalSales, 
SUM(Global_Sales) AS Global_TotalSales,
SUM(EU_Sales)/SUM(Global_Sales)*100 AS PercentageOfEUsales
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND Platform IS NOT NULL AND 
Year BETWEEN 2000 AND 2017
GROUP BY  Genre
ORDER BY 4



-- Looking at years with the highest sales Globally
SELECT  Year, SUM(Global_Sales) AS TotalGlobal_SalesOverTheYears
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND Platform IS NOT NULL AND
Year BETWEEN 2000 AND 2017
GROUP BY  Year
ORDER BY 2

-- Using CTE's 
WITH cte_totalGlobalSales AS
(SELECT  Year, SUM(Global_Sales) AS TotalGlobal_SalesOverTheYears
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND Platform IS NOT NULL AND
Year BETWEEN 2000 AND 2017
GROUP BY  Year
--ORDER BY 2
)

SELECT *
FROM cte_totalGlobalSales
WHERE Year BETWEEN 2010 AND 2016


-- Look at Platform with the highest sales globally
SELECT Platform, SUM(Global_Sales) AS PlatformWithHighestSales
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND
Platform IS NOT NULL --AND Year BETWEEN 2010 AND 2016
GROUP BY Platform
ORDER BY 2

--Creating view to store data for visualisation
CREATE VIEW PlatformWithHighestSales AS
SELECT Platform, SUM(Global_Sales) AS PlatformWithHighestSales
FROM [dt_personal]..vgsales
WHERE Year IS NOT NULL AND
Platform IS NOT NULL --AND Year BETWEEN 2010 AND 2016
GROUP BY Platform
--ORDER BY 2

SELECT * 
FROM PlatformWithHighestSales 
