use cadcafeterias;
/*
P4. Sabemos que alguno de nuestros empleados son también socios-clientes. 
Prepara una vista con la que podamos trabajar con ambos sin que se repitan. 
Se debe mostrar el nombre, los apellidos, la dirección postal y un código diferente para cada uno.
*/
create view socios_y_clientes
	(codigo, nombre, ape1, ape2, dirpostal)
as
select codsocio, nomsocio, ape1socio, ape2socio, dirpostal
from socios
union
select codemp + (select max(codsocio) from socios),
	nomemp, ape1emp, ape2em, diremp
from personal 
where concat(nomemp, ape1emp, ape2em, diremp) not in
	(select concat(nomsocio, ape1socio, ape2socio, dirpostal)
    from socios);

-- habría valido algo asi (incluso sin sumar al codigo de empleado nada):

create view socios_y_clientes
	(codigo, nombre, ape1, ape2, dirpostal)
as
select codsocio, nomsocio, ape1socio, ape2socio, dirpostal
from socios
union
select codemp + (select max(codsocio) from socios),
	nomemp, ape1emp, ape2em, diremp
from personal;



/*
P5. Queremos saber cuales son los mejores meses en nuestras cafeterías, por eso, 
nos han pedido que preparemos un procecimiento que, dado un año, devuelva el número de comandas atendidas 
y el importe que han supuesto, en cada cafetería y cada mes en dicho año. Descartar las filas con menos de 5 comandas.
*/
drop procedure if exists ejer5;
delimiter $$
create procedure ejer5(in anyo int)
begin
	select codcafeteria, month(fechacomanda), count(*), sum(importe)
	from comandas
    where year(fechacomanda) = anyo
    group by codcafeteria, month(fechacomanda)
    having  count(*) >=5;
end $$
delimiter ;

/*
P6. Prepara un procedimiento que muestre un listado de los empleados (su nombre y apellidos) cuya media 
en el importe de las comandas atendidas por estos empleados supere a la media de los importes de las comandas 
de las cafeterías en las que trabajan.
*/

drop procedure if exists ejer6;
delimiter $$
create procedure ejer6()
begin
	select nomemp, ape1emp, ape2emp
    from personal join comandas on personal.codemp = comandas.codemp
    group by nomemp, ape1emp, ape2emp
    having avg(importe) >= (select avg(importe)
							from comandas
                            where comandas.codcafet = personal.codcafet);

end $$
delimiter ;

