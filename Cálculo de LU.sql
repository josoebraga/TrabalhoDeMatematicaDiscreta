--Lower Triangular Component L

DROP TABLE IF EXISTS ##l;
DROP TABLE IF EXISTS ##u;
DROP TABLE IF EXISTS ##tmpValoressss;

select * into ##l from inputs;

update ##l set x2 = 0, x3 = 0 where id = 1;
update ##l set x3 = 0 where id = 2;

--Upper Triangular Component U

select * into ##u from inputs;

update ##u set x1 = 0 where id = 1;
update ##u set x1 = 0, x2 = 0 where id = 2;
update ##u set x1 = 0, x2 = 0, x3 = 0 where id = 3;

--------------------------------------------------------

--Inverse of L-1*

select x1, x2, x3 from ##l; select x1, x2, x3 from ##u;

select x1, x2, x3 from ##l

select top 1 * into ##tmpValoressss from ##tmpValores Order by id desc;

select 
		(x1 * ( select cast(substring(cast(x1 as varchar(15)), 1, 7) as float) from ##tmpValoressss )) + 
		(x2 * ( select cast(substring(cast(x2 as varchar(15)), 1, 7) as float) from ##tmpValoressss )) + 
		(x3 * ( select cast(substring(cast(x3 as varchar(15)), 1, 7) as float) from ##tmpValoressss )) 
from inputs

--select * from ##tmpValoressss

--select top 1 id, cast(substring(cast(x1 as varchar(15)), 1, 10) as float)/1000, round(x1,15), round(x2,15), round(x3,15) from ##tmpValores Order by id desc;
--select top 1 * from ##tmpValores Order by id desc;

select top 1 *, substring(cast(Floor(x1) as varchar(15)), 1, 7), Floor(x1) from ##tmpValores Order by id desc;

select top 1 id, x1, cast(cast(substring(cast(x1 as varchar), 1, 7) as float) as float) from ##tmpValores Order by id desc;

update ##tmpValores set x1 = cast(cast(substring(cast(x1 as varchar), 1, 7) as float) as float)


