DROP view if EXISTS public.vw_pers_staff;
DROP VIEW if EXISTS  public.vw_orgeh_pers_staff;
DROP MATERIALIZED VIEW if EXISTS  public.mv_staff_by_orgeh;
DROP MATERIALIZED VIEW if EXISTS  public.mv_pers_by_staff;
DROP MATERIALIZED VIEW if EXISTS public.mv_orgeh_baselevel;
DROP VIEW if EXISTS  public.vw_type_staff;


--drop VIEW public.vw_type_staff;
CREATE OR REPLACE VIEW public.vw_type_staff
AS SELECT '50175446'::text AS type_staff_code,
    'Директор Кластера'::text AS type_staff_name,
    'Директор Кластера'::text AS role_staff_name,
    'DC'::text AS role_staff_abbr
UNION ALL
 SELECT '52036679'::text AS type_staff_code,
    'Директор Кластера'::text AS type_staff_name,
    'Директор Кластера'::text AS role_staff_name,
    'DC'::text AS role_staff_abbr
UNION ALL
 SELECT '52036730'::text AS type_staff_code,
    'РМП'::text AS type_staff_name,
    'Региональный менеджер по подбору'::text AS role_staff_name,
    'RMP'::text AS role_staff_abbr
UNION ALL
 SELECT '51671102'::text AS type_staff_code,
    'РМП РЦ'::text AS type_staff_name,
    'Региональный менеджер по подбору'::text AS role_staff_name,
    'RMP'::text AS role_staff_abbr
UNION ALL
 SELECT '50000741'::text AS type_staff_code,
    'СПВ'::text AS type_staff_name,
    'Супервайзер'::text AS role_staff_name,
    'SPV'::text AS role_staff_abbr
UNION ALL
 SELECT '51180462'::text AS type_staff_code,
    'НОО'::text AS type_staff_name,
    'НОО'::text AS role_staff_name,
    'NOO'::text AS role_staff_abbr
UNION ALL
 SELECT '52036725'::text AS type_staff_code,
    'НОО'::text AS type_staff_name,
    'НОО'::text AS role_staff_name,
    'NOO'::text AS role_staff_abbr
/*UNION ALL
 SELECT '52036725'::text AS type_staff_code,
    'НОП'::text AS type_staff_name,
    'НОП'::text AS role_staff_name,
    'NOP'::text AS role_staff_abbr */
UNION ALL 
SELECT '50027881'::text AS type_staff_code,
    'НОП'::text AS type_staff_name,
    'НОП'::text AS role_staff_name,
    'NOP'::text AS role_staff_abbr
UNION all
SELECT '50000583'::text AS type_staff_code,
    'Заместитель директора магазина'::text AS type_staff_name,
    'Директор магазина'::text AS role_staff_name,
    'DSH'::text AS role_staff_abbr
UNION ALL
 SELECT '50000566'::text AS type_staff_code,
    '   Директор Магазина'::text AS type_staff_name,
    'Директор магазина'::text AS role_staff_name,
    'DSH'::text AS role_staff_abbr
UNION ALL
 SELECT '50000535'::text AS type_staff_code,
    'Администратор'::text AS type_staff_name,
    'Директор магазина'::text AS role_staff_name,
    'DSH'::text AS role_staff_abbr
UNION ALL
 SELECT '50616757'::text AS type_staff_code,
    'Старший продавец-кассир'::text AS type_staff_name,
    'Прочее'::text AS role_staff_name,
    'Other'::text AS role_staff_abbr
UNION ALL
 SELECT '50000682'::text AS type_staff_code,
    'Продавец-кассир'::text AS type_staff_name,
    'Прочее'::text AS role_staff_name,
    'Other'::text AS role_staff_abbr
UNION ALL
 SELECT '50000665'::text AS type_staff_code,
    'Пекарь'::text AS type_staff_name,
    'Прочее'::text AS role_staff_name,
    'Other'::text AS role_staff_abbr
