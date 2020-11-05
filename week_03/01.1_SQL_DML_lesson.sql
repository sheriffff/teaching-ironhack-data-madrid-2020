##########################################################
##########################################################
#
#            The SQL SELECT Statement
#		      			 (& Friends)
#
#                    \ (•◡•) /
#
##########################################################
##########################################################

USE employees;

###########
-- SELECT - FROM: https://www.mysqltutorial.org/mysql-select-statement-query-data.aspx

# select specific columns from table
SELECT first_name, last_name, birth_date
FROM employees;

# select all columns from table   
SELECT * 
FROM employees;


###########
-- WHERE: https://www.mysqltutorial.org/mysql-where/

/* 
Allows us to specify conditions that the data we want to select
need to satisfy
*/

-- All employees named Hugo
SELECT *
FROM employees
WHERE first_name = 'Hugo';
    
-- All female employees

SELECT *
FROM employees
WHERE gender = 'F';

###########    
/*
In SQL there are many OPERATORS that are used to link
keywords and symbosl. Let´s have a look to the most 
frequent ones!
*/    
###########
-- AND: https://www.mysqltutorial.org/mysql-and/

-- All female employees named Hugo
SELECT *
FROM employees
WHERE first_name = 'Hugo' AND gender = 'F';
    


###########
-- OR: https://www.mysqltutorial.org/mysql-or/

-- All employees that are either female or named Hugo

SELECT *
FROM employees
WHERE first_name = 'Hugo' OR first_name = 'F';
    
    
###########
-- Operator Precedence

# What is this query going to return??
SELECT *
FROM employees
WHERE first_name = 'Hugo' AND gender = 'M' OR gender = 'F';

/*
SQL rule: The operator AND takes precedence over the operator OR
			  If we want to override this behaviour, we must use parentheses.
*/

SELECT *
FROM employees
WHERE last_name = 'Hugo' AND (gender = 'M' OR gender = 'F');
    


###########
-- IN / NOT IN: https://www.mysqltutorial.org/sql-in.aspx

# Retrieve all data for people named either: Hugo, Mark, Bojan, or Anneke
SELECT *
FROM employees
WHERE 
	first_name = 'Hugo'
	OR first_name = 'Mark'
	OR first_name = 'Bojan'
	OR first_name = 'Anneke';

# A better option ("Python like")
SELECT *
FROM employees
WHERE first_name IN ('Hugo', 'Mark', 'Bojan','Anneke');

# Or, to do just the opposite
SELECT *
FROM employees
WHERE first_name NOT IN ('Hugo', 'Mark', 'Bojan','Anneke');

###########
-- LIKE / NOT LIKE: https://www.mysqltutorial.org/mysql-like/
/*
Query data based on a specified pattern
Syntax: expression LIKE pattern ESCAPE escape_character


(Notice that the patterns are not case sensitive)
*/

# The percentage ( % ) wildcard matches any string of zero or more characters. 
# (It can be seen as a substitute for a sequence of characters)

# Select all employees whose name starts with 'An'
SELECT *
FROM employees
WHERE first_name LIKE('An%');
    
# What will this do?
SELECT *
FROM employees
WHERE first_name LIKE('%An');

# And this?    
SELECT *
FROM employees
WHERE first_name LIKE('%AN%');


-- The underscore ( _ ) wildcard matches any single character--- but only one

SELECT *
FROM employees
WHERE first_name LIKE ('mar_');

# (NOT LIKE works just in the opposite way)

# Retrieve all data from employees not hired in the year 1990
SELECT *
FROM employees
WHERE hire_date NOT LIKE ('1990%');

    
/*
NOTE: *, %, _ are called "Wildcard Characters" 
*/


###########
-- BETWEEN - AND: https://www.mysqltutorial.org/mysql-between

# with dates
SELECT *
FROM employees
WHERE 
	hire_date BETWEEN '1990-01-01' AND '2000-01-01';    

# It is equivalent to	
SELECT *
FROM employees
WHERE 
	hire_date >= '1990-01-01' AND hire_date >= '2000-01-01';  
    
# with numeric types    
SELECT *
FROM salaries
WHERE 
	salary NOT BETWEEN 60000 AND 70000;

# with strings

SELECT first_name
FROM employees
WHERE first_name BETWEEN 'a%' AND 'd%';
    
###########
-- IS NOT NULL / IS NULL: https://www.mysqltutorial.org/mysql-is-null/
-- Just like pandas ʕ•ᴥ•ʔ
    
SELECT *
FROM employees
WHERE first_name IS NULL;

SELECT *
FROM employees
WHERE first_name IS NOT NULL;

###########
-- Mathematical Comparison Operators

	# equals =
	# not equal <> or !=   
	# greater than >
	# greater or equal than >
	# less than < 
	# less than or equal  

-- EXERCISE: Retrieve all columns for female employes hired (strictly) after '2015-01-01'


SELECT *
FROM employees
WHERE 
	hire_date >= '2000-01-01' AND gender = 'F';


###########
-- SELECT DISTINCT: https://www.mysqltutorial.org/mysql-distinct.aspx

