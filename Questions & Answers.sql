use music_store;

-- Q1: who is the senior most employee based on job title ? 
select concat(first_name," ",last_name) as employee from employee
order by levels desc
limit 1;



-- Q2: which countries have the most invoices ?
select billing_country as country, count(billing_country) as "No. of invoices" from invoice
group by billing_country
order by count(billing_country) desc;



-- Q3: which are top 3 values of total invoice ?
select total from invoice
order by total desc
limit 3;



-- Q4: which city has the best customer ? 
-- We would like to throw a promotional music festival in the city we made the most money. 
-- write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city & sum of all invoice totals.
select billing_city as city, sum(total) as "sum of all invoice totals" from invoice
group by billing_city
order by sum(total) desc
limit 1;



-- Q5: who is the best customer ? 
-- The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.
select concat(first_name," ",last_name) as "Best customer" from customer
where customer_id = (select customer_id from invoice
group by customer_id
order by sum(total) desc
limit 1);



-- Q6: write query to return the email, first name, last name and genre of all Rock Music listeners.
-- Return your list ordered alphabetically by email starting with A.
select distinct a.email, a.first_name, a.last_name, e.name as genre from customer a
join invoice b
on a.customer_id = b.customer_id
join invoice_line c
on b.invoice_id = c.invoice_id
join track d
on c.track_id = d.track_id
join genre e
on d.genre_id = e.genre_id
where e.name like "Rock"
order by a.email;



-- Q7: Let's invite the artists who have written the most rock music in our dataset.
-- write a query that returns the artist name and total track count of the top 10 rock bands.

select a.name as Artist, count(d.name) as "Number of songs" from artist a
join album b
on a.artist_id = b.artist_id
join track c
on b.album_id = c.album_id 
join genre d
on c.genre_id = d.genre_id
where d.name = "rock"
group by a.name
order by count(d.name) desc
limit 10;



-- Q8: Return all the track names that have a song length longer than the average song length. 
-- Return the name and milliseconds for each track. order by the song length with the longest songs listed first. 

select name, milliseconds from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;



-- Q9: Find how much amount spent by each customer on artists ? 
-- Write a query to return customer name, artist name and total spent.
select concat(a.first_name," ",a.last_name) as Name, f.name as Artist, sum(b.total) as "Total spent" from customer a
join invoice b
on a.customer_id = b.customer_id
join invoice_line c
on b.invoice_id = c.invoice_id
join track d
on c.track_id = d.track_id
join album e
on d.album_id = e.album_id 
join artist f
on e.artist_id = f.artist_id
group by Name, Artist
order by sum(b.total) desc;



-- Q10: We want to find out the most popular music genre for each country.
-- We determine the most popular genre as the genre with the highest amount of purchases.
-- Write a query that returns each country along with the top genre. 
-- For countries where the maximum number of purchases is shared return all genres.

with popular_genre as 
(select count(c.quantity) as purchases, a.country, e.name, 
row_number() over (partition by a.country order by count(c.quantity) desc) row_num 
from customer a
join invoice b
on a.customer_id = b.customer_id
join invoice_line c
on b.invoice_id = c.invoice_id
join track d
on c.track_id = d.track_id
join genre e
on d.genre_id = e.genre_id
group by 2,3)
select country, name, purchases from popular_genre
where row_num = 1;



-- Q11. Write a query that determines the customer that has spent the most on music for each country.
-- Write a query that returns the country along with the top customer and how much they spent.

with top_customers as
(select concat(a.first_name," ",a.last_name) as Name, a.country, sum(b.total) total_purchases, 
row_number () over (partition by country order by sum(b.total) desc) row_num 
from customer a
join invoice b
on a.customer_id = b.customer_id
group by 1,2)
select Name, country, total_purchases from top_customers
where row_num = 1;























