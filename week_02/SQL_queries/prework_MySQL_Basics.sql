
/* LESSON 1 MySQL Basics */

DROP DATABASE IF EXISTS Apps;
CREATE DATABASE Apps;
USE Apps;
CREATE TABLE Ratings (
    ID INT,
    AppName VARCHAR(255),
    AppSize BIGINT,
    Price FLOAT,
    TotalRatings FLOAT,
    CurrentVersionRatings FLOAT,
    OverallRating FLOAT,
    CurrentVersionRating FLOAT,
    Genre VARCHAR(50)
);

/* IMPORT Ddata apple_store.csv using Sequel Pro*/


/* Select everything in the table */
SELECT *
FROM Ratings;

/* Select just some fields (columns) */
SELECT AppName, Price, TotalRatings, OverallRating, Genre
FROM Ratings;



/* Select just some fields (columns)  
  and rows satisfying a conditionb */

SELECT AppName, Price, TotalRatings, OverallRating, Genre
FROM Ratings
WHERE Price = 0 AND OverallRating >= 4;

/* Order the results in descending order by TotalRating 
 and limit our results to 20 records
*/

SELECT AppName, Price, TotalRatings, OverallRating, Genre
FROM Ratings
WHERE Price = 0 AND OverallRating >= 4
ORDER BY TotalRatings DESC
LIMIT 20;



