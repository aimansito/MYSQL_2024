select nomde, sum(empleados.salarem)
from departamentos
join empleados on departamentos.numde = empleados.numde
group by departamentos.numde
limit 1;