/* EJER 1 */

select codtest, nommateria
from tests join materias on tests.codmateria = materias.codmateria
where date_add(feccreacion, interval 3 month) < ifnull(fecpublicacion, curdate());

/* EJER 2 */
drop function if exists obtenCuenta;
delimiter $$
create function obtenCuenta
	(numeroExpediente int)
returns varchar(100)
deterministic
begin
	declare cuenta varchar(100);
	select concat(left(nomalum,1),
	              right(nomalum,1),
	              substring(ape1em,(length(ape1em) div 2),3),
	              month(fecnacim))
	    into cuenta
    from alumnos 
    where numexped = numeroExpediente;
    return concat(cuenta,'@micentro.es');
end $$
delimiter ;
select obtenNota(1,1);


/* EJER 3*/
drop procedure if exists exam_u7new_3_2022_2023;
delimiter $$
create procedure exam_u7new_3_2022_2023
	(in codigoExpediente int)
begin
	Select  respuestas.codtest, numrepeticion, count(*)
	from respuestas join preguntas on respuestas.codtest = preguntas.codtest 
		and respuestas.numpreg = preguntas.numpreg
	where respuestas.numexped = codigoExpediente 
		and respuestas.respuesta = preguntas.resvalida
	group by respuestas.codtest, respuestas.numrepeticion
	having count(*) >= 4;
end $$
delimiter ;

call exam_u7new_3_2022_2023(1);

/* EJER 4 */
select materias.nommateria, materias.cursomateria, respuestas.codtest, respuestas.numexped -- , count(distinct respuestas.codtest)
from materias join tests on materias.codmateria = tests.codmateria
	join respuestas on tests. codtest = respuestas.codtest
group by materias.nommateria
having count(distinct respuestas.numexped) > 2;

/* EJER 5 */

/*
tests que ha hecho cada alumno y materia de dicho test:
*/
select numexped, codtest, codmateria
from respuestas join tests on respuestas.codtest = tests.codtest
    join materias on tests.codmateria = materias.codmateria
/* por tanto: */    
select alumnos.numexped, concat_ws(nomalum,ape1alum, ape2alum)
from alumnos join respuestas on alumnos.numexped = respuestas.numexped
    join tests on respuestas.codtest = tests.codtest
    join materias on tests.codmateria = materias.codmateria
where materias.codmateria not in
    (select codmateria
     from matriculas
     where matriculas.numexped = alumnos.numexped);

/* EJER 6*/
drop view if exists catalogoTests;
create view catalogoTests
	(codMateria, NombreMateria, codTest, descripTest, respuestaValida, repetible, numPreguntas)
AS
	select materias.codmateria, materias.nommateria,
		tests.codtest, tests.descrip, 
        if(resvalida='a',resa, if(resvalida ='b',resb,resc)),
        if(repetible > 0,'repetible','no repetible'), count(*)
    from materias join tests on materias.codmateria = tests.codmateria
		join preguntas on tests.codtest = preguntas.codtest
	
	group by materias.codmateria, tests.codtest;

select * from catalogoTests;



/* EJER 7 */
/*
Prepara una función que, dado un alumno/a y una materia, nos devuelva la nota de dicho alumno/a en dicha materia. 
La nota se calculará obteniendo la media entre el número de respuestas correctas y el num. de preguntas de cada test 
de la materia. Solo se utilizarán los tests no repetibles (estos tendrán en el campo repetible de la tabla 
tests el valor 1, indicando así que solo se puede hacer una vez). 
Los alumnos que no hayan hecho alguno de los tests no repetibles de la materia, 
obtendrán una puntuación de cero en dicho test y esta nota entrará en la media..
*/

drop function if exists obtenNota;
delimiter $$
create function obtenNota
	(numeroExpediente int, codMateria int)
returns decimal(4,2)
deterministic
begin
	declare nota decimal(4,2);
	select count(*)/count(distinct respuestas.codtest) into nota
    from respuestas join preguntas on respuestas.codtest = preguntas.codtest and respuestas.numpreg = preguntas.numpreg
		join tests on tests.codtest = preguntas.codtest
    where numexped = numeroExpediente and tests.codmateria = codMateria
		and tests.repetible = 0 and respuestas.respuesta = preguntas.resvalida;
 
    return nota;
end $$
delimiter ;
select obtenNota(1,1);