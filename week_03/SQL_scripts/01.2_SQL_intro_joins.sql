CREATE DATABASE publications;
USE publications;

/* From looking at our ERD, we know that publishers and titles have a one-to-many relationship. Let's join them and get a count of the number of titles each publisher has published. */

SELECT pub_name, COUNT(title_id) AS count_titles
FROM publishers 
INNER JOIN titles
ON publishers.pub_id = titles.pub_id
GROUP BY pub_name;

/* Because we used an INNER JOIN for this query, it returns only results for publishers whose pub_id is in both tables. What if we wanted the results to return records for all the publishers, regardless of whether they had published any titles? This is exactly what a left join can help us with. All we need to do is replace our INNER JOIN with a LEFT JOIN and it will return all the records in the publishers table and count zero records for the ones that do not have any titles published.*/

SELECT pub_name, COUNT(title_id) AS count_titles
FROM publishers 
LEFT JOIN titles
ON publishers.pub_id = titles.pub_id
GROUP BY pub_name;


/* What if we wanted to analyze how many units were sold for each title? We could declare our sales table first, our titles table second, and use a RIGHT JOIN to ensure that our query returns a record for every title (even the ones that did not have any sales).*/


SELECT title, type, price, SUM(qty) AS units_sold
FROM sales
RIGHT JOIN titles
ON sales.title_id = titles.title_id
GROUP BY title, type, price;


/*
The command for an outer join is typically FULL OUTER JOIN. However, MySQL does not support full outer joins, so we must improvise and perform them using a combination of the LEFT JOIN, RIGHT JOIN, and UNION commands. The left and right joins will collectively return all the records from each of the joined tables. The UNION command combines the results of two queries, and it should be placed directly between them. For example, if we wanted to see what employees were assigned to which jobs, ensuring that the query returns both employees not assigned to a job and jobs not assigned to any employee, we would write our query as follows --- notice also that we can reference tables and columns as if they were attributes in Python classes :).
*/

SELECT *
FROM publications.employee emp
RIGHT JOIN publications.jobs job
ON emp.job_id = job.job_id
UNION
SELECT *
FROM publications.employee emp
LEFT JOIN publications.jobs job
ON emp.job_id = job.job_id;
