# Real-estate-analysis

## Data collection and extraction

The dataset for this analysis is collected from https://www.cmhc-schl.gc.ca/. The dataset contains rental data for the years 2018-2022 across Canada. The cleaning , transforation was done in python to create relational database and get the data for loading in SQl server for further analysis. The files for the same are loacated [here](Extraction_tranformation.ipynb). The final tables and database relationship tables were made using Quickdbd 
![image](Results/QuickDBD-export%20(2).png)

# Loading 
Database was created in SQl server and related tables were loaded for further analysis

# Analysis
Sql queries to get insights were performed such as
- to get province wise rents
~~~
SELECT p.Provinces, r.YEAR, ROUND(AVG(r._1_Bedroom),2) AS '1 BHK' ,ROUND(AVG(r._2_Bedroom),2) AS '2 BHK'
FROM [Rental Data] r
INNER JOIN Provinces p ON r.province_id = p.province_id
WHERE r._1_Bedroom > 0
GROUP BY r.YEAR, p.Provinces;
 ~~~

- Average rents centrewise
~~~ 
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
~~~

* created views to get summary
~~~
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
~~~

# Insights and results

- In general the overall trend for the rents across Canada has been on the increasing side 

![](Results/Rnts%20yearwise.png)


- Among the Provinces British Columbia has seen the highest rents for all the years followed by Ontario.
- In Ontario Toronto Centre tops the rents for all the years
![](Results/Average%20rents%20based%20on%20province%20and%20centre.png)


- In B. C Vancouver is the least affordabale place rentwise.


- In Albeta, Calgary has seen the highest rents 

![](Results/Summary%20for%20the%20provinces.png)


- Top three centres in BC are

![](Results/Top%203%20Centres.png)

- Toronto , Barrie and Ottawa are the least affordable areas in Ontario for both 1 and 2 BHK

![](Results//Top%203%20centres%20based%20on%20the%20Year%20and%20Centre.png)


