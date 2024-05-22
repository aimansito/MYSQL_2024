use bdgestproyectos;
/*
P1. Cuando contratamos a un empleado nuevo, le pediremos que acceda a nuestro sistema y se cree una cuenta. 
En este proceso se le asignará un usuario y una contraseña que se almacenará en la tabla empleados. 
Se debe asegurar que no existe el nombre de usuario.
*/
delimiter $$
create trigger nuevouser
	before insert on empleados
for each row
begin
	declare texto varchar(100);
	-- if exists (select * from empleados where userem = new.userem) then
	if (select count(*) from empleados where userem = new.userem) > 0 then
	begin
		set texto = 'No se ha dado de alta al empleado. El usuario ya existe en el sistema';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = texto;
    end;
    end if;
end $$
delimiter ;


/*
P2. Los empleados administrativos no pueden ser técnicos y viceversa. Asegúrate que no se puede dar de alta 
al mismo empleado como técnico y como administrativo.
*/
delimiter $$
create trigger nuevotecnico
	before insert on tecnicos
for each row
begin
	declare texto varchar(100);
	if (select count(*) from administrativos where numem = new.numem) > 0 then
	begin
		set texto = concat('El empleado ', new.numem,' es administrativo. No puede darse de alta como técnico');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = texto;
    end;
    end if;
end $$

create trigger nuevoadministrativo
	before insert on adminitrativos
for each row
begin
	declare texto varchar(100);
	if (select count(*) from tecnicos where numem = new.numem) > 0 then
	begin
		set texto = concat('El empleado ', new.numem,' es técnico. No puede darse de alta como administrativo');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = texto;
    end;
    end if;
end $$



delimiter ;


/*
P3. Se ha elaborado un procedimiento “OptimizaNumeroEmpleados”. Nos piden que hagamos lo que consideremos oportuno 
para que se ejecute una vez al año durante los próximos 10 años. 
Para comenzar nos piden que lo dejemos preparado para que, desde el uno de enero del próximo año,  
comience a ejecutarse el viernes a la 1.00h a.m..
*/

create event ejecutaOptimizaNumeroEmpleados
on schedule
	every 1 year
	starts '2024/01/01'
	ends '2024/01/01' + interval 10 year
do
	call OptimizaNumeroEmpleados();
    

/*P4. En el ejercicio 1, el sistema nos pide que se cumpla unos criterios, Debemos asegurarnos que estos criterios 
se cumplen siempre para todos los usuarios tanto cuando se dan de alta como cuando modifican su contraseña. 
Estos criterios son los siguientes:
a) Debe contener al menos dos números separados por un carácter cualquiera.
b) Debe contener un carácrer especial de entre estos: =, <, >, +
c) Debe terminar en una letra de la a a la z.
d) No debe contener el nombre del empleado.
*/

delimiter $$
create trigger CriteriosnuevouserInser
	before insert on empleados
for each row
begin
	declare texto varchar(100);
	if not new.userem rlike '[0-9].[0-9]'
		or not new.userem rlike '[=<>+]'
			or not new.userem rlike '[a-z]$'
				or new.userem rlike new.nomem
    then
	begin
		set texto = 'No se ha dado de alta al empleado. No se cumplen los criterios de nombre de usuario';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = texto;
    end;
    end if;
end $$

create trigger CriteriosnuevouserModif
	before update on empleados
for each row
begin
	declare texto varchar(100);
	if new.nomuser <> old.nomuser and (not new.userem rlike '[0-9].[0-9]'
										or not new.userem rlike '[=<>+]'
											or not new.userem rlike '[a-z]$'
												or new.userem rlike new.nomem)
    then
	begin
		set texto = 'No se ha dado de alta al empleado. No se cumplen los criterios de nombre de usuario';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = texto;
    end;
    end if;
end $$

delimiter ;




