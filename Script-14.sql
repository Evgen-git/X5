

WITH RECURSIVE q 
     AS (SELECT h, 5 AS level, ARRAY[id] AS breadcrumb
           FROM orgeh h
          WHERE id in ('52299019')
          --WHERE id in ('52952393','52299019')
          UNION ALL
         SELECT hi, q.level - 1 AS level, breadcrumb || id
           FROM q JOIN orgeh hi ON hi.id = (q.h).parentid),
	t2 as (SELECT  row_number() over (order by breadcrumb desc) as rn,
					level as level_,
			        REPEAT('=>', level) ||' '||(q.h).id as id,
			        (q.h).parentid,
			        (q.h).typeoe,
			        (q.h).stext,
			        breadcrumb::VARCHAR AS path
			  FROM q)
select distinct level_,id,parentid,typeoe,stext
from t2 			  
--where lv = 5
ORDER BY level_;

