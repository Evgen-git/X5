commit;
begin;
--truncate TABLE tmp_tab1,tmp_tab2;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tab1 ON COMMIT drop AS
SELECT id,parentid,begda,endda,typeoe,stext,cfo
							  	 		  FROM orgeh h
										  where 1=1
											and CURRENT_DATE between to_date(begda,'YYYYMMDD') and to_date(endda,'YYYYMMDD');

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tab2 ON COMMIT drop AS
with RECURSIVE q AS (SELECT h, 1 AS level, ARRAY[id] AS breadcrumb,
										   ARRAY[stext] AS path_stext,
										   ARRAY[typeoe] AS path_typeoe
							           FROM tmp_tab1 h
										WHERE parentid = '00000000'
										--WHERE id in ('52299019')
							          --WHERE id in ('52952393','52299019')
							          UNION ALL
							         SELECT hi, q.level+1 AS level, 
							         			breadcrumb || id,
							         			path_stext ||  stext,
							         			path_typeoe ||  typeoe
							           FROM q JOIN tmp_tab1 hi ON hi.parentid = (q.h).id),
							  t2 as (SELECT  row_number() over (order by breadcrumb) as rn,
												level as level_,
										        (q.h).id,
										        (q.h).parentid,
										        (q.h).typeoe,
										        (q.h).stext,
										        REPEAT('=>', level) ||' '||(q.h).stext as stext_lev, 
										        (q.h).begda,
										        (q.h).endda,
										        (q.h).cfo,
										        breadcrumb::VARCHAR AS path_id,
										        path_stext::VARCHAR AS path_stext,
										        path_typeoe::VARCHAR AS path_typeoe
										  FROM q)
select distinct rn,level_,id,parentid,begda,endda,typeoe,stext,cfo,stext_lev,path_id,path_typeoe,path_stext
from t2 			  
--where lv = 5
ORDER BY level_
;


select path_typeoe,level_, count(1) as cnt
from tmp_tab2
WHERE 1=1
  and typeoe = 'Подразделение'
  and cfo is not null 
 group by path_typeoe,level_ 
 order by cnt desc;
