use empresaclase ;

/* 1. *Obtener por orden alfabético el nombre y los sueldos de los empleados con más de tres hijos.*/

drop procedure Ejer1 ;
delimiter $$
create procedure Ejer1 ()
begin
	select empleados.nomem as NombreEmpleado, empleados.salarem as Salarios
    from empleados
    where numhiem>'3'
    order by empleados.nomem ASC;
end $$
delimiter ;

call Ejer1 ;

/* 2. Obtener la comisión, el departamento y el nombre de los empleados cuyo salario
 es inferior a 190.000 u.m., clasificados por departamentos en orden creciente y por
 comisión en orden decreciente dentro de cada departamento.*/
 
 select empleados.comisem as Comision, departamentos.numde as Depto, empleados.nomem as Nombre
 from empleados
	join departamentos on empleados.numde=departamentos.numde
where empleados.comisem<'190.000'
order by departamentos.numde ASC, empleados.comisem DESC;

/* 3. *Hallar por orden alfabético los nombres de los deptos cuyo director lo es en funciones y no en propiedad. */

select departamentos.nomde as Nombre, empleados.nomem as NombreDirector, dirigir.fecfindir
from empleados 
	join departamentos on empleados.numde=departamentos.numde
		join dirigir on departamentos.numde=dirigir.numdepto
where dirigir.fecfindir is null or dirigir.fecfindir = curdate()
order by empleados.nomem ASC;

/*4. *Obtener un listín telefónico de los empleados del departamento 121 incluyendo el nombre del empleado,
 número de empleado y extensión telefónica. Ordenar alfabéticamente */
 
 select  empleados.numem as Num, empleados.nomem as NombreEmpleado, empleados.extelem as ExtensionTelf
 from empleados
	join departamentos on empleados.numde=departamentos.numde
where departamentos.numde='121' 
order by empleados.nomem ASC;
 
 /*5. Hallar la comisión, nombre y salario de los empleados con más de tres hijos, clasificados por comisión 
 y dentro de comisión por orden alfabético.*/
 
 select comisem as Comis, nomem as Nombre, salarem as Salario
 from empleados
 where numhiem > '3'
 order by empleados.comisem ASC;
 
  /* 6. Hallar por orden de número de empleado, el nombre y salario total (salario más comisión) de los
  empleados cuyo salario total supere las 300.000 u.m. mensuales*/
  
  select empleados.numem as Numero, empleados.nomem as Nombre, (salarem+ifnull(comisem,0)) as SalarioTotal
  from empleados
  where (salarem+ifnull(comisem,0)) > 300.00
  order by empleados.numem ASC;
 
/* Obtener los números de los departamentos en los que haya algún empleado cuya comisión supere al 20% de su salario*/

select departamentos.numde
from empleados join
					departamentos on empleados.numde = departamentos.numde
where empleados.comisem > (0.2*salarem);

/*8. Hallar por orden alfabético los nombres de los empleados tales que si se les da una gratificación de 100 u.m. 
por hijo el total de esta gratificación no supere a la décima parte del salario.*/

select empleados.nomem as Nombres
from empleados
where (numhiem*100) < (0.1*salarem)
order by nomem ASC;

/* 9. *Llamaremos presupuesto medio mensual de un depto. al resultado de dividir su presupuesto
 anual por 12. Supongamos que se decide aumentar los presupuestos medios de todos los deptos 
 en un 10% a partir del mes de octubre inclusive. Para los deptos. cuyo presupuesto mensual anterior 
 a octubre es de más de 500.000 u.m. Hallar por orden alfabético el nombre de departamento y su presupuesto
 anual total después del incremento. */
 
 select departamentos.nomde as NombreDepartamento, ((((presude/12)*0.1)*3)+presude) as PresupuestoAnualTotal
 from departamentos
 where (presude/12) > 500
 order by nomde ASC;
 
/*10. Suponiendo que en los próximos tres años el coste de vida va a aumentar un 6% anual y que se suben los 
salarios en la misma proporción. Hallar para los empleados con más de cuatro hijos, su nombre y sueldo anual, 
actual y para cada uno de los próximos tres años, clasificados por orden alfabético.*/

select empleados.nomem as Nombre, (salarem*12) as SueldoAnual, ((salarem*1.06)*12) as Sueldo1subida, ((salarem*1.12)*12) as Sueldo2subida, ((salarem*1.18)*12) as Sueldo3subida
from empleados
where numhiem > 4
order by nomem ASC;

/*15. Hallar los nombres de los empleados que no tienen comisión, clasificados de manera que aparezcan primero aquellos 
cuyos nombres son más cortos.*/

select empleados.nomem
from empleados
where comisem is null or comisem=0
order by length(nomem) ASC;

/*18. Hallar la diferencia entre el salario más alto y el más bajo.*/

select max(salarem)-min(salarem)
from empleados;

