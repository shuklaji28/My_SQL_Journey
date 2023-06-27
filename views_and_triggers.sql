select * from album
--boring work. Why should I show you album name :) I'll keep it secret :)

create view vv as (select album_id from album)
select * from vv
-- it's fun guys :)

-- time be serious. Let's look at some bigger table.

select * from customer 
join invoice on 
customer.customer_id = invoice.customer_id
--  now suppose you want to perform some analysis on this data. You have to write this join everytime you use these two table together.
-- So we'll create join once and do not have to write join in every command to analyse data. Let's look at that.

-- create or replace view combined_table as 
-- select distinct * from customer 
-- join invoice on customer.customer_id = invoice.customer_id 
-- group by customer_id

CREATE OR REPLACE VIEW combined_table AS
SELECT customer.customer_id, customer.first_name AS customer_name, SUM(invoice.total) AS total_amount, customer.last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id;

select * from combined_table order by customer_id

-- to change name of columm
alter view combined_table rename column total_amount to sum_of_amount


select * from combined_table

create role james
login
password 'james'

grant select on combined_table to james
alter table customer add column gender varchar(30) 
select * from combined_table
alter table combined_table drop column last_name
-- viewing structure 
SELECT *  
FROM information_schema.COLUMNS  
WHERE TABLE_NAME = 'customer';

-- creating triggers in sql

select * from vv limit 10

create or replace trigger trig_album
before insert on vv
for each row
 enable
declare v_user varchar(20)
begin
select user into v_user from dual 
	dbms.putline('Entered a new row'||v_user)
end;



create table logdata (msg varchar(100))

CREATE TRIGGER trig_album AFTER INSERT ON album
FOR EACH ROW EXECUTE PROCEDURE trigger_function()

-- the following code helps to create a simple trigger after insert statement. Also, firstly we created a function to use it as a logic in trigger.
   
CREATE or replace FUNCTION trigger_function()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
    INSERT INTO logdata(msg) VALUES (current_timestamp);
    RETURN NEW;
END;
$$

insert into vv values (1000)
select * from logdata





-- BEGIN
--       INSERT INTO logdata(msg) VALUES (current_timestamp);
--       RETURN NEW;
--    END;
   
--   CREATE OR REPLACE FUNCTION auditlogfunc() RETURNS TRIGGER AS $trig_album$
--    BEGIN
--       INSERT INTO logdata(msg) VALUES (current_timestamp);
--       RETURN NEW;
--    END;


