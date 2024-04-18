-- ej33
-- Obtener los nombres y salarios de los empleados cuyo salario coincide con la comisión de algún otro o la suya propia.
select nomem,salarem 
from empleados
where salarem = any (select comisem from empleados)
order by nomem;  
-- ej34
-- Obtener los nombres y salarios de los empleados cuyo salario coincide con la comisión de algún otro o la suya propia.
use empresaclase;
SELECT nomem 
FROM empleados 
WHERE numde IN (
    SELECT empleados.numde 
    FROM empleados 
    JOIN departamentos ON departamentos.numde = empleados.numde 
    WHERE nomem = 'PILAR' OR nomem = 'DOROTEA'
)
order by nomem;
-- ej35
-- Obtener por orden alfabético los nombres de los empleados cuyo salario supere en tres veces y media o más al mínimo salario de los empleados del departamento 122.
-- ej36
-- Hallar el salario máximo y mínimo para cada grupo de empleados con igual número de hijos y que tienen al menos uno, y solo si hay más de un empleado en el grupo.
select min(salarem), max(salarem) 
from empleados
group by numhiem
having count(nomem)>1 and numhiem>0 ;

SELECT numhiem, MAX(salarem) AS salario_maximo, MIN(salarem) AS salario_minimo
FROM empleados
WHERE numhiem>=1 IN (
    SELECT numhiem
    FROM empleados
    GROUP BY numhiem
    HAVING COUNT(*) > 1
)
GROUP BY numhiem;
-- Hallar el centro de trabajo (nombre y dirección) de los empleados sin comisión.
select distinct(nomce),dirce
from centros
join departamentos on centros.numce = departamentos.numce
join empleados on departamentos.numde = empleados.numde
where empleados.numem in( select numem from empleados
where comisem = 0 or comisem is null);

-- ej38
-- Hallar cuantos empleados no tienen comisión en un centro dado.
select count(nomem)
from empleados
join departamentos on empleados.numde = departamentos.numde
join centros on departamentos.numce = centros.numce
where centros.numce = ltrim('SEDE CENTRAL') and comisem is null;

