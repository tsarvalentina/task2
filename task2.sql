--1  вывести количество фильмов в каждой категории, отсортировать по убыванию.
SELECT c.name, COUNT(f.film_id) count_film
FROM film_category f
JOIN category c ON f.category_id = c.category_id
GROUP BY c.name
ORDER BY 2 desc
--2 вывести 10 актеров, чьи фильмы большего всего арендовали, отсортировать по убыванию.
SELECT  a.first_name, a.last_name, COUNT(r.rental_id)  rental_quantity
FROM actor a JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN inventory i 
ON fa.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id
ORDER BY 3 desc
LIMIT 10
--3 вывести категорию фильмов, на которую потратили больше всего денег.
SELECT c.name, SUM(p.amount) sum_amount
FROM category c JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i 
ON fc.film_id = i.film_id
JOIN rental r 
ON i.inventory_id= r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.category_id
ORDER BY 2 desc
LIMIT 1
--4  вывести названия фильмов, которых нет в inventory. Написать запрос без использования оператора IN.
SELECT f.title
FROM film f LEFT JOIN inventory i
ON f.film_id IS NULL
--5  вывести топ 3 актеров, которые больше всего появлялись в фильмах в категории “Children”. 
--Если у нескольких актеров одинаковое кол-во фильмов, вывести всех.
SELECT first_name, last_name
FROM
(SELECT first_name, last_name,count_film, DENSE_RANK() OVER(ORDER BY count_film desc) rnk
FROM
(SELECT a.first_name, a.last_name, COUNT(a.actor_id) count_film
FROM actor a JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film_category fc
ON fa.film_id = fc.film_id
JOIN category c 
ON fc.category_id = c.category_id
WHERE c.name = 'Children'
GROUP BY a.actor_id
ORDER BY COUNT(a.actor_id) DESC) t) r
WHERE rnk IN (1,2,3)

--6 вывести города с количеством активных и неактивных клиентов (активный — customer.active = 1). 
--Отсортировать по количеству неактивных клиентов по убыванию.
SELECT ct.city, SUM(c.active) AS active, (COUNT(c.active) - SUM(c.active)) AS not_active
FROM customer c JOIN address a
ON c.address_id = a.address_id
JOIN city ct 
ON a.city_id = ct.city_id
GROUP BY ct.city
ORDER BY 3 DESC

--7 вывести категорию фильмов, у которой самое большое кол-во часов суммарной аренды в городах 
--(customer.address_id в этом city), и которые начинаются на букву “a”. 
--То же самое сделать для городов в которых есть символ “-”. Написать все в одном запросе.
SELECT c.name, t.city, SUM(r.return_date - r.rental_date) AS sum_rental
FROM category c JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id=i.film_id
JOIN rental r
ON i.inventory_id=r.inventory_id
JOIN store s
ON i.store_id = s.store_id
JOIN address a
ON s.address_id=a.address_id
JOIN city t
ON a.city_id = t.city_id
WHERE t.city LIKE 'a%' OR t.city LIKE '%-%'
GROUP BY c.name, t.city












