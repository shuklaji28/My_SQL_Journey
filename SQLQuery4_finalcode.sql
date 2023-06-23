select ord.order_id,
concat(cst.first_name,' ', cst.last_name) full_name,
cst.city, cst.state,
ord.order_date,

sum(otm.quantity) as 'total_units',
sum(otm.quantity * otm.list_price) as 'revenue',
prd.product_name,
pcg.category_name,
sto.store_name,
concat(stf.firsT_name, ' ', stf.last_name) as 'sales_rep_name'

from sales.orders ord 
JOIN sales.customers cst
ON ord.customer_id = cst.customer_id
join sales.order_items otm
on ord.order_id = otm.order_id
join production.products prd 
on otm.product_id = prd.product_id
join production.categories pcg
on prd.category_id = pcg.category_id
join sales.stores sto
on ord.store_id = sto.store_id
join sales.staffs stf
on ord.staff_id = stf.staff_id
group by ord.order_id, 
concat(cst.first_name,' ' , cst.last_name),
cst.city,
cst.state,
ord.order_date,
prd.product_name,
pcg.category_name,
sto.store_name,
concat(stf.firsT_name, ' ', stf.last_name)
;