-- Nacho Salcedo Guarde
delimiter $$
drop trigger if exists eje1$$
create trigger eje1
before insert on  empleados
for each row
begin
-- if userem = new.userem then 
if userem in (select userem from empleados ) then 
 signal sqlstate '45000' set message_text = 'El nombre de usuario ya existe';
 end if;
end $$
delimiter ;


insert   empleados
(numem , numde, extelem, fecnaem, fecinem,salarem ,comisem, numhiem, nomem, ape1em, ape2em, dniem, userem, passem)
values
(777, 111,780, '1981-09-15', '2002-01-05', 999.00, 150.00,1,'nacho', 'pruebaA', 'prueba', '123456789','eeee', null );


-- ejer2

delimiter $$
drop trigger if exists eje2$$
create trigger eje2
before insert on  empleados
for each row
begin
 if new.numem = (select numem  from tecnicos  join empleados on tecnicos.numem= empleados.numem where tecnicos.numem= empleados.numem) and 
 (select numem from administrativos join empleados on administrativos.numem = empleados.numem where administrativos.numem= empleados.numem)
 then 
 signal sqlstate '45000' set message_text = 'El empleado no puede ser administrativo  y tecnico a  la vez';
 end if;
end $$
delimiter ;




-- ejer3

delimiter $$
create event eje3
on schedule
	every 1 year
    starts '2024-01-01' + interval 10 year
   
do
	begin
		call OptimizaNumeroEmpleados();
    end $$
    
delimiter ;


-- ejer4


-- alta de contraseña
delimiter $$
drop trigger if exists eje4$$
create trigger eje4
before insert  on empleados
for each row
begin	
	if((new.passem not rlike '[0-9.0-9][\\=-\\<-\\>-\\+][z$]') and ( new.passem = empleado.nomuser))then  
     signal sqlstate '45000' set message_text = 'Los contraseña no cumplen los requisitos';
     end if;
     end $$
delimiter ;
     
 -- modificación de contraseña
 
 delimiter $$
drop trigger if exists eje4M$$
create trigger eje4M
before update  on empleados
for each row
begin	
	if((new.passem not rlike '[0-9.0-9][\\=-\\<-\\>-\\+][z$]') and ( new.passem = empleado.nomuser) and (old.passem= new.passem))then  
     signal sqlstate '45000' set message_text = 'Los contraseña no cumplen los requisitos para su modificacion';
     end if;
     end $$
delimiter ;
     
	
