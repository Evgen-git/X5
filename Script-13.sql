select h.typeoe,count(1) as cnt 
  from orgeh h
--where h.typeoe is not null  
group by h.typeoe
order by cnt desc;
