/*
drop table inputs;

create table inputs (id int, x1 float(53), x2 float(53), x3 float(53), b float(53))
create table inputs (id int, x1 real, x2 real, x3 real, b real)


select 
1 id, 
cast(0.12345679101112131457966 as double) as x1, 
cast(0.12345679101112131457966 as double) as x2, 
cast(0.12345679101112131457966 as double) as x3, 
cast(0.12345679101112131457966 as double) as b
into inputs
*/


truncate table inputs;

insert into inputs (id, x1, x2, x3, b) values (1, 6, -2, 1, 5)
insert into inputs (id, x1, x2, x3, b) values (2, 2, 8, -1, 9)
insert into inputs (id, x1, x2, x3, b) values (3, 1, -3, 7, 5)

select * from inputs order by x1 desc, x2 desc, x3 desc;

--select * into #tmp from inputs;
--select * from #tmp;
