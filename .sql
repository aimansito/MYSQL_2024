/*
P1. Se quiere asegurar que no se repiten preguntas en el mismo test. Esto es, si se añade una pregunta a un test, 
si esta ya existía para ese mismo test, no se debe añadir. 
En el caso de que se modifique una pregunta, si se está sustituyendo por una existente, 
no se hará la modificación aunque esto será transparente al usuario.

*/
drop trigger if exists compruebaPregInsert;
delimiter $$
create trigger compruebaPregInsert
	before insert on preguntas
for each row
begin
declare mensaje varchar(100);

if exists (select *
		   from preguntas
           where textopreg = new.textopreg and codtest = new.codtest) then
	begin
		set mensaje = concat('La pregunta ', new.textopreg, ' ya existe para el test ', new.codtest);
		signal sqlstate '45000' set message_text = mensaje;
	end;
end if;
end $$
delimiter ;

drop trigger if exists compruebaPregUpdate;
delimiter $$
create trigger compruebaPregUpdate
	before update on preguntas
for each row
begin

if new.textopreg <> old.textopreg and exists (select *
												from preguntas
												where textopreg = new.textopreg and codtest = new.codtest) then
	begin
		set new.textopreg = old.textopreg;
	end;
end if;
end $$
delimiter ;

/* PRUEBAS */

insert into preguntas
	(codtest, numpreg, textopreg,resa,resb,resc,resvalida)
values
	(1,6,'5 - 7', '7','-2','9','b');

update preguntas
set textopreg = '5 - 7'
where codtest = 1 and numpreg = 5;
select * from preguntas; -- para comprobar que no ha cambiado

/*
P2. Se ha detectado que en nuestro sistema se hacen multitud de consultas buscando tests por código de materia 
y unidad y queremos asegurar que estas consultas se hacen lo más ágilmente posible. 
Una vez hecho lo que consideres necesario para garantizar ésto, explica razonadamente qué sucederá cuando se 
hagan operaciones de manipulación de tests.
*/

create index buscatestsporuniymat
	on tests (unidadtest,codmateria);
/*
En las operaciones de manipulación, es decir, en insert, delete y update, el sistema tendrá también que 
actualizar los datos de este índice, por lo que estas operaciones serán más lentas.
*/    

/*
P3. Se ha decidido que para el curso actual, que comienza en septiembre y termina en junio, al finalizar 
cada trimestre se va a subir un punto en la nota del al alumnado en las materias en 
las que haya hecho más de 10 tests.
*/
-- Vamos a buscar al alumnado susceptible de subirle la nota:
-- para probarlo tengo al alumno 1 matriculado en materia 1 y ha hecho el test 1 y 2 de dicha materia
-- el alumno 2, matriculado en la materia 1, ha hecho solo el test 1 de dicha materia
-- vamos a cambiar la condición en las pruebas poniendo '>1' en lugar de '>10'
-- con el siguiente select vemos que solo el alumno 1 cumple la condición:
/*
select respuestas.numexped, tests.codmateria, count(*), count(distinct respuestas.codtest) 
from respuestas join tests on respuestas.codtest = tests.codtest
group by respuestas.numexped, tests.codmateria
having count(distinct respuestas.codtest) >1;
*/
-- Vamos a usarlo ahora dentro de nuestro evento:
delimiter $$
create procedure fomentaTrabajo ()
begin
	declare finalcursor boolean default 0;
    declare expediente char(12);
    declare materia int;
    declare alumTrabajador cursor for
										(select respuestas.numexped, tests.codmateria
										from respuestas join tests on respuestas.codtest = tests.codtest
										group by respuestas.numexped, tests.codmateria
										having count(distinct respuestas.codtest) >1);
                                        
   declare continue handler for sqlstate '02000'
		set finalcursor = 1;
	open alumTrabajador;
    fetch alumTrabajador into expediente, materia;
    while not finalcursor do
    begin
		update matriculas
		set nota = nota + 1
		where numexped = expediente and codmateria = materia;
		fetch alumTrabajador into expediente, materia;
	end;
    end while;
    close alumTrabajador;
end $$
delimiter ;
/* si probamos el procedimiento de nuestro evento sustituyendo '>10' por '>1', comprobaremos que solo al alumno 1 se le suma el punto
 para ello:
 1. comprueba primero las notas (en matriculas):
 select * from matriculas;
 2. ejecuta el procedimiento
 3. vuelve a hacer select:
select * from matriculas;
 
*/

create event subenota
on schedule
	every 1 quarter
starts '2022/9/1' + interval 1 quarter
ends '2022/9/1' + interval 3 quarter

do
	call fomentaTrabajo();
    
/*** PROCEDIMIENTO PARA AÑADIR LAS MATRÍCULAS DEL ALUMNADO    ***/
use GBDgestionaTests;

-- NOTA: Para poder hacer este ejercicio, debes añadir una columna en la tabla matrículas:
-- (este campo valdrá 0 la primera vez que un alumno/a curse una materia y 1, 2, etc. cuando repita)
/*alter table matriculas
	add column repite tinyint default 0,
    drop primary key,
    add constraint pk_matriculas primary key (numexped, codmateria, repite);
*/
drop procedure if exists matriculaAlumnado;
delimiter $$
create procedure matriculaAlumnado
 (in numeroexped char(12),
  in nombrealum varchar(30),
  in apellido1alum varchar(30),
  in apellido2alum varchar(30),
  in fechanacimalum date,
  in callealum varchar(60),
  in poblacionalum varchar(60),
  in codpostalalum char(5),
  in emailalum varchar(60),
  in telefonoalum char(12),
  in nomuseralum char(8),
  in passwordalum char(12),
  in cursomatricula char(6)
)
begin
	/*Zona de declaración.*/
	declare alumnomatriculado boolean default false;
    declare numrepeticion tinyint default 0;
  
  /* CÓDIGO T2 */
  	-- declare exit handler for sqlstate '45000'
	declare exit handler for sqlexception
		rollback;   -- si se produjera el error 45000 ==> se cerraríamos la transacción explícita que abrimos con start transaction
					-- rollback cierra las transacciones deshaciendo todos los cambios que se han producido mientras estamos dentro de la transacción
	/* FIN CÓDIGO T2 */
  
    /*Zona de código.*/
	  /* CÓDIGO T2: */
    start transaction;  -- comienza una transacción explícita
	/* FIN CÓDIGO T2 */
