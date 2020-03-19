select * from to_del_8
where cfoid in ('E1031899', 'E1029273', 'E1012029', 'E1012102')
order by "name";

--select   contacts    address interviewaddress    dmfio   dmemail rmpemail    nooemail    dmphone supervisoremail supervisorfio   orgunittype regionaloffice  "cluster"   division    macroregion category    sapid   cfoid   openingdata is_archive  
select cfoid as id, "Name", rpm_fio as "ResponsibleId", rpm_phone as "Contacts", address as "Address",
       address as "ExtraData.InterviewAddress",
       dshop_fio as "ExtraData.DMFio",
       dshop_email as "ExtraData.DMEmail",
       dshop_phone as "ExtraData.DMPhone",
       rpm_email as "ExtraData.RMPEmail",
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
--select *
from vw_orgeh_pers_staff vops 
where cfoid in ('E1031899', 'E1029273', 'E1012029', 'E1012102', 'E1025998','E1012102')
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
       role_staff_abbr as  "Role"
from vw_pers_staff
where firstname = 'Иванцова'
;





  
  SELECT so.dep_oe_id AS dep_id,mp_1.fio,mp_1.cell,mp_1.email,mp_1.staff_id
                  FROM mv_staff_by_orgeh so,mv_pers_by_staff mp_1
                 WHERE so.staff_id::text = mp_1.staff_id::text 
                   AND so.role_staff_abbr::text = 'SPV' 
                   AND mp_1.rn_pers = 1
and   so.dep_oe_id = '52865080'
  
  SELECT so.*
FROM mv_staff_by_orgeh so
where 1=1
and   so.dep_oe_id = '52865080'
AND so.role_staff_abbr::text = 'DSH' 
  
select * from mv_pers_by_staff
where staff_oe_id  = '52422902' 


select * from plans
where parentid  = '52006106' 

select * from pernr
where fio like 'Иванцова%'
plans = '52006110'

select * from spv s 
where cfo like '%998'

'52865080'


select * from pernr
where id = '01192216'

select * from plans
where parentid = '52006106'
stell = '50027881'
id  = '52905702' 

select * from PUBLIC.orgeh o  
where 1=1
  and stext like '11189%' 

SELECT * FROM public.orgeh;

  
  select * from pg_available_extensions;
  
  
  CREATE EXTENSION tablefunc;
  
  
  
  
  