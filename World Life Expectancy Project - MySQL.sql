# World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;

# Identifying duplicates in columns Country and Year

SELECT Country, Year, 
CONCAT(Country,Year) AS country_and_year, 
COUNT(CONCAT(Country,Year)) AS count_countries
FROM world_life_expectancy
GROUP BY Country, Year, country_and_year
HAVING count_countries > 1
;

# Identifying duplicate row_id

SELECT *
FROM(
	SELECT ROW_ID,
	CONCAT(Country,Year) AS Country_Year,
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) AS Row_Num
	FROM world_life_expectancy
	) AS Row_Table
WHERE Row_Num > 1
;

# Remove duplicate columns - 3 rows affected

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN(
    SELECT Row_ID
FROM(
	SELECT Row_ID,
	CONCAT(Country,Year) AS Country_Year,
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) AS Row_Num
	FROM world_life_expectancy
	) AS Row_Table
WHERE Row_Num > 1
)
    ;

# Reviewing the table after made changes

SELECT * 
FROM world_life_expectancy
;

# Identifying missing data (blanks, nulls) in the Status column

SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

# Identifying categories in the Status column

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

# 

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

# Populating blank cells in the Status column where countries are in developing category

UPDATE world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

# Populating blank cells in the Status column where countries are in developed category

UPDATE world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

# Reviewing the table after populating missing data in the Status column

SELECT *
FROM world_life_expectancy
;

# Identifying missing data in the Life Expectancy column

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

# Populating missing data in the Life Expectancy column

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1) AS avg_life_exp
FROM world_life_expectancy AS t1
INNER JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
INNER JOIN world_life_expectancy AS t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

UPDATE world_life_expectancy AS t1
INNER JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
INNER JOIN world_life_expectancy AS t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1) 
WHERE t1.`Life expectancy` = ''
;

# Reviewing the table after populating missing data in the Life expectancy column

SELECT *
FROM world_life_expectancy
;

# Checking if there's any blanks cells in the Life expectancy column

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

# Starting with Exploratory Data Analysis (EDA)

# Identifying lower life expectancy and highest life expectancy by Country

SELECT Country, 
MIN(`Life expectancy`) AS lower_life_exp,
MAX(`Life expectancy`) AS highest_life_exp
FROM world_life_expectancy
GROUP BY Country
HAVING lower_life_exp <> 0
	AND highest_life_exp <> 0
ORDER BY Country DESC
;

# Identifying biggest strides by Country from their lower life expectancy point to their highest life expectancy point

SELECT Country, 
MIN(`Life expectancy`) AS Lower_Life_Exp,
MAX(`Life expectancy`) AS Highest_Life_Exp,
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING Lower_Life_Exp <> 0
	AND Highest_Life_Exp <> 0
ORDER BY Life_Increase_15_Years DESC
;

# Identifying average life expectancy by year

SELECT Year, 
ROUND(AVG(`Life expectancy`),2) AS Avg_Life_Exp
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Avg_Life_Exp DESC
;

# Identifying correlation between Life expectancy and GDP

SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_Exp, 
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
	AND GDP > 0
ORDER BY GDP DESC
;

# Showing very strong correlation from a high GDP to a high life expectancy vs. low GDP to a low life expectancy - That's high correlation. 

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) AS High_GDP_Life_Exp,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) AS Low_GDP_Life_Exp
FROM world_life_expectancy
;

# Identifying average life expectancy between "developed" and "developing" countries

SELECT Status,
COUNT(DISTINCT(Country)) AS Num_of_Countries,
ROUND(AVG(`Life expectancy`),1) AS Avg_Life_Exp
FROM world_life_expectancy
GROUP BY Status
;

# Identifying correlation between Life expectancy and BMI (Body Mass Index) - We found pretty positive correlation

SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_Exp, 
ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
	AND BMI > 0
ORDER BY BMI ASC
;

# Identifying correlation between Life expectancy and Adult mortality

SELECT Country,
Year,
`Life expectancy`,
`Adult mortality`,
SUM(`Adult mortality`)OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;

# That is a ton of EDA and we can go so much further in this.