/* A. Buscamos si el alumno/a ha estado dado de alta anteriormente */
	set alumnomatriculado = exists (select * from alumnos where numexped = numeroexped);
    
/* B. Si el alumno estaba matriculado anteriormente, nos aseguramos que sus datos sean los que nos han pasado,
	  si no, insertaremos al alumno  */
    if alumnomatriculado then
		update alumnos
        set nomalum = nombrealum,
			ape1alum = apellido1alum,
			ape2alum = apellido2alum,
			fecnacim = fechanacimalum,
			calle = callealum,
			poblacion = poblacionalum,
			codpostal = codpostalalum,
			email = emailalum,
			telefono = telefonoalum,
			nomuser = nomuseralum,
			password = passwordalum
		where numexped = numeroexped;
	else
		insert into alumnos
			(numexped, nomalum, ape1alum, ape2alum, fecnacim, calle, poblacion, codpostal, email, telefono, nomuser,password)
		values
			(numeroexped,nombrealum,apellido1alum,apellido2alum,fechanacimalum,callealum,poblacionalum,codpostalalum,emailalum,telefonoalum,nomuseralum,passwordalum);
	end if;
	
    /* C. Si el alumno estaba matriculado, comprobamos el número de veces de repetición de un curso */
    if alumnomatriculado then
-- 		set numrepeticion = (......) /* PUNTO EXTRA */
	/* solución */
   set numrepeticion = (select max(repite) +1
						from matriculas
						where numexped = numeroexped);
	else
		set numrepeticion = 0;
	end if;
 
/* D. Añadimos las matrículas */
	-- .............
	/* PUNTO EXTRA */
    -- solución
    insert into matriculas
		(numexped,codmateria, nota, repite)
		(select numeroexped, codmateria, null, numrepeticion
		 from materias
		 where cursomateria = cursomatricula);
/* CÓDIGO T2:*/
commit; -- se cierra la transacción explícita que abrimos con start transaction
		-- commit cierra la transacción confirmando todos los cambios que se han producido mientras estamos dentro de la transacción
/* FIN CÓDIGO T2*/
end $$
delimiter ;
/* PROBAMOS: */
/*
create procedure matriculaAlumnado
 (in numeroexped char(12),
  in nombrealum varchar(30),
  in apellido1alum varchar(30),
  in apellido2alum varchar(30),
  in fechanacimalum date,
  in callealum varchar(60),
  in poblacionalum varchar(60),
  in codpostalalum char(5),
  in emailalum varchar(60),
  in telefonoalum char(12),
  in nomuseralum char(8),
  in passwordalum char(12),
  in cursomatricula char(6)
)

*/

call matriculaAlumnado
('101', 'María', 'Sánchez','Sánchez', '2010/5/2','C/ El viento', 'Estepona', '29680','maria@gmail.com', '600000001',
	'mss','1234','1eso');
    
call matriculaAlumnado
('101', 'María', 'Sánchez','Sánchez', '2010/5/2','C/ El viento nú. 2', 'Estepona', '29680','maria@gmail.com', '600000001',
	'mss','1234','1eso');
    
/* 
P4.Queremos asegurarnos que no vamos a tener dos posibles respuestas iguales en una pregunta, esto es, 
las tres respuestas posibles de una pregunta deben ser diferentes.
*/

-- vamos a modificar los triggers del ejercicio P1, ya que si hiciera uno nuevo del mismo tipo para la misma operación
-- se machacaría el anterior:

drop trigger if exists compruebaPregInsert;
delimiter $$
create trigger compruebaPregInsert
	before insert on preguntas
for each row
begin
declare mensaje varchar(100);

if exists (select *
		   from preguntas
           where textopreg = new.textopreg and codtest = new.codtest) then
	begin
		set mensaje = concat('La pregunta ', new.textopreg, ' ya existe para el test ', new.codtest);
		signal sqlstate '45000' set message_text = mensaje;
	end;
end if;
if new.resa = new.resb or new.resa = new.resc or new.resb = new.resc then
	begin
		set mensaje = concat('No debe haber respuestas repetidas en el test ', new.codtest);
		signal sqlstate '45000' set message_text = mensaje;
	end;
end if;
end $$
delimiter ;

drop trigger if exists compruebaPregUpdate;
delimiter $$
create trigger compruebaPregUpdate
	before update on preguntas
for each row
begin

if new.textopreg <> old.textopreg and exists (select *
												from preguntas
												where textopreg = new.textopreg and codtest = new.codtest) then
	begin
		set new.textopreg = old.textopreg;
	end;
end if;

if (new.resa <> old.resa or new.resb <> old.resb or new.resc <> old.resc) 
	and (new.resa = new.resb or new.resa = new.resc or new.resb = new.resc) then
		signal sqlstate '01001' set message_text = 'no se han actualizado las posibles respuestas';
end if;

end $$
delimiter ;
