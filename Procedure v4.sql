/*
Orienta��o
Atividade INDIVIDUAL: Apresentar um resumo sobre o m�todo de solu��o Gauss-Seidel para sistemas lineares, crit�rios de converg�ncia 
e crit�rios de parada. 
Tudo com foco em ERROS COMPUTACIONAIS. O que eles podem afetar quais os cuidados na programa��o de algor�tmos matem�ticos recursivos.
Op��o de apresentar um programa que solucione sistemas lineares (INDIVIDUAL OU EM DUPLA) pelo m�todo de Gauss-Seidel. 
Especifica��o em anexo. 
Ap�s ser� feita uma avalia��o de 2 pontos sobre o assunto.

Apresente algoritmo ou programa implement�vel em um sistema computacional que seja capaz de solucionar
sistemas lineares com pelo menos 3 vari�veis (sistemas com o n�mero de vari�veis customiz�vel s�o bem
aceitos), atrav�s dos m�todos interativos Gauss-Jacobi ou Gauss-Seidel.
* Considerando que o sistema pode receber qualquer sistema linear podendo este ter uma solu��o,
infinitas solu��es ou nenhuma solu��o, o mesmo deve informar a �nica solu��o ou que o sistema linear
tem infinitas solu��es ou nenhuma (recomend�vel o teste pelo determinante);
* Alguns sistemas lineares, apesar de terem solu��o, n�o podem ser solucionados pelos m�todos
interativos, estude e implemente os crit�rios de Linhas ou Sassenfeld para verificar se o sistema tem
solu��o;
* Se poss�vel implemente o pivotamento de Gauss para alterar o sistema linear para que os crit�rios de
Linha ou Sassenfeld sejam atendido, caso os mesmos n�o possam ser atendidos, o sistema deve
informar que tem solu��o mas n�o pode ser realizado pelos m�todos interativos
* Caso n�o seja poss�vel implementar o pivotamento de Gauss, o sistema deve recomendar ao usu�rio
a alimenta��o do sistema linear trocando as linhas;
* Por ser um sistema de apoio did�tico o mesmo deve apresentar o m�ximo de informa��o sobre as
vari�veis de decis�o utilizadas pelo sistema, como por exemplo o determinante da matriz, os crit�rio
de Linha ou Sassenfeld, o n�mero de intera��es, o valores de converg�ncia, etc;
* Por estar utilizando de um m�todo interativo, informe quais s�o os crit�rios de parada utilizados no
relat�rio explicativo;
* Se poss�vel coloque um bot�o passo a passo e um bot�o para solu��o direta;
* Apresente relat�rio explicativo dos problemas encontrados para a implementa��o, o custo
computacional das rotinas e do sistema em um todo;
* Como o sistema pode parar antes dos valores corretos serem determinados, deve ser apresentado alguns
testes e o c�lculo do erro computacional absoluto e relativo e com base nesses um parecer sobre a
capacidade e confiabilidade do seu sistema.

Bom trabalho
*/



	DROP TABLE IF EXISTS ##inputs;
	DROP TABLE IF EXISTS ##tmpValores;
	DROP TABLE IF EXISTS ##tmpValorX;
	DROP TABLE IF EXISTS ##tmpValorXRealativo;
	DROP TABLE IF EXISTS ##tmpValorXAbsoluto;
	DROP TABLE IF EXISTS ##maxb;
	DROP TABLE IF EXISTS ##Sassenfeld;
	DROP TABLE IF EXISTS ##criterioLinhas;

	DROP TABLE IF EXISTS ##relat�rioSassenfeld;
	DROP TABLE IF EXISTS ##relat�rioLinhas;
	DROP TABLE IF EXISTS ##relat�rioDeterminantes;
	DROP TABLE IF EXISTS ##relat�rioSugestaoReordena;


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

	declare @autorizaReordena as int; --0 n�o, 1 sim
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

	/* Crit�rio das linhas */ --@maxLinhas1; @linhasSoma1;

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
SPD-> detA <> 0 (1 solu��o)
SPI-> detA = 0, detAX=detAY=detAZ=...detAn=0 (Infinitas solu��es)
SI-> detA = 0, se pelo menos um detAX, detAY, detAZ ...detAn for <> 0 (N�o tem solu��o)
*/

select @determinante det, @determinanteX detX, @determinanteY detY, @determinanteZ detZ,
case 
	when @determinante != 0 then 'SPD: 1 solu��o'
	when @determinante = 0 and @determinanteX = 0  and @determinanteY = 0  and @determinanteZ = 0 then 'SPI: Infinitas solu��es'
	when @determinante = 0 and (@determinanteX + @determinanteY + @determinanteZ) != 0 then 'SI: n�o tem solu��o'
end discussaoDoSistema
into ##relat�rioDeterminantes
from ##maxb

	--select @maxs

	/* Tem que decompor eem LU */


	/* In�cio: Reordena */
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
SELECT * into ##tmpValorXRealativo FROM inputs i (nolock);
SELECT * into ##tmpValorXAbsoluto FROM inputs i (nolock);

