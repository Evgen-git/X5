select * from rental;	
select * from store;

select staff_id,store_id from staff

select st.store_id,count(distinct py.customer_id) as cnt_buyers
  from staff st,payment py
 where py.staff_id=st.staff_id  
group by st.store_id 


select py.staff_id,count(distinct py.customer_id) as cnt_buyers
  from payment py
 group by py.staff_id 