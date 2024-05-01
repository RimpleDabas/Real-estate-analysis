USE Rental;

-- Select distinct provinces and neighbourhood
SELECT DISTINCT(Provinces) FROM Provinces;
SELECT DISTINCT(Neighbourhood) FROM Neighbourhood;

SELECT YEAR, ROUND(AVG(_1_Bedroom),2) AS '1 BHK' , ROUND(AVG(_2_Bedroom),2) AS '2 BHK' FROM [Rental Data]
GROUP BY Year;

-- Average rents province wise
SELECT p.Provinces, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1 BHK' ,ROUND(AVG(r._2_Bedroom),2) AS '2 BHK'
FROM [Rental Data] r
INNER JOIN Provinces p ON r.province_id = p.province_id
WHERE r._1_Bedroom > 0
GROUP BY r.YEAR, p.Provinces;

-- Average rents Centres wise and getting data for particular Centre using CTE
WITH Centres_data AS
(
	SELECT p.Provinces, c.centres, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1 BHK' 
	FROM [Rental Data] r
	INNER JOIN Provinces p ON r.province_id = p.province_id
	RIGHT JOIN Centres c  ON r.Centre_id = c.Centre_id
	WHERE r._1_Bedroom > 0
	GROUP BY  p.Provinces,c.Centres,r.Year
	)

SELECT * FROM  Centres_data
WHERE Centres = 'Toronto'
ORDER BY Year;




-- Average rents province wise, Neighborhood wise and eliminating data where there are no values 

SELECT p.Provinces, n.neighbourhood, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1 BHK' 
FROM [Rental Data] r
INNER JOIN Provinces p ON r.province_id = p.province_id
RIGHT JOIN Neighbourhood n  ON r.Neighbourhood_id = n.Neighbourhood_id
WHERE (r._1_Bedroom > 0 AND p.Provinces LIKE 'Ont.') -- Use wildcard to get neighbourhood trend
GROUP BY r.YEAR, p.Provinces,n.Neighbourhood;
--HAVING ROUND(AVG(r._1_Bedroom),2)  > 0  ;

-- Same Results using cte

WITH Provincial_data AS (
	SELECT p.Provinces, n.neighbourhood, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1 BHK' 
	FROM [Rental Data] r
	INNER JOIN Provinces p ON r.province_id = p.province_id
	RIGHT JOIN Neighbourhood n  ON r.Neighbourhood_id = n.Neighbourhood_id
	WHERE (r._1_Bedroom > 0 AND p.Provinces LIKE 'Ont.') -- Use wildcard to get neighbourhood trend
	GROUP BY r.YEAR, p.Provinces,n.Neighbourhood
	)

SELECT * FROM Provincial_data;



-- Province with highest rent
SELECT Provinces
FROM Provinces 
WHERE province_id IN (
    SELECT TOP 1 province_id
    FROM [Rental Data] 
    GROUP BY  province_id
    ORDER BY ROUND(AVG(_1_Bedroom),2) DESC
);

WITH AvgRentByProvince AS (
    SELECT province_id, ROUND(AVG(_1_Bedroom),2) AS avg_rent
    FROM [Rental Data]
    GROUP BY province_id
),
MaxAvgRent AS (
    SELECT MAX(avg_rent) AS max_avg_rent
    FROM AvgRentByProvince
),
MinAvgRent AS (
    SELECT MIN(avg_rent) AS min_avg_rent
    FROM AvgRentByProvince
)
SELECT * 
FROM AvgRentByProvince arp
WHERE arp.avg_rent IN (SELECT max_avg_rent FROM MaxAvgRent)
   OR arp.avg_rent IN (SELECT min_avg_rent FROM MinAvgRent);


-- We can create view to get insights for the Provinces based on the years
CREATE VIEW RentalSummary AS
SELECT r.Rent_ID, r._1_Bedroom, r.province_id, r.neighbourhood_id, r.YEAR, p.Provinces
FROM [Rental Data] r
INNER JOIN Provinces p ON r.province_id = p.province_id;

SELECT * FROM RentalSummary;

CREATE VIEW Provincial_data AS (
SELECT p.Provinces, c.centres, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1_BHK' 
FROM [Rental Data] r
INNER JOIN Provinces p ON r.province_id = p.province_id
RIGHT JOIN Centres c  ON r.Centre_id = c.Centre_id
WHERE r._1_Bedroom > 0
GROUP BY  p.Provinces,c.Centres,r.Year);


SELECT * FROM Provincial_data; 
-- Getting data for the provinces for all years top 5
SELECT TOP 5 Provinces,Year , ROUND(AVG([1_BHK]),2) AS rents FROM Provincial_data
GROUP BY Provinces,Year
ORDER BY YEAR DESC, ROUND(AVG([1_BHK]),2) DESC;


-- filter based on the year top 5
SELECT TOP 5 Provinces ,ROUND(AVG([1_BHK]),2) AS rents FROM Provincial_data
WHERE YEAR = '2018'
GROUP BY Provinces
ORDER BY ROUND(AVG([1_BHK]),2) DESC;
	

CREATE VIEW Centres_data AS 
	(SELECT p.Provinces, c.centres, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1_BHK' 
		FROM [Rental Data] r
		INNER JOIN Provinces p ON r.province_id = p.province_id
		RIGHT JOIN Centres c  ON r.Centre_id = c.Centre_id
		WHERE r._1_Bedroom > 0
		GROUP BY  p.Provinces,c.Centres,r.Year)

SELECT * FROM Centres_data;

-- WE can use this to select data based on the Provinces and Year 

SELECT TOP 3 Centres ,ROUND(AVG([1_BHK]),2) AS rents FROM Centres_data
WHERE YEAR = '2018' AND Provinces = 'B.C.'
GROUP BY Centres
ORDER BY ROUND(AVG([1_BHK]),2) DESC;
	
-- Include 2 bhk as well
CREATE VIEW Centres_data_2 AS 
	(SELECT p.Provinces, c.centres, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1_BHK' , 
		ROUND(AVG(r._2_Bedroom),2) AS '2_BHK' 
		FROM [Rental Data] r
		INNER JOIN Provinces p ON r.province_id = p.province_id
		RIGHT JOIN Centres c  ON r.Centre_id = c.Centre_id
		WHERE r._1_Bedroom > 0
		GROUP BY  p.Provinces,c.Centres,r.Year)

SELECT * FROM Centres_data_2;

SELECT TOP 3 Centres , ROUND(AVG([1_BHK]),2) AS rents_1, ROUND(AVG([2_BHK]),2) AS rents_2 FROM Centres_data_2
WHERE YEAR = '2018' AND Provinces = 'B.C.'
GROUP BY Centres
ORDER BY ROUND(AVG([1_BHK]),2) DESC;
	