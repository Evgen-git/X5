select cfo,id,to_date(begda::text, 'YYYYMMDD'::text) as begda,to_date(endda::text, 'YYYYMMDD'::text) as endda,type,is_archive 
-- select count(1)
  from spv
 where cfo in (
 select cfo
  from spv
 group by cfo 
having count(1)>1
)
and CURRENT_DATE >= to_date(begda::text, 'YYYYMMDD'::text) AND CURRENT_DATE <= to_date(endda::text, 'YYYYMMDD'::text) 
and is_archive = false
order by cfo, id 



select distinct staff_id
from mv_staff_by_orgeh msbo 
where staff_id in 
(
select plans
from to_del_7 td)
and  staff_role = 'Директор кластера'




,
     vw_type_post vtp 