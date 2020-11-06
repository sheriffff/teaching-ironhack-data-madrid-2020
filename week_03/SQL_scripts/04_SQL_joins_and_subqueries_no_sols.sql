##########################################################
##########################################################

#                     SQL Joins

# ¯\_( ͡° ͜ʖ ͡°)_/¯¯\_( ͡° ͜ʖ ͡°)_/¯¯\_( ͡° ͜ʖ ͡°)_/¯¯\_( ͡° ͜ʖ ͡°)_/¯

##########################################################
##########################################################
/* 

SQL joins is what allows to mix information from different 
tables, unleashing the true power of relational databases.

Relational schemas are your friend here, since you need to 
know what tables you can link together.

The columns we use to relate tables must represent the same
object (such as id)

*/
###########
# PREAMBLE

# for some rather technical reasons, run this query if you 
# ever encounter a error 1055 during this lesson!

# set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');
# set @@global.sql_mode := concat('ONLY_FULL_GROUP_BY,', @@global.sql_mode);

/*
For the purpose of this lesson
we willuse two duplicate tables:
 * departments_dup
 * dept_manager_dup 
 
By now you should understand this commands, 
but let´s skip the details and just run it.

We do so in order to include some null data 
and illustrate better the different types of 
JOINS.

*/

# DUPLICATE AND DEPARTMENTS
SELECT * FROM departments;

# Create an empty duplicate
DROP TABLE IF EXISTS departments_dup;
CREATE TABLE departments_dup (
    dept_no CHAR(4) NULL,
    dept_name VARCHAR(40) NULL
);

# Populate it with the same values in departments
INSERT INTO departments_dup (
		dept_no, dept_name)
SELECT *
FROM departments;

# Modify some data
INSERT INTO departments_dup (dept_name) 
VALUES ('Public Relations');

DELETE FROM departments_dup 
WHERE dept_no = 'd002';  
    
INSERT INTO departments_dup(dept_no) 
VALUES ('d010'), ('d011');

# DUPLICATE dept_manager 

# Create the table
DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
  emp_no int(11) NOT NULL,
  dept_no char(4) NULL,
  from_date date NOT NULL,
  to_date date NULL
  );

# Insert the original values
INSERT INTO dept_manager_dup
SELECT * FROM dept_manager;

# Add some values
INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES  (999904, '2017-01-01'),
		     (999905, '2017-01-01'),
        (999906, '2017-01-01'),
       	(999907, '2017-01-01');

# Delete some values
DELETE FROM dept_manager_dup 
WHERE
    dept_no = 'd001'; 

###########
-- INNER JOIN: https://www.mysqltutorial.org/mysql-inner-join.aspx 
/*
Syntax:

SELECT
    select_list
FROM t1
INNER JOIN t2 ON join_condition1
INNER JOIN t3 ON join_condition2
...;

*/
# LEFT table: dept_manager_dup
# RIGHT table: departments_dup

# Common key: dept_no
-- 

# LEFT table: dept_manager_dup

SELECT *
FROM dept_manager_dup
ORDER BY dept_no;
# (notice the NULLS)

# RIGHT table: departments_dup
SELECT *
FROM departments_dup
ORDER BY dept_no;

# (notice the NULLS: which is the PK of this table?)


SELECT m.dept_no, m.emp_no, d.dept_name      # notice we can use the aliases right here!
FROM dept_manager_dup m                      # equivalent to dept_manager_dup AS m
INNER JOIN departments_dup d                 # equivalent to departments_dup AS d
ON m.dept_no = d.dept_no                     # --> Jaime! no need to be keys (just same object)
ORDER BY m.dept_no;

/*
We have data about the departments from 3 to 9 only.
There is no data about departments 1, 2, 10 or 11 nor about the ones labeled as NULL values.
Why is this happening? --> INNER JOIN

--> Check the LEFT and RIGHT tables to make sure you understand the output

*/

# Just like in pandas, the default join is INNER,
# so we might ommit that keyword.

SELECT m.dept_no, m.emp_no, d.dept_name      
FROM dept_manager_dup m                     
JOIN departments_dup d                 
ON m.dept_no = d.dept_no                     
ORDER BY m.dept_no;


###########
/*

NOTE: 

Although it is undesired, duplicate rows might happen in your
database (or pandas DataFrame). The way JOINS work there can
be tricky. We won´t be dealing with this here but bare in mind 
it is possible. Here is a vide you might want to see to get an
idea:

https://www.youtube.com/watch?v=dJVuo0v6jqg

*/
###########
-- LEFT JOIN: https://www.mysqltutorial.org/mysql-left-join.aspx

# Let us repeat the same query but with a LEFT join