UNION ALL
 SELECT '50612455'::text AS type_staff_code,
    'Тренинг-менеджер на РЦ'::text AS type_staff_name,
    'Прочее'::text AS role_staff_name,
    'Other'::text AS role_staff_abbr;


CREATE MATERIALIZED VIEW public.mv_orgeh_baselevel
TABLESPACE pg_default
AS WITH RECURSIVE q AS (
         SELECT h.id AS root_id,
            1 AS lev,
            h.id,
            h.parentid,
            h.stext,
            h.typeoe,
            h.addr,
                CASE
                    WHEN CURRENT_DATE < to_date(h.begda::text, 'YYYYMMDD'::text) THEN 'BeforeRange'::text
                    WHEN CURRENT_DATE > to_date(h.endda::text, 'YYYYMMDD'::text) THEN 'AfterRange'::text
                    ELSE 'IntoRange'::text
                END AS rageperiod
           FROM orgeh h
          WHERE (h.id::text IN ( SELECT h_1.id
                   FROM orgeh h_1
                  WHERE 1 = 1 AND h_1.typeoe::text = 'Подразделение'::text AND h_1.cfo IS NOT NULL))
        UNION ALL
         SELECT q.root_id,
            q.lev + 1 AS lev,
            hi.id,
            hi.parentid,
            hi.stext,
            hi.typeoe,
            hi.addr,
                CASE
                    WHEN CURRENT_DATE < to_date(hi.begda::text, 'YYYYMMDD'::text) THEN 'BeforeRange'::text
                    WHEN CURRENT_DATE > to_date(hi.endda::text, 'YYYYMMDD'::text) THEN 'AfterRange'::text
                    ELSE 'IntoRange'::text
                END AS rageperiod
           FROM q
             JOIN orgeh hi ON hi.id::text = q.parentid::text
        ), q_pivot AS (
         SELECT q.root_id,
            max(
                CASE q.typeoe
                    WHEN 'Торговая сеть'::text THEN q.id
                    ELSE NULL::character varying
                END::text) AS ts_id,
            max(
                CASE q.typeoe
                    WHEN 'Дивизион'::text THEN q.id
                    ELSE NULL::character varying
                END::text) AS division_id,
            max(
                CASE q.typeoe
                    WHEN 'Дивизион'::text THEN q.rageperiod
                    ELSE NULL::text
                END) AS division_range,
            max(
                CASE q.typeoe
                    WHEN 'МакроРегион'::text THEN q.id
                    ELSE NULL::character varying
                END::text) AS makro_id,
            max(
                CASE q.typeoe
                    WHEN 'МакроРегион'::text THEN q.rageperiod
                    ELSE NULL::text
                END) AS makro_range,
            max(
                CASE q.typeoe
                    WHEN 'МакроРегион'::text THEN q.stext
                    ELSE NULL::character varying
                END::text) AS makro_name,
            max(
                CASE q.typeoe
                    WHEN 'Кластер/Регион'::text THEN q.id
                    ELSE NULL::character varying
                END::text) AS cluster_id,
            max(
                CASE q.typeoe
                    WHEN 'Кластер/Регион'::text THEN q.rageperiod
                    ELSE NULL::text
                END) AS cluster_range,
            max(
                CASE q.typeoe
                    WHEN 'Кластер/Регион'::text THEN q.addr
                    ELSE NULL::text
                END) AS cluster_addr,
            max(
                CASE q.typeoe
                    WHEN 'Кластер/Регион'::text THEN q.stext::text
                    ELSE NULL::text
                END) AS cluster_name,
            max(
                CASE q.typeoe
                    WHEN 'Подразделение'::text THEN q.id
                    ELSE NULL::character varying
                END::text) AS dep_id,
            max(
                CASE q.typeoe
                    WHEN 'Подразделение'::text THEN q.rageperiod
                    ELSE NULL::text
                END) AS dep_range
           FROM q
          WHERE q.typeoe::text = ANY (ARRAY['Торговая сеть'::character varying::text, 'Дивизион'::character varying::text, 'МакроРегион'::character varying::text, 'Кластер/Регион'::character varying::text, 'Подразделение'::character varying::text])
          GROUP BY q.root_id
        ), q_info AS (
         SELECT t1.root_id,
            t1.ts_id,
            t1.makro_id,
            t1.makro_range,
            t1.makro_name,
            t1.cluster_id,
            t1.cluster_range,
            t1.cluster_name,
            t1.cluster_addr,
            t1.division_id,
            t1.division_range,
            t1.dep_id,
            t1.dep_range,
            t2.stext AS dep_name,
            t2.parentid,
            t2.begda,
            t2.endda,
            t2.typeoe,
            t2.cfo,
            t2.mvz,
            t2.email,
            t2.addr,
            t2.is_archive,
            t2.redun
           FROM q_pivot t1,
            orgeh t2
          WHERE t1.dep_id = t2.id::text
        )
 SELECT q_info.root_id,
    q_info.ts_id,
    q_info.makro_id,
    q_info.makro_range,
    q_info.makro_name,
    q_info.cluster_id,
    q_info.cluster_range,
    q_info.cluster_name,
    q_info.cluster_addr,
    q_info.dep_id,
    q_info.dep_range,
    q_info.dep_name,
    q_info.begda,
    q_info.endda,
    q_info.cfo,
    q_info.mvz,
    q_info.email,
    q_info.addr,
    q_info.is_archive,
    q_info.redun
   FROM q_info
