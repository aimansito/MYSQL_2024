-- Insercion 
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
call InsertaEmpleados(@numem,140,333,'2020-1-1',curdate(),2000,null,3,'Antonio','Harrar','Daoud','099112','sa',null);

CALL InsertaEmpleados(@numem, 140, 333, '2020-01-01', CURDATE(), 2000, NULL, 3, 'Messi', 'Harrar', 'Daoud', '099112', 'sa', NULL);
select * from empleados;
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
CALL InsertaDeptos(@numce,66,100000,170,'CR7');
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
call BorrarEmpleados(140);
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
select * from empleados;
drop procedure if exists actualizaEmpleados;
delimiter $$
create procedure actualizaEmpleados(
	numemp int,
    numdep int,
    ext int,
    fec date,
    feci date,
    salario float,
    comis float,
    numh int ,
    nomemp varchar(50),
    ape1 varchar(40),
    ape2 varchar(40),
    dni varchar(9),
    usersa varchar(39),
    pass int
)
begin
	declare exit handler for SQLEXCEPTION
    rollback;
    start transaction;
    update empleados set numde=numdep,extelem = ext,fecnaem=fec,fecinem=feci,salarem=salario,comisem=comis,numhiem=numh,nomem=nomemp,ape1em=ape1,ape2em=ape2,userem=usersa,passem=pass
    where numem=numemp;
commit;
end $$
