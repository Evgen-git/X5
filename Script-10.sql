WITH RECURSIVE q 
     AS (SELECT h, 1 AS level, ARRAY[id] AS breadcrumb
           FROM orgeh h
          WHERE parentid = '00000000'
          UNION ALL
         SELECT hi, q.level + 1 AS level, breadcrumb || id
           FROM q JOIN orgeh hi ON hi.parentid = (q.h).id),
	t2 as (SELECT  row_number() over (order by breadcrumb) as rn,
					level as lv,
			        REPEAT('=>', level) ||' '||(q.h).id as id,
			        (q.h).parentid,
			        (q.h).typeoe,
			        (q.h).stext,
			        breadcrumb::VARCHAR AS path
			  FROM q)
select * from t2 			  
where lv = 5
ORDER BY rn


