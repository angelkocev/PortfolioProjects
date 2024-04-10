# US Household Income

# US Household Income Data Cleaning

# Reviewing data in the US Household Income table

SELECT *
FROM us_household_income
;

# Reviewing data in the US Household Income Statistics table 

SELECT *
FROM us_household_income_statistics
;

# Fixing the first column name of the US Household Income Statistics table

ALTER TABLE us_household_income_statistics
RENAME COLUMN `п»їid` TO `id`
;

# Reviewing data in the US Household Income Statistics table after correcting the name of the first column into 'id'

SELECT *
FROM us_household_income_statistics
;

# Counting the rows of data in both tables
	# There is 32,296 rows of data in the US Household Income table - We're missing 230 rows of data (it's very minimal).
	# There is 32,526 rows of data in the US Household Income Statistics table

SELECT COUNT(row_id) AS count_rows
FROM us_household_income
;

SELECT COUNT(id) AS count_rows
FROM us_household_income_statistics
;

# Identifying duplicates in the US Household Income table

SELECT id,
COUNT(id) AS count_rows
FROM us_household_income
GROUP BY id
HAVING count_rows > 1
;

SELECT *
FROM(
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM us_household_income
) AS duplicates
WHERE row_num > 1
;

# Removing the duplicate rows in the US Household Income table

DELETE FROM us_household_income 
WHERE row_id IN(
	SELECT row_id
	FROM(
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income
		) AS duplicates
	WHERE row_num > 1
)
;

# Identifying duplicates in the US Household Income Statistics table
	# Result: We don't have duplicate rows in this table

SELECT id,
COUNT(id) AS count_rows
FROM us_household_income_statistics
GROUP BY id
HAVING count_rows > 1
;

# Identifying spelling mistakes in the US Household Income table

SELECT State_Name,
COUNT(State_Name) AS count_states
FROM us_household_income
GROUP BY State_Name
;

SELECT DISTINCT(State_Name)
FROM us_household_income
ORDER BY 1;

# Standardizing the data in the US Household Income table
	# Correcting the row name 'georia' into 'Georgia'
    # Correcting the row name 'alabama' into 'Alabama'

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;

# Reviewing the US Household Income table after standardizing the column State Name 

SELECT *
FROM us_household_income
;

# Identifying any error in the State abbreviation column in the US Household Income table - Everything looks okay!

SELECT DISTINCT(State_ab)
FROM us_household_income
ORDER BY 1;

# Identifying blank rows in the Place column in the US Household Income table - Result: Only one blank row in the Place column

SELECT *
FROM us_household_income
WHERE Place = ''
;

SELECT *
FROM us_household_income
WHERE County = 'Autauga County'
;

# Populating blank row in the Place column in the US Household Income table

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
	AND City = 'Vinemont'
;

# Identifying errors in the Type column in the US Household Income table

SELECT Type,
COUNT(Type) AS type_num
FROM us_household_income
GROUP BY Type
;

# Fixing errors in the Type column in the US Household Income table - Correcting the misspelled 'Boroughs' into 'Borough'

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

# Identifying any errors in the ALand and AWater columns in the US Household Income table - Result: No errors in these two columns. Everything looks fine.

SELECT ALand,
AWater
FROM us_household_income
WHERE (AWater = 0
	OR AWater = ''
    OR AWater IS NULL)
AND (ALand = 0
	OR ALand = ''
    OR ALand IS NULL)
;

SELECT ALand,
AWater
FROM us_household_income
WHERE AWater = 0
	OR AWater = ''
    OR AWater IS NULL
;

SELECT ALand,
AWater
FROM us_household_income
WHERE ALand = 0
	OR ALand = ''
    OR ALand IS NULL
;

# US Household Income - Exploratory Data Analysis
	# Reviewing both datasets before start analysing the data

SELECT *
FROM us_household_income
;

SELECT *
FROM us_household_income_statistics
;

# Reviewing how much water and lands states, counties and cities have
	# The output represents the area of land and area of water down to city level

SELECT State_Name, County, City, ALand, AWater
FROM us_household_income
;

# Exploring area of water and area of land on higher level - Doing some aggregations in order to make it more accurate.
	# Identifying the states with the highest area of water 
    # Identifying the states with the highest area of land 


SELECT State_Name, 
SUM(ALand) AS total_area_of_land, 
SUM(AWater) AS total_area_of_water
FROM us_household_income
GROUP BY State_Name
ORDER BY total_area_of_water DESC
;