SELECT gender
FROM employees;
    
# make clear you don´t want duplicates 
SELECT DISTINCT gender
FROM employees;
    

###########
-- Introduction to Aggregate Functions: https://www.mysqltutorial.org/mysql-aggregate-functions.aspx

/* 
An aggregate function performs a calculation on multiple rows and returns a single value.
Syntax: function_name(DISTINCT | ALL expression)

All aggregate functions IGNORE NULL values unless specified
*/    

# How many employees are there in our database? 
# hint: emp_no is the primary key of the table

SELECT COUNT(emp_no)
FROM employees;

# How many different names do we have in the table??
SELECT  COUNT(DISTINCT first_name)
FROM employees;

-- How many employes were born after 1965-01-01??
SELECT COUNT(*) # NOTE using * makes COUNT to include NULL values
FROM employees
WHERE
    birth_date >= '1965-01-01';
    
###########
-- ORDER BY: https://www.mysqltutorial.org/mysql-order-by/

# Order names in alphabetical order
SELECT *
FROM employees
ORDER BY first_name ASC; # ASC is the default

SELECT *
FROM employees
ORDER BY first_name DESC;

# Use multiple fields
SELECT *
FROM employees
ORDER BY first_name , last_name;

# MAX()
SELECT 
    MAX(salary) AS highest_salary
FROM
    salaries;

# AVG()
SELECT 
    AVG(salary) AS mean_salary
FROM
    salaries;

# Count the number of unique departments
SELECT 
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;

###########
-- GROUP BY: https://www.mysqltutorial.org/mysql-group-by.aspx
# Does this sound familiar to you? ʕ•ᴥ•ʔ
/*
Syntax:

SELECT 
    c1, c2,..., cn, aggregate_function(ci)
FROM
    table
WHERE
    where_conditions
GROUP BY c1 , c2,...,cn
ORDER BY c1, c2, ...;
*/

# Count the number of times each name appears in the table employees
SELECT first_name, COUNT(first_name) # it is a good habit to include the column you are grouping by
FROM employees
GROUP BY first_name;  

# EXERCISE: Repeat the query but ordering the result in alphabetical order
SELECT first_name, COUNT(first_name)
FROM employees
GROUP BY first_name
ORDER BY first_name;


###########
-- Using Aliases (AS): https://www.mysqltutorial.org/mysql-alias/

/* Used to rename a selection from your query to clarify the output*/

# Rename the COUNT(first_name) column
SELECT first_name, COUNT(first_name) AS names_count
FROM employees
GROUP BY first_name
ORDER BY first_name;


###########
-- HAVING: https://www.mysqltutorial.org/mysql-having.aspx

/*
Used frequently with GROUP BY, it specifies a filter condition for groups of rows or aggregates.
It works like a WHERE but inside a GROUP BY clause

Syntax:

SELECT 
    select_list
FROM 
    table_name
WHERE 
    search_condition
GROUP BY 
    group_by_expression
HAVING 
    group_condition;
ORDER BY
	 column_name(s)
	 
After HAVING, you can have a condition with an aggregate function,
while WHERE cannot use aggregate functions within its conditions

*/

# WHERE and HAVING equivalent:
SELECT 
    *
FROM
    employees
WHERE
    hire_date >= '2000-01-01';
    
SELECT 
    *
FROM
    employees
HAVING
    hire_date >= '2000-01-01';

# Example WHERE doesn´t work, HAVING does:

/*Extract all first names that appear more than 250 times in the Employees table.*/

	# WHERE doesn´t work:

SELECT 
    first_name, COUNT(first_name) as names_count
FROM
    employees
GROUP BY first_name
# HAVING|WHERE names_count > 250
ORDER BY first_name;


-- WHERE vs HAVING 

/*

WHERE allows us to set conditions that refer to subsets of individual rows.
These conditions are applied *before* reorganizing the output into groups.

It is not until this moment that the output can be further improved or filtered with a condition specified
in the HAVING clause.
*/

/*

From the subset of employees hired before 2015, (it applies to all rows --> WHERE)
Extract a list of all names that are encountered less than 250 times. (aggregate funct COUNT --> HAVING)

*/

SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
WHERE
    hire_date < '2015-01-01'
GROUP BY first_name
HAVING COUNT(first_name) < 250
ORDER BY first_name;

###########
-- LIMIT: https://www.mysqltutorial.org/mysql-limit.aspx


# Show the employee numbers of the 10 highest paid employees 
SELECT 
    emp_no, salary
FROM
    salaries
ORDER BY salary DESC
LIMIT 10;


########### EXTRA ###################
-- SQL has built-in functions to deal with NULL values. Good examples are:

# IFNULL(expression_1,expression_2); returns expression_1 if expression_1 is not NULL ; otherwise, it returns expression_2

# COALESCE(value1,value2,...);takes a number of arguments and returns the first non-NULL argument. 
# In case all arguments are NULL, the COALESCE function returns NULL.

# for more info: 
-- > COALESECE() https://www.mysqltutorial.org/mysql-coalesce/
-- > IFNULL() https://www.mysqltutorial.org/mysql-ifnull/
