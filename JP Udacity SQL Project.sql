Justin Paul Pepito Udacity SQL Project

Q1: What are the categories of the the three most frequently rented movie titles that begin with the letter 'A'?


SELECT 
f.title Title, 
c.name Category_Name, 
COUNT(*) Rental_Count
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id 
JOIN film f
ON fc.film_id = f.film_id
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
WHERE f.title LIKE 'A%'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3;

---------

Q2: Assign quartiles for each film's length. For each quartile, sum all movie lengths and graph how many total minutes are in each quartile. 

SELECT
DISTINCT(t1.quartile) quartile,
SUM(t1.length) OVER (PARTITION BY t1.quartile) AS Sum_of_length_by_quartile
FROM 
(SELECT
NTILE(4) OVER (ORDER BY f.length) AS quartile,
f.length length
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id =  c.category_id) t1
ORDER BY 1

---------

Q3: Sort all films in the Family category by rental duration, and sort each of the films by one out of four quartiles by rental duration. For each quartile, sum all rental durations and graph how many total days are in each quartile. 

WITH t1 AS (SELECT 
c.name category, 
f.rental_duration rental_duration, 
NTILE(4) OVER (ORDER BY f.rental_duration) AS quartile_of_rental_duration
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id 
JOIN film f 
ON fc.film_id = f.film_id
WHERE c.name LIKE 'Family')

SELECT 
DISTINCT(t1.quartile_of_rental_duration) quartile_of_rental_duration,
SUM(t1.rental_duration) OVER (PARTITION BY t1.quartile_of_rental_duration) AS Sum_of_quartile_duration
FROM t1 
ORDER BY 2 

---------

Q4: Take note of the first 50 customers' countries' in Sakila (i.e the first 50 people to have successfully returned a rental). Which of these countries appeared the most (i.e, where did most of our first 50 customers come from?).  

SELECT
t1.country country, 
COUNT(*) country_count_in_the_first_50_rental_returns 
FROM
(SELECT
r.return_date return_date, 
co.country country
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id
JOIN address a 
ON c.address_id = a.address_id
JOIN city ct
ON a.city_id = ct.city_id 
JOIN country co
ON ct.country_id= co.country_id
ORDER BY 1
LIMIT 50) t1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 4;







 