SELECT State_Name, 
SUM(ALand) AS total_area_of_land, 
SUM(AWater) AS total_area_of_water
FROM us_household_income
GROUP BY State_Name
ORDER BY total_area_of_land DESC
;

# Identifying the top 10 largest states by land

SELECT State_Name, 
SUM(ALand) AS total_area_of_land, 
SUM(AWater) AS total_area_of_water
FROM us_household_income
GROUP BY State_Name
ORDER BY total_area_of_land DESC
LIMIT 10
;

# Identifying the top 10 largest states by water

SELECT State_Name, 
SUM(ALand) AS total_area_of_land, 
SUM(AWater) AS total_area_of_water
FROM us_household_income
GROUP BY State_Name
ORDER BY total_area_of_water DESC
LIMIT 10
;

# Tie both tables together
	# We should remember that not every row from the US Household Income dataset was imported at the beginning (230 rows). Because of that, we'll do RIGHT JOIN and do some filtering. 

SELECT *
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
;

SELECT *
FROM us_household_income AS hi
RIGHT JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE hi.id IS NULL
;

# After seeing the output, there's a lot of NULL data coming from the first table (US Household Income).
    # In this case, we're not gonna do anything. We're just going to not use those NULL data by doing an INNER JOIN.

SELECT *
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
;

# Data cleaning - Filtering the data excluding missing data in the statistic columns, such as Mean, Median, Standard Deviation and Sum_W

SELECT *
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
;

# Pulling some columns interesting to work with - These is more of categorical data

SELECT hi.State_Name, County, Type, `Primary`, Mean, Median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
;

# Let's first look at the state level
	# Exploring average mean and average median data by states
    # After running this query, we have some really interesting information about average income and median income by state.
    # Household income can mean one person or it can mean two people. Typically, it refers to a couple, or a married couple.
    # Results: Puerto Rico is obviously quite lower, but they're not continental USA. Missisipi are at the very bottom. That's average below $50,000 for an entire household. That's quite low, especially in today's terms. 

SELECT hi.State_Name, 
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY hi.State_Name
ORDER BY avg_mean ASC
;

# Identifying the five states in the USA with the lowest average household income: 

SELECT hi.State_Name, 
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY hi.State_Name
ORDER BY avg_mean ASC
LIMIT 5
;

# Identifying the five states in the USA with the highest average household income: 

SELECT hi.State_Name, 
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY hi.State_Name
ORDER BY avg_mean DESC
LIMIT 5
;

# Identifying the five states in the USA with the highest median household income: 

SELECT hi.State_Name, 
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY hi.State_Name
ORDER BY avg_median DESC
LIMIT 5
;

# Identifying the five states in the USA with the lowest median household income: 

SELECT hi.State_Name, 
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY hi.State_Name
ORDER BY avg_median ASC
LIMIT 5
;

# Identifying the 10 states in the USA with the highest median household income: 

SELECT hi.State_Name, 
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY hi.State_Name
ORDER BY avg_median DESC
LIMIT 10
;

# Results: We have some really high earning households high above the average!

# Data aggregation by Type column - Exploring average household income and median income by type

SELECT Type,
COUNT(Type) AS count_type,
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY avg_mean DESC
;

SELECT Type,
COUNT(Type) AS count_type,
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY avg_median DESC
;

# Looking for the state who have community type of households

SELECT *
FROM us_household_income
WHERE Type = 'Community'
;

# Filtering out types of households with extremely low counts and exploring average income and median income by type
	# Looking at the higher volume types for these different areas

SELECT Type,
COUNT(Type) AS count_type,
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY avg_mean DESC
;

SELECT Type,
COUNT(Type) AS count_type,
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY avg_median DESC
;

# Exploring average household income and median income at city level
	# Exploring the highest and the lowest average household income and median income by city

SELECT hi.State_name, 
City,
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
GROUP BY hi.State_Name, City
ORDER BY avg_mean DESC
;

SELECT hi.State_name, 
City,
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
GROUP BY hi.State_Name, City
ORDER BY avg_median DESC
;

SELECT hi.State_name, 
City,
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
GROUP BY hi.State_Name, City
HAVING avg_mean <> 0
ORDER BY avg_mean ASC
;

SELECT hi.State_name, 
City,
ROUND(AVG(Mean),1) AS avg_mean, 
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income AS hi
INNER JOIN us_household_income_statistics AS his
	ON hi.id = his.id
GROUP BY hi.State_Name, City
HAVING avg_median <> 0
ORDER BY avg_median ASC
;