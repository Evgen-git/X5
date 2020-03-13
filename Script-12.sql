with pth as ( 
select 1 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51047541'
union all
select 2 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51054438'
union all
select 3 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51055453'
union all
select 4 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51865527'
union all
select 5 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where id = '51413992'
union all
select 6 as rn, h.id, h.parentid,h.typeoe,h.stext,h.begda,h.endda,h.cfo,h.is_archive 
  from orgeh h
where parentid = '51413992'
)
select * from pth
order by rn;


