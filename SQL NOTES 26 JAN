--Subqueries -- A subquery is a query written inside another query. The inner query runs first and its result is used by the outer query.
--Inner query gets all address IDs from the customer table.
--Outer query finds first and last names of customers whose address_id is in the list returned by the subquery.”
--IN means: check if value exists in the result of subquery

SELECT first_name, last_name                          ________
FROM sakila.customer                                         |
WHERE address_id IN (                                        |------> Main query
SELECT address_id            -----| ---> Subquery            |
FROM sakila.customer              |                          |
);                           -----                    ________
--order: From-->subquery(inside where)-->Where-->Select

__________________________________________________________________________________________________________________________________________________________
---Actors who acted in more than 10 films
--Subquery calculates actors with more than 10 films. Main query fetches actor details
--HAVING is used with aggregate functions like COUNT()

SELECT actor_id, first_name, last_name   ---actor table
FROM sakila.actor
WHERE actor_id IN (
SELECT actor_id
FROM sakila.film_actor ---    ---(actor_id, film_id = film table)
GROUP BY actor_id             --Groups all rows by actor
HAVING COUNT(film_id) > 10      --Count how many movies each actor acted in.            
);
_____________________________________________________________________________________________________________________________________________________________
---Subquery in SELECT 
--: Subquery runs once for every actor and counts matching rows in the film_actor table.
--main query uses a subquery in the SELECT clause to calculate how many films each actor has acted in.

SELECT actor_id,first_name,last_name,
(
SELECT COUNT(*)
FROM sakila.film_actor
WHERE film_actor.actor_id = actor.actor_id     -- film_actor.actor_id (inside subquery) should match with current actor’s id from outer query
) AS film_count
FROM sakila.actor;                             ---Go through each actor one by one (Actor 1 ,Then Actor 2,Then Actor 3 …one at a time)
--ordrer: From-->SELECT actor_id,first_name,last_name,-->Subquery
________________________________________________________________________________________________________________________________________________________________

---Derived Tables-It's a temporary table created inside a query using a subquery in the FROM or JOIN  (It does not get saved in the database.)
---sakila.actor a → real table with actor names
---( ... ) fa → derived table (film counts)
--JOIN → combine both tables
--ON a.actor_id = fa.actor_id → match same actor

SELECT a.actor_id, a.first_name, a.last_name, fa.film_count
FROM sakila.actor a
JOIN (
SELECT actor_id, COUNT(film_id) AS film_count                  ______
FROM sakila.film_actor                                              | ---"Derived Table (Inner Query)--For each actor, count how many films they acted in and
GROUP BY actor_id                                                   |--- show only those actors who acted in MORE THAN 10 films"
HAVING COUNT(film_id) > 10                                     ______                                       
) fa ON a.actor_id = fa.actor_id;
___________________________________
----Top 5 customers by total payment
SELECT customer_id, total_spent
FROM (
SELECT customer_id, SUM(amount) AS total_spent
FROM sakila.payment
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5
) AS top_customers;  --name of that derived table
--Order of Execution: FROM - WHERE - GROUP BY- HAVING- SELECT-ORDER BY
__________________________________________  
  ---CASE statement (like IF–ELSE)
--SELECT * FROM grouped_customers       __
--WHERE group_label = 'Group N-Z';      __|--Takes the derived table, Shows only customers whose last name starts with N–Z
  
  SELECT *
FROM (
    SELECT last_name,                                                                          _____
           CASE                                                                                    |
               WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M' THEN 'Group A-M'                        |                   
               WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'                        |----->Taking customers' last names,Looking at the first letter of each last name,Putting them into groups
               ELSE 'Other'                                                                        |
           END AS group_label                                                                      |
    FROM sakila.customer                                                                      _____|
) AS grouped_customers 
WHERE group_label = 'Group N-Z';
# order of execution -- FROM ---- > Where --->  select 
______________________________________________________________________________________________________________________________________
----When to use Subqueries-:- You need temporary results to build your main query ,-- You are comparing against aggregate values
  
