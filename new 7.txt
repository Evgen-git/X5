--commit;
--begin;

--CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tab1 ON COMMIT drop AS
drop TABLE to_del_tab1;
CREATE TABLE to_del_tab1 AS
SELECT id,parentid,begda,endda,typeoe,stext,cfo,mvz,email,addr,is_archive,redun
FROM orgeh h
where CURRENT_DATE <= to_date(endda,'YYYYMMDD')
  and typeoe = 'Подразделение'
  and cfo is not null;


--CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tab2 ON COMMIT drop AS
drop TABLE to_del_tab2;
CREATE TABLE to_del_tab2 AS
with RECURSIVE q AS (SELECT h.id as root_id, 1 as lev,h.id,h.parentid,h.typeoe
                       FROM orgeh h
                      WHERE h.id in (select id from to_del_tab1)
                      UNION ALL
                     SELECT q.root_id,q.lev+1 as lev,hi.id,hi.parentid,hi.typeoe
                       FROM q JOIN orgeh hi ON hi.id = q.parentid),
              q_pivot as (select max(case typeoe when 'Торговая сеть' then id end) as ts_id, 
                                 max(case typeoe when 'МакроРегион' then id end) as makro_id, 
                                 max(case typeoe when 'Кластер/Регион' then id end) as cluster_id, 
                                 max(case typeoe when 'Дивизион' then id end) as division_id,
                                 root_id as dep_id
                            from q
                            where typeoe in ('Подразделение','Дивизион','МакроРегион','Кластер/Регион','Торговая сеть')
                            group by root_id),
             q_info as (select t1.ts_id,t1.makro_id,t1.cluster_id,t1.dep_id,
                               t2.parentid,t2.begda,t2.endda,t2.typeoe,t2.stext,t2.cfo,t2.mvz,t2.email,t2.addr,t2.is_archive,t2.redun   
                          from q_pivot t1,
                               to_del_tab1 t2  
                          where t1.dep_id=t2.id)
select ts_id,makro_id,cluster_id,dep_id,parentid,begda,endda,typeoe,stext,cfo,mvz,email,addr,is_archive,redun   
from q_info;


--CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tab3 ON COMMIT drop AS
drop TABLE to_del_tab3;
CREATE TABLE to_del_tab3 AS
with staff as (select pl.id, pl.begda, pl.endda, pl.parentid, pl.stext, pl.ltext, pl.stell, pl.is_archive, pl.redun, ps.post_name, ps.post_role 
                 from vw_type_post ps inner join "plans" pl on (ps.post_code =pl.stell)
                where  CURRENT_DATE between to_date(pl.begda,'YYYYMMDD') and to_date(pl.endda,'YYYYMMDD')
                  and  pl.stell in ('50000566'/*дм*/,'50000583'/*здм*/,'52036730'/*рмп*/,'50000741'/*спв*/,'50175446'/*дк*/)),
     pers  as (select id, "plans", fio, usrid, email, cell, gbdat, is_archive, hpern
                 from (select id, "plans", fio, usrid, email, cell, gbdat, is_archive, hpern,
                              count(1) over (partition by usrid) as dbl_usrid 
                         from pernr
                        where usrid is not null) t
                where dbl_usrid=1),
     pers_by_staff as (select st.id as id_staff, st.post_name as type_staff, post_role as type_staff_role, st.parentid as parentid_staff,st.stell,st.stext as stext_staff, st.begda as begda_staff,st.endda as endda_staff, st.ltext as ltext_staff,st.is_archive as is_archive_staff, st.redun as redun_staff, 
                              ps.id as id_pers, ps.fio, ps.usrid , ps.email as email_pers, ps.cell as cell_pers, ps.gbdat , ps.is_archive as is_archive_pers, ps.hpern
                         from pers ps, staff st    
                        where ps."plans"=st.id)           
select * 
  from pers_by_staff;

-- *USERS*
select t3.usrid as Login,
       t3.fio,
       case when stell in ('50000566','50000583') then og.email
            when stell in ('50000741','52036730','51671102') then t3.email_pers
        end as Email,
       t3.cell_pers as phonenumber,
       t3.ltext_staff as "position", 
       0 as "version", 
       t3.is_archive_pers as is_archived,
       t3.type_staff_role
  from to_del_tab3 t3 left join orgeh og on (t3.parentid_staff=og.id) ;

-- *OE*

  
  
