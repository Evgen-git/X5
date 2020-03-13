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

-- 3) Ѕыли ли брони, по которым не совершалось перелеты?
  with board as (select distinct ticket_no,flight_id from boarding_passes), 
  	   type_boarding as (select tf.ticket_no,case when sum(distinct case when bp.flight_id is null then 1 else 2 end) = 3 then 2 else 1 end as type_brd 
					  from ticket_flights tf left join board bp on (tf.ticket_no=bp.ticket_no and tf.flight_id=bp.flight_id)
					 group by tf.ticket_no  
					having sum(distinct case when bp.flight_id is null then 1 else 2 end) <> 2)
select *
 from bookings b
where book_ref in (select t.book_ref  
 				     from tickets t inner join type_boarding tb on (t.ticket_no=tb.ticket_no)  
					group by t.book_ref
					-- зависит от того в каких комбинаци€х нужно отношение множественности между бронью и посадками
					-- без услови€ по having отраз€тс€ все брони, в рамках которых был хоть один рейс по которому не было ни одной посадки  
				   --having SUM(distinct tb.type_brd)=1 --+ 1=ALL,2=ANY,7=ALL+ANY
					)
										 				
										 				
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
with transf as (select distinct
					  --ticket_no,	
				  	  count(1) over (partition by ticket_no,cnt_tranf) as cnt_transf,
				  	  first_value(departure_airport) over (partition by ticket_no,cnt_tranf order by actual_departure) as departure_airport,
		              first_value(arrival_airport) over (partition by ticket_no,cnt_tranf order by actual_departure desc) as arrival_airport
				from (select t1.ticket_no,t1.actual_departure,t1.departure_airport,t1.arrival_airport,
							 sum(case when t1.sign_tranf is null then 0 else t1.sign_tranf end) over (partition by t1.ticket_no order by t1.actual_departure) as cnt_tranf
						from (select tf.ticket_no,f.actual_departure,f.departure_airport,f.arrival_airport,
									 sign(extract(day from f.actual_departure-lag(f.actual_arrival) over (partition by tf.ticket_no order by f.actual_departure)))  as sign_tranf
 							    from ticket_flights tf,	flights f
							   where tf.flight_id=f.flight_id		
							     and f.actual_departure is not null
							     and f.actual_arrival is not null) t1) t2)
select distinct 
		least(ad1.city,ad2.city) as departure_city,
		greatest(ad1.city,ad2.city) as arrival_city
from transf tf 
     left join airports_data ad1 on (ad1.airport_code=tf.departure_airport) 
     left join airports_data ad2 on (ad2.airport_code=tf.arrival_airport) 
where tf.cnt_transf > 1 and tf.departure_airport<>tf.arrival_airport

-- 9) ¬ычислите рассто€ние между аэропортами, св€занными пр€мыми рейсами, сравните с допустимой максимальной дальностью перелетов  в самолетах, обслуживающих эти рейсы **										 				
select flight_no,departure_airport,arrival_airport,max_range,
		round(6371*acos(sin(lat_a)*sin(lat_b) + cos(lat_a)*cos(lat_b)*cos(lng_a - lng_b))) as L2
from (		
select ft.flight_no,ft.departure_airport,ft.arrival_airport,
		ad1.coordinates as departure_coord,
		ad2.coordinates as arrival_coord,
		radians(ad1.coordinates[0]) as lat_a,
		radians(ad2.coordinates[0]) as lat_b,
		radians(ad1.coordinates[1]) as lng_a,
		radians(ad2.coordinates[1]) as lng_b,
		ac."range" as max_range
  from flights ft
     left join airports_data ad1 on (ad1.airport_code=ft.departure_airport) 
     left join airports_data ad2 on (ad2.airport_code=ft.arrival_airport) 
     left join aircrafts_data ac on (ac.aircraft_code=ft.aircraft_code) 
) t1