# Can you anticipate the differences??
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d          # you could also use LEFT OUTER JOIN
ON m.dept_no = d.dept_no            
ORDER BY m.dept_no;


-- trick to keep only the entries in LEFT not in RIGHT
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d ON m.dept_no = d.dept_no
WHERE dept_name IS NULL
ORDER BY m.dept_no;


###########
-- RIGHT JOIN: https://www.mysqltutorial.org/mysql-right-join/

/*
Since LEFT JOIN already exists there are actually no reasons
to use RIGHT JOIN. They are rarely used in practice. 
But they exist, so it is good to know them!
*/

# EXERCISE: Modify this query so that it returns the same output
#           but using a right join

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d          
ON m.dept_no = d.dept_no            
ORDER BY m.dept_no;







###########
-- JOIN and WHERE Used Together

# Select the employees and salaries of those earning less that 50000
SELECT e.emp_no, e.first_name, e.last_name, s.salary # it is good practice to keep emp_no and salary here
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE s.salary < 50000;



###########
-- CROSS JOIN: https://www.mysqltutorial.org/mysql-cross-join/
/* 

A cross join produces a cartesian product between the two tables, returning all possible combinations of all 
rows. It has no on clause because you're just joining everything to everything.

We want see this in the lesson, but is good to know that it exists.

See also: https://stackoverflow.com/questions/3228871/sql-server-what-is-the-difference-between-cross-join-and-full-outer-join#:~:text=CROSS%20JOIN%20is%20simply%20Cartesian,OUTER%20JOIN%20of%20two%20tables.&text=Then%20CROSS%20JOIN%20will%20return,25%20rows%20in%20result%20set.
*/

###########
-- Combining Aggregate Functions and Joins


# Finally!!! What is the average salary of men and women??
SELECT e.gender, ROUND(AVG(s.salary)) AS average_salary 
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY gender;

# Add standard deviation (syntax is not highlighted (ᗒᗣᗕ)՞)
SELECT e.gender, ROUND(AVG(s.salary)) AS average_salary, ROUND(STD(s.salary)) AS std_deviation
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY gender;  

# What is the average salary of men and women that make more than 60000??









# Solution
SELECT e.gender, ROUND(AVG(s.salary)) AS average_salary 
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary > 60000                   # AND will also work, can you guess why?
GROUP BY gender;


###########
/*
We won´t be covering this in detail here, but beware that we can 
combine more than two tables in a JOIN

*/
SELECT e.first_name, e.last_name, e.hire_date, m.from_date, d.dept_name
FROM employees e
	JOIN dept_manager m 
		ON e.emp_no = m.emp_no
	JOIN departments d 
		ON m.dept_no = d.dept_no;

###########
/*
Finally, it is possible to "append" tables as in pandas "append"
---stacking one on top of the other.

We won´t cover these cases here, but beware they exist!

UNION: https://www.mysqltutorial.org/sql-union-mysql.aspx/

*/
##########################################################
##########################################################
#
#                  SUBQUERIES
#
# (You guessed right, we can write queries inside of queries, 
# inside of queries...) ᕙ(▀̿̿Ĺ̯̿̿▀̿ ̿) ᕗ
##########################################################
##########################################################    


###########
-- Subqueries with IN nested inside WHERE

# All employees names and surnames
SELECT e.first_name, e.last_name
FROM employees e;

# All emp_no from managers 
SELECT 
    dm.emp_no
FROM
    dept_manager dm;
    

# A query within a query!! 
# All names and surnames of managers
SELECT 
    e.first_name, e.last_name        # outer query
FROM
    employees e
WHERE
    e.emp_no IN (SELECT              # inner query (subquery)
            dm.emp_no
        FROM
            dept_manager dm);
            
# EXERCISE: Get the same result than above but using a JOIN










/*
NOTE: it is often the case that a query can be executed both with a
subquery or a JOIN. It is a matter of style, performance, readability 
which one to use. Read this if you wanna know more!

https://stackoverflow.com/questions/2577174/join-vs-sub-query
*/


-- EXERCISE (use subqueries or JOIN as you prefer!)

/* Extract the information about all department managers who 
were hired between the 1990-01-01 and the 1995-01-01. */



/* 
Lastly, a couple of things we did not cover here but you might want to check yourself

* VIEWS: By definition, a view is a named query stored in the database catalog.
					 https://www.mysqltutorial.org/mysql-views-tutorial.aspx 

* TEMPORARY TABLE: In MySQL, a temporary table is a special type of table that allows you to store a temporary result set, which you can reuse several times in a single session.
https://www.mysqltutorial.org/mysql-temporary-table/
*/

###################################
#           THE END
#      
#           \ (•◡•) / 
###################################