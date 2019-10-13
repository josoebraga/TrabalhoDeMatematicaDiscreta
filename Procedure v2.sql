DROP TABLE IF EXISTS ##tmpValores;
DROP TABLE IF EXISTS ##tmpValorX;
DROP TABLE IF EXISTS ##tmpValorXRealativo;
DROP TABLE IF EXISTS ##tmpValorXAbsoluto;

declare @i as int; set @i = 0;
declare @qtd as int;
declare @a11 as float(53);
declare @a12 as float(53);
declare @a13 as float(53);
declare @b1 as float(53);
declare @a21 as float(53);
declare @a22 as float(53);
declare @a23 as float(53);
declare @b2 as float(53);
declare @a31 as float(53);
declare @a32 as float(53);
declare @a33 as float(53);
declare @b3 as float(53);
declare @x1 as float(53); declare @x1KMenos1 as float(53);
declare @x2 as float(53); declare @x2KMenos1 as float(53);
declare @x3 as float(53); declare @x3KMenos1 as float(53);
declare @x1Relativo as float(53);
declare @x2Relativo as float(53);
declare @x3Relativo as float(53);
declare @x1Max as float(53);	
declare @x2Max as float(53);
declare @x3Max as float(53);

SELECT * into ##tmpValores FROM inputs i (nolock);
SELECT * into ##tmpValorX FROM inputs i (nolock);
SELECT * into ##tmpValorXRealativo FROM inputs i (nolock);
SELECT * into ##tmpValorXAbsoluto FROM inputs i (nolock);

truncate table ##tmpValores; truncate table ##tmpValorX; truncate table ##tmpValorXRealativo; truncate table ##tmpValorXAbsoluto;

--insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

SELECT @qtd = count(*) FROM inputs i (nolock);

/* K = 0 */

insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

/* K = 1 */



while ((select top 1 x1 from ##tmpValores order by id desc) <= 1 )
BEGIN
select @i = 1 + @i;

SELECT @x1KMenos1 = x1, @x2KMenos1 = x2, @x3KMenos1 = x3, @b1 = b FROM ##tmpValores (nolock) where id = @i - 1; --
--SELECT @x1KMenos1, @x2KMenos1, @x3KMenos1
SELECT @a11 = x1, @a12 = x2, @a13 = x3, @b1 = b FROM inputs i (nolock) where id = 1;--@i; --1
SELECT @a21 = x1, @a22 = x2, @a23 = x3, @b2 = b FROM inputs i (nolock) where id = 2;--@i+1; --2
SELECT @a31 = x1, @a32 = x2, @a33 = x3, @b3 = b FROM inputs i (nolock) where id = 3;--@i+1+1; --3
--SELECT @i;
/* x1 */

select @x1 = ( @b1 - @a12 * @x2KMenos1 - @a13 * @x3KMenos1 ) / @a11

/* x2 */

select @x2 = ( @b2 - @a21 * @x1 - @a23 * @x3KMenos1 ) / @a22

/* x3 */

select @x3 = ( @b3 - @a31 * @x1 - @a32 * @x2 ) / @a33

/* X Máx */

set @x1Max = @x1 - @x1KMenos1;
set @x2Max = @x2 - @x2KMenos1;
set @x3Max = @x3 - @x3KMenos1;

--select @i = 1 + @i

insert into ##tmpValores (id, x1, x2, x3, b) values (@i, @x1, @x2, @x3, 0);

insert into ##tmpValorXAbsoluto (id, x1, x2, x3, b) values (@i, @x1Max, @x2Max, @x3Max, 0);
--select @i = 1 + @i
END

select x1, x2, x3 from ##tmpValores;
--select x1, x2, x3 from ##tmpValorXAbsoluto;
