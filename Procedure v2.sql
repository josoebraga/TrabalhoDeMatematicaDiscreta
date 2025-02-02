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
	declare @determinante as float(53); declare @det1 as float(53);	declare @det2 as float(53);

	/* Sassenfeld */

	SELECT @a11 = x1, @a12 = x2, @a13 = x3, @b1 = b FROM inputs i (nolock) where id = 1;
	SELECT @a21 = x1, @a22 = x2, @a23 = x3, @b2 = b FROM inputs i (nolock) where id = 2;
	SELECT @a31 = x1, @a32 = x2, @a33 = x3, @b3 = b FROM inputs i (nolock) where id = 3;

	select @bs1 = (@a12 + @a13) / @a11;
	select @bs2 = (1/@a22) * ((@a21 * @bs1) + @a23);
	select @bs3 = 1/@a33 * (@a31 * @bs1 + @a32 * @bs2);

	select max(b) maxb into ##maxb from (select case when @bs1 < 0 then @bs1*-1 else @bs1 end b union select case when @bs2 < 0 then @bs2*-1 else @bs2 end union select case when @bs3 < 0 then @bs3*-1 else @bs3 end) b order by 1 desc;
	select @maxs = maxb from ##maxb;

	/* Determinante */

	select @det1 = ( (@a11*@a22*@a33) + (@a12*@a23*@a31) + (@a13*@a21*@a32) );
	select @det2 = ( (@a13*@a22*@a31) + (@a32*@a23*@a11) + (@a33*@a21*@a12) );
	select @determinante = (@det1 - @det2)

	--select @maxs

	/* Tem que decompor eem LU */


	/* Reordena */

	SELECT *, ROW_NUMBER() OVER(Order by i.x1 desc, i.x2 desc, i.x3 desc) idNovo 
	into ##inputs
	FROM inputs i (nolock) 
	Order by x1 desc, x2 desc, x3 desc;

update inputs set id = idNovo
from inputs i (nolock) 
join ##inputs n (nolock) on i.id = n.id;

SELECT * into ##tmpValores FROM inputs i (nolock) Order by x1 desc, x2 desc, x3 desc;
SELECT * into ##tmpValorX FROM inputs i (nolock);
SELECT * into ##tmpValorXRealativo FROM inputs i (nolock);
SELECT * into ##tmpValorXAbsoluto FROM inputs i (nolock);

truncate table ##tmpValores; truncate table ##tmpValorX; truncate table ##tmpValorXRealativo; truncate table ##tmpValorXAbsoluto;

--insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

SELECT @qtd = count(*) FROM inputs i (nolock);

if @maxs < 1 /* Crit�rio de Sassenfeld */
begin
/* K = 0 */

insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

/* K = 1 */

while ((select top 1 x2 from ##tmpValores order by id desc) <= 1 /* and (select top 1 x2 from ##tmpValores order by id desc) <= 1 and (select top 1 x3 from ##tmpValores order by id desc) <= 1 */)
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

/* X M�x */

set @x1Max = @x1 - @x1KMenos1;
set @x2Max = @x2 - @x2KMenos1;
set @x3Max = @x3 - @x3KMenos1;

--select @i = 1 + @i

insert into ##tmpValores (id, x1, x2, x3, b) values (@i, @x1, @x2, @x3, 0);

insert into ##tmpValorXAbsoluto (id, x1, x2, x3, b) values (@i, @x1Max, @x2Max, @x3Max, 0);
--select @i = 1 + @i
END
end

/* Devolve o ID a posi��o original */

update inputs set id = n.idNovo
from inputs i (nolock) 
join ##inputs n (nolock) on i.id = n.id;



select x1, x2, x3 from ##tmpValores;
select x1, x2, x3 from ##tmpValorXAbsoluto;

