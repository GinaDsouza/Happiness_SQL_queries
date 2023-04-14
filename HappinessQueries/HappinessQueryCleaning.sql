-- AIM OF THIS ANALYSIS.!!!
/* To understand how India compares with the happiest and the saddest countries.
to learn which factors India can improve upon and which factors, if any, are done well by India */ 
/* maybe just concentrate on India and see how each factors changing over the year has affected the happiness rank yearly */

-- to view the table
SELECT *
FROM Project.dbo.happinessmerged

--remove duplicate data
SELECT COUNT(DISTINCT(country))
FROM Project.dbo.happinessmerged
/* looks like there is no duplicate data as we have 144 rows and the above query returns 144 */

--Let us drop the countries that are of no interest to us
 SELECT TOP 10 *
 FROM Project.dbo.happinessmerged
 ORDER BY happiness_rank_2015, happiness_rank_2016, happiness_rank_2017, happiness_rank_2018, happiness_rank_2019
 
 SELECT TOP 10 *
 FROM Project.dbo.happinessmerged
 ORDER BY happiness_rank_2015 DESC, happiness_rank_2016 DESC, happiness_rank_2017 DESC, happiness_rank_2018 DESC, happiness_rank_2019 DESC
 
 SELECT *
 FROM Project.dbo.happinessmerged
 WHERE country = 'India'
	--deleting other rows which aren't needed
	/*checking if we are choosing the correct rows to keep */
	SELECT country, row_num
	FROM (
	SELECT country, ROW_NUMBER() OVER (ORDER BY happiness_rank_2015,
	happiness_rank_2016, happiness_rank_2017, happiness_rank_2018, happiness_rank_2019) AS row_num
	FROM Project.dbo.happinessmerged
	) subquery1
	WHERE row_num < 11 OR country = 'India'
	UNION ALL
	SELECT country, row_num
	FROM (
	SELECT country, ROW_NUMBER() OVER (ORDER BY happiness_rank_2015 DESC,
	happiness_rank_2016 DESC, happiness_rank_2017 DESC, happiness_rank_2018 DESC, happiness_rank_2019 DESC) AS row_num
	FROM Project.dbo.happinessmerged
	) subquery2
	WHERE row_num < 11
	
	/* Since we have chosen the correct rows to keep, let us make a CTE of the rows not included in the above query so that it
	is easier to delete */
	WITH Rows_to_delete_CTE AS (
		SELECT *
		FROM Project.dbo.happinessmerged
		WHERE country NOT IN (
								SELECT country
								FROM (
								SELECT country, ROW_NUMBER() OVER (ORDER BY happiness_rank_2015,
								happiness_rank_2016, happiness_rank_2017, happiness_rank_2018, happiness_rank_2019) AS row_num
								FROM Project.dbo.happinessmerged
								) subquery1
								WHERE row_num < 11 OR country = 'India'
				   UNION ALL
								SELECT country
								FROM (
								SELECT country, ROW_NUMBER() OVER (ORDER BY happiness_rank_2015 DESC,
								happiness_rank_2016 DESC, happiness_rank_2017 DESC, happiness_rank_2018 DESC, happiness_rank_2019 DESC) AS row_num
								FROM Project.dbo.happinessmerged
								) subquery2
								WHERE row_num < 11
							 )
								)
	DELETE
	FROM Project.dbo.happinessmerged
	WHERE country IN (SELECT country FROM Rows_to_delete_CTE)

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

--address outliers
 /*let us use some statistical analysis to weed out the outliers.
 To know more about the data so far, let us use tableau to make some data viz
 so that we get some insight into the data we are working with */

 /* on doing a visual inspection, there seemed to be no outliers. Usually we would do more statistical analysis to ensure that 
 there are no outliers but for now, I will move ahead with the assumption that the visual inspection sufficied */

 --checking for missing values
SELECT *
FROM Project.dbo.happinessmerged
WHERE happiness_rank_2015 IS NULL
OR happiness_score_2015 IS NULL
OR economy_2015 IS NULL
OR family_2015 IS NULL
OR health_2015 IS NULL
OR freedom_2015 IS NULL
OR trust_2015 IS NULL
OR generosity_2015 IS NULL

SELECT *
FROM Project.dbo.happinessmerged
WHERE happiness_rank_2016 IS NULL
OR happiness_score_2016 IS NULL
OR economy_2016 IS NULL
OR family_2016 IS NULL
OR health_2016 IS NULL
OR freedom_2016 IS NULL
OR trust_2016 IS NULL
OR generosity_2016 IS NULL

SELECT *
FROM Project.dbo.happinessmerged
WHERE happiness_rank_2017 IS NULL
OR happiness_score_2017 IS NULL
OR economy_2017 IS NULL
OR family_2017 IS NULL
OR health_2017 IS NULL
OR freedom_2017 IS NULL
OR trust_2017 IS NULL
OR generosity_2017 IS NULL

SELECT *
FROM Project.dbo.happinessmerged
WHERE happiness_rank_2018 IS NULL
OR happiness_score_2018 IS NULL
OR economy_2018 IS NULL
OR family_2018 IS NULL
OR health_2018 IS NULL
OR freedom_2018 IS NULL
OR trust_2018 IS NULL
OR generosity_2018 IS NULL

SELECT *
FROM Project.dbo.happinessmerged
WHERE happiness_rank_2019 IS NULL
OR happiness_score_2019 IS NULL
OR economy_2019 IS NULL
OR family_2019 IS NULL
OR health_2019 IS NULL
OR freedom_2019 IS NULL
OR trust_2019 IS NULL
OR generosity_2019 IS NULL

--standardize variables
	/* while seeing the design table, everything is in the correct data format */

--correct data entry errors
	/* from the visual inspection in tableau, it seems like there is no data entry errors */

--let us have a new column which will tell us if the country is in the top10 or bottom10
	--this is done to help us during the creation of the vizualisation
ALTER TABLE Project.dbo.happinessmerged
ADD top_bottom_rank NVARCHAR(10)

UPDATE Project.dbo.happinessmerged
SET top_bottom_rank = (
						CASE WHEN happiness_rank_2015 < 11
								THEN 'TOP'
							WHEN country = 'India'
								THEN 'INDIA'
							ELSE 'BOTTOM'
						END
					   )

--As we have addressed all the ways the data might have been dirty, our data cleaning is complete


SELECT happiness_rank_2015,happiness_rank_2016,happiness_rank_2017,happiness_rank_2018,happiness_rank_2019
FROM Project.dbo.happinessmerged
ORDER BY happiness_rank_2015