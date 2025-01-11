# Data Cleaning in SQL

SELECT *
FROM layoffs;

# 1. Remove Duplicates 
# 2. Standardize the Data
# 3. Null Values or blank values
# 4. Remove Any Columns or Rows

# Creating staging or raw dataset (copy all of the data from the raw table into the staging table)

CREATE TABLE layoffs_staging
LIKE layoffs;

# Review of the new dataset - We have all of the columns from the raw dataset

SELECT *
FROM layoffs_staging;

# Insert the data from the raw dataset into the staging dataset

INSERT layoffs_staging
SELECT *
FROM layoffs;

# Review of the new table

SELECT *
FROM layoffs_staging;

# Identifying the duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
( 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1
;

# Noticing that some rows are not duplicates

SELECT *
FROM layoffs_staging
WHERE company = 'Oda';

# Identifying the duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
( 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1
;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

# Creating new table

CREATE TABLE `layoffs_staging2` (
	`company` text,
    `location` text,
    `industry` text,
    `total_laid_off` int DEFAULT NULL,
    `percentage_laid_off` text,
    `date` text,
    `stage` text,
    `country` text,
    `funds_raised_millions` int DEFAULT NULL,
    `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# Reviewing the new table

SELECT *
FROM layoffs_staging2;

# Inserting information to the new table

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

# Reviewing the new table after inserting the information

SELECT *
FROM layoffs_staging2
;

# Filtering the duplicate rows

SELECT *
FROM layoffs_staging2
WHERE row_num > 1
;

# Removing the duplicates

DELETE
FROM layoffs_staging2
WHERE row_num > 1
;

# Reviewing the table after removing duplicate rows

SELECT *
FROM layoffs_staging2
WHERE row_num > 1
;

SELECT *
FROM layoffs_staging2;

# Standardizing data

# Identifying and removing white space in the rows of the company column

SELECT company,
TRIM(company) AS company_trim
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

# Reviewing the industry column

SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY industry;

# Filtering and looking for the crypto industry

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'
;

# Updating all of the rows in crypto industry naming "Crypto"

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
;

# Reviewing the industry column after updating the same column for the crypto industry

SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY industry;

# Reviewing the whole dataset

SELECT *
FROM layoffs_staging2
;

# Reviewing the location column

SELECT DISTINCT(location)
FROM layoffs_staging2
ORDER BY location
;

# Updating all misspeled rows in the location column

UPDATE layoffs_staging2
SET location = 'Dusseldorf'
WHERE location = 'DГјsseldorf'
;

UPDATE layoffs_staging2
SET location = 'Florianopolis'
WHERE location = 'FlorianГіpolis'
;

UPDATE layoffs_staging2
SET location = 'Malmo'
WHERE location = 'MalmГ¶'
;

# Reviewing the location column after updating the misspeled cities

SELECT DISTINCT(location)
FROM layoffs_staging2
ORDER BY location
;

# Reviewing the country column

SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY country
;

# Updating the misspeled rows in the location column

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country = 'United States.'
;

# Reviewing the country column after updating the single misspeled country in this dataset: 'United States'

SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY country
;

# Transforming the date column from string (text) data type into date data type

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y') AS datetype
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` =  STR_TO_DATE(`date`,'%m/%d/%Y')
;

# Reviewing the date column after transforming the type from string (text) format into date format

SELECT *
FROM layoffs_staging2
;

# Converting the date column from string (text) data format into the date format

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

# Reviewing the table

SELECT *
FROM layoffs_staging2
;

# Working with NULL and blank values

# Identifying NULL values in the total_laid_off and percentage_laid_off columns

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;

# Identifying NULL and blank values in the industry column

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
	OR industry = '';
    
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'
;

SELECT *
FROM layoffs_staging2
WHERE company = 'Carvana'
;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%'
;

SELECT *
FROM layoffs_staging2
WHERE company = 'Juul'
;

# Other way to identify NULL or blank values in the industry column using JOIN function

SELECT *
FROM layoffs_staging2 AS t1
INNER JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
	AND t2.industry IS NOT NULL
;

# Populating blank values in the industry column

UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE company = 'Airbnb'
;

UPDATE layoffs_staging2
SET industry = 'Transportation'
WHERE company = 'Carvana'
;

UPDATE layoffs_staging2
SET industry = 'Consumer'
WHERE company = 'Juul'
;

# Identifying NULL and blank values in the industry column after populating these rows

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
	OR industry = '';

# Reviewing the dataset

SELECT *
FROM layoffs_staging2
;

# For the second time identifying NULL values in the total_laid_off and percentage_laid_off columns

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;
    
# Removing rows with NULL values in both total_laid_off and percentage_laid_off columns - Reason: Because we can't trust that data!

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;

# Reviewing total_laid_off and percentage_laid_off columns after removing NULL values

SELECT total_laid_off,
percentage_laid_off
FROM layoffs_staging2
; 

# Reviewing the dataset

SELECT *
FROM layoffs_staging2;

# Removing row_num column - Reason: We don't need this column anymore!

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

# Reviewing the dataset after removing the row_num column

SELECT *
FROM layoffs_staging2;