/* LESSON 2 Summary Statistics in MySQL */
USE Apps;

/* Groupong in SQL (get unique values)*/
SELECT Genre
FROM Ratings
GROUP BY Genre;

/* See the range of a variable */
SELECT Price
FROM Ratings
GROUP BY Price
ORDER BY Price ASC;


/* We can even group by multiple fields to see prices by genre. */

SELECT Genre, Price
FROM Ratings
GROUP BY Genre, Price
ORDER BY Genre ASC, Price ASC;

/* counting */
SELECT COUNT(*)
FROM Ratings;

/* total number of unique genres in our data */
SELECT COUNT(DISTINCT(Genre))
FROM Ratings;

/* number of records in each genre */

SELECT Genre, COUNT(*) AS Records
FROM Ratings
GROUP BY Genre;
/* let's add sorting and limiting to our query to get the top 3 genres with the most apps */
SELECT Genre, COUNT(*) AS Records
FROM Ratings
GROUP BY Genre
ORDER BY COUNT(*) DESC
LIMIT 3; 

/* summing */
/* see what genre has had the most number of ratings */ 

SELECT Genre, SUM(TotalRatings) AS TotalRatings
FROM Ratings
GROUP BY Genre
ORDER BY SUM(TotalRatings) DESC;

/* Averaging */
SELECT Genre, SUM(TotalRatings) AS TotalRatings, AVG(OverallRating) AS AvgRating
FROM Ratings
GROUP BY Genre
ORDER BY SUM(TotalRatings) DESC;

/* Adding conditions */
SELECT Genre, SUM(TotalRatings) AS TotalRatings, AVG(OverallRating) AS AvgRating
FROM Ratings
WHERE Price = 0
GROUP BY Genre
ORDER BY SUM(TotalRatings) DESC
LIMIT 5;