WITH DATA;


--drop MATERIALIZED VIEW public.mv_staff_by_orgeh
CREATE MATERIALIZED VIEW public.mv_staff_by_orgeh
TABLESPACE pg_default
AS WITH RECURSIVE staff as (select ps.type_staff_code,ps.role_staff_abbr,pl.id AS staff_id,pl.stext as staff_name,
                               pl.parentid AS staff_oe_id
                          from plans pl left join vw_type_staff ps ON ps.type_staff_code = pl.stell::text 
                          where CURRENT_DATE >= to_date(pl.begda::text, 'YYYYMMDD'::text) AND CURRENT_DATE <= to_date(pl.endda::text, 'YYYYMMDD'::text) 
                          and ps.role_staff_abbr in ('DC','RMP','SPV','DSH','NOO') and type_staff_code not in ('50000535')),
               rmp_DrillUp(type_staff_code,role_staff_abbr,staff_id,staff_name,staff_oe_id,id,pid,typeoe) as
                         (select sf.type_staff_code,sf.role_staff_abbr,sf.staff_id,sf.staff_name,sf.staff_oe_id,rg.id,rg.parentid as pid,rg.typeoe
                            from staff sf inner join orgeh rg on (sf.staff_oe_id=rg.id and sf.role_staff_abbr in ('RMP','NOO'))
                           union all  
                          select cls.type_staff_code,cls.role_staff_abbr,cls.staff_id,cls.staff_name,cls.staff_oe_id,rg.id,rg.parentid as pid,rg.typeoe
                            from rmp_DrillUp cls,orgeh rg
                           where cls.pid = rg.id),
               staff_by_dep as (select type_staff_code,role_staff_abbr,staff_id,staff_name,staff_oe_id,staff_oe_id as start_oe_id
                                 from staff                      
                                where role_staff_abbr in ('DC','DSH')
                                 union    
                                select type_staff_code,role_staff_abbr,staff_id,staff_name,staff_oe_id,id as start_oe_id
                                    from rmp_DrillUp
                                    where typeoe='Кластер/Регион'
                                 union    
                                select (select type_staff_code from vw_type_staff where role_staff_abbr='SPV') as type_staff_code,
                                       (select role_staff_abbr from vw_type_staff where role_staff_abbr='SPV') as role_staff_abbr,
                                       pr."plans" as staff_id,
                                       (select type_staff_name from vw_type_staff where role_staff_abbr='SPV') as staff_name,
                                        rg.id as start_oe_id,rg.id as staff_oe_id
                                  from (select cfo,pers_id,staff_type,row_number() over (partition by cfo order by staff_type,pers_id desc) as rn_staff
                                          from (select cfo,id as pers_id,type as staff_type--,row_number() over (partition by cfo order by type,id desc) as rn_staff  
                                                  from spv
                                                 where 1=1 
                                                   and CURRENT_DATE >= to_date(begda::text, 'YYYYMMDD'::text) AND CURRENT_DATE <= to_date(endda::text, 'YYYYMMDD'::text) 
                                                   and is_archive = false) t1 
                                       ) st left join orgeh rg on (st.cfo = rg.cfo)
                                            left join pernr pr on (st.pers_id=pr.id)        
                                 where st.rn_staff =1
                                    ),
               t_common(type_staff_code,role_staff_abbr,staff_id,staff_name,staff_oe_id, oe_id, oe_pid, oe_type, gen, deprageperiod) AS 
                         (select stf.type_staff_code,stf.role_staff_abbr,stf.staff_id,stf.staff_name,stf.staff_oe_id,
                                 org.id AS oe_id,org.parentid AS oe_pid,org.typeoe AS oe_type,1 AS gen,
                                 case when CURRENT_DATE < to_date(org.begda::text, 'YYYYMMDD'::text) THEN 'BeforeRange'::text
                                      when CURRENT_DATE > to_date(org.endda::text, 'YYYYMMDD'::text) THEN 'AfterRange'::text
                                      else 'IntoRange'::text
                                  end as deprageperiod
                            from staff_by_dep stf left join orgeh org ON stf.start_oe_id::text = org.id::text
                           union all
                          select pr.type_staff_code,pr.role_staff_abbr,pr.staff_id,pr.staff_name,pr.staff_oe_id,
                                 hi.id AS oe_id,
                                 hi.parentid AS oe_pid,
                                 hi.typeoe AS oe_type,
                                 pr.gen + 1 AS gen,
                                 case when  CURRENT_DATE < to_date(hi.begda::text, 'YYYYMMDD'::text) THEN 'BeforeRange'::text
                                      when  CURRENT_DATE > to_date(hi.endda::text, 'YYYYMMDD'::text) THEN 'AfterRange'::text
                                      else  'IntoRange'::text
                                  end as  deprageperiod
                               FROM t_common pr, orgeh hi
                              WHERE pr.oe_id::text = hi.parentid::text)
