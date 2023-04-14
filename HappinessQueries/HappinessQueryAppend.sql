-- let us add a column to know which year the data is from and then we can change the column names of different tables in a way that
	--will make sense to append
ALTER TABLE Project.dbo.happiness2015
	ADD year int
UPDATE Project.dbo.happiness2015
	SET year = 2015

ALTER TABLE Project.dbo.happiness2016
	ADD year int
UPDATE Project.dbo.happiness2016
	SET year = 2016

ALTER TABLE Project.dbo.happiness2017
	ADD year int
UPDATE Project.dbo.happiness2017
	SET year = 2017

ALTER TABLE Project.dbo.happiness2018
	ADD year int
UPDATE Project.dbo.happiness2018
	SET year = 2018

ALTER TABLE Project.dbo.happiness2019
	ADD year int
UPDATE Project.dbo.happiness2019
	SET year = 2019

-- FIRST CHOOSE THE APPROPRIATE ROWS, MAKE A TABLE OF THEM AND THEN APPEND
ALTER TABLE appendedhappiness
DROP COLUMN weighted_sum




-- We will make all the columns in the different tables have the same respective column name using the design option
	--all the tables have the same column names. now we shall go ahead and append the rows
DROP TABLE IF EXISTS happinessappended
SELECT country, happiness_rank, happiness_score, economy, family, health, freedom, trust, generosity, year
INTO happinessappended
FROM (
			SELECT  country, happiness_rank, happiness_score, economy, family, health, freedom, trust, generosity, year
			FROM Project.dbo.happiness2015
	UNION ALL
			SELECT  country, happiness_rank, happiness_score, economy, family, health, freedom, trust, generosity, year
			FROM Project.dbo.happiness2016
	UNION ALL
			SELECT  country, happiness_rank, happiness_score, economy, family, health, freedom, trust, generosity, year
			FROM Project.dbo.happiness2017
	UNION ALL
			SELECT  country, happiness_rank, happiness_score, economy, family, health, freedom, trust, generosity, year
			FROM Project.dbo.happiness2018
	UNION ALL
			SELECT  country, happiness_rank, happiness_score, economy, family, health, freedom, trust, generosity, year
			FROM Project.dbo.happiness2019
	) AS  appended_happiness

-- we have already found the top 10 and bottom 10 countries in the 'HappinessQueryCleaning'. we shall use the info from there
/* TOP 10 RANKED COUNTRIES.!!!
    Switzerland
	Iceland
	Denmark
	Norway
	Canada
	Finland
	Netherlands
	Sweden
	New Zealand
	Australia  
Keep INDIA ALSO TO SEE HOW IT IS PERFORMING COMPARED TO THE OTHER YEARS 

BOTTOM 1O COUNTRIES IN THE RANKING
	Togo
	Burundi
	Syria
	Benin
	Rwanda
	Afghanistan
	Burkina Faso
	Ivory Coast
	Guinea
	Chad                    */

-- Let us keep only the above mentioned countries in our happinessappended table
DELETE FROM happinessappended
WHERE country NOT IN (
    'Switzerland',
    'Iceland',
	'Denmark',
	'Norway',
	'Canada',
	'Finland',
	'Netherlands',
	'Sweden',
	'New Zealand',
	'Australia',
	'India',
	'Togo',
	'Burundi',
	'Syria',
	'Benin',
	'Rwanda',
	'Afghanistan',
	'Burkina Faso',
	'Ivory Coast',
	'Guinea',
	'Chad'
	)

-- checking to see if we got the data we wanted
	SELECT *
	FROM happinessappended

-- We have completed data wrangling. now we can use this table in tableau to make vizualisations and get insights