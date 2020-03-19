CREATE OR REPLACE VIEW public.vw_type_post
AS SELECT 'Старший продавец-кассир'::text AS post_name,
    'Прочее'::text AS post_role,
    '50616757'::text AS post_code
UNION ALL
 SELECT 'Продавец-кассир'::text AS post_name,
    'Прочее'::text AS post_role,
    '50000682'::text AS post_code
UNION ALL
 SELECT 'Пекарь'::text AS post_name,
    'Прочее'::text AS post_role,
    '50000665'::text AS post_code
UNION ALL
 SELECT 'Администратор'::text AS post_name,
    'Прочее'::text AS post_role,
    '50000535'::text AS post_code
UNION ALL
 SELECT 'СПВ'::text AS post_name,
    'Супервайзер'::text AS post_role,
    '50000741'::text AS post_code
UNION ALL
 SELECT 'НОО'::text AS post_name,
    'Прочее'::text AS post_role,
    '51180462'::text AS post_code
UNION ALL
 SELECT 'Директор магазина'::text AS post_name,
    'Директор Магазина'::text AS post_role,
    '50000566'::text AS post_code
UNION ALL
 SELECT 'Заместитель директора магазина'::text AS post_name,
    'Директор Магазина'::text AS post_role,
    '50000583'::text AS post_code
UNION ALL
 SELECT 'Директор Кластера'::text AS post_name,
    'Директор кластера'::text AS post_role,
    '50175446'::text AS post_code
UNION ALL
 SELECT 'Директор Кластера'::text AS post_name,
    'Директор кластера'::text AS post_role,
    '52036679'::text AS post_code
UNION ALL
 SELECT 'РМП'::text AS post_name,
    'Региональный Менеджер по подбору'::text AS post_role,
    '52036730'::text AS post_code
UNION ALL
 SELECT 'Тренинг-менеджер на РЦ'::text AS post_name,
    'Прочее'::text AS post_role,
    '50612455'::text AS post_code
UNION ALL
 SELECT 'РМП РЦ'::text AS post_name,
    'Региональный Менеджер по подбору'::text AS post_role,
    '51671102'::text AS post_code;

-- Permissions

ALTER TABLE public.vw_type_post OWNER TO postgres;
GRANT ALL ON TABLE public.vw_type_post TO postgres;

