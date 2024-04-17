-- ejercicios left y right join
use empresaclase;
select nomde, count(nomem)
from departamentos
right join empleados on empleados.numde = departamentos.numde
group by nomde
HAVING count(nomem)>=0;

select nomde, count(nomem)
from departamentos
left join empleados on empleados.numde = departamentos.numde
group by nomde;

insert into departamentos
(numde,numce,presude,depende,nomde)
values
(132,20,300000,120,'MESSI');