SELECT type_staff_code,role_staff_abbr,staff_id,staff_name,staff_oe_id,oe_id as dep_oe_id,deprageperiod
  FROM t_common
 WHERE t_common.oe_type::text = 'Подразделение'::text;

CREATE MATERIALIZED VIEW public.mv_pers_by_staff
TABLESPACE pg_default
AS WITH staff AS (select ps.type_staff_code,ps.role_staff_abbr,ps.role_staff_name,
                         pl.id AS staff_id,pl.stext as staff_name,
                         pl.parentid AS staff_oe_id,rg.email as email_oe 
                    FROM plans pl left join vw_type_staff ps ON ps.type_staff_code = pl.stell::text
                                  left join orgeh rg on (pl.parentid = rg.id )  
                  WHERE CURRENT_DATE >= to_date(pl.begda::text, 'YYYYMMDD'::text) AND CURRENT_DATE <= to_date(pl.endda::text, 'YYYYMMDD'::text) 
                    AND ps.role_staff_abbr in ('DC','RMP','SPV','DSH','NOO')
                    and pl.is_archive = false and trim(pl.redun) = ''), 
        pers AS (SELECT staff_id,pers_id,fio,usrid,email_ps,cell,gbdat,rn_pers
                   FROM ( SELECT pr1.plans as staff_id, pr1.id as pers_id, pr2.fio, pr2.usrid, pr2.email as email_ps, pr2.cell, pr2.gbdat, 
                                 row_number() over (partition by pr1.plans order by pr1.id desc) as rn_pers,
                                 count(1) OVER (PARTITION BY pr2.usrid) AS dbl_usrid
                            FROM pernr pr1 inner join pernr pr2 on (pr1.hpern=pr2.id)
                           WHERE pr2.usrid is not null and (pr1.is_archive and pr2.is_archive)=false) t
                  WHERE t.dbl_usrid = 1 and rn_pers=1), 
        pers_by_staff AS (SELECT st.type_staff_code,st.role_staff_abbr,st.role_staff_name,st.staff_id,st.staff_name,st.staff_oe_id,
                                 ps.pers_id,ps.fio,ps.usrid,ps.cell,ps.gbdat,ps.rn_pers,
                                 case when st.role_staff_abbr='DSH' then st.email_oe else ps.email_ps end as email
                            FROM pers ps,staff st
                           WHERE ps.staff_id::text = st.staff_id::text)
 select type_staff_code,role_staff_abbr,role_staff_name,staff_id,staff_name,staff_oe_id,
        pers_id,fio,usrid,email,cell,gbdat,rn_pers
