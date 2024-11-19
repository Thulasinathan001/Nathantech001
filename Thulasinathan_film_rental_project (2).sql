-- film_rental Sample Database Schema
-- Version 1.4

-- Copyright (c) 2006, 2022, Oracle and/or its affiliates.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are
-- met:

-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
-- * Redistributions in binary form must reproduce the above copyright
--   notice, this list of conditions and the following disclaimer in the
--   documentation and/or other materials provided with the distribution.
-- * Neither the name of Oracle nor the names of its contributors may be used
--   to endorse or promote products derived from this software without
--   specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
-- IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS film_rental;
CREATE SCHEMA film_rental;
USE film_rental;

--
-- Table structure for table `actor`
--

CREATE TABLE actor (
  actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (actor_id),
  KEY idx_actor_last_name (last_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `address`
--

CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  -- Add GEOMETRY column for MySQL 5.7.5 and higher
  -- Also include SRID attribute for MySQL 8.0.3 and higher
  /*!50705 location GEOMETRY */ /*!80003 SRID 0 */ /*!50705 NOT NULL,*/
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (address_id),
  KEY idx_fk_city_id (city_id),
  /*!50705 SPATIAL KEY `idx_location` (location),*/
  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `category`
--

CREATE TABLE category (
  category_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `city`
--

CREATE TABLE city (
  city_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  city VARCHAR(50) NOT NULL,
  country_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (city_id),
  KEY idx_fk_country_id (country_id),
  CONSTRAINT `fk_city_country` FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `country`
--

CREATE TABLE country (
  country_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  country VARCHAR(50) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (country_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `customer`
--

CREATE TABLE customer (
  customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  store_id TINYINT UNSIGNED NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (customer_id),
  KEY idx_fk_store_id (store_id),
  KEY idx_fk_address_id (address_id),
  KEY idx_last_name (last_name),
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `film`
--

CREATE TABLE film (
  film_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(128) NOT NULL,
  description TEXT DEFAULT NULL,
  release_year YEAR DEFAULT NULL,
  language_id TINYINT UNSIGNED NOT NULL,
  original_language_id TINYINT UNSIGNED DEFAULT NULL,
  rental_duration TINYINT UNSIGNED NOT NULL DEFAULT 3,
  rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  length SMALLINT UNSIGNED DEFAULT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99,
  rating ENUM('G','PG','PG-13','R','NC-17') DEFAULT 'G',
  special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (film_id),
  KEY idx_title (title),
  KEY idx_fk_language_id (language_id),
  KEY idx_fk_original_language_id (original_language_id),
  CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `film_actor`
--

CREATE TABLE film_actor (
  actor_id SMALLINT UNSIGNED NOT NULL,
  film_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (actor_id,film_id),
  KEY idx_fk_film_id (`film_id`),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `film_category`
--

CREATE TABLE film_category (
  film_id SMALLINT UNSIGNED NOT NULL,
  category_id TINYINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `inventory`
--

CREATE TABLE inventory (
  inventory_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  film_id SMALLINT UNSIGNED NOT NULL,
  store_id TINYINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (inventory_id),
  KEY idx_fk_film_id (film_id),
  KEY idx_store_id_film_id (store_id,film_id),
  CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `language`
--

CREATE TABLE language (
  language_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name CHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (language_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `payment`
--

CREATE TABLE payment (
  payment_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id SMALLINT UNSIGNED NOT NULL,
  staff_id TINYINT UNSIGNED NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (payment_id),
  KEY idx_fk_staff_id (staff_id),
  KEY idx_fk_customer_id (customer_id),
  CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `rental`
--

CREATE TABLE rental (
  rental_id INT NOT NULL AUTO_INCREMENT,
  rental_date DATETIME NOT NULL,
  inventory_id MEDIUMINT UNSIGNED NOT NULL,
  customer_id SMALLINT UNSIGNED NOT NULL,
  return_date DATETIME DEFAULT NULL,
  staff_id TINYINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (rental_id),
  UNIQUE KEY  (rental_date,inventory_id,customer_id),
  KEY idx_fk_inventory_id (inventory_id),
  KEY idx_fk_customer_id (customer_id),
  KEY idx_fk_staff_id (staff_id),
  CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `staff`
--

CREATE TABLE staff (
  staff_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  picture BLOB DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  store_id TINYINT UNSIGNED NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (staff_id),
  KEY idx_fk_store_id (store_id),
  KEY idx_fk_address_id (address_id),
  CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `store`
--

CREATE TABLE store (
  store_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  manager_staff_id TINYINT UNSIGNED NOT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (store_id),
  UNIQUE KEY idx_unique_manager (manager_staff_id),
  KEY idx_fk_address_id (address_id),
  CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

USE film_rental;

/*1. What is the total revenue generated from all rentals in the database?*/

SELECT
	sum(b.amount) AS Total_revenue 
FROM
	rental a 
INNER JOIN  
	payment b ON a.rental_id = b.rental_id;

/*2. How many rentals were made in each month_name?*/

SELECT
	date_format(rental_date, '%b') AS Month_name,count(rental_id) as Count
FROM 
	rental
GROUP BY 
	month_name;

/*3.What is the rental rate of the film with the longest title in the database?*/
SELECT 
	title,rental_rate,length(title) as length_of_title
FROM 
	film
ORDER BY
	length_of_title DESC
LIMIT 1;

/*4. What is the average rental rate for films that were taken from the last 30 days from the date("2005-05-05 22:04:30")?*/

SELECT
	film.title,AVG(film.rental_rate) AS average_rental_rate,rental.rental_date AS date_interval 
FROM
	film 
JOIN
	inventory ON film.film_id=inventory.film_id
JOIN 
	rental ON rental.inventory_id=inventory.inventory_id
WHERE
	rental.rental_date >= DATE_sub("2005-05-05 22:04:30",INTERVAL 30 DAY)
GROUP BY
	1,date_interval
ORDER BY 
	date_interval;

/*5.What is the most popular category of films in terms of the number of rentals?*/

SELECT
	category.name,count(film.rental_duration) AS Total_count 
FROM
	film_category  
JOIN 
	film ON film_category.film_id = film.film_id
JOIN
	category ON category.category_id = film_category.category_id
GROUP BY 
	category.name
ORDER BY 
	Total_count DESC;

/*6.Find the longest movie duration from the list of films that have not been rented by any customer. */


SELECT
	f.title AS Film_title,f.length AS 'Duration' 
FROM
	film f
LEFT JOIN
	inventory i ON f.film_id=i.film_id
LEFT JOIN
	rental r ON i.inventory_id = r.inventory_id
WHERE
	r.inventory_id IS NULL
ORDER BY
	2 DESC LIMIT 1;


/*7.What is the average rental rate for films, broken down by category? */
SELECT
	t.name AS categories,AVG(f.rental_rate)AS average_rent_rate
FROM 
	film f JOIN film_category c ON f.film_id = c.film_id 
JOIN 
	category t ON t.category_id = c.category_id
GROUP BY 1;

/*8.what is the total revenue generated from rentals for each actor in the database?*/

SELECT
	concat(actor.first_name,' ',actor.last_name) AS 'Actor_Name' , sum(payment.amount) AS'Total_revenue'
FROM
	actor 
JOIN 
	film_actor ON actor.actor_id = film_actor.actor_id
JOIN 
	film ON film_actor.film_id = film.film_id
JOIN
	inventory ON film.film_id = inventory.film_id
JOIN
	rental ON rental.inventory_id = inventory.inventory_id
join 
	payment ON payment.rental_id = rental.rental_id
GROUP BY 1;

/*9.Show all the actresses who worked in a film having a "Wrestler" in the description*/
SELECT
	concat(a.first_name,' ',a.last_name) AS Actor_name 
FROM
	actor a 
JOIN 
	film_actor i ON a.actor_id = i.actor_id
JOIN 
	film f ON i.film_id = f.film_id
WHERE
	description like '%wrestler%'
GROUP BY 1;

/*10.Which customers have rented the same film more than once? */
SELECT* FROM rental;

SELECT 
	c.customer_id,concat(c.first_name,' ',c.last_name) AS 'Customer_name',f.title,count(f.film_id) AS count
FROM
	customer c JOIN rental r ON c.customer_id = r.customer_id
JOIN 
	inventory i ON i.inventory_id = r.inventory_id
JOIN 
	film f  ON f.film_id = i.film_id
GROUP BY
	c.customer_id,f.title HAVING count(*) >1
ORDER BY
	count DESC;

/*11.	How many films in the comedy category have a rental rate higher than the average rental rate?*/

SELECT 
	count(film.title) AS count 
FROM 
	category 
JOIN 
	film_category ON category.category_id = film_category.category_id
JOIN 
	film ON film.film_id = film_category.film_id
WHERE 
	film.rental_rate >(SELECT AVG(rental_rate) FROM  film)
    AND category.name like 'comedy';


/*12.Which films have been rented the most by customers living in each city? */

SELECT 
	f.title,count(f.title) AS count ,t.city 
FROM 
	customer c JOIN rental r ON c.customer_id = r.customer_id
JOIN
	inventory i ON i.inventory_id = r.inventory_id
JOIN
	film f  ON f.film_id = i.film_id
JOIN 
	address a ON a.address_id = c.address_id
JOIN 
	city t ON a.city_id = t.city_id
GROUP BY c.customer_id,f.title having count(*) >1
ORDER BY count desc;

/*13.What is the total amount spent by customers whose rental payments exceed $200? */

SELECT 
	concat(c.first_name,' ',c.last_name) AS 'Customer name',sum(P.amount) AS Total_amount 	
FROM
	customer c
JOIN 
	payment p ON c.customer_id = p.customer_id
GROUP BY 
	concat(c.first_name,' ',c.last_name) HAVING sum(p.amount)>200; 

/*14.	Display the fields which are having foreign key constraints related to the "rental" table.
 [Hint: using Information_schema] */
 USE Information_schema;
 SHOW TABLES;
 SELECT
    constraint_name
    Table_name,
    column_name,
    Referenced_table_name,
    Referenced_column_name
FROM
   information_schema.key_column_usage
WHERE
    Referenced_table_name = 'rental'
	and constraint_schema = 'film_rental';

/*15.Create a View for the total revenue generated by each staff member,
 broken down by store city with the country name.*/
 
CREATE VIEW staff_revenue AS 
SELECT
    s.staff_id,
    CONCAT(y.city, ', ', ct.country) AS store_location,
    SUM(p.amount) AS total_revenue
FROM 
	staff s
JOIN 
	store st ON s.store_id = st.store_id
JOIN 
	address a ON st.address_id = a.address_id
JOIN
	city y ON y.city_id = a.city_id
JOIN
	country ct on ct.country_id = y.country_id
JOIN 
	customer c ON st.store_id = c.store_id
JOIN 
	payment p ON c.customer_id = p.customer_id
GROUP BY
    s.staff_id,
    y.city,
    ct.country;
    SELECT * FROM staff_revenue;
    
/*16.	Create a view based on rental information consisting of visiting_day, customer_name, the title of the film, 
 no_of_rental_days, the amount paid by the customer along with the percentage of customer spending.*/
 
CREATE VIEW rental_information_on_customer AS
SELECT
  r.rental_date AS 'Visiting_date',
  concat(c.first_name,' ',c.last_name)  AS customer_name,
  f.title AS film_title,
  count(r.rental_date) OVER(PARTITION BY f.title) AS total_days,
  p.amount,
  (p.amount / (SELECT SUM(amount) FROM payment) * 100) AS spending_percentage
FROM
	rental r
JOIN 
	customer c ON r.customer_id = c.customer_id
JOIN 
	inventory i ON r.inventory_id = i.inventory_id
JOIN
	film f ON i.film_id = f.film_id
JOIN 
	payment p ON p.rental_id = r.rental_id
GROUP BY 
	f.title,customer_name,r.rental_date,p.amount;
    
SELECT * FROM rental_information_on_customer;

 /*17.Display the customers who paid 50% of their total rental costs within one day. */
select

           distinct(concat(c.first_name,' ',c.last_name)) as Customer_name,

    date_format(p.payment_date,'%y-%m-%d') as date,sum(amount)

from

           customer c

join

           rental r on r.customer_id = c.customer_id

join

           payment p on p.rental_id = r.rental_id

where

           date_add(r.rental_date,interval 1 day)

group by

customer_name,date

HAVING SUM(p.amount) <= (0.5 * (

    SELECT SUM(amount)

    FROM payment))

    order by 3 desc

    ;






