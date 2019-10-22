/*
Orientação
Atividade INDIVIDUAL: Apresentar um resumo sobre o método de solução Gauss-Seidel para sistemas lineares, critérios de convergência 
e critérios de parada. 
Tudo com foco em ERROS COMPUTACIONAIS. O que eles podem afetar quais os cuidados na programação de algorítmos matemáticos recursivos.
Opção de apresentar um programa que solucione sistemas lineares (INDIVIDUAL OU EM DUPLA) pelo método de Gauss-Seidel. 
Especificação em anexo. 
Após será feita uma avaliação de 2 pontos sobre o assunto.

Apresente algoritmo ou programa implementável em um sistema computacional que seja capaz de solucionar
sistemas lineares com pelo menos 3 variáveis (sistemas com o número de variáveis customizável são bem
aceitos), através dos métodos interativos Gauss-Jacobi ou Gauss-Seidel.
* Considerando que o sistema pode receber qualquer sistema linear podendo este ter uma solução,
infinitas soluções ou nenhuma solução, o mesmo deve informar a única solução ou que o sistema linear
tem infinitas soluções ou nenhuma (recomendável o teste pelo determinante);
* Alguns sistemas lineares, apesar de terem solução, não podem ser solucionados pelos métodos
interativos, estude e implemente os critérios de Linhas ou Sassenfeld para verificar se o sistema tem
solução;
* Se possível implemente o pivotamento de Gauss para alterar o sistema linear para que os critérios de
Linha ou Sassenfeld sejam atendido, caso os mesmos não possam ser atendidos, o sistema deve
informar que tem solução mas não pode ser realizado pelos métodos interativos
* Caso não seja possível implementar o pivotamento de Gauss, o sistema deve recomendar ao usuário
a alimentação do sistema linear trocando as linhas;
* Por ser um sistema de apoio didático o mesmo deve apresentar o máximo de informação sobre as
variáveis de decisão utilizadas pelo sistema, como por exemplo o determinante da matriz, os critério
de Linha ou Sassenfeld, o número de interações, o valores de convergência, etc;
* Por estar utilizando de um método interativo, informe quais são os critérios de parada utilizados no
relatório explicativo;
* Se possível coloque um botão passo a passo e um botão para solução direta;
* Apresente relatório explicativo dos problemas encontrados para a implementação, o custo
computacional das rotinas e do sistema em um todo;
* Como o sistema pode parar antes dos valores corretos serem determinados, deve ser apresentado alguns
testes e o cálculo do erro computacional absoluto e relativo e com base nesses um parecer sobre a
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
	declare @maxLinhas1 as float(53); declare @linhasSoma1 as float(53); declare @maxLinhas2 as float(53); declare @linhasSoma2 as float(53); declare @maxLinhas3 as float(53); declare @linhasSoma3 as float(53); 
	declare @criterioLinhasMax as float(53); declare @criterioLinhas1 as float(53); declare @criterioLinhas2 as float(53); declare @criterioLinhas3 as float(53);
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

	--select @maxs

	/* Tem que decompor eem LU */


	/* Início: Reordena */

	SELECT *, ROW_NUMBER() OVER(Order by i.x1 desc, i.x2 desc, i.x3 desc) idNovo 
	into ##inputs
	FROM inputs i (nolock) 
	Order by x1 desc, x2 desc, x3 desc;

update inputs set id = idNovo
from inputs i (nolock) 
join ##inputs n (nolock) on i.id = n.id;

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

if @maxs < 1 /* Critério de Sassenfeld */ or @criterioLinhasMax < 1 /* Critério das Linhas */
begin
/* K = 0 */

insert into ##tmpValores (id, x1, x2, x3, b) values (0, 0, 0, 0, 0);

/* K = 1 */

--while ((select top 1 x1 from ##tmpValores order by id desc) <= 1 or (select top 1 x2 from ##tmpValores order by id desc) <= 1 /* and (select top 1 x3 from ##tmpValores order by id desc) <= 1*/)
while (

(select 
round(x1 * (select x1 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x2 * (select x2 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x3 * (select x3 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1)
from inputs i (nolock)
where id = 1) = @b1 and
(select 
round(x1 * (select x1 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x2 * (select x2 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x3 * (select x3 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1)
from inputs i (nolock)
where id = 2) = @b2 and
(select 
round(x1 * (select x1 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x2 * (select x2 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1) + 
round(x3 * (select x3 from ##tmpValores t (nolock) where id = (select max(id) from ##tmpValores t (nolock))),1)
from inputs i (nolock)
where id = 3) = @b3 and

(select top 1 x1 from ##tmpValores order by id desc) <= 1 or @x1Max >= @x1Relativo or @x2Max >= @x2Relativo or @x3Max >= @x3Relativo)
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

--select @i = 1 + @i
END
end

/* Devolve o ID a posição original */

update inputs set id = n.idNovo
from inputs i (nolock) 
join ##inputs n (nolock) on i.id = n.id;


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

select x1, x2, x3 from ##tmpValores;
select x1, x2, x3 from ##tmpValorXAbsoluto;
select x1, x2, x3 from ##tmpValorXRealativo;

