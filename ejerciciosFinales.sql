-- ejercicios tema 6 
use empresaclase;
-- Comprobar el comportamiento de la sentencia (explain):
-- sin el where
EXPLAIN select empleados.numem, empleados.nomem, departamentos.nomde
from empleados straight_join departamentos on empleados.numde = departamentos.numde;

-- con el where 
EXPLAIN select empleados.numem, empleados.nomem, departamentos.nomde
from empleados straight_join departamentos on empleados.numde = departamentos.numde 
where empleados.numde <120;

-- con inner_Join
EXPLAIN select empleados.numem, empleados.nomem, departamentos.nomde
from empleados inner join departamentos on empleados.numde = departamentos.numde 
where empleados.numde <120;

-- añadir index a numem
CREATE INDEX numEm_indice on empleados(numem); 
SHOW INDEX FROM empleados;
-- hacer ahora el explain 
EXPLAIN select empleados.numem, empleados.nomem, departamentos.nomde
from empleados inner join departamentos on empleados.numde = departamentos.numde 
where empleados.numde <120;
-- borrar todos los index 
DROP INDEX fk_empleados_deptos ON  empleados;

-- Nuestra aplicación hace múltiples consultas por apellidos y nombre de clientes. Consideramos que
-- no hay apellidos que repitan más de 4 letras y nombres que repitan las 3 primeras letras.
-- Comprueba el resultado con explain.
SELECT nomem,ape1em,ape2em
FROM empleados
GROUP BY ape2em
HAVING COUNT(DISTINCT SUBSTRING(ape2em, 1, 1)) <= 4;
-- En una de las consultas de nuestra aplicación, la búsqueda se hace por nombre y apellidos. ¿Cuál
-- sería la mejor opción para optimizar esta consulta? Comprueba el resultado con explain.
create index nombreComplEmp on empleados(nomem,ape1em,ape2em);
SELECT * FROM empleados WHERE nomem = 'Juan' ;
create index presupuestoDepto on departamentos(presude) ;
select presude from departamentos;
-- Necesitamos ejecutar una consulta en la que se obtengan los nombres de los departamentos y su
-- presupuesto, se quiere que los datos aparezcan ordenados por el presupuesto del departamento y
-- que el departamento con mayor presupuesto aparezca primero. Diseña la consulta de forma que sea
-- lo más eficiente posible.
drop index presupuestoDepto on departamentos;
create index presupuestoDepto on departamentos(nomde,presude) ;
select nomde,presude 
from departamentos
order by presude desc;
-- Comprueba la sentencia anterior con EXPLAIN.
explain select nomde,presude 
from departamentos
order by presude desc;
-- Se desea comprobar el número de empleados que hay en cada departamento (utilizando el nombre
-- de departamento). Comprueba la ejecución de esta sentencia con EXPLAIN.
select nomde,count(empleados.nomem) 
from empleados 
join departamentos on empleados.numde = departamentos.numde
group by nomde;
-- Comprueba la sentencia anterior después de crear un índice para el nombre del departamento.
create index nombreDepto on departamentos (nomde);