truncate table ##tmpValores; truncate table ##tmpValorX; truncate table ##tmpValorXRealativo; truncate table ##tmpValorXAbsoluto;

--insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

SELECT @qtd = count(*) FROM inputs i (nolock);

set @x1Max = 1;  set @x1Relativo = 1;
set @x2Max = 1;  set @x2Relativo = 1;
set @x2Max = 1;  set @x2Relativo = 1;

if(select discussaoDoSistema from ##relat�rioDeterminantes) != 'SI: n�o tem solu��o' /* Sugere Reordenar */

begin

if @maxs < 1 /* Crit�rio de Sassenfeld */ or @criterioLinhasMax < 1 /* Crit�rio das Linhas */
begin
/* K = 0 */

insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

set @b1TesteParada = 1;
set @b2TesteParada = 1;
set @b3TesteParada = 1;


/* K = 1 */

--while ((select top 1 x1 from ##tmpValores order by id desc) <= 1 or (select top 1 x2 from ##tmpValores order by id desc) <= 1 /* and (select top 1 x3 from ##tmpValores order by id desc) <= 1*/)
while (
@b1TesteParada != 1 and --@b1 and
@b2TesteParada != 1 and --@b2 and
@b3TesteParada != 1 --@b3 --and
)
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
insert into ##tmpValorXRealativo (id, x1, x2, x3, b) values (@i, @x1Relativo, @x2Relativo, @x3Relativo, 0);

--select x1 from ##tmpValores where id < 2000 and x1 = (select x1 from ##tmpValores where id = (@id - 1))

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

/*
if (
	(select x1 from ##tmpValores where id = @i) = (select x1 from ##tmpValores where id = @i) and
	(select x2 from ##tmpValores where id = @i) = (select x2 from ##tmpValores where id = @i) and
	(select x3 from ##tmpValores where id = @i) = (select x3 from ##tmpValores where id = @i) 
) break;
*/
------------------------------------------------------------------------------------------------------------------

/*
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
*/

------------------------------------------------------------------------------------------------------------------
/*
if(1=1) 
BEGIN
BREAK;
END
*/
--select @i = 1 + @i
END
end
end

/* Devolve o ID a posi��o original */
	if(@autorizaReordena) = 1
	begin
		update inputs set id = n.idNovo
		from inputs i (nolock) 
		join ##inputs n (nolock) on i.id = n.id;
	end
/*
select 
round(x1 * (select x1 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x2 * (select x2 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x3 * (select x3 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1)
from inputs i (nolock)
where id = 1;
select 
round(x1 * (select x1 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x2 * (select x2 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x3 * (select x3 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1)
from inputs i (nolock)
where id = 2;
select 
round(x1 * (select x1 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x2 * (select x2 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x3 * (select x3 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1)
from inputs i (nolock)
where id = 3;
*/

select @maxs maxs into ##Sassenfeld  /* Crit�rio de Sassenfeld */ 

select @criterioLinhasMax criterioLinhas into ##criterioLinhas /* Crit�rio das Linhas */

--select distinct Round(x1,4) x1, Round(x2,4) x2, Round(x3,4) x3 from ##tmpValores Order by 1 asc;
--update ##tmpValores set x1 = Round(x1,4), x2 = Round(x2,4), x3 = Round(x3,4);


select --top 1 *,
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
where 
(select b from ##inputs where id = 1) between (round(
(
(x1 * (select x1 from ##inputs i where id = 1)) +
(x2 * (select x2 from ##inputs i where id = 1)) +
(x3 * (select x3 from ##inputs i where id = 1))
),1)) and (select b from ##inputs where id = 1) and
--
(select b from ##inputs where id = 2) between (round(
(
(x1 * (select x1 from ##inputs i where id = 2)) +
(x2 * (select x2 from ##inputs i where id = 2)) +
(x3 * (select x3 from ##inputs i where id = 2))
),1)) and (select b from ##inputs where id = 2) and
--
(select b from ##inputs where id = 3) between (round(
(
(x1 * (select x1 from ##inputs i where id = 3)) +
(x2 * (select x2 from ##inputs i where id = 3)) +
(x3 * (select x3 from ##inputs i where id = 3))
),1)) and (select b from ##inputs where id = 3)
--id = 1 order by id desc;


select * from criterio_parada_user;
--select round(x1, 4) from ##tmpValores;
select /*top 100*/ * from ##tmpValores order by id asc;
select x1, x2, x3 from ##tmpValorXAbsoluto;
select x1, x2, x3 from ##tmpValorXRealativo;
select * from ##inputs

select distinct id, x1, x2, x3 from ##tmpValores order by id asc;
	select * from criterio_parada_user;
exec sp_calcula_sistema_linear 1;
