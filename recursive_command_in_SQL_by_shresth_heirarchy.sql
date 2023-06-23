use Bikestores;
---database already present on the server

select * from sys.sysobjects WHERE
  xtype = 'U';
---the above command shows all the tables on the server

create table employee_heirarchy (emp_id int, rep_id int);
---cerating table before proceeding with the query




insert into employee_heirarchy values
(1,null),
(2,1),
(3,1),
(4,2),
(5,2),
(6,3),
(7,3),
(8,4),
(9,4);

select * from employee_heirarchy;

---we'll use CTE expression "with" here. Remember we can use the result later in other queries as well.

with recursive cte as 
	(select emp_id, emp_id as heirarchy 
	from employee_heirarchy where emp_id = 1
	union all
	select cte.emp_id, eh.emp_id as heirarchy 
	from cte 
	join employee_heirarchy eh on cte.emp_id = eh.rep_id)
select * from cte;

---this code above has error in it. Now we'll look it one by one by looking at every iteration. 
---Also remember the "recursive" word in a query is used in postgresql and not mssql. 
---You can write recursive commands without using recursive word here in the query. We'll change that at the end.


---first iteration
select emp_id, emp_id as heirarchy 
	from employee_heirarchy where emp_id = 1

---second iteration
select cte.emp_id, eh.emp_id as heirarchy 
	from (select emp_id, emp_id as heirarchy 
	from employee_heirarchy where emp_id = 1) cte
	join employee_heirarchy eh on cte.emp_id = eh.rep_id

---this command gives emp_ids which are under 1 by performing recurion here and taking data from first recursion. 

---third iteration
select cte.emp_id, eh.emp_id as heirarchy 
	from (select cte.emp_id, eh.emp_id as heirarchy 
	from (select emp_id, emp_id as heirarchy 
	from employee_heirarchy where emp_id = 1) cte
	join employee_heirarchy eh on cte.emp_id = eh.rep_id) cte 
	join employee_heirarchy eh on cte.heirarchy = eh.rep_id

---the above code works and it gives next heirarchy.

---now writing the combined query again.

with cte as 
	(select emp_id, emp_id as heirarchy 
	from employee_heirarchy where emp_id = 1
	union all
	select cte.emp_id, eh.emp_id as heirarchy 
	from cte 
	join employee_heirarchy eh on cte.heirarchy = eh.rep_id)
select * from cte;

---the above command gives correct output for emp_id 1.
---lets check if it works with other emp id as well.

with cte as 
	(select emp_id, emp_id as heirarchy 
	from employee_heirarchy where emp_id = 2
	union all
	select cte.emp_id, eh.emp_id as heirarchy 
	from cte 
	join employee_heirarchy eh on cte.heirarchy = eh.rep_id)
select * from cte;

---it's working. Yayyy.
---now let's do something. Remove that where condition and do it for all the values.

with cte as 
	(select emp_id, emp_id as heirarchy 
	from employee_heirarchy
	union all
	select cte.emp_id, eh.emp_id as heirarchy 
	from cte 
	join employee_heirarchy eh on cte.heirarchy = eh.rep_id)
select * from cte
order by emp_id;

--congratulations. We did it. If you are reading this, Hire me xd. Waiting for your call, lol. jk. Eagerly waiting :)
---BTW did you notice any spelling errors here? I noticed a lot :) And damn, no. of grammatical errors. The reason I'm not correcting them is -  just to make you call me asap xd.
