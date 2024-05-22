/*
tema 8 teoria

¿Tabla?
¿Operacion?
¿Antes/despues?after
before--> control  / after-->operacion adicional




*/

/*

ventas
-->comprobr si hay un stock suficient	
-->quiero modificar el stock
   
-->cuando queden  menos de 5 unidadfes de stock quiero hacer pedido autoatico de cinco unidades

before insert de aqui es donde hago la comprobacion detalleventas
after insert detalleventa  insert es nuevo

after update prodcutos      update es agregar o modificar algo existente
 

  -----------------------------------------------------------------------------Trigger 
   delimiter $$
drop trigger if exists compruebadeptodir $$
create trigger compruebadeptodir
	before insert on dirigir
for each row
begin
	declare mensaje varchar(100);
	if (select numde from departamentos where numem = new.numempdirec) <> new.numdepto then
	begin
		set mensaje = concat('El empleado no pertenece al departamento ', new.numdepto); -- en algunas versiones de mysql de error usar concat directamente en la sentencia signal
		signal sqlstate '45000' set message_text = mensaje;
	end;
    end if;
end $$
delimiter ;
   
  ---------------------- 
   before insert -----antes de insertar datos
   before update -----antes de modificar datos
   after update -------despues de 
   
   
   delimiter $$
drop trigger if exists borradoEmpleados$$
create trigger borradoEmpleados
 after delete on empleados   ---- despues de borrar
for each row
begin
	update departamentos      ----- hago la modificacion
    set numempleados = (select count(*) from empleados where numde = old.numde)
    where numde = old.numde;
end $$
delimiter ;
   
   
   /*
signals con 01xxx provocan warnings-----------OJo
signals con otro provoca errores---------------OJO

drop trigger mitrigger;
DELIMITER $$
CREATE TRIGGER mitrigger
 BEFORE UPDATE ON departamentos
FOR EACH ROW
BEGIN
-- 	DECLARE numero int;
	if (new.presude < old.presude) then
		begin
			set new.presude = old.presude;
            -- SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'El presupuesto no se modificará';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El presupuesto no se modificará';
		end;
	end if;
END $$
DELIMITER ;
   
   
*/

