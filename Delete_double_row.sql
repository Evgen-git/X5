delete from orgeh 
where pk in (select pk 
               from (select pk,max(pk) over (partition by id, begda, endda, parentid, typeoe, stext, ltext, email, addr, cfo, mvz, is_archive, redun) as max_pk 
                       from orgeh) f
              where pk <> max_pk);
--commit;

delete from pernr
where pk in (select pk 
               from (select pk,max(pk) over (partition by id, "plans", fio, usrid, email, cell, gbdat, is_archive, hpern) as max_pk 
                       from pernr) f
              where pk <> max_pk);
--commit;

delete from "plans"
where pk in (select pk 
               from (select pk,max(pk) over (partition by id, begda, endda, parentid, stext, ltext, stell, is_archive, redun) as max_pk 
                       from "plans") f
              where pk <> max_pk);
--commit;

delete from status
where pk in (select pk 
               from (select pk,max(pk) over (partition by id, "type", "serial", crdate, crtime, dest_id, datetime) as max_pk 
                       from  status) f
              where pk <> max_pk);








