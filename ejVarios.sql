select nomde, sum(empleados.salarem)
from departamentos
join empleados on departamentos.numde = empleados.numde
group by departamentos.numde
limit 1;

-- ej 21
use empresaclase;
select extelem,count(numem),round(avg(salarem),2)
from empleados
group by extelem;

select nomem , translate(date_format(fecinem,'El %d de %M de %Y'))
from empleados
join dirigir 
on empleados.numem = dirigir.numempdirec
JOIN departamentos on dirigir.numdepto = departamentos.numde
where tipodir='F' and ifnull(fecfindir,curdate()>=curdate())
order by nomem;

DELIMITER $$
create function traducirMes(mes varchar(100))
RETURNS VARCHAR(50)
deterministic
BEGIN 
	declare traduccion varchar(50);
    declare traducido varchar(50);
    set traduccion = mes;
    SELECT 
    case traduccion  
    when 'January' then traducido =  'Enero'
    when 'February' then traducido = 'Febrero'
    when 'March' then traducido ='Marzo'
    when 'April' then traducido = 'Abril'
    when 'May' then traducido = 'Mayo'
    ELSE traducido = 'No es un mes valido'
	END ;
    return traducido;
END $$