/* 19. Hallar el número medio de hijos por empleado para todos los empleados que no tienen más de dos hijos.*/

select AVG(numhiem)
from empleados
where numhiem < 2;

/* Para cada extensión telefónica, hallar cuantos empleados la usan y el salario medio de éstos.*/

select extelem as Extension, count(empleados.numem) as NumeroEmpleados, avg (salarem) as SalarioMe
from empleados
group by empleados.extelem;

/*24. Hallar por orden alfabético, los nombres de los empleados que son directores en funciones. */ 

select empleados.nomem
from empleados join 
				departamentos on empleados.numde = departamentos.numde
					join dirigir on departamentos.numde=dirigir.numdepto
where fecfindir is null or fecfindir> curdate()
order by empleados.nomem ASC;


/* 25. A los empleados que son directores en funciones se les asignará una gratificación del 5% de su salario.
 Hallar por orden alfabético, los nombres de estos empleados y la gratificación correspondiente a cada uno.*/
 
select empleados.nomem, (empleados.salarem*0.05)
from empleados join 
				departamentos on empleados.numde = departamentos.numde
					join dirigir on departamentos.numde=dirigir.numdepto
where fecfindir is null or fecfindir> curdate()
order by empleados.nomem ASC;
 
 /*29. Seleccionar los nombres de los  departamentos que no dependan de ningún otro. */
 
 select departamentos.nomde
 from departamentos
 where depende is null;
 
 /* 33. Obtener los nombres y salarios de los empleados cuyo salario coincide con la comisión 
 de algún otro o la suya propia. */
 
 select empleados.nomem, empleados.salarem
 from empleados
 where salarem=comisem;
 
 select * from empleados order by nomem ASC;
 
 /*34. Obtener por orden alfabético los nombres de los empleados que trabajan en el mismo departamento 
 que Pilar Gálvez o Dorotea Flor.*/
 
 
SELECT empleados.nomem
FROM empleados e join 
			departamentos d on empleados.numde=departamentos.numde
where departamentos.numde = (
select d2.numde
from e2 join
				d2 on e2.numde=d2.numde
where e2.nomem in ('pilar')
)
and empleado.nomem not in ('pilar');


/*37 Hallar el centro de trabajo (nombre y dirección) de los empleados sin comisión. */ 

select centros.nomce as nombrecentro, centros.dirce as direccioncentro, empleados.nomem
	from empleados 
		join departamentos on empleados.numde=departamentos.numde
			join centros on centros.numce=departamentos.numce
where empleados.comisem is null or comisem=0;

/* 38. Hallar cuantos empleados no tienen comisión en un centro dado.*/

drop procedure if exists Ejer38 ; 
delimiter $$
create procedure Ejer38 (in NombreCentro varchar (60))
begin
select count(empleados.numem)
from empleados 
		join departamentos on empleados.numde=departamentos.numde
			join centros on centros.numce=departamentos.numce
where trim(centros.nomce)=NombreCentro and empleados.comisem is null;
end $$
delimiter ; 
call Ejer38 ('sede central');

/*39. Hallar cuantos empleados no tienen comisión por cada centro de trabajo. */

select centros.nomce, count(empleados.numem) as Numero_Empleados
from empleados
	join departamentos on empleados.numde=departamentos.numde
		join centros on departamentos.numce=centros.numce
where empleados.comisem is null or empleados.comisem=0
group by centros.nomce;

/*26. Borrar de la tabla EMPLEADOS a los empleados cuyo salario (sin incluir la comisión) 
supere al salario medio de los empleados de su departamento.*/

use empresaclase ;

delete from empleados
where empleados.salarem > all (select avg(empleados.salarem) 
								from empleados as e 
                                where e.numde = empleados.numde);
				
                                
/* 27. Disminuir en la tabla EMPLEADOS un 5% el salario de los empleados que superan el 50% 
del salario máximo de su departamento.*/

update empleados
set salarem = salarem*0.95
where numem in (
select empleados.numem
from empleados
where empleados.salarem > (select 0.5*max(empleados.salarem) from empleados as e 
							where e.numde = empleados.numde)
);
                                
/* 40.  Para la base de datos de turismo rural, queremos obtener las casas disponibles para una zona y un rango de fecha dados.*/
use GBDturRural2015;

drop procedure if exists Ejer40;
delimiter $$
create procedure Ejer40(in fecha1 date, in fecha2 date, in zona int)
begin
select casas.codcasa as casas_disponibles, casas.nomcasa
from casas
where casas.codzona=zona and casas.codcasa not in (select casas.codcasa from casas	
														join reservas on casas.codcasa=reservas.codcasa
							where reservas.feciniestancia between fecha1 and fecha2 or fecanulacion is not null);
end $$

delimiter ;

call Ejer40 ('2023-12-01','2023-12-02','2');
                                