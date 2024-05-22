
-- Para la base de datos empresaclase haz los siguientes ejercicios:
use empresaclase;
-- Comprueba que no podamos contratar a empleados que no tengan 16 años.
delimiter $$
drop trigger if exists mayores16 $$
create trigger mayores16
before insert on empleados
for each row
begin
	if ((date_add(empleados.fecnaem, interval 16 year)) > curdate()) then
    signal sqlstate '01000' set message_text = 'El empleado que desea añadir no es mayor de 16 años';
    end if;
end $$
delimiter ;

-- Comprueba que el departamento de las personas que ejercen la dirección 
-- de los departamentos pertenezcan a dicho departamento.
delimiter $$
drop trigger if exists deptoDirector $$
create trigger deptoDirector
before insert on dirigir
for each row
begin
	if (new.numdepto <> empleados.numde) then
    signal sqlstate '01000' set message_text = 'El director no pertenece a ese departamento';
    end if;
end $$
delimiter ;

-- Añade lo que consideres oportuno para que las comprobaciones anteriores se hagan también 
-- cuando se modifiquen la fecha de nacimiento de un empleado o al director/a de un departamento.
delimiter $$
drop trigger if exists mayores16 $$
create trigger mayores16
before update on empleados
for each row
begin
	if ((date_add(empleados.fecnaem, interval 16 year)) > curdate()) and
		(new.fecnaem <> old.fecnaem) then
    signal sqlstate '01000' set message_text = 'El empleado que desea añadir no es mayor de 16 años';
    end if;
end $$
delimiter ;

delimiter $$
drop trigger if exists deptoDirector $$
create trigger deptoDirector
before update on dirigir
for each row
begin
	if (new.numdepto <> empleados.numde) and
		(new.numdepto <> old.numdepto) then
    signal sqlstate '01000' set message_text = 'El director no pertenece a ese departamento';
    end if;
end $$
delimiter ;

-- Añade una columna numempleados en la tabla departamentos. 
-- En ella vamos a almacenar el número de empleados de cada departamento.
alter table departamentos add
	numempleados int;
	
-- Prepara un procecdimiento que para cada departamento calcule el número de empleados 
-- y guarde dicho valor en la columna creada en el apartado 4.
update departamentos set numempleados = (select count(empleados.numem) 
										 from empleados 
                                         where departamentos.numde = empleados.numde
                                         group by empleados.numde);

-- Prepara lo que consideres necesario para que cada trimestre se compruebe y actualice, 
-- en caso de ser necesario, el número de empleados de cada departamento.


-- Asegúrate de que cuando eliminemos a un empleado, se actualice el número de empleados 
-- del departamento al que pertenece dicho empleado.
delimiter $$
drop trigger if exists actualizarEmpleados $$
create trigger actualizarEmpleados
after delete on empleados
for each row
begin
	update departamentos set numempleados = numempleados - 1;
end $$
delimiter ;

-- Para la base de datos gestionTests haz los siguientes ejercicios:
use gbdgestionatests;

-- El profesorado también puede matricularse en nuestro centro pero no de las materias que imparte. 
-- Para ello tendrás que hacer lo sigjuiente:
	-- Añade el campo dni en la tabla de alumnado.
    alter table alumnos
		add column dni char(9);
	-- Añade la tabla profesorado (codprof, nomprof, ape1prof, ape2prof, dniprof).
    create table profesorado (
			codprof int,
            nomprof varchar(60),
            ape1prof varchar(60),
            ape2prof varchar(60),
            dniprof char(9),
            constraint pk_profesorado primary key (codprof)
		);
	-- Añade una clave foránea en materias ⇒ codprof references a profesorado (codprof).
    alter table materias
		add column codprof int,
        add constraint fk_materias_profesorado foreign key (codprof) 
			references profesorado (codprof);
	-- Introduce datos en las tablas y campos creados para hacer pruebas.
    UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678B' WHERE (`numexped` = '1');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678C' WHERE (`numexped` = '10');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678D' WHERE (`numexped` = '11');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678F' WHERE (`numexped` = '12');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678G' WHERE (`numexped` = '13');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678I' WHERE (`numexped` = '14');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678J' WHERE (`numexped` = '15');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678K' WHERE (`numexped` = '16');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678L' WHERE (`numexped` = '17');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678M' WHERE (`numexped` = '18');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678N' WHERE (`numexped` = '19');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678Ñ' WHERE (`numexped` = '2');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678O' WHERE (`numexped` = '20');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678P' WHERE (`numexped` = '21');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678Q' WHERE (`numexped` = '22');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678R' WHERE (`numexped` = '23');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678S' WHERE (`numexped` = '24');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678T' WHERE (`numexped` = '25');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678W' WHERE (`numexped` = '26');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678Z' WHERE (`numexped` = '27');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678X' WHERE (`numexped` = '28');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '12345678V' WHERE (`numexped` = '29');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321A' WHERE (`numexped` = '3');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321B' WHERE (`numexped` = '30');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321C' WHERE (`numexped` = '31');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321D' WHERE (`numexped` = '32');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321F' WHERE (`numexped` = '33');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321G' WHERE (`numexped` = '34');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321H' WHERE (`numexped` = '35');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321I' WHERE (`numexped` = '36');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321J' WHERE (`numexped` = '37');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321K' WHERE (`numexped` = '38');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321L' WHERE (`numexped` = '39');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321M' WHERE (`numexped` = '4');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321N' WHERE (`numexped` = '40');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321Ñ' WHERE (`numexped` = '41');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321O' WHERE (`numexped` = '42');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321P' WHERE (`numexped` = '43');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321Q' WHERE (`numexped` = '44');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321R' WHERE (`numexped` = '45');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321S' WHERE (`numexped` = '46');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321T' WHERE (`numexped` = '47');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321U' WHERE (`numexped` = '48');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321W' WHERE (`numexped` = '49');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321Y' WHERE (`numexped` = '5');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321Z' WHERE (`numexped` = '50');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321X' WHERE (`numexped` = '51');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '87654321V' WHERE (`numexped` = '52');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '23784526A' WHERE (`numexped` = '53');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '23784526B' WHERE (`numexped` = '54');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '23784526C' WHERE (`numexped` = '55');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '23784526D' WHERE (`numexped` = '6');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '23784526E' WHERE (`numexped` = '7');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '23784526F' WHERE (`numexped` = '8');
