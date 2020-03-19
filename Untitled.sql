refresh MATERIALIZED VIEW mv_orgeh_baselevel;
refresh MATERIALIZED VIEW mv_pers_by_staff;
refresh MATERIALIZED VIEW mv_staff_by_orgeh;

select login,firstname,middlename,lastname,email,phonenumber,"Position","version",isarchived,type_staff_role 
from vw_pers_staff;
select sap_id,cfo_id,"Name",address,openingdate,isarchived,makro_name,cluster_name,clusterdirectorfio,clusterdirectorphone,clusterdirectoremail 
from vw_orgeh_pers_staff;