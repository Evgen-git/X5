create table to_del_8 as  
SELECT DISTINCT ON (orgeh_1.cfo) 
   orgeh_1.cfo AS "id",
   orgeh_1.ltext AS "name",
   pernr_6.email AS "responsibleid",
   pernr_6.cell AS "contacts",
   orgeh_1.addr AS "address",
   orgeh_1.addr AS "interviewaddress",
   pernr_5.fio AS "dmfio",
   orgeh_1.email AS "dmemail",
   pernr_6.email AS "rmpemail",
   pernr_7.email AS "nooemail",
   pernr_5.cell AS "dmphone",
   pernr_8.email AS "supervisoremail",
   pernr_8.fio AS "supervisorfio",
   orgeh_1.typeoe AS "orgunittype",
   'null' AS "regionaloffice",
   orgeh_3.ltext AS "cluster", 
   orgeh_5.ltext AS "division",
   orgeh_6.ltext AS "macroregion",
   'null' AS "category",
   orgeh_1.id AS "sapid",
   orgeh_1.cfo AS "cfoid",
   orgeh_1.begda AS "openingdata",
   case WHEN orgeh_1.is_archive = true OR orgeh_1.redun = 'X' THEN true ELSE false END AS "is_archive"
FROM orgeh AS orgeh_1
JOIN orgeh AS orgeh_2 ON orgeh_1.parentid = orgeh_2.id
JOIN orgeh AS orgeh_3 ON orgeh_2.parentid = orgeh_3.id AND orgeh_3.typeoe = 'Кластер/Регион' AND orgeh_1.stext LIKE '%Пятерочка%' and orgeh_1.cfo in ('E1031899', 'E1029273', 'E1012029', 'E1012102', 'E1025998')
JOIN orgeh AS orgeh_4 ON orgeh_3.parentid = orgeh_4.id
JOIN orgeh AS orgeh_5 ON orgeh_4.parentid = orgeh_5.id
JOIN orgeh AS orgeh_6 ON orgeh_5.parentid = orgeh_6.id
LEFT JOIN plans AS plans_1 ON plans_1.parentid = orgeh_1.id and plans_1.stell = '50000566'
LEFT JOIN pernr AS pernr_1 ON pernr_1.plans = plans_1.id
JOIN orgeh AS orgeh_7 ON orgeh_7.parentid = orgeh_3.id and orgeh_7.typeoe LIKE 'ЦО%'
JOIN orgeh AS orgeh_8 ON orgeh_8.parentid = orgeh_7.id AND orgeh_8.stext = 'Персонал'
JOIN plans AS plans_2 ON plans_2.parentid = orgeh_8.id AND plans_2.stell = '52036730'
JOIN pernr AS pernr_2 ON plans_2.id = pernr_2.plans
JOIN orgeh AS orgeh_9 ON orgeh_9.parentid = orgeh_3.id
LEFT JOIN orgeh AS orgeh_10 ON orgeh_10.parentid = orgeh_9.id AND orgeh_10.stext = 'Отдел операций'
LEFT JOIN plans AS plans_3 ON plans_3.parentid = orgeh_10.id AND  plans_3.stell = '51180462'
LEFT JOIN pernr AS pernr_3 ON plans_3.id = pernr_3.plans
LEFT JOIN spv ON spv.cfo = orgeh_1.cfo
LEFT JOIN pernr AS pernr_4 ON pernr_4.id = spv.id
LEFT JOIN pernr AS pernr_5 ON pernr_1.hpern = pernr_5.id
LEFT JOIN pernr AS pernr_6 ON pernr_2.hpern = pernr_6.id
LEFT JOIN pernr AS pernr_7 ON pernr_3.hpern = pernr_7.id
LEFT JOIN pernr AS pernr_8 ON pernr_4.hpern = pernr_8.id

--ORDER BY orgeh_1.cfo

