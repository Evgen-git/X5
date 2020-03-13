with pth as ( 
select 1 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51047541'
union all
select 2 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51311685'
union all
select 3 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51312011'
union all
select 4 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51062889'
union all
select 5 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where parentid = '51062889'
)
select * from pth
order by rn;



-- {51047541,51311685,51312011,51062889}
-- {51047541,51054438,51055453,51865527,51413992}