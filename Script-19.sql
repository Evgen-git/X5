select * from to_del_tab2;





select * from vw_type_post vtp 
select *   from to_del_tab3
select *   from orgeh
select *   from pernr


select cfo as id,
       stext as "name",
       as responsiblieid,
select *
   from to_del_tab2
where cluster_id in ('52903424','52905250','52905351','52905525','52905674','52905767','52906101','52903295','52903526','52903665')


select * from pernr
where  fio like 'Кудакаев%'
stell = '50175446'


select id, "plans", fio, usrid, email, cell, gbdat, is_archive, hpern,
                              count(1) over (partition by usrid) as dbl_usrid 
                         from pernr
                        where usrid = 'MARAT.KUDAKAEV'
'52905536'

select * 
                 from "plans" pl 
                where 1=1
                --CURRENT_DATE between to_date(pl.begda,'YYYYMMDD') and to_date(pl.endda,'YYYYMMDD')
                  --and  pl.stell in ('50000566'/*дм*/,'50000583'/*здм*/,'52036730'/*рмп*/,'50000741'/*спв*/,'50175446'/*дк*/)
and pl.id = '52905536'

select st.id_staff,st.type_staff,st.parentid_staff ,stext_staff ,begda_staff ,endda_staff,is_archive_staff ,id_pers ,fio ,usrid,
       oh.typeoe, oh.stext 
from to_del_tab3 st left join orgeh oh on (st.parentid_staff=oh.id)
where st.stell in ('50175446','52036679')
  and 
  
select * from orgeh
where id = '52908807'

select stell, count(1) as cnt
                 from "plans" pl 
                where 1=1
and lower(stext) like 'директор кластера%'
group by stell


select stext,stell, count(1) as cnt
from "plans" pl 
where 1=1
and stell in ('50175446','52036679')
group by stext,stell
order by cnt desc


with RECURSIVE q AS (SELECT h.id as root_id, 1 as lev,h.id,h.parentid,h.typeoe
                       FROM orgeh h
                      WHERE h.id = '52908807'
                      UNION ALL
                     SELECT q.root_id,q.lev+1 as lev,hi.id,hi.parentid,hi.typeoe
                       FROM q JOIN orgeh hi ON hi.id = q.parentid)
select * from q;
with RECURSIVE q AS (SELECT h.id as root_id, 1 as lev,h.id,h.parentid,h.typeoe
                       FROM orgeh h
                      WHERE h.id = '52908807'
                      UNION ALL
                     SELECT q.root_id,q.lev+1 as lev,hi.id,hi.parentid,hi.typeoe
                       FROM q JOIN orgeh hi ON hi.parentid = q.id)
select * from q;


select * from orgeh h
where id in ('52908807',
'52906170',
'52880585',
'51047541')