UPDATE `gbdgestionatests`.`alumnos` SET `dni` = '23784526G' WHERE (`numexped` = '9');

	-- Comprueba que un profesor no se matricule de las materias que imparte.
	-- before insert on matriculas
	-- si el dni del alumno = dni profesor que imparte la materia de la matricula entonces
		-- provocar error
	-- La fecha de publicación de un test no puede ser anterior a la de creación.
	-- El alumnado no podrá hacer más de una vez un test (ya existe el registro de dicho test para el alumno/a) 
    -- si dicho test no es repetible (tests.repetible = 0|false).


-- Crea/Utiliza la base de datos gestionPromo y para dicha base de datos:

-- El precio de un artículo en promoción nunca debe ser mayor o igual al precio habitual de venta (el de la tabla artículos).


-- Crea/Utiliza la base de datos BDALMACEN y para dicha base de datos:

-- Hemos detectado que hay usuarios que consiguen que el precio del pedido sea negativo, 
-- con lo cual no se hace un cobro del cliente sino un pago, por esta razón hemos decidido 
-- comprobar el precio del pedido y hacer que siempre sea un valor positivo.

-- Cuando vendemos un producto:
-- Comprobar si tenemos suficiente stock para ello, si no es así, mostraremos un mensaje de no disponibilidad.

-- Si tenemos suficiente stock, se hará la venta y se disminuirá de forma automática el stock de dicho producto.

-- Queremos que, cuando queden menos de 5 unidades almacenadas  en nuestro almacén, se realice un pedido automático a nuestro proveedor.

-- Añade una columna de tipo bit para indicar los empleados jubilados y otra con la fecha de jubilación.

-- Cuando un empleado se jubila, si es director de algún departamento, debe aparecer un mensaje que 
-- recuerde que debemos buscar un nuevo director para ese departamento.

-- Prepara un evento que, cada trimestre, compruebe si hay algún departamento sin director actual, 
-- en cuyo caso mostraremos un mensaje con todos los departamentos sin director.

-- Crea un evento que, al comienzo de cada año, compruebe los empleados jubilados hace diez años o más 
-- y los elimine de la base de datos (haz una copia antes de ejecutar este apartado). Deberá eliminar, 
-- también, los registros de la tabla dirigir asociados a estos empleados.

-- Crea un evento anual que incremente en un 2,5% el salario de los empleados no jubilados. 
-- Este evento se creará deshabilitado.


-- Unidad 4. Construcción de Guiones de Administración

-- Actividades II

/*
Da de alta una tabla para los turnos de la empresa y otra para contabilizar los turnos de cada empleado. Ver Nota 2.
Crea un evento que se ejecute una vez, el primer día del año de 2014 y que llame a un procedimiento que desde el primer lunes de 2014, inserte, para cada empleado, un turno alternativo (1ª semana mañana, 2ª semana tarde, 3ª semana noche, y así sucesivamente), para todo el año. El campo asiste será 0 para todas las filas, serán los empleados al ticar, cuando lleguen al trabajo los que harán que este valor se incremente.
Incluye en el procedimiento del apartado anterior los manejadores de error que consideres oportunos (al menos 3).
Haz un segundo evento, igual que el anterior, pero ahora que se ejecute el primer día de cada año.
Prepara un evento que una vez al mes (el día uno de cada mes), llame a un procedimiento que compruebe la asistencia de nuestro personal e inserte/actualice en la tabla “bajasporanyo”, el número de días no trabajados para cada trabajador.
Incluye en el procedimiento del apartado anterior los manejadores de error que consideres oportunos (al menos 3).
Nota 1.- Para las pruebas, por simplicidad, puedes hacer estos ejercicios con una tabla con los primeros 10 empleados y para el primer trimestre del año
Nota 2.- Aquí tienes la estructura de las tablas y los turnos que debes insertar:
turnos
(codturno, desturno)
Necesitamos almacenar tres turnos:
    (1, 'mañana'),
     (2, 'tarde'),
     (3, 'noche')
turnosSemana
 (empleado*, turno*, dia_desde(date), dia_hasta(date), diastrabajados(numeŕico de 0 a 7- por defecto valor 0), observaciones)
bajasporanyo (empleado*, anyo, numbajas)

*/