FROM pers_by_staff
WITH DATA;

CREATE OR REPLACE VIEW public.vw_orgeh_pers_staff
as select mob.cfo AS id,
       'Розница' as type_dep,
       mob.dep_name AS "Name",
       mob.addr AS address,
       mob.makro_name,        
       mob.cluster_name,
       mob.cluster_addr,
       '' as division_name,
       rmp.fio as rmp_fio,
       rmp.cell as rmp_phone,
       rmp.email as rmp_email,
       dc.fio as clusterdirectorfio,
       dc.cell as clusterdirectorphone, 
       dc.email as clusterdirectoremail,
       dsh.fio as dshop_fio,
       dsh.cell as dshop_phone,
       dsh.email as dshop_email,
       noo.email as noo_email,
       spv.fio as spv_fio,
       spv.cell as spv_phone,
       spv.email as spv_email,
       mob.dep_id as sapid, 
       mob.cfo as cfoid, 
       mob.begda AS openingdate,
       mob.is_archive AS isarchived
   FROM mv_orgeh_baselevel mob
     LEFT JOIN (SELECT so.dep_oe_id AS dep_id,mp_1.fio,mp_1.cell,mp_1.email
                  FROM mv_staff_by_orgeh so,mv_pers_by_staff mp_1
                 WHERE so.staff_id::text = mp_1.staff_id::text 
                   AND so.role_staff_abbr::text = 'RMP' 
                   AND mp_1.rn_pers = 1) rmp ON (mob.dep_id = rmp.dep_id::text)
     LEFT JOIN (SELECT so.dep_oe_id AS dep_id,mp_1.fio,mp_1.cell,mp_1.email
                  FROM mv_staff_by_orgeh so,mv_pers_by_staff mp_1
                 WHERE so.staff_id::text = mp_1.staff_id::text 
                   AND so.role_staff_abbr::text = 'DSH' and so.type_staff_code = '50000566'
                   AND mp_1.rn_pers = 1) dsh ON (mob.dep_id = dsh.dep_id::text)
     LEFT JOIN (SELECT so.dep_oe_id AS dep_id,mp_1.fio,mp_1.cell,mp_1.email
                  FROM mv_staff_by_orgeh so,mv_pers_by_staff mp_1
                 WHERE so.staff_id::text = mp_1.staff_id::text 
                   AND so.role_staff_abbr::text = 'NOO' 
                   AND mp_1.rn_pers = 1) noo ON (mob.dep_id = noo.dep_id::text)
     LEFT JOIN (SELECT so.dep_oe_id AS dep_id,mp_1.fio,mp_1.cell,mp_1.email
                  FROM mv_staff_by_orgeh so,mv_pers_by_staff mp_1
                 WHERE so.staff_id::text = mp_1.staff_id::text 
                   AND so.role_staff_abbr::text = 'SPV' 
                   AND mp_1.rn_pers = 1) spv ON (mob.dep_id = spv.dep_id::text)
     LEFT JOIN (SELECT so.dep_oe_id AS dep_id,mp_1.fio,mp_1.cell,mp_1.email
                  FROM mv_staff_by_orgeh so,mv_pers_by_staff mp_1
                 WHERE so.staff_id::text = mp_1.staff_id::text 
                   AND so.role_staff_abbr::text = 'DC' 
                   AND mp_1.rn_pers = 1) dc ON (mob.dep_id = dc.dep_id::text)
  WHERE btrim(mob.redun::text) = ''::text
   -- and mob.cfo in ('E1031899', 'E1029273', 'E1012029', 'E1012102', 'E1025998')
  ;


