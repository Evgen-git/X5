select * FROM pg_class tbl 
where relname in ('actor','city')

conrelidrelname, = pg_class.oid