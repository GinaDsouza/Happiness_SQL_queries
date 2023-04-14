-- ****IMPORTANT..!!!!!!*****
-- YOU HAVE DISABLED THE OPTION THAT PREVENTS SAVING CHANGES TO A TABLE. AFTER THE COMPLETION
--   OF THE PROJECT, PLEASE CHANGE IT BACK. tools->Options->Designers->Table and database designers->tick 'Prevent saving changes that require table re-creation'
-- DONT FORGET TO DROP THE TEMP TABLE U CREATED

-- Checking if the tables are compatible for merging

SELECT *
FROM Project.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('happiness2015', 'happiness2016', 'happiness2017','happiness2018','happiness2019')
ORDER BY ORDINAL_POSITION

    -- To see if all tables have same number of rows 
	SELECT COUNT(*)  /* =158 */
	FROM Project.dbo.happiness2015

	SELECT COUNT(*) /* =157 */
	FROM Project.dbo.happiness2016

	SELECT COUNT(*) /* =775 */
	FROM Project.dbo.happiness2017

	SELECT COUNT(*) /* =156 */
	FROM Project.dbo.happiness2018

	SELECT COUNT(*) /* =156 */
	FROM Project.dbo.happiness2019

	-- Removing duplicated rows
	SELECT * /* Looks like it has many duplicated rows*/
	FROM Project.dbo.happiness2017
	ORDER BY happiness_rank_2017

        --creating a CTE to aid in the removal of duplicates
		   /* verifying that we are choosing the correct rows to delete*/
			WITH CTE2017 AS (
			SELECT *,
			ROW_NUMBER() OVER (
			PARTITION BY country_2017,
						 happiness_rank_2017,
						 happiness_score_2017
			  ORDER BY country_2017 ) row_num
			  FROM Project.dbo.happiness2017
			  )
			SELECT *
			FROM CTE2017
			WHERE row_num > 1
  
	 --deleting the duplicate rows
	WITH CTE2017 AS (
	SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY country_2017,
  				 happiness_rank_2017,
				 happiness_score_2017
	ORDER BY country_2017 ) row_num
	FROM Project.dbo.happiness2017
	)
	DELETE
	FROM CTE2017
	WHERE row_num > 1

	-- comparing 'country' column of every table to check for name errors
	WITH countryCTE AS(
	SELECT '2015' as SourceTable, country
	FROM Project.dbo.happiness2015
	UNION ALL
	SELECT '2016' as SourceTable, country_2016
	FROM Project.dbo.happiness2016
	UNION ALL
	SELECT '2017' as SourceTable, country_2017
	FROM Project.dbo.happiness2017
	UNION ALL
	SELECT '2018' as SourceTable, country_2018
	FROM Project.dbo.happiness2018
	UNION ALL
	SELECT '2019' as SourceTable, country_2019
	FROM Project.dbo.happiness2019
	--ORDER BY country
	)
	SELECT COUNT(*) AS country_count, country
	FROM countryCTE
	GROUP BY country
	ORDER BY country_count
	 /* there are 4 countries which are misspelled. Rest of the countries we are going to ignore as
	      they arent present in all 5 tables*/

		-- to correct these errors
		  --to see which table has the misspelled names
			WITH countryCTE AS(
			SELECT '2015' as SourceTable, country
			FROM Project.dbo.happiness2015
			UNION ALL
			SELECT '2016' as SourceTable, country_2016
			FROM Project.dbo.happiness2016
			UNION ALL
			SELECT '2017' as SourceTable, country_2017
			FROM Project.dbo.happiness2017
			UNION ALL
			SELECT '2018' as SourceTable, country_2018
			FROM Project.dbo.happiness2018
			UNION ALL
			SELECT '2019' as SourceTable, country_2019
			FROM Project.dbo.happiness2019
			--ORDER BY country
			)
			SELECT SourceTable, country
			FROM countryCTE
			WHERE country LIKE 'trinidad %' OR country LIKE 'Hong %'
			OR country LIKE '% cyprus' OR country LIKE 'Taiwan%'
			ORDER BY country

	  -- Correcting the errors
		--Trinidad and Tobago
		  --2018
			SELECT country_2018, happiness_rank_2018 /* rank is 38 */
			FROM Project.dbo.happiness2018
			WHERE country_2018 LIKE 'Trinidad%'

			UPDATE Project.dbo.happiness2018
			SET country_2018 = 'Trinidad and Tobago'
			WHERE happiness_rank_2018 = 38
		  
		 --2019
			SELECT country_2019, happiness_rank_2019 /* rank is 39 */
			FROM Project.dbo.happiness2019
			WHERE country_2019 LIKE 'Trinidad%'

			UPDATE Project.dbo.happiness2019
			SET country_2019 = 'Trinidad and Tobago'
			WHERE happiness_rank_2019 = 39

		--Northern Cyprus
		  --2018
			SELECT country_2018, happiness_rank_2018 /* rank is 58 */
			FROM Project.dbo.happiness2018
			WHERE country_2018 LIKE '%Cyprus'

			UPDATE Project.dbo.happiness2018
			SET country_2018 = 'Northern Cyprus'
			WHERE happiness_rank_2018 = 58
		  --2019
			SELECT country_2019, happiness_rank_2019 /* rank is 64 */
			FROM Project.dbo.happiness2019
			WHERE country_2019 LIKE '%Cyprus'

			UPDATE Project.dbo.happiness2019
			SET country_2019 = 'Northern Cyprus'
			WHERE happiness_rank_2019 = 64

		--Hong Kong
		  --2017
		    SELECT country_2017, happiness_rank_2017 /* rank is 71 */
			FROM Project.dbo.happiness2017
			WHERE country_2017 LIKE 'Hong%'

			UPDATE Project.dbo.happiness2017
			SET country_2017 = 'Hong Kong'
			WHERE happiness_rank_2017 = 71
		--Taiwan
		  --2017
		    SELECT country_2017, happiness_rank_2017 /* rank is 33 */
			FROM Project.dbo.happiness2017
			WHERE country_2017 LIKE 'Taiwan%'

			UPDATE Project.dbo.happiness2017
			SET country_2017 = 'Taiwan'
			WHERE happiness_rank_2017 = 33

--Merging data
  --Creating a temp table and using inner join
	SELECT *
	INTO happiness2015to2019 /* to create temp table*/
	FROM Project.dbo.happiness2015 h15
	JOIN Project.dbo.happiness2016 h16 ON h15.country = h16.country_2016
	JOIN Project.dbo.happiness2017 h17 ON h15.country = h17.country_2017
	JOIN Project.dbo.happiness2018 h18 ON h15.country = h18.country_2018
	JOIN Project.dbo.happiness2019 h19 ON h15.country = h19.country_2019

 -- Deleting redundant country columns
	ALTER TABLE happiness2015to2019
    DROP COLUMN country_2016, country_2017, country_2018, country_2019

-- viewing the temp table
SELECT *
FROM happiness2015to2019
ORDER BY happiness_rank_2015
 
-- THE ABOVE TEMP TABLE IS EXPORTED