/*
-------------------------------------------------------------------------------------------EVENTOS 
/*
EVENTOS PASO A PASO

delimiter $$
create event (nombre)
on schedule
	every (numero) (unidad temporal)
    starts '(fecha de inicio)'
    ends (fecha de fin)
do
	begin
		(llamada a un método o código)
    end $$
    
delimiter ;

Intervalos de tiempo
	
SEGUNDO: Se utiliza para especificar intervalos de tiempo en segundos. 
Por ejemplo, INTERVAL 5 SECOND representa un intervalo de 5 segundos.

MINUTO: Este intervalo se usa para especificar intervalos de tiempo en minutos.
 Por ejemplo, INTERVAL 10 MINUTE representa un intervalo de 10 minutos.

HORA: Se utiliza para especificar intervalos de tiempo en horas. 
Por ejemplo, INTERVAL 2 HOUR representa un intervalo de 2 horas.

DÍA: Este intervalo se utiliza para especificar intervalos de tiempo en días. 
Por ejemplo, INTERVAL 1 DAY representa un intervalo de 1 día.

SEMANA: Se utiliza para especificar intervalos de tiempo en semanas. 
Por ejemplo, INTERVAL 3 WEEK representa un intervalo de 3 semanas.

MES: Este intervalo se utiliza para especificar intervalos de tiempo en meses. 
Por ejemplo, INTERVAL 6 MONTH representa un intervalo de 6 meses.

AÑO: Se utiliza para especificar intervalos de tiempo en años. 
Por ejemplo, INTERVAL 1 YEAR representa un intervalo de 1 año.

QUARTER: Se utiliza para especificar intervalos de tiempo en trimestres. 
Por ejemplo, INTERVAL 2 QUARTER representa un intervalo de 2 trimestres.

YEAR_MONTH: Este intervalo se utiliza para especificar intervalos de tiempo en años y meses. 
Por ejemplo, INTERVAL '2-3' YEAR_MONTH representa un intervalo de 2 años y 3 meses.

DAY_HOUR: Se utiliza para especificar intervalos de tiempo en días y horas.
 Por ejemplo, INTERVAL '5 12' DAY_HOUR representa un intervalo de 5 días y 12 horas.

DAY_MINUTE: Este intervalo se utiliza para especificar intervalos de tiempo en días y minutos. 
Por ejemplo, INTERVAL '3 30:00' DAY_MINUTE representa un intervalo de 3 días y 30 minutos.


----------------------------
EJEMPLO
Se ha elaborado un procedimiento “OptimizaCatalogosPromos”. Nos piden que hagamos lo que consideremos 
oportuno para que se ejecute cada semestre (2 trimestres) durante el próximo año. 
Para comenzar nos piden que lo dejemos preparado para que, desde hoy martes,  
comience a ejecutarse el domingo a las 00.00h.

Create event ejer_g1_3

on schedule

every 2 quarter
-- every 6 month
	-- starts curdate() + interval 3 day
    -- starts curdate() + interval '5 0' day_hour
    starts '2021-05-28 17:00'
    -- ends curdate() + interval '5 0' day_hour + interval 1 year
    ends '2022-05-28 17:00' + interval 1 year
do call OptimizaCatalogosPromos();


*/
/*
------------------------------------------------------------------------------------------------------------expresiones regulares

operador LIKE

selec *
from centros
where dirce like '%ATOCHA%'

[not] Like -> es el operador básico para usar regexs
% es como el * del sistema operativo -> Es cualquier cadena
_ es como el ? del sistema operativo -> Cualquier caracter
^ -> cadenas que empiecen por un caracter determinado
$ -> cadenas que terminen por un caracter determinado
(a|b|c) -> | separa las opciones es como poner o
[0-9] números del 0 al 9
^[XY] que empiece por X o Y
^ dentro del corchete sirve para negar
[]{n} -> Siendo n el número de coincidencias del caracter dentro del corchete

----------

REGEXP: Esta expresión se utiliza para realizar una búsqueda de patrones utilizando expresiones regulares.
Por ejemplo, SELECT * FROM tabla WHERE columna REGEXP 'patrón';

RLIKE: Es una alternativa a REGEXP y se utiliza de la misma manera para buscar patrones con expresiones regulares.
Por ejemplo, SELECT * FROM tabla WHERE columna RLIKE 'patrón';

^: Representa el inicio de una cadena.
 Por ejemplo, '^patrón' buscará coincidencias al inicio de la cadena.

$: Representa el final de una cadena. 
 Por ejemplo, 'patrón$' buscará coincidencias al final de la cadena.

.: Representa cualquier carácter individual, excepto el salto de línea.
 Por ejemplo, 'a.c' buscará cualquier cadena que tenga un "a" seguido de cualquier carácter y luego una "c".

[ ]: Define un conjunto de caracteres posibles en un lugar específico.
 Por ejemplo, '[abc]' buscará cualquier cadena que contenga cualquiera de los caracteres "a", "b" o "c" en esa posición.

[^ ]: Define un conjunto de caracteres excluidos en un lugar específico.
 Por ejemplo, '[^abc]' buscará cualquier cadena que no contenga los caracteres "a", "b" o "c" en esa posición.

: Representa cero o más repeticiones del elemento anterior.
 Por ejemplo, 'a' buscará cualquier cadena que contenga ninguna o múltiples repeticiones de la letra "a".

+: Representa una o más repeticiones del elemento anterior.
 Por ejemplo, 'a+' buscará cualquier cadena que contenga una o múltiples repeticiones de la letra "a".

?: Representa cero o una repetición del elemento anterior.
 Por ejemplo, 'colou?r' buscará tanto "color" como "colour".



*/


/*
----------------------------------------------------------------------------------------CASE ejemplos

SELECT column1,
       CASE
           WHEN column2 > 0 THEN 'Positivo'
           WHEN column2 < 0 THEN 'Negativo'
           ELSE 'Cero'
       END AS status
FROM table;

SELECT column1,
       CASE
           WHEN column2 > 10 THEN 'Mayor a 10'
           WHEN column2 > 5 THEN 'Mayor a 5'
           ELSE 'Menor o igual a 5'
       END AS status
FROM table;

SELECT column1,
       CASE
           WHEN column2 + column3 > 100 THEN 'Suma mayor a 100'
           WHEN column2 * column3 > 50 THEN 'Producto mayor a 50'
           ELSE 'No se cumple ninguna condición'
       END AS status
FROM table;


*/