--customers who paid MORE than the average payment  
SELECT customer_id, amount
FROM sakila.payment
WHERE amount > (
SELECT AVG(amount)  --It calculates the average payment amount
FROM sakila.payment
);
____________________________________________________________________________________________________
---When Subqueries Fail
SELECT first_name,
(SELECT address_id FROM sakila.address WHERE district = 'California') AS cali_address       --Give me the address_id of all addresses in California(There are many addresses in California, not just one)
FROM sakila.customer;
--Subquery returns multiple rows
--- Subquery in SELECT must return ONLY ONE VALUE
_____________________________________________________________________________________________________________________________________________________________________________________________________________
---Correlated Subqueries:It's subquery that uses values from the outer query and executes once for each row of the outer query.
--sakila.film_actor table=This table connects movies and actors, One row = one actor in one movie
--fa.film_id → from the inner query , f.film_id → from the outer query
  
SELECT title,
(SELECT COUNT(*)
FROM sakila.film_actor fa
WHERE fa.film_id = f.film_id) AS actor_count
FROM sakila.film f;        --main query -- We are going movie by movie, f is just a short nickname or the film table
order: take first movie from film -> Run subquery → count actors for that movie -> Show result -> Take second movie -> Run subquery again -> Repeat for every movie
__________________________________________________________________________________________________________________
--Payments higher than customer’s average
Sakila.payment: table that keeps track of all payments customers have made.
Each payment has: payment_id , customer_id , amount ,payment_date
  
SELECT payment_id, customer_id, amount, payment_date
FROM sakila.payment p1                 ---tries to get the amount from sakila.customer, but usually, the customer table doesn’t have an amount column, so this might give an error.
WHERE amount > (
SELECT AVG(amount)
FROM sakila.payment p2
WHERE p2.customer_id = p1.customer_id     ---For every payment in p1 (outer query), the database checks the average amount for that specific customer using p2 (inner query).
                                          --(EX: Imagine you have a list of students and their test scores. You want to find the scores that are above each student’s personal average)
);
  
--Example with numbers: Let’s say customer_id = 1 made these payments:
payment_id	customer_id	 amount
101          	1          	50
102	          1         	100
103         	1	          150
The average for customer 1 is (50 + 100 + 150)/3 = 100.
The query checks each payment:
50 → not greater than 100 → ignore
100 → not greater than 100 → ignore
150 → greater than 100 → include!    
--payment_id 103 will show up for customer 1.
____________________________________________________________________________________________________________________________________________________________________________________________________________
#JOINS 
imagine you have two tables in your database:
--film – has all the movies.
--language – has the languages of the movies.
  
#INNER JOIN 
-------Give me a list of all movies along with their language names, but only if the movie has a valid language in the language table.---
  
--SELECT f.title, l.name AS language
     --f.title → we are picking the movie title from the film table (we call it f).
     --l.name AS language → we are picking the language name from the language table (we call it l) and giving it a column name language.

--FROM sakila.film f--This tells MySQL: “Start with the film table.”
--INNER JOIN sakila.language l ON f.language_id = l.language_id;
     --INNER JOIN sakila.language l → we are joining the language table, and calling it l.
     --ON f.language_id = l.language_id → the “matching rule”: match the language_id in the film table with language_id in the language table.
  
SELECT f.title, l.name AS language
FROM sakila.film f
INNER JOIN sakila.language l ON f.language_id = l.language_id;     --ON = “This is how we match the tables
-- SELECT f.title, l.name AS language
-- FROM sakila.film f
-- INNER JOIN sakila.language l ON f.language_id = l.language_id;
______________________________________________________________________________________________________________________________________________________________________________________________________
  #LEFT JOIN : A LEFT JOIN is a type of join that keeps all rows from the left table, even if there is no matching row in the right table.
  --If there’s no match in the right table, SQL fills it with NULL
------
SELECT f.title, c.name AS category
FROM sakila.film f            ---left table
LEFT JOIN sakila.film_category fc ON f.film_id = fc.film_id     --This joins the film_category table, which tells us which film belongs to which category.
                                                                --If a film doesn’t have a category, it still appears in the result, with NULL for category info.
