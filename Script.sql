select * from pg_catalog.pg_tables
 where schemaname ='public';

select nsp.nspname as namespaces,tbl.relname as table_name, cnt.conname as key_name 
  from pg_catalog.pg_constraint cnt
  left join pg_catalog.pg_class tbl on (cnt.conrelid = tbl.oid)
  left join pg_catalog.pg_namespace nsp on (cnt.connamespace = nsp.oid)
 where cnt.contype ='p'
   and nsp.nspname = 'public'
 order by namespaces,table_name,key_name;



