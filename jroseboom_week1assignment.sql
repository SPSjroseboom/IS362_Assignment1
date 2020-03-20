-- ***IS 362 Assignment 1 – SQL and Tableau (Review)*** --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Part 1. SQL and NULLs 
-- Please use the tables in the flights database.  Your deliverable should include the SQL queries 
-- that you write in support of your conclusions.  You may use multiple queries to answer questions.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1a. How many airplanes have listed speeds? 
--
-- ANSWER: My script below uses SELECT COUNT(*) to give the total number of planes that have listed
-- speeds FROM the 'planes' table that doesn't have a null value. 
-- The total number of planes is 23. 
--
SELECT COUNT(*) AS planespeed_notnull 
FROM planes 
WHERE speed IS NOT null;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1b. What is the minimum listed speed and the maximum listed speed?
--
-- ANSWER: My two scripts below uses SELECT MAX(speed) FROM the 'planes' table and also SELECT MIN(speed)
-- to find the maximum and minimum speeds. 
-- The MAX speed is 432 mph. 
-- The MIN speed is 90 mph.
--
SELECT MAX(speed) AS max_listedspeed 
FROM planes;

SELECT MIN(speed) 
AS min_listedspeed 
FROM planes;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 2a. What is the total distance flown by all of the planes in January 2013? 
-- 
-- ANSWER:  My script below uses SELECT SUM(distance) to calculate the sum of the amount of miles travelled by
-- all of the planes FROM the 'flights' table in January (WHERE month=1) AND 2013 (year=2013). 
-- The total distance is 27,188,805 miles.
--
SELECT SUM(distance) AS totaldist_jan2013 
FROM flights 
WHERE month=1 AND year=2013;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 2b. What is the total distance flown by all of the planes in January 2013 where the tailnum is missing?
--
-- ANSWER: My script below uses SELECT SUM(distance) to calculate the sum of the amount of miles travelled by
-- all of the planes FROM the 'flights' table in January (WHERE month=1) AND 2013 (year=2013) AND the tailnum is
-- missing(""). This is not to be confused with a NULL value. 
-- The total distance is 81,763 miles.
-- 
SELECT SUM(distance) AS totaldist_jan2013_emptytailnum 
FROM flights 
WHERE month=1 AND year=2013 AND tailnum="";
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 3a. What is the total distance flown for all planes on July 5, 2013 grouped by aircraft manufacturer?  
-- Write this statement first using an INNER JOIN, then using a LEFT OUTER JOIN. 
--  
-- ANSWER: My script below uses SELECT planes.manufacturer and SUM(flights.distance) to show the sum of all distance
-- columns FROM the 'flights' table then INNER JOIN with 'planes' table using the tailnum column from both tables.alter
-- We only want to select the data from July 5th, 2013 and then group by planes.manufacturer so we can only have distinct
-- values for manufacturer and only the sums of their distances. The next script is the same thing but instead of an
-- INNER JOIN we use an OUTER LEFT JOIN.
--
SELECT planes.manufacturer, SUM(flights.distance) 
FROM flights 
INNER JOIN planes 
ON flights.tailnum = planes.tailnum
WHERE flights.month=7 AND flights.day=5 AND flights.year=2013
GROUP BY planes.manufacturer
ORDER BY SUM(flights.distance) DESC;

SELECT planes.manufacturer, SUM(flights.distance) 
FROM flights 
LEFT OUTER JOIN planes 
ON flights.tailnum = planes.tailnum
WHERE flights.month=7 AND flights.day=5 AND flights.year=2013
GROUP BY planes.manufacturer
ORDER BY SUM(flights.distance) DESC;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 3b. How do your results compare?
--
-- ANSWER: The LEFT OUTER JOIN result includes a NULL value in the manufacturer column while the INNER JOIN
-- does not. Generally speaking, the INNER JOIN shows all the results with the rows they have in common- like with the 
-- tailnum column. LEFT OUTER JOIN shows everything in it's result plus all the rows it has in common with the other table.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 4. Write and answer at least one question of your own choosing that joins information from at least three 
-- of the tables in the flights database. 
--
-- QUESTION: Which Boeing flight traveled the farthest distance on Christmas of 2013?
-- ANSWER: United Air Lines Flight# 15 traveled the farthest distance on Christmas of 2013.
--
SELECT flights.flight, airlines.name, flights.month, flights.day, flights.year, SUM(flights.distance)
FROM flights 
INNER JOIN planes 
ON flights.tailnum = planes.tailnum
INNER JOIN airlines
ON flights.carrier = airlines.carrier
WHERE flights.month=12 AND flights.day=25 AND flights.year=2013 AND planes.manufacturer="Boeing"
GROUP BY airlines.name, flights.flight, flights.month, flights.day, flights.year
ORDER BY SUM(flights.distance) DESC;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
