-- Ejercicio 4

create view muestraEmpleadosSocios
as

select distinct personal.nomemp,personal.ape1emp,personal.ape2emp,socios.dirpostal,personal.codemp from personal
join cafeterias on personal.codcafet=cafeterias.codcafet
join socios on cafeterias.codcafet=socios.codcafet
where personal.codcafet = cafeterias.codcafet = socios.codcafet

union

select  nomsocio,ape1socio,ape2socio,dirpostal,codsocio from socios
join cafeterias on socios.codcafet=cafeterias.codcafet
join personal on cafeterias.codcafet=personal.codcafet
where socios.codcafet = cafeterias.codcafet= personal.codcafet
;

select * from muestraEmpleadosSocios;

-- Ejercicio 5

drop procedure if exists numeroComandasSumaImporte;
delimiter $$
create procedure numeroComandasSumaImporte(in anio year)
begin

		select month(fechacomanda),count(*),sum(importe) from comandas
        where year(fechacomanda)=anio
        group by month(fechacomanda)
        having count(*)>=5
        order by month(fechacomanda);
	

 end $$
delimiter ;

call numeroComandasSumaImporte(2020);

-- Ejercicio 6

drop procedure if exists muestraEmpleadosMayorMedia;
delimiter $$
create procedure muestraEmpleadosMayorMedia()
begin

		select concat(' ',personal.nomemp,' ',personal.ape1emp,' ',personal.ape2emp)as nombreCompleto from personal
        join comandas on personal.codemp=comandas.codemp
        where avg(comandas.importe)>(select avg(comandas.importe) from comandas where comandas.codemple= personal.codemple)
        
														
	

 end $$
delimiter ;

-- parte tema 9

-- Ejercicio 1

delimiter $$
drop trigger if exists compruebaNombreUsu $$
create trigger compruebaNombreUsu
	before insert on empleados
for each row
begin
	
    if new.userem = any(select userem from empleados) then
    
		signal sqlstate '45000' set message_text = 'ya existe ese usuario';
	end if;
end $$
delimiter ;

insert into empleados (userem) value('sa');

-- Ejercicio 2

delimiter $$
drop trigger if exists compruebaTecni $$
create trigger compruebaAdminTecni
	before insert on tecnicos
for each row
begin
		
        if new.numem = any(select numem from administrativos) then
    
    
		signal sqlstate '45000' set message_text = 'este usuario es administrativo';
	end if;
end $$
delimiter ;


delimiter $$
drop trigger if exists compruebaAdmin $$
create trigger compruebaAdmin
	before insert on administrativos
for each row
begin
		
        if new.numem = any(select numem from tecnicos) then
    
    
		signal sqlstate '45000' set message_text = 'este usuario es tecnico';
	end if;
end $$
delimiter ;

insert into tecnicos values(39,110);
insert into administrativos values(4,999);

-- Ejercicio 3

delimiter $$
create procedure OptimizaNumeroEmpleados()
begin
end$$
delimiter ;

drop event if exists optimizaNumeroEmpleados;
delimiter $$
create event if not exists optimizaNumeroEmpleados
on schedule
	every 1 year
    starts '2024-01-01'
    ends '2034-01-01'
do
	begin
		
    end $$
    
delimiter ;

-- Ejercicio 4
drop trigger if exists compruebainsertaParteA ;
delimiter $$
drop trigger if exists compruebaInsertaParteA $$
create trigger compruebaParteA
	before insert on empleados
for each row
begin
	
    if new.userem regexp '[0-9]+.[0-9]'   then
    
		signal sqlstate '45000' set message_text = 'no cumple las condiciones';
	end if;
end $$
delimiter ;
drop trigger if exists compruebainsertaParteB;
delimiter $$
create trigger compruebainsertaParteB
	before insert on empleados
for each row
begin
	
    if new.userem regexp '.*[=|<|>|+].*' then
    
		signal sqlstate '45000' set message_text = 'no cumple las condiciones';
	end if;
end $$
delimiter ;

drop trigger if exists compruebainsertaParteC ;

delimiter $$

create trigger compruebainsertaParteC
	before insert on empleados
for each row
begin
	
    if new.userem regexp '.*[a-z]{1}$'then
    
		signal sqlstate '45000' set message_text = 'no cumple las condiciones';
	end if;
end $$
delimiter ;

drop trigger if exists compruebainsertaParteD ;
delimiter $$

create trigger compruebainsertaParteD
	before insert on empleados
for each row
begin
	
    if new.userem not regexp concat('.*',new.nomem)   then
    
		signal sqlstate '45000' set message_text = 'no cumple las condiciones';
	end if;
end $$
delimiter ;

-- 

drop trigger if exists compruebaactualizarParteA ;
delimiter $$
drop trigger if exists compruebaactualizarParteA $$
create trigger compruebaParteA
	before update on empleados
for each row
begin
	
    if new.userem<>old.userem and new.userem regexp '[0-9]+.[0-9]'   then
    
		signal sqlstate '45000' set message_text = 'no cumple las condiciones';
	end if;
end $$
delimiter ;
drop trigger if exists compruebaactualizarParteB;
delimiter $$
create trigger compruebaactuaizarParteB
	before update on empleados
for each row
begin
	
    if new.userem<>old.userem and new.userem regexp '.*[=|<|>|+].*' then
    
		signal sqlstate '45000' set message_text = 'no cumple las condiciones';
	end if;
end $$
delimiter ;

drop trigger if exists compruebaactualizaParteC ;

delimiter $$

create trigger compruebaactualizaParteC
	before update on empleados
for each row
begin
	
    if new.userem<>old.userem and new.userem regexp '.*[a-z]{1}$'then
    
		signal sqlstate '45000' set message_text = 'no cumple las condiciones';
	end if;
end $$
delimiter ;

drop trigger if exists compruebaactualizaParteD ;
delimiter $$

create trigger compruebaactualizaParteD
	before update on empleados
for each row
begin
	
    if new.userem<>old.userem and new.userem not regexp concat('.*',new.nomem)   then
    
		signal sqlstate '45000' set message_text = 'no cumple las condiciones';
	end if;
end $$
delimiter ;

