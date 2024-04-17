-- Insercion 
select * from empleados;
drop procedure if exists InsertaEmpleados;
delimiter $$
create procedure InsertaEmpleados
	(out numem int,numde int ,extelem int,fecnaem date,fecinem date,salarem float,comisem double,numhiem int,nomem varchar(50),ape1em varchar(50),ape2em varchar(50),dniem varchar(9),userem varchar(10),paseem int)
begin
	declare numMax int;
    declare exit handler for SQLEXCEPTION
    rollback;
start transaction ;
    set numMax = (select max(numem) from empleados)+1;
insert into empleados 
	(numem,numde,extelem,fecnaem,fecinem,salarem,comisem,numhiem,nomem,ape1em,ape2em,dniem,userem,passem)
    values(@numMax,numde,extelem,fecnaem,fecinem,salarem,comisem,numhiem,nomem,ape1em,ape2em,dniem,userem,passem);
commit ;
end $$
SET @numem = NULL;
use empresaclase;
call InsertaEmpleados(@numem,140,333,'2020-1-1',curdate(),2000,null,3,'Aiman','Harrar','Daoud','099112','sa',null);
select @numem AS numem ;

CALL InsertaEmpleados(@numem, 140, 333, '2020-01-01', CURDATE(), 2000, NULL, 3, 'Aiman', 'Harrar', 'Daoud', '099112', 'sa', NULL);
select * from empleados where nomem='Aiman';
-- insercion deptos
select * from departamentos;
drop procedure if exists InsertaDeptos;
delimiter $$
create procedure InsertaDeptos
	(out numde int,numce int ,presude double,depende int,nomde varchar(50))
begin
	declare numMax int;
    declare exit handler for SQLEXCEPTION
    rollback;
start transaction ;
    set numMax = (select max(numde) from departamentos)+1;
insert into empleados 
	(numde,numce,presude,depende,nomde)
    values(@numMax,numce,presude,depende,nomde);
commit ;
end $$
SET @numde = NULL;
use empresaclase;
CALL InsertaDeptos(@numce,20,100000,130,'La Cañada');
select @numde AS numde ;

select * from dirigir;
-- insercion dirigir
drop procedure if exists InsertaDir;
delimiter $$
create procedure InsertaDir
	(numdepto int,numempdirec int,fecinidir date,fecfindir date, tipodir varchar(1))
begin
    declare exit handler for SQLEXCEPTION
    rollback;
start transaction ;
insert into empleados 
	(numdepto,numempdirec,fecinidir,fecfindir,tipodir)
    values(numdeptonumempdirec,fecinidir,fecfindir,tipodir);
commit ;
end $$
use empresaclase;
call InsertaDir(100,400,'2020-1-1',curdate(),'P');
select * from dirigir where numempdirec=400;
-- borrar empleados drop procedure if exists InsertaDir;
drop procedure if exists InsertaDir;
delimiter $$
create procedure BorrarEmpleado
	(IN numemp int)
begin
start transaction ;
delete from empleados where numem = numemp;
commit ;
end $$
select * from empleados;
call BorrarEmpleados(110);
-- actualizar empleados 
drop procedure if exists actualizarDeptos;
delimiter $$
create procedure actualizarDeptos(
	IN numdepto int, IN numcentro int,presup float,dep int,nomdep varchar(50)
)
begin 
start transaction;
update departamentos set presude=presup , depende=dep , nomde = nomdep where numde=numdepto;
commit;
end $$
use empresaclase;
call actualizarDeptos(130,10,500,111,'Hear This Music');
use empresaclase;
select * from departamentos;