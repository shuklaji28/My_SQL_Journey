--- This is an intermediate level SQL Project where I'll be writing SQL queries 
---to analyse data. LEt's begin in reverse order from writing advanced queries to basic ones.

-- Q.1 : Find how much amount spent by each customer on artists? Write a query 
-- to return customer name, artist name, and total spent. 

-- Let's look at tables first. Also give a look at schema to understand how to write joins.
---Looking at the schema, it's clear we need to join three tables. 
-- Here we'll use CTE to produce output.

with best_selling_artist as (
	select artist.artist_id as artist_id,
	artist.name as artist_name, 
	sum(invl.unit_price * invl.quantity) as total_sales
	from invoice_line invl
	join track 
	on track.track_id = invl.track_id
	join album 
	on album.album_id = track.album_id
	join artist 
	on artist.artist_id = album.artist_id
	group by artist.artist_id
	order by 3 desc
	
)

select customer.customer_id,
customer.first_name, 
customer.last_name, 
bsa.artist_name, 
sum(invl.unit_price*invl.quantity) as amount_spent
from invoice
join customer on 
customer.customer_id = invoice.customer_id
join invoice_line invl
on invl.invoice_id = invoice.invoice_id
join track
on track.track_id = invl.track_id
join album 
on album.album_id = track.album_id
join best_selling_artist bsa
on bsa.artist_id = album.artist_id
group by 1,2,3,4
order by 5 desc

-- That was an interesting question tbh.I like that. Let's move forward to next question.

--Q.2 Find out most popular genre for each country. Most popular means the one with the highest purchase. 
--Write a code that returns each country along with the top genre. 
--For countries where the maximum number of purchases is shared return all the genres.


with final_table as (
select count(invl.quantity) as purchase_per_genre,customer.country as country, g.name, g.genre_id, sum(invl.unit_price*invl.quantity)as amount_spent, 
row_number() over (partition by customer.country order by count(invl.quantity) desc) as row_no 
from invoice_line invl
join invoice on invoice.invoice_id = invl.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invl.track_id
join genre g on g.genre_id = track.genre_id
group by 2,3,4
order by 2 asc,1 desc 
)

select * from final_table where row_no <=1


-- We used row number to give first row value as output from the table. 
-- We can do this using another method as well - using recursive statement. Let's not look at that rn.

--Q.3 Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount apent is shared, provide all customers who spent this amount.

/*
That's a wrong code btw. Give a try and find out what's wrong here.


with best_customer as (
select customer.first_name, customer.last_name, 
customer.country, invoice.total as total,
row_number() 
over (partition by customer.country order by invoice.total desc) as row_no
from customer
join invoice on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 4)

select * from best_customer where row_no <=1

*/


with recursive 
customer_from_country as (
	select customer.first_name, customer.last_name, customer.country as bill_country, 
	customer.customer_id, sum(total) as total_amount from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3,4
	order by 5 desc),
	max_customer as (select bill_country, max(total_amount) as max_amount 
				from customer_from_country group by bill_country)
				
select cc.first_name, cc.last_name, mc.max_amount, mc.bill_country from customer_from_country cc
join max_customer mc on cc.bill_country = mc.bill_country
where cc.total_amount = mc.max_amount
order by 4 

/*
Chaliye smjhte hai yaha ho kya rha hai. Sabse phle humne ek table banai jimse customer ka first name, last name store kiya, uske total spendings 
store kiye aur uski country store kari. Sabse basic kaam kiya ki jo jo column chahiye phle ek sath unki table bana li.
Fir ek doosri table bana rhe jaha hum sirf vo countries le rhe hai jaha spendings sabse jada hai. aur usko first table ke sath join kar rhe under the column 
such that jo bhi bande ki maximum spending ho sirf uski detials aaye first wali table se, aur baaki logo ki details nhi chahiye hume.
So first table se baaki sab data aya. But jab second table join kari to har country ka maximum spending aa gaya. Jab join karenge to unki details hi aayengi jinki total apensing ye maximum ke bara bar hai. Smjhe?
*/
				
				