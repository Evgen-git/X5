with cross_city as (select ad1.airport_code as dep_airport_code,
							ad1.city as dep_city,
							ad2.airport_code as arr_airport_code,
							ad2.city as arr_city
  			   	      from airports_data ad1 cross join airports_data ad2
  			   	     where ad1.city <> ad2.city)
select distinct cc.dep_city,cc.arr_city
from cross_city cc 
left join flights fg1 on (cc.dep_airport_code=fg1.departure_airport and cc.arr_airport_code=fg1.arrival_airport)
where fg1.flight_id is null;
