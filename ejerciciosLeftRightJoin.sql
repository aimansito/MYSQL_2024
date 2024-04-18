-- ejercicios left y right join
use empresaclase;
-- no muestra las que tienen 0
select nomde, count(nomem)
from departamentos
right join empleados on empleados.numde = departamentos.numde
group by nomde
HAVING count(nomem)>=0;
/*
Podemos usar GROUP BY sin HAVING
Pero no un HAVING sin GROUP BY
*/

-- muestra las que tienen 0 
select nomde, count(nomem)
from departamentos
left join empleados on empleados.numde = departamentos.numde
group by nomde;
-- CORRECCION : 
select departamentos.numde,departamentos.nomde, count(departamentos.numde) /*valdrá 1 para los departamentos sin empleados*/, count(empleados.numde) as 'Número Empleados por depto'
from departamentos left join empleados
	on departamentos.numde = empleados.numde
group by departamentos.numde;

insert into departamentos
(numde,numce,presude,depende,nomde)
values
(132,20,300000,120,'MESSI');

-- ej2