CREATE OR REPLACE VIEW public.vw_pers_staff
AS SELECT t3.usrid AS login,
    (regexp_split_to_array(t3.fio::text, '\s+'::text))[2] AS FirstName,
    (regexp_split_to_array(t3.fio::text, '\s+'::text))[1] AS MiddleName,
    (regexp_split_to_array(t3.fio::text, '\s+'::text))[3] AS LastName,
    t3.email,
    t3.cell,
    t3.staff_name,
    0 AS vers,
    false AS isarchived,
	t3.role_staff_name,
    t3.role_staff_abbr
FROM mv_pers_by_staff t3
WHERE 1=1
    --and t3.role_staff_abbr::text = 'DC'::text
    and staff_id in (select staff_id
                       from  mv_staff_by_orgeh msbo 
                      where dep_oe_id in (select dep_id 
                                            from  mv_orgeh_baselevel mob
                                            where cluster_id in ('52903424','52905250','52905351','52905525','52905674','52905767','52906101','52903295','52903526','52903665')))
    ;


refresh MATERIALIZED VIEW mv_orgeh_baselevel;
refresh MATERIALIZED VIEW mv_pers_by_staff;
refresh MATERIALIZED VIEW mv_staff_by_orgeh;

select cfoid as id, "Name", rmp_fio as "ResponsibleId", rmp_phone as "Contacts", address as "Address",
       address as "ExtraData.InterviewAddress",
       dshop_fio as "ExtraData.DMFio",
       dshop_email as "ExtraData.DMEmail",
       dshop_phone as "ExtraData.DMPhone",
       rmp_email as "ExtraData.RMPEmail",
       noo_email as "ExtraData.NOOEmail",
       type_dep as "ExtraData.OrgUnitType",
       cluster_addr as "ExtraData.RegionalOffice",
       makro_name as "ExtraData.Macroregion",
       null as "ExtraData.Division",
       cluster_name as "ExtraData.Cluster",
       sapid as "ExtraData.SAPId",
       cfoid as "ExtraData.CFOId",
       to_date(openingdate,'YYYYMMDD') as "ExtraData.OpeningDate",
       false as "IsArchived",
       spv_fio as "ExtraData.SupervisorFio",
       spv_email as "ExtraData.SupervisorEmail",
       clusterdirectorfio as "ExtraData.ClusterDirectorFio",
       clusterdirectorphone as "ExtraData.ClusterDirectorPhone",
       clusterdirectoremail as "ExtraData.ClusterDirectorEmail"
from vw_orgeh_pers_staff vops 
where cfoid in ('E1031899', 'E1029273', 'E1012029', 'E1012102', 'E1025998','E1011888')
order by "Name";
 

select login as "Login",
       firstname as "FirstName",
       middlename as "MiddleName",
       lastname as "LastName",
       email as "Email",
       cell as "PhoneNumber",
       staff_name  as "Position",
       vers as "Version",
       isarchived  as "IsArchived",
       role_staff_name as  "Role"
from vw_pers_staff;




