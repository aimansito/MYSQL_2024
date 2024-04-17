use empresaclase;
-- PRIMERA RELACION DE EJERCICIOS 
-- ej 1
select * from departamentos;
-- ej 2
select extelem 
from empleados 
where nomem="JUAN" AND ape1em="LOPEZ";
-- ej3 
select nomem,ape1em,ape2em 
from empleados 
where numhiem between 1 and 3;
-- ej4
select CONCAT(nomem,' ',ape1em,' ',ape2em) as nombre_completo 
from empleados 
where numhiem between 1 and 3;
-- ej5
select CONCAT(nomem,' ',ape1em,' ',ape2em) as nombre_completo
from empleados 
where comisem is null ;
-- ej6
select dirce 
from centros
where nomce="SEDE CENTRAL";
-- ej7
select nomde 
from departamentos 
where presude>=6000;
-- ej8
select nomde 
from departamentos 
where presude>=6000;
-- ej9
select CONCAT_WS(' ',nomem,' ',ape1em,' ',ape2em,' ') as nombre_completo
from empleados 
where datediff(curdate(),fecinem) > 365;
-- ej10
select CONCAT_WS(' ',nomem,' ',ape1em,' ',ape2em,' ') as nombre_completo
from empleados 
where datediff(curdate(),fecinem) BETWEEN 365 AND 1095 ;
-- ej 11
drop procedure if exists consulta11;
delimiter $$
create procedure consulta11
	()
begin 
	select * from empleados;
end $$
delimiter ;
-- ej 12
drop procedure if exists consultas12;
delimiter $$ 
create procedure consultas12 
	(nom varchar(30))
begin 
	select extelem from empleados where nomem=nom;
end $$
delimiter ; 
call consultas12("JUAN");
-- ej13

-- SEGUNDA RELACION DE EJERCICIOS 
-- ej1
select empleados.*,nomde 
from empleados 
JOIN departamentos ON empleados.numde = departamentos.numde;
-- ej2
SELECT empleados.extelem, centros.nomce
FROM empleados
JOIN departamentos ON empleados.numde = departamentos.numde
JOIN centros ON departamentos.numce = centros.numce
WHERE empleados.nomem = 'JUAN' AND empleados.ape1em = 'LOPEZ';
-- ej3
SELECT CONCAT(nomem,' ',ape1em,' ',ape2em) as nombre_completo
FROM empleados
JOIN departamentos ON empleados.numde = departamentos.numde
WHERE nomde="PERSONAL" OR nomde="SECTOR SERVICIOS";
-- ej4
select nomem from empleados 
join departamentos on empleados.numde=departamentos.numde
where nomde="PERSONAL"; 
-- ej5 
select nomde,presude 
from departamentos 
join centros on departamentos.numce=centros.numce
where nomce='SEDE CENTRAL';
-- ej6
select nomce,presude from centros 
join departamentos on centros.numce=departamentos.numce
where presude between 100000 and 150000;
-- ej7
select distinct(extelem) from empleados
join departamentos on empleados.numde=departamentos.numde
where nomde='PERSONAL';
-- ej8
select concat(' ',nomem,' ',ape1em,' ',ape2em) as NombreCompleto
from empleados
join departamentos on empleados.numde=departamentos.numde
where nomde='PERSONAL'; 
-- ej9

-- TERCERA RELACION DE EJERCICIOS
-- ej1
select max(salarem) from empleados;
-- ej2
select min(salarem) from empleados;
-- ej3
select avg(salarem) from empleados;
-- ej4 
select max(salarem), min(salarem), avg(salarem) 
from empleados 
join departamentos on empleados.numde=departamentos.numde
where nomde='Organizacion';
-- ej5
select concat(' ',departamentos.numde,'/',max(salarem)) as salario 
from empleados 
join departamentos on empleados.numde=departamentos.numde
group by departamentos.numde ;
--  ej6
select sum(empleados.salarem+ifnull(empleados.comisem,0))
from empleados
join departamentos on empleados.numde=departamentos.numde
group by departamentos.numde;
-- ej7
select sum(presude) from departamentos;
-- ej8
select max(salarem), min(salarem), avg(salarem) 
from empleados 
join departamentos on empleados.numde=departamentos.numde
group by departamentos.numde;
-- ej9
select count(distinct(extelem)) from empleados;
-- ej10
select count(distinct(extelem)) from empleados
join departamentos on empleados.numde=departamentos.numde
group by departamentos.numde;
