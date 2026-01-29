Use sakila ; 
-- Identify if there are duplicates in Customer table. Don't use customer id to check the duplicates
SELECT first_name, last_name, email, COUNT(*) AS duplicate_count
FROM sakila.customer
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;

-- Number of times letter 'a' is repeated in film descriptions
SELECT 
    SUM(
        LENGTH(description) 
        - LENGTH(REPLACE(LOWER(description), 'a', ''))
    ) AS total_a_count
FROM sakila.film;

 -- Number of times each vowel is repeated in film descriptions 
 SELECT 'a' AS vowel,
       SUM(LENGTH(description) - LENGTH(REPLACE(LOWER(description), 'a', ''))) AS count
FROM sakila.film
UNION ALL
SELECT 'e',
       SUM(LENGTH(description) - LENGTH(REPLACE(LOWER(description), 'e', '')))
FROM sakila.film
UNION ALL
SELECT 'i',
       SUM(LENGTH(description) - LENGTH(REPLACE(LOWER(description), 'i', '')))
FROM sakila.film
UNION ALL
SELECT 'o',
       SUM(LENGTH(description) - LENGTH(REPLACE(LOWER(description), 'o', '')))
FROM sakila.film
UNION ALL
SELECT 'u',
       SUM(LENGTH(description) - LENGTH(REPLACE(LOWER(description), 'u', '')))
FROM sakila.film;

-- Display the payments made by each customer

-- Payments made by each customer – MONTH-WISE
SELECT 
    customer_id,
    YEAR(payment_date)  AS year,
    MONTH(payment_date) AS month,
    SUM(amount)         AS total_payment
FROM sakila.payment
GROUP BY customer_id, YEAR(payment_date), MONTH(payment_date)
ORDER BY customer_id, year, month;

-- Payments made by each customer – YEAR-WISE
SELECT 
    customer_id,
    YEAR(payment_date) AS year,
    SUM(amount)        AS total_payment
FROM sakila.payment
GROUP BY customer_id, YEAR(payment_date)
ORDER BY customer_id, year;

-- Payments made by each customer – WEEK-WISE
SELECT 
    customer_id,
    YEAR(payment_date) AS year,
    WEEK(payment_date) AS week,
    SUM(amount)        AS total_payment
FROM sakila.payment
GROUP BY customer_id, YEAR(payment_date), WEEK(payment_date)
ORDER BY customer_id, year, week;

-- Check if any given year is a leap year or not. You need not consider any table from sakila database. Write within the select query with hardcoded date
SELECT 
    CASE 
        WHEN (YEAR('2024-01-01') % 400 = 0)
          OR (YEAR('2024-01-01') % 4 = 0 AND YEAR('2024-01-01') % 100 <> 0)
        THEN 'Leap Year'
        ELSE 'Not a Leap Year'
    END AS leap_year_result;
    
    -- Display number of days remaining in the current year from today.
    USE sakila;

SELECT 
    DATEDIFF(
        STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-12-31'), '%Y-%m-%d'),
        CURDATE()
    ) AS days_remaining_in_year;