LEFT JOIN sakila.category c ON fc.category_id = c.category_id;  --This brings in the category name from the category table.

SELECT c.customer_id, c.first_name, r.rental_id
FROM sakila.customer c
LEFT JOIN sakila.rental r ON c.customer_id = r.customer_id;          ---Joins the rental table, which lists which movies each customer rented.All customers will appear, even if they never rented a movie.

  __________________________________________________________________________________________________________________________________________________________________________________________________

#fullouter join           (LEFT JOIN + RIGHT JOIN + UNION)
# List all actors and the films they’ve acted in (even if unmatched on either side
---
SELECT a.actor_id, a.first_name, fa.film_id                            -----|
FROM sakila.actor a                                                         |--Take all rows from the left table (actor) and match with the right table (film_actor). 
LEFT JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id             -----|  If there’s no match, still keep the left table row, and fill the right side with NULL

UNION    --UNION combines the two results and removes duplicates.This way, we get all actors and films together, like a FULL OUTER JOIN.

SELECT a.actor_id, a.first_name, fa.film_id
FROM sakila.actor a
RIGHT JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id;

  ____________________________________________________________
#List all customers and all rentals, including those without each other
--LEFT JOIN → all customers + matching rentals
--RIGHT JOIN → all rentals + matching customers
--UNION → everything together
  
SELECT c.customer_id, r.rental_id                         -------|
FROM sakila.customer c                                           |-->left join: Take all customers (c) and match them with rentals (r).
LEFT JOIN sakila.rental r ON c.customer_id = r.customer_id  -----|   If a customer didn’t rent anything, still show them, but rental_id will be NULL.

UNION

SELECT c.customer_id, r.rental_id
FROM sakila.customer c
RIGHT JOIN sakila.rental r ON c.customer_id = r.customer_id;
_________________________________________________________________________________________________________________________________________________________________________________________________
#SELF JOIN :table joins itself.Normally, a join connects two different tables, like Customers and Orders.
--But sometimes, we want to compare rows within the same table, and that’s when we use a SELF JOIN.

SELECT s1.staff_id, s2.staff_id, s1.store_id           --Finally, we pick the columns we want to see:Staff from s1   ,Staff from s2,  The store they work at
FROM sakila.staff s1                                  ----sakila.staff s1 and sakila.staff s2: We are using the same table staff twice.
JOIN sakila.staff s2 ON s1.store_id = s2.store_id      ---Match every staff in s1 with every staff in s2 who works at the same store
WHERE s1.staff_id <> s2.staff_id;                      --This prevents a staff member from matching with themselves. We only want pairs of different staff in the same store.
________________________________________________________________
  select * from sakila.staff;  --staff table
  ________________________________________________________________________________________________________________________________________________________________________
1. Create the staff_demo table
CREATE TABLE sakila.staff_demo (
    staff_id INT PRIMARY KEY,         --Each staff has a unique ID number (primary key)
    first_name VARCHAR(50),
    store_id INT        --which store the staff works in.
);

-- 2. Insert sample data          
INSERT INTO sakila.staff_demo (staff_id, first_name, store_id) VALUES          --Adds data into your table.
(1, 'Alice', 1),
(2, 'Bob', 1),
(3, 'Charlie', 2),
(4, 'Diana', 2),
(5, 'Ethan', 1);

-- 3. Run a self join: find staff pairs working in the same store
SELECT                                     --Show the staff pair (staff_1 and staff_2) and their store.
    s1.staff_id AS staff_1_id,
    s1.first_name AS staff_1_name,
    s2.staff_id AS staff_2_id,
    s2.first_name AS staff_2_name,
    s1.store_id
FROM sakila.staff_demo s1
JOIN sakila.staff_demo s2
  ON s1.store_id = s2.store_id            ---Only match rows where both staff are in the same store.
  AND s1.staff_id <> s2.staff_id          --Make sure we don’t pair someone with themselves.
ORDER BY s1.store_id, s1.staff_id;        --Sort the results first by store, then by staff_1 ID.
  ______________________________________________________________________________________________________________________________________________________________________________________________________________
  







  
