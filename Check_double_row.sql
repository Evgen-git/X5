select tbl,cnt_grp,cnt_row 
  from (  select 'orgeh' as tbl, cnt_grp, count(1) as cnt_row 
            from (select count(1) over (partition by id, begda, endda, parentid, typeoe, stext, ltext, email, addr, cfo, mvz, is_archive, redun) as cnt_grp,
                         max(pk) over (partition by id, begda, endda, parentid, typeoe, stext, ltext, email, addr, cfo, mvz, is_archive, redun) as max_pk, 
                         pk,id, begda, endda, parentid, typeoe, stext, ltext, email, addr, cfo, mvz, is_archive, redun
                    from  orgeh) f
           group by cnt_grp
           union all
           select 'pernr' as tbl, cnt_grp, count(1) as cn 
             from (select count(1) over (partition by id, "plans", fio, usrid, email, cell, gbdat, is_archive, hpern) as cnt_grp,
                         max(pk) over (partition by id, "plans", fio, usrid, email, cell, gbdat, is_archive, hpern) as max_pk, 
                         pk,id, "plans", fio, usrid, email, cell, gbdat, is_archive, hpern
                    from  pernr) f
            group by cnt_grp
           union all
           select 'plans' as tbl, cnt_grp, count(1) as cn 
             from (select count(1) over (partition by id, begda, endda, parentid, stext, ltext, stell, is_archive, redun) as cnt_grp,
                         max(pk) over (partition by id, begda, endda, parentid, stext, ltext, stell, is_archive, redun) as max_pk, 
                         pk,id, begda, endda, parentid, stext, ltext, stell, is_archive, redun
                    from  "plans") f
            group by cnt_grp
           union all
           select 'spv' as tbl, cnt_grp, count(1) as cn 
             from (select count(1) over (partition by id, cfo, begda, endda, "type", is_archive) as cnt_grp,
                         max(pk) over (partition by id, cfo, begda, endda, "type", is_archive) as max_pk, 
                         pk,id, cfo, begda, endda, "type", is_archive
                    from  spv) f
            group by cnt_grp
           union all
           select 'status' as tbl, cnt_grp, count(1) as cn 
             from (select count(1) over (partition by id, "type", "serial", crdate, crtime, dest_id, datetime) as cnt_grp,
                         max(pk) over (partition by id, "type", "serial", crdate, crtime, dest_id, datetime) as max_pk, 
                         pk,id, "type", "serial", crdate, crtime, dest_id, datetime
                    from  status) f
            group by cnt_grp
            
            ) t
order by tbl,cnt_grp









