--Samuel Mainwood
-- s3939120
--Submission for Database Concepts A4
--queries.sql
-- Q1
SELECT c_final.Name AS "Country Name", total.Value as "TotalVaccinations (Administered to Date)", c_final.DailyVaccinations AS "Daily Vaccinations", c_final.Date AS "Date"
FROM CountryStats total
    INNER JOIN (
        SELECT c.Name, c.CountryCode, agg.Date, agg.DailyVaccinations, agg.Average
            FROM Country c
                INNER JOIN (
                    SELECT cs.CountryCode, cs.Date, cs.Value as "DailyVaccinations", cd.Average
                    FROM CountryStats cs
                    INNER JOIN (SELECT AVG(Value) as "Average", Date
                    FROM CountryStats
                    WHERE Statistic = "daily_vaccinations"
                    GROUP BY Date) cd on cs.Date = cd.Date
                    WHERE cs.Value > cd.Average AND cs.Statistic = "daily_vaccinations") agg
                ON c.CountryCode = agg.CountryCode) c_final
            ON total.CountryCode = c_final.CountryCode
            AND total.Date = c_final.Date
WHERE Statistic = "total_vaccinations";

--Q2 Cumulative Stats above average
WITH Totals AS (
    SELECT MAX(value) AS "TotalNo" 
    FROM CountryStats
    WHERE statistic = "total_vaccinations"
    GROUP BY CountryCode),
AverageTotal AS(
SELECT AVG(TotalNo)
FROM Totals)
SELECT c.Name AS "Country", Max(cs.Value) as "Cumulative Doses"
FROM CountryStats cs 
    INNER JOIN Country c
    ON cs.CountryCode = c.CountryCode
WHERE cs.Statistic = "total_vaccinations"
GROUP BY c.Name
HAVING Max(cs.Value) > (SELECT * FROM AverageTotal);

-- Q3 - Vaccines by Manufacturer
SELECT c.Name AS "Country", vax.ManufacturerName AS "Vaccine Type"
FROM Country c INNER JOIN VaccinesByManufacturer vax
ON c.CountryCode = vax.CountryCode
GROUP BY c.Name, vax.ManufacturerName;

--Q4 - Vaccines by Biggest Source
SELECT c.Name AS "Country",  cd.SourceURL AS "Source Name (URL)", cs.value AS "Biggest total Administered Vaccines" FROM
(Country c INNER JOIN CountryDataSource cd 
ON c.CountryCode = cd.CountryCode) INNER JOIN CountryStats cs ON cd.CountryCode = cs.CountryCode
AND cd.LatestDate = cs.Date
WHERE cs.Statistic = "total_vaccinations"
GROUP BY cd.SourceURL
ORDER BY cd.SourceURL;


--Q5 France, Aus, England, Germany
WITH DateRange AS (
    SELECT DISTINCT Date
    FROM CountryStats
    WHERE JulianDay(Date) % 7 = 0
    AND JulianDay(Date) BETWEEN JulianDay('2021-01-01') AND JulianDay('2023-01-01')
),
CountryVaccinations AS (
    SELECT CountryCode, Date, Value
    FROM CountryStats
    WHERE Statistic = 'people_fully_vaccinated'
        AND Date IN DateRange
)
SELECT d.Date AS "Week",
       MIN(CASE WHEN c.CountryCode = 'AUS' THEN c.Value END) AS Australia,
       MIN(CASE WHEN c.CountryCode = 'FRA' THEN c.Value END) AS France,
       MIN(CASE WHEN c.CountryCode = 'DEU' THEN c.Value END) AS Germany,
       MIN(CASE WHEN c.CountryCode = 'OWID_ENG' THEN c.Value END) AS England
FROM DateRange d
INNER JOIN CountryVaccinations c ON d.Date = c.Date
GROUP BY d.Date
ORDER BY d.Date;
