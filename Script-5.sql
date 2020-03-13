-- 1) ¬ каких городах больше одного аэропорта?
select city
from airports_data ad
group by city
having count(1) > 1

-- 2) ¬ каких аэропортах есть рейсы, которые обслуживаютс€ самолетами с максимальной дальностью перелетов? 
select *
  from airports_data ad
 where airport_code in (select arrival_airport
  						  from flights f
						 where aircraft_code in (select aircraft_code 
					 							   from aircrafts_data ad
												  where range in (select max(range) from aircrafts_data ad))
						 union
						select departure_airport
						  from flights f
						 where aircraft_code in (select aircraft_code 
												   from aircrafts_data ad
												  where range in (select max(range) from aircrafts_data ad)));

-- 3) Ѕыли ли брони, по которым не совершались перелеты?
select *
from bookings b
where book_ref in (select  book_ref
				     from tickets t 
		  		    where ticket_no in (select ticket_no 
										  from ticket_flights tf
										 where not exists (select 1 from boarding_passes bp 
										 					where tf.flight_id=bp.flight_id and tf.ticket_no=bp.ticket_no)));
												 
												 
-- 4) —амолеты каких моделей совершают наибольший % перелетов?
select ad.*
  from aircrafts_data ad
 where ad.aircraft_code in (select aircraft_code 
 							  from (select aircraft_code,
								 			count(1) as cnt_flight,
									 		sum(count(1)) over () as comm_flight,
									 		count(1)*100/sum(count(1)) over () as perc_flight
									  from flights f
									 group by aircraft_code
									 order by perc_flight desc
									 limit 1 ) t1
									); 

-- 5) Ѕыли ли города, в которые можно  добратьс€ бизнес - классом дешевле, чем эконом-классом?
with city_amount as (select ad.city,
							max(case when tf.fare_conditions='Economy' then tf.amount end) as max_Economy_amount,
							min(case when tf.fare_conditions='Business' then tf.amount end) as min_Business_amount
					from ticket_flights tf,
							flights f,
							airports_data ad
					where tf.flight_id=f.flight_id		
					  and f.arrival_airport=ad.airport_code
					group by ad.city)
select * 
from city_amount 
where max_Economy_amount > min_Business_amount;

-- 6) ”знать максимальное врем€ задержки вылетов самолетов
select status,scheduled_departure,actual_departure,
	   COALESCE(actual_departure,CURRENT_TIMESTAMP),CURRENT_TIMESTAMP as tmp,
	   f.flight_id
from flights f
where 1=1 
and scheduled_departure <  COALESCE(actual_departure,CURRENT_TIMESTAMP)
and actual_departure is null
--group by 
--and status = 'Delayed'

-- 7) ћежду какими городами нет пр€мых рейсов*?
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
-- 8) ћежду какими городами пассажиры делали пересадки*?
-- 9) ¬ычислите рассто€ние между аэропортами, св€занными пр€мыми рейсами, сравните с допустимой максимальной дальностью перелетов  в самолетах, обслуживающих эти рейсы **										 				
										 				
										 				
										 				