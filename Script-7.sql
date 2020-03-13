select *
from bookings b
where book_ref in (select  book_ref
				     from tickets t 
		  		    where ticket_no in (
		  		    
		  		    select count(1) 
										  from ticket_flights tf
										 where not exists (select 1 from boarding_passes bp 
										 					where tf.flight_id=bp.flight_id and tf.ticket_no=bp.ticket_no)
										 					
										 					
										 					));
										 					
										 				
										 				
/*+
 	 HashJoin(bp tf)
 	 IndexScan(boarding_passes_pkey)
 
 */
EXPLAIN  										 				
		  		    select count(distinct tf.ticket_no)
										  from ticket_flights tf
										 where not exists (select 1 
										 					 from boarding_passes bp 
										 					where tf.flight_id=bp.flight_id and tf.ticket_no=bp.ticket_no)
										 				
										 				
select count(1)
from boarding_passes bp 
										 															 				
										 				
										 					
										 				
/*+
 	 HashJoin(bp tf)
 	 IndexScan(boarding_passes_pkey)
 
 */
--EXPLAIN  										 				
		  		    select count(distinct tf.ticket_no) 
					  from ticket_flights tf,boarding_passes bp 
 					where not (tf.flight_id=bp.flight_id and tf.ticket_no=bp.ticket_no)



