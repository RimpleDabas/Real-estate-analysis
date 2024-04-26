-- Select distinct provinces and neighbourhood

SELECT DISTINCT(Provinces) FROM Provinces;
SELECT DISTINCT(Neighbourhood) FROM Neighbourhood;

SELECT YEAR, ROUND(AVG(_1_Bedroom),2) AS '1 BHK' , ROUND(AVG(_2_Bedroom),2) AS '2 BHK' FROM [Rental Data]
GROUP BY Year;



-- Average rents province wise
SELECT p.Provinces, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1 BHK' ,ROUND(AVG(r._2_Bedroom),2) AS '2 BHK'
FROM [Rental Data] r
INNER JOIN Provinces p ON r.province_id = p.province_id
GROUP BY r.YEAR, p.Provinces;



-- Average rents province wise, Neighborhood wise and eliminating data where there are no values
SELECT p.Provinces, n.neighbourhood, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1 BHK' 
FROM [Rental Data] r
INNER JOIN Provinces p ON r.province_id = p.province_id
RIGHT JOIN Neighbourhood n  ON r.Neighbourhood_id = n.Neighbourhood_id
GROUP BY r.YEAR, p.Provinces,n.Neighbourhood
HAVING ROUND(AVG(r._1_Bedroom),2)  > 0  ;


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

