-- Nacho Salcedo Guarde

/*1*/

delimiter $$
drop procedure if exists eje1$$
create procedure eje1()
begin
select tests.codtest, materias.nommateria
from tests left join materias on tests.codtest= materias.codmateria
where datediff(tests.feccreacion,tests.fecpublic>3);
end $$
delimiter ;

call eje1();

/*2*/

delimiter $$
drop function if exists eje2$$
create  function eje2
(
numeroAlum char(12)
)
returns varchar(20)
deterministic
begin
declare usuario varchar(20);
set usuario = (
				select concat(left(alumnos.nomalum,1),'',right(alumnos.nomalum,1),'',
                right(alumnos.ape1alum,1),'',
                  (substring(alumnos.ape1alum,length(alumnos.ape1alum)/2-1,3),'',
                  dayofMonth(alumnos.fecnacim),
                  '@micentro.es')
				)
			 from alumnos 
			where alumnos.numexped = numeroAlum
			);
 return usuario;
 end$$
delimiter ;

select eje2('1');


/*3*/
delimiter $$
drop procedure if exists eje3$$
create procedure eje3
(
numero char(12)
)
begin 
select alumnos.nomalum, count(preguntas.numpreg), respuestas.codtest, respuestas.numrepeticion
from alumnos join respuestas on alumnos.numexped=respuestas.numexped
				join preguntas on respuestas.codtest = preguntas.codtest
		where respuestas.numexped = numero and respuestas.respuesta = preguntas.resvalida
			and (
            
            select count(respuestas.numpreg)
            from respuestas join preguntas on respuestas.codtest = preguntas.codtest
            where respuestas.numexped = numero)>4
            
		    group by respuestas.codtest, respuestas.numrepeticion
            order by respuestas.codtest asc, respuestas.numrepeticion desc;


end$$
delimiter ;

call eje3(1);


/*4*/

delimiter $$
drop procedure if exists eje4$$
create procedure eje4()
begin 
select materias.nommateria, materias.cursomateria, count(tests.codtest)as numeroTest
	from materias join tests on materias.codmateria= tests.codmateria
				join matriculas on materias.codmateria= matriculas.codmateria
                join alumnos on matriculas.numexped = alumnos.numexped
                join respuestas on tests.codtest = respuestas.codtest
		where tests.codtest = respuestas.codtest and (select alumnos.numexped
								from alumnos join respuestas on alumnos.numexped= respuestas.numexped
                                where alumnos.numexped>4)

		group by materias.codmateria;
end$$
delimiter ;

call eje4();

/*
5
*/

delimiter $$
drop procedure if exists eje5$$
create procedure eje5()
begin 
select alumnos.numexped as numeroExpediente, concat(nomalum,' ',ape1alum,' ', ifnull(ape2alum, ''))as nombreCompleto
from alumnos join respuestas on alumnos.numexped= respuestas.numexped
where alumnos.numexped not in ( select alumnos.numexped
								from alumnos join matriculas on alumnos.numexped= matriculas.numexped 
                                );

end$$
delimiter ;

call eje5();


/*
6
*/

drop view catalogo;
create view catalogo
(codigoMateria , nombreMateria, codigoTest, descripTest, respuestaValida, numeroPreguntas)
as
select materias.codmateria, materias.nommateria, tests.codtest, tests.descrip, if(respuestas.numrepeticion>4, 'repetible', 'no repetible'), preguntas.numpreg
from materias right join tests on materias.codmateria = tests.codmateria
			right join preguntas on tests.codtest= preguntas.codtest
			 left join respuestas on tests.codtest= respuestas.codtest;
            
            

select *  from catalogo;
