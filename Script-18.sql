create or replace view vw_type_post as 
select 'Старший продавец-кассир' as post_name, '50616757' as post_code union all
select 'Продавец-кассир' as post_name, '50000682' as post_code union all
select 'Пекарь' as post_name, '50000665' as post_code union all
select 'Администратор' as post_name, '50000535' as post_code union all
select 'СПВ' as post_name, '50000741' as post_code union all
select 'НОО' as post_name, '51180462' as post_code union all
select 'Директор магазина' as post_name, '50000566' as post_code union all
select 'Заместитель директора магазина' as post_name, '50000583' as post_code union all
select 'Директор Кластера' as post_name, '50175446' as post_code union all
select 'Директор Кластера' as post_name, '52036679' as post_code union all
select 'РМП' as post_name, '52036730' as post_code union all
select 'Тренинг-менеджер на РЦ' as post_name, '50612455' as post_code union all
select 'РМП РЦ' as post_name, '51671102' as post_code;