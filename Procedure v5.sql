	DROP TABLE IF EXISTS ##inputs;
	DROP TABLE IF EXISTS ##tmpValores;
	DROP TABLE IF EXISTS ##tmpValorX;
	DROP TABLE IF EXISTS ##tmpValorXRelativo;
	DROP TABLE IF EXISTS ##tmpValorXAbsoluto;
	DROP TABLE IF EXISTS ##maxb;
	DROP TABLE IF EXISTS ##Sassenfeld;
	DROP TABLE IF EXISTS ##criterioLinhas;

	DROP TABLE IF EXISTS ##relatórioSassenfeld;
	DROP TABLE IF EXISTS ##relatórioLinhas;
	DROP TABLE IF EXISTS ##relatórioDeterminantes;
	DROP TABLE IF EXISTS ##relatórioSugestaoReordena;


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
	declare @bs1 as float(53); declare @bs2 as float(53); declare @bs3 as float(53); declare @maxs as float(53);
	declare @maxLinhas1 as float(53); declare @linhasSoma1 as float(53); declare @maxLinhas2 as float(53); declare @linhasSoma2 as float(53); declare @maxLinhas3 as float(53); declare @linhasSoma3 as float(53); 
	declare @criterioLinhasMax as float(53); declare @criterioLinhas1 as float(53); declare @criterioLinhas2 as float(53); declare @criterioLinhas3 as float(53);
	declare @determinante as float(53); declare @det1 as float(53);	declare @det2 as float(53);
	declare @determinanteX as float(53); declare @detx1 as float(53);	declare @detx2 as float(53);
	declare @determinanteY as float(53); declare @detY1 as float(53);	declare @detY2 as float(53);
	declare @determinanteZ as float(53); declare @detZ1 as float(53);	declare @detZ2 as float(53);
	declare @idTesteParada as float(53); declare @b1TesteParada as float(53); declare @b2TesteParada as float(53); declare @b3TesteParada as float(53);

	declare @autorizaReordena as int; --0 não, 1 sim
	declare @criterioParadaUsuario as float(53);

	set @autorizaReordena = 1;
	--set @criterioParadaUsuario = 0.9
	select @criterioParadaUsuario = valor from criterio_parada_user;

	/* Sassenfeld */

	SELECT @a11 = x1, @a12 = x2, @a13 = x3, @b1 = b FROM inputs i (nolock) where id = 1;
	SELECT @a21 = x1, @a22 = x2, @a23 = x3, @b2 = b FROM inputs i (nolock) where id = 2;
	SELECT @a31 = x1, @a32 = x2, @a33 = x3, @b3 = b FROM inputs i (nolock) where id = 3;

	select @bs1 = (@a12 + @a13) / @a11;
	select @bs2 = (1/@a22) * ((@a21 * @bs1) + @a23);
	select @bs3 = 1/@a33 * (@a31 * @bs1 + @a32 * @bs2);

	select max(b) maxb into ##maxb from (select case when @bs1 < 0 then @bs1*-1 else @bs1 end b union select case when @bs2 < 0 then @bs2*-1 else @bs2 end union select case when @bs3 < 0 then @bs3*-1 else @bs3 end) b order by 1 desc;
	select @maxs = maxb from ##maxb;

	/* Critério das linhas */ --@maxLinhas1; @linhasSoma1;

	--Os 2 menores / maior

	select @maxLinhas1 = max(a) from (select @a11 a union select @a12 a union select @a13 a) dt
	select @linhasSoma1 = sum(a) from (select @a11 a union select @a12 a union select @a13 a) dt where dt.a != @maxLinhas1
	select @criterioLinhas1 = @linhasSoma1 / @maxLinhas1;

	select @maxLinhas2 = max(a) from (select @a21 a union select @a22 a union select @a23 a) dt
	select @linhasSoma2 = sum(a) from (select @a21 a union select @a22 a union select @a23 a) dt where dt.a != @maxLinhas2
	select @criterioLinhas2 = @linhasSoma2 / @maxLinhas2;

	select @maxLinhas3 = max(a) from (select @a31 a union select @a32 a union select @a33 a) dt
	select @linhasSoma3 = sum(a) from (select @a31 a union select @a32 a union select @a33 a) dt where dt.a != @maxLinhas3
	select @criterioLinhas3 = @linhasSoma3 / @maxLinhas3;

	select @criterioLinhasMax = max(a) from (select @criterioLinhas1 a union select @criterioLinhas2 union select @criterioLinhas3) dt;
	
	/* Determinante */

	select @det1 = ( (@a11*@a22*@a33) + (@a12*@a23*@a31) + (@a13*@a21*@a32) );
	select @det2 = ( (@a13*@a22*@a31) + (@a32*@a23*@a11) + (@a33*@a21*@a12) );
	select @determinante = (@det1 - @det2)

	/* Determinante X */

	select @detX1 = ( (@b1*@a22*@a33) + (@a12*@a23*@b3) + (@a13*@b2*@a32) );
	select @detX2 = ( (@a13*@a22*@b3) + (@a32*@a23*@b1) + (@a33*@b2*@a12) );
	select @determinanteX = (@detX1 - @detX2)

	/* Determinante Y */

	select @detY1 = ( (@a11*@b2*@a33) + (@b1*@a23*@a31) + (@a13*@a21*@b3) );
	select @detY2 = ( (@a13*@b2*@a31) + (@b3*@a23*@a11) + (@a33*@a21*@b1) );
	select @determinanteY = (@detY1 - @detY2)

	/* Determinante Z */

	select @detZ1 = ( (@a11*@a22*@b3) + (@a12*@b2*@a31) + (@b1*@a21*@a32) );
	select @detZ2 = ( (@b1*@a22*@a31) + (@a32*@b2*@a11) + (@b3*@a21*@a12) );
	select @determinanteZ = (@detZ1 - @detZ2)
/*
SPD-> detA <> 0 (1 solução)
SPI-> detA = 0, detAX=detAY=detAZ=...detAn=0 (Infinitas soluções)
SI-> detA = 0, se pelo menos um detAX, detAY, detAZ ...detAn for <> 0 (Não tem solução)
*/

select @determinante det, @determinanteX detX, @determinanteY detY, @determinanteZ detZ,
case 
	when @determinante != 0 then 'SPD: 1 solução'
	when @determinante = 0 and @determinanteX = 0  and @determinanteY = 0  and @determinanteZ = 0 then 'SPI: Infinitas soluções'
	when @determinante = 0 and (@determinanteX + @determinanteY + @determinanteZ) != 0 then 'SI: não tem solução'
end discussaoDoSistema
into ##relatórioDeterminantes
from ##maxb

	--select @maxs

	/* Tem que decompor eem LU */


	/* Início: Reordena */
	if(@autorizaReordena) = 1
	begin
		SELECT *, ROW_NUMBER() OVER(Order by i.x1 desc, i.x2 desc, i.x3 desc) idNovo 
		into ##inputs
		FROM inputs i (nolock) 
		Order by x1 desc, x2 desc, x3 desc;

		update inputs set id = idNovo
		from inputs i (nolock) 
		join ##inputs n (nolock) on i.id = n.id;
	end
	/* Fim: Reordena */

SELECT * into ##tmpValores FROM inputs i (nolock) Order by x1 desc, x2 desc, x3 desc;
SELECT * into ##tmpValorX FROM inputs i (nolock);
SELECT * into ##tmpValorXRelativo FROM inputs i (nolock);
SELECT * into ##tmpValorXAbsoluto FROM inputs i (nolock);

truncate table ##tmpValores; truncate table ##tmpValorX; truncate table ##tmpValorXRelativo; truncate table ##tmpValorXAbsoluto;

--insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

SELECT @qtd = count(*) FROM inputs i (nolock);

set @x1Max = 1;  set @x1Relativo = 1;
set @x2Max = 1;  set @x2Relativo = 1;
set @x2Max = 1;  set @x2Relativo = 1;

--update ##relatórioDeterminantes set discussaoDoSistema = 'SI: não tem solução' 
--set @maxs = 12;

if(select discussaoDoSistema from ##relatórioDeterminantes) != 'SI: não tem solução' /* Sugere Reordenar */
if @maxs < 1 /* Critério de Sassenfeld */ or @criterioLinhasMax < 1 /* Critério das Linhas */

insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

set @b1TesteParada = 100000;
set @b2TesteParada = 100000;
set @b3TesteParada = 100000;

while (
@b1TesteParada < @b1 and 
@b2TesteParada < @b2 and 
@b3TesteParada < @b3 
or @i <= @criterioParadaUsuario 
or @i <= 1000
)
BEGIN
--select * from ##tmpValores
select @i = 1 + @i;

--select @i
--if ( @i = 10 )  break;

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

/* X Absoluto */

set @x1Max = @x1 - @x1KMenos1;
set @x2Max = @x2 - @x2KMenos1;
set @x3Max = @x3 - @x3KMenos1;

/* X Relativo */

set @x1Relativo = (@x1 - @x1KMenos1) / @x1;
set @x2Relativo = (@x2 - @x2KMenos1) / @x2;
set @x3Relativo = (@x3 - @x3KMenos1) / @x3;

--select @i = 1 + @i

insert into ##tmpValores (id, x1, x2, x3, b) values (@i, @x1, @x2, @x3, 0);
insert into ##tmpValorXAbsoluto (id, x1, x2, x3, b) values (@i, @x1Max, @x2Max, @x3Max, 0);
insert into ##tmpValorXRelativo (id, x1, x2, x3, b) values (@i, @x1Relativo, @x2Relativo, @x3Relativo, 0);

   IF EXISTS (
	select * from (
		select count(*) qtd from (
				select x1 from ##tmpValores where id = 1034 and round(x1,15) = (select round(x1,15) from ##tmpValores where id = (1034 - 1)) union
				select x2 from ##tmpValores where id = 1034 and round(x2,15) = (select round(x2,15) from ##tmpValores where id = (1034 - 1)) union
				select x3 from ##tmpValores where id = 1034 and round(x3,15) = (select round(x3,15) from ##tmpValores where id = (1034 - 1)) 
				) interno
				) valida 
	Where valida.qtd >=3
			)
   BEGIN
      BREAK;
   END

------------------------------------------------------------------------------------------------------------------


select top 1 
@idTesteParada = id,
@b1TesteParada = round(
(
(x1 * (select x1 from ##inputs i where id = 1)) +
(x2 * (select x2 from ##inputs i where id = 1)) +
(x3 * (select x3 from ##inputs i where id = 1))
),1),
@b2TesteParada = round(
(
(x1 * (select x1 from ##inputs i where id = 2)) +
(x2 * (select x2 from ##inputs i where id = 2)) +
(x3 * (select x3 from ##inputs i where id = 2))
),4),
@b3TesteParada = round(
(
(x1 * (select x1 from ##inputs i where id = 3)) +
(x2 * (select x2 from ##inputs i where id = 3)) +
(x3 * (select x3 from ##inputs i where id = 3))
),4)
from ##tmpValores v
Order by id desc


------------------------------------------------------------------------------------------------------------------
/*
if(1=1) 
BEGIN
BREAK;
END
*/
--select @i = 1 + @i
END


/* Devolve o ID a posição original */
	if(@autorizaReordena) = 1
	begin
		update inputs set id = n.idNovo
		from inputs i (nolock) 
		join ##inputs n (nolock) on i.id = n.id;
	end


---------------------------------------------------------------------

select top 1 *,
round(
(
(x1 * (select x1 from ##inputs i where id = 1)) +
(x2 * (select x2 from ##inputs i where id = 1)) +
(x3 * (select x3 from ##inputs i where id = 1))
),1) b1,
round(
(
(x1 * (select x1 from ##inputs i where id = 2)) +
(x2 * (select x2 from ##inputs i where id = 2)) +
(x3 * (select x3 from ##inputs i where id = 2))
),4) b2,
round(
(
(x1 * (select x1 from ##inputs i where id = 3)) +
(x2 * (select x2 from ##inputs i where id = 3)) +
(x3 * (select x3 from ##inputs i where id = 3))
),4) b3
from ##tmpValores v
order by id desc;


--select round(x1, 4) from ##tmpValores;
select /*top 100*/ * from ##tmpValores order by id asc;
select x1, x2, x3 from ##tmpValorXAbsoluto;
select x1, x2, x3 from ##tmpValorXRelativo;
select * from ##inputs

select distinct id, x1, x2, x3 from ##tmpValores order by id asc;
	select * from criterio_parada_user;
exec sp_calcula_sistema_linear 1;

	select * from (
		select count(*) qtd from (
				select x1 from ##tmpValores where id = 1034 and round(x1,15) = (select round(x1,15) from ##tmpValores where id = (1034 - 1)) union
				select x2 from ##tmpValores where id = 1034 and round(x2,15) = (select round(x2,15) from ##tmpValores where id = (1034 - 1)) union
				select x3 from ##tmpValores where id = 1034 and round(x3,15) = (select round(x3,15) from ##tmpValores where id = (1034 - 1)) 
				) interno
				) valida 
	Where valida.qtd >=3

select * from ##tmpValorXAbsoluto order by id asc;
select * from ##tmpValorXRelativo order by id asc;

select * from ##inputs Order by idNovo Asc;

select distinct 
	v.id, v.x1, v.x2, v.x3,
		  isnull(a.x1,0) aX1, isnull(a.x2,0) aX2, isnull(a.x3,0) aX3,
		  isnull(r.x1,0) rX1, isnull(r.x2,0) rX2, isnull(r.x3,0) rX3
from ##tmpValores v
left join ##tmpValorXAbsoluto a on a.id = v.id
left join ##tmpValorXRelativo r on a.id = r.id
order by v.id asc;

	select cast(maxb as float)*1 maxb, case when maxb < 1 then 'S' else 'N' end valS from ##maxb;
	select criterioLinhas, case when criterioLinhas < 1 then 'S' else 'N' end valS from ##criterioLinhas;
	select * from ##relatórioDeterminantes;

--select * into inputsBkp2 from inputs;