CREATE MATERIALIZED VIEW public.mv_orgeh_baselevel
TABLESPACE pg_default
AS WITH RECURSIVE q AS (
         SELECT h.id AS root_id,
            1 AS lev,
            h.id,
            h.parentid,
            h.typeoe,
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
            hi.typeoe,
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
                END) AS rangedivision,
            max(
                CASE q.typeoe
                    WHEN 'МакроРегион'::text THEN q.id
                    ELSE NULL::character varying
                END::text) AS makro_id,
            max(
                CASE q.typeoe
                    WHEN 'МакроРегион'::text THEN q.rageperiod
                    ELSE NULL::text
                END) AS rangemakro,
            max(
                CASE q.typeoe
                    WHEN 'Кластер/Регион'::text THEN q.id
                    ELSE NULL::character varying
                END::text) AS cluster_id,
            max(
                CASE q.typeoe
                    WHEN 'Кластер/Регион'::text THEN q.rageperiod
                    ELSE NULL::text
                END) AS rangecluster,
            max(
                CASE q.typeoe
                    WHEN 'Подразделение'::text THEN q.id
                    ELSE NULL::character varying
                END::text) AS dep_id,
            max(
                CASE q.typeoe
                    WHEN 'Подразделение'::text THEN q.rageperiod
                    ELSE NULL::text
                END) AS rangedep
           FROM q
          WHERE q.typeoe::text = ANY (ARRAY['Торговая сеть'::character varying, 'Дивизион'::character varying, 'МакроРегион'::character varying, 'Кластер/Регион'::character varying, 'Подразделение'::character varying]::text[])
          GROUP BY q.root_id
        ), q_info AS (
         SELECT t1.root_id,
            t1.ts_id,
            t1.division_id,
            t1.makro_id,
            t1.cluster_id,
            t1.dep_id,
            t1.rangedivision,
            t1.rangemakro,
            t1.rangecluster,
            t1.rangedep,
            t2.parentid,
            t2.begda,
            t2.endda,
            t2.typeoe,
            t2.stext,
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
    q_info.division_id,
    q_info.makro_id,
    q_info.cluster_id,
    q_info.dep_id,
    q_info.rangedivision,
    q_info.rangemakro,
    q_info.rangecluster,
    q_info.rangedep,
    q_info.parentid,
    q_info.begda,
    q_info.endda,
    q_info.typeoe,
    q_info.stext,
    q_info.cfo,
    q_info.mvz,
    q_info.email,
    q_info.addr,
    q_info.is_archive,
    q_info.redun
   FROM q_info
WITH NO DATA;

-- Permissions

ALTER TABLE public.mv_orgeh_baselevel OWNER TO postgres;
GRANT ALL ON TABLE public.mv_orgeh_baselevel TO postgres;


CREATE MATERIALIZED VIEW public.mv_persstaff
TABLESPACE pg_default
AS WITH staff AS (
         SELECT pl.id,
            pl.begda,
            pl.endda,
            pl.parentid,
            pl.stext,
            pl.ltext,
            pl.stell,
            pl.is_archive,
            pl.redun,
            ps.post_name,
            ps.post_role
           FROM plans pl
             LEFT JOIN vw_type_post ps ON ps.post_code = pl.stell::text
          WHERE CURRENT_DATE >= to_date(pl.begda::text, 'YYYYMMDD'::text) AND CURRENT_DATE <= to_date(pl.endda::text, 'YYYYMMDD'::text) AND (pl.stell::text = ANY (ARRAY['50000566'::character varying, '50000583'::character varying, '52036730'::character varying, '50000741'::character varying, '50175446'::character varying, '52036679'::character varying]::text[]))
        ), pers AS (
         SELECT t.id,
            t.plans,
            t.fio,
            t.usrid,
            t.email,
            t.cell,
            t.gbdat,
            t.is_archive,
            t.hpern
           FROM ( SELECT pernr.id,
                    pernr.plans,
                    pernr.fio,
                    pernr.usrid,
                    pernr.email,
                    pernr.cell,
                    pernr.gbdat,
                    pernr.is_archive,
                    pernr.hpern,
                    count(1) OVER (PARTITION BY pernr.usrid) AS dbl_usrid
                   FROM pernr
                  WHERE pernr.usrid IS NOT NULL) t
          WHERE t.dbl_usrid = 1
        ), pers_by_staff AS (
         SELECT st.id AS id_staff,
            st.post_name AS type_staff,
            st.post_role AS type_staff_role,
            st.parentid AS parentid_staff,
            st.stell,
            st.stext AS stext_staff,
            st.begda AS begda_staff,
            st.endda AS endda_staff,
            st.ltext AS ltext_staff,
            st.is_archive AS is_archive_staff,
            st.redun AS redun_staff,
            ps.id AS id_pers,
            ps.fio,
            ps.usrid,
            ps.email AS email_pers,
            ps.cell AS cell_pers,
            ps.gbdat,
            ps.is_archive AS is_archive_pers,
            ps.hpern
           FROM pers ps,
            staff st
          WHERE ps.plans::text = st.id::text
        )
 SELECT pers_by_staff.id_staff,
    pers_by_staff.type_staff,
    pers_by_staff.type_staff_role,
    pers_by_staff.parentid_staff,
    pers_by_staff.stell,
    pers_by_staff.stext_staff,
    pers_by_staff.begda_staff,
    pers_by_staff.endda_staff,
    pers_by_staff.ltext_staff,
    pers_by_staff.is_archive_staff,
    pers_by_staff.redun_staff,
    pers_by_staff.id_pers,
    pers_by_staff.fio,
    pers_by_staff.usrid,
    pers_by_staff.email_pers,
    pers_by_staff.cell_pers,
    pers_by_staff.gbdat,
    pers_by_staff.is_archive_pers,
    pers_by_staff.hpern
   FROM pers_by_staff
WITH NO DATA;

-- Permissions

ALTER TABLE public.mv_persstaff OWNER TO postgres;
GRANT ALL ON TABLE public.mv_persstaff TO postgres;



refresh MATERIALIZED VIEW mv_orgeh_baselevel;
refresh MATERIALIZED VIEW mv_persstaff;

select count(1) from mv_orgeh_baselevel;
select count(1) from mv_persstaff;






