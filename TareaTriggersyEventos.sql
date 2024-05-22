/*Para la base de datos empresaclase haz los siguientes ejercicios:

1.Comprueba que no podamos contratar a empleados que no tengan 16 años.
2.Comprueba que el departamento de las personas que ejercen la dirección de los departamentos pertenezcan a dicho departamento.
3.Añade lo que consideres oportuno para que las comprobaciones anteriores se hagan también cuando se modifiquen la fecha de nacimiento de un empleado o al director/a de un departamento.
4.Añade una columna numempleados en la tabla departamentos. En ella vamos a almacenar el número de empleados de cada departamento.
5.Prepara un procecdimiento que para cada departamento calcule el número de empleados y guarde dicho valor en la columna creada en el apartado 4.
6.Prepara lo que consideres necesario para que cada trimestre se compruebe y actualice, en caso de ser necesario, el número de empleados de cada departamento.
7.Asegúrate de que cuando eliminemos a un empleado, se actualice el número de empleados del departamento al que pertenece dicho empleado.

Para la base de datos gestionTests haz los siguientes ejercicios:

8.El profesorado también puede matricularse en nuestro centro pero no de las materias que imparte. Para ello tendrás que hacer lo sigjuiente:
	a.Añade el campo dni en la tabla de alumnado.
	b.Añade la tabla profesorado (codprof, nomprof, ape1prof, ape2prof, dniprof).
	c.Añade una clave foránea en materias ⇒ codprof references a profesorado (codprof).
	d.Introduce datos en las tablas y campos creados para hacer pruebas.
9.Comprueba que un profesor no se matricule de las materias que imparte.
before insert on matriculas
si el dni del alumno = dni profesor que imparte la materia de la matricula entonces
	provocar error
10.La fecha de publicación de un test no puede ser anterior a la de creación.
11.El alumnado no podrá hacer más de una vez un test (ya existe el registro de dicho test para el alumno/a) si dicho test no es repetible (tests.repetible = 0|false).

Crea/Utiliza la base de datos gestionPromo y para dicha base de datos:

1.El precio de un artículo en promoción nunca debe ser mayor o igual al precio habitual de venta (el de la tabla artículos).


Crea/Utiliza la base de datos BDALMACEN y para dicha base de datos:

1.Hemos detectado que hay usuarios que consiguen que el precio del pedido sea negativo,
 con lo cual no se hace un cobro del cliente sino un pago,
 por esta razón hemos decidido comprobar el precio del pedido y 
 hacer que siempre sea un valor positivo.
 
2.Cuando vendemos un producto:
Comprobar si tenemos suficiente stock para ello, si no es así, mostraremos un mensaje de no disponibilidad.
Si tenemos suficiente stock, se hará la venta y se disminuirá de forma automática el stock de dicho producto.

3.Queremos que, cuando queden menos de 5 unidades almacenadas  en nuestro almacén, se realice un pedido automático a nuestro proveedor.
4.Añade una columna de tipo bit para indicar los empleados jubilados y otra con la fecha de jubilación.
5.Cuando un empleado se jubila, si es director de algún departamento, debe aparecer un mensaje que recuerde que debemos buscar un nuevo director para ese departamento.
6.Prepara un evento que, cada trimestre, compruebe si hay algún departamento sin director actual, en cuyo caso mostraremos un mensaje con todos los departamentos sin director.
7.Crea un evento que, al comienzo de cada año, compruebe los empleados jubilados hace diez años o más y los elimine de la base de datos (haz una copia antes de ejecutar este apartado). Deberá eliminar, también, los registros de la tabla dirigir asociados a estos empleados.
8.Crea un evento anual que incremente en un 2,5% el salario de los empleados no jubilados. Este evento se creará deshabilitado.

/*
/**/

use  empresaclase;

-- 1.Comprueba que no podamos contratar a empleados que no tengan 16 años.
delimiter $$
drop trigger if exists compruebaedad $$
create trigger compruebaedad
	before insert on empleados
for each row
begin
	-- if date_sub(curdate(), interval 16 year) < new.fecnaem then
    if date_add(new.fecnaem, interval 16 year) > curdate() then
    
		signal sqlstate '45000' set message_text = 'no se cumple la edad';
	end if;
end $$
delimiter ;
-- lo probamos:
insert into empleados
	(numem, numde, extelem, fecnaem, fecinem,salarem,
	 comisem, numhiem,nomem,ape1em,ape2em,dniem, userem, passem)
values
	(1201, 110, '342','2010/12/12', curdate(), 1000,10,
	0,'María', 'del Campo', 'Flores','10000001a','maria','1234');

-- 2.Comprueba que el departamento de las personas que ejercen la dirección de los departamentos pertenezcan a dicho departamento.

delimiter $$
drop trigger if exists compruebadeptodir $$
create trigger compruebadeptodir
	before insert on dirigir
for each row
begin
	declare mensaje varchar(100);
	if (select numde from departamentos where numem = new.numempdirec) <> new.numdepto then
	begin
		set mensaje = concat('El empleado no pertenece al departamento ', new.numdepto); -- en algunas versiones de mysql de error usar concat directamente en la sentencia signal
		signal sqlstate '45000' set message_text = mensaje;
	end;
    end if;
end $$
delimiter ;
-- lo probamos:

/*
insert into dirigir
	(numdepto, numempdirec, fecinidir, fecfindir, tipodir)
values
--	(....);
*/
-- 3.Añade lo que consideres oportuno para que las comprobaciones anteriores se hagan también cuando se modifiquen la fecha de nacimiento de un empleado o al director/a de un departamento.
-- sobre ejer1
delimiter $$
drop trigger if exists modficofecha $$
create trigger  modficofecha
  before update on empleados
 for each row
begin 
	if date_add(new.fecnaem, interval 16 year) > curdate() and old.fecnaem <> new.fecnaem then
	begin 
		signal sqlstate '45000' set message_text = 'no se cumple la edad';
    end;
	end if;
 
end$$
delimiter ;

-- lo probamos:
update empleados
set extelem = '567'
where numem = 999;

update empleados
set fecnaem = '2007/1/1'
where numem = 999;		

-- sobre ejer2

delimiter $$
drop trigger if exists modficoDire $$
create trigger  modficoDire
 before update on dirigir
for each row
begin
	declare mensaje varchar(100);
	if  old.numdepto <> new.numdepto and (select numde from departamentos where numem = new.numempdirec) <> new.numdepto then
	begin
		set mensaje = concat('El empleado no pertenece al departamento ', new.numdepto); -- en algunas versiones de mysql de error usar concat directamente en la sentencia signal
		signal sqlstate '45000' set message_text = mensaje;
	end;
    end if;
end $$
delimiter ;

-- lo probamos:
update dirigir
set	fecfindir = curdate()
where numempdirec = 150 
	and numdepto = 121 and fecinidir = '2003/08/03';

update dirigir
set	numdepto = 111
where numempdirec = 150 
	and numdepto = 121 and fecinidir = '2003/08/03';

-- 4.Añade una columna numempleados en la tabla departamentos. En ella vamos a almacenar el número de empleados de cada departamento.
alter table departamentos
	add column numempleados int not null default 0;

-- 5.Prepara un procecdimiento que para cada departamento calcule el número de empleados y guarde dicho valor en la columna creada en el apartado 4.
delimiter $$
drop procedure if exists sumaEmpleados $$
create procedure sumaEmpleados()
 begin
	update departamentos
		set numempleados = (select count(*) from empleados where empleados.numde = departamentos.numde);
end $$
delimiter ;

/*
 6.Prepara lo que consideres necesario para que cada trimestre se compruebe y
 actualice, en caso de ser necesario, el número de empleados de cada departamento.
*/
delimiter $$
create event actualizaNumeroEmpleados
on schedule
	every 1 quarter
    starts '2022/6/1'
do
	begin
		call sumaEmpleados();
    end $$
    
delimiter ;

-- 7.Asegúrate de que cuando eliminemos a un empleado, se actualice el número de empleados del departamento al que pertenece dicho empleado.
delimiter $$
drop trigger if exists borradoEmpleados$$
create trigger borradoEmpleados
 after delete on empleados   
for each row
begin
	update departamentos
    set numempleados = (select count(*) from empleados where numde = old.numde)
    where numde = old.numde;
end $$
delimiter ;


	/*
    usar gestionatest
    8.El profesorado también puede matricularse en nuestro centro pero no de las materias que imparte. Para ello tendrás que hacer lo sigjuiente:
	a.Añade el campo dni en la tabla de alumnado.
	b.Añade la tabla profesorado (codprof, nomprof, ape1prof, ape2prof, dniprof).
	c.Añade una clave foránea en materias ⇒ codprof references a profesorado (codprof).
	d.Introduce datos en las tablas y campos creados para hacer pruebas.
    
    */
    
    alter table alumnos 
		add column dnialum char(9) null;
        
	create table profesorado
(
	codprof int, 
	nomprof varchar(60) not null, 
	ape1prof varchar(60) not null, 
	ape2prof varchar(60) null, 
	dniprof char(9) not null,
    constraint pk_profesorado primary key (codprof)
);

alter table materias
	add column codprof int,
	add constraint fk_materias_profesorado foreign key (codprof) references profesorado(codprof);
    /*
    
9.Comprueba que un profesor no se matricule de las materias que imparte.
  before insert on matriculas
 si el dni del alumno = dni profesor que imparte la materia de la matricula entonces
  provocar error
  
*/

-- 10.La fecha de publicación de un test no puede ser anterior a la de creación.

 drop trigger if exists compruebafechatest;
delimiter $$
create trigger compruebafechatest
	before insert on tests
for each row
begin
	if new.fecpublic < new.feccreacion then
		signal sqlstate '45000' set message_text = 'la fecha de publicación no puede ser anterior a la de creación';
	end if;
end $$
delimiter ;

drop trigger if exists compruebafechatestEditar;
delimiter $$
create trigger compruebafechatestEditar
	before update on tests
for each row
begin
	if (new.fecpublic <> old.fecpublic or new.feccreacion <> old.feccreacion) -- si lo que han cambiado son las fechas de creación o publicación
		and new.fecpublic < new.feccreacion then
		signal sqlstate '45000' set message_text = 'la fecha de publicación no puede ser anterior a la de creación';
	end if;
end $$
delimiter ;       
       

-- 11.El alumnado no podrá hacer más de una vez un test (ya existe el registro de dicho test para el alumno/a) si dicho test no es repetible (tests.repetible = 0|false).

drop trigger if exists compruebarepeticiontestsalumno;
delimiter $$
create trigger compruebarepeticiontestsalumno
	before insert on respuestas
for each row
begin
	if (select repetible from tests where codtest = new.codtest) = false and
	  (select count(*) from respuestas where codtest = new.codtest and numexped = new.numexped) > 0 then
		signal sqlstate '45000' set message_text = 'el test no se puede repetir';
	end if;
end $$
delimiter ;




* ejercicio propuesto */

/* 1. modificar la tabla articulos, añadiendo el campo stock,
que contendrá el numero de articulos que hay en la tienda */

alter table articulos
	add column stock int not null default 0;
/* 2. Actualizar la tabla artículos asgnando 10 unidades a los artículos
 pares y 7 unidades a los impares */
 
 /* probemos esto:
 select refart, right(refart,2), mod(right(refart,2),2)
from articulos;
*/
 
 update articulos
	set stock = if (mod(right(refart,2),2)=0,10,7);
/* haz que cuando se haga una venta de un artículo, se modifique
automaticamente el stock 
*/
/*Veamos a que tabla, para que operación y como afecta:
cuando se haga una venta de un artículo ==> los artículos de las ventas están en DETALLEVENTA
										==> se trata de ventas nuevas ==> INSERT
										==> ¿control de datos? ==> NO
                                        ==> modificación de otros datos cuando se haga efectiva la venta ==> SI
											==> AFTER
		por tanto, se trata de hacer un trigger AFTER INSERT ON DETALLEVENTA  
        
        VALORES new y old en un trigger before|after insert
		new ==> valores que se acaban de insertar en la tabla detalleventa 
			(new.refart, new.cant, new.codventa, new.precioventa )
        old ==> valores que tenían las columnas de la tabla detalleventa para la fila en cuestión
				antes de la insercción (en las inserciones siempre es null y no se usarán)
*/

drop trigger if exists actualizastock;
delimiter $$
create trigger actualizastock
		after insert on detalleventa
for each row
begin
		update articulos
			set stock = stock - new.cant
		where refart = new.refart;
end $$
delimiter ;
/* Comprueba también que si no hay suficiente stock no se permita la venta */
/* 
/*Veamos a que tabla, para que operación y como afecta:
cuando se haga una venta de un artículo ==> los artículos de las ventas están en DETALLEVENTA
										==> se trata de ventas nuevas ==> INSERT
										==> ¿control de datos? ==> SI
                                        ==> modificación de otros datos cuando se haga efectiva la venta ==> NO
											==> BEFORE
		por tanto, se trata de hacer un trigger BEFORE INSERT ON DETALLEVENTA  
        
        VALORES new y old en un trigger before|after insert
		new ==> valores que se acaban de insertar en la tabla detalleventa 
			(new.refart, new.cant, new.codventa, new.precioventa )
        old ==> valores que tenían las columnas de la tabla detalleventa para la fila en cuestión
				antes de la insercción (en las inserciones siempre es null y no se usarán)
*/

/*

start transaction;
		select ifnull(max(codventa),0) + 1 into @nuevaventa
        from ventas;
        
        insert into ventas
			(codventa, codcli, fecventa, codvende)
		values
			(@nuevaventa, @cliente, @fecha,@vendedor);
		insert into detalleventa
			(codventa, refart, cant, precioventa)
		values
			(@nuevaventa, 'c1_01',10,2.95), -- new.codventa = @nuevaventa; new.refart = 'c1_01'; new.cant = 10; new.precioventa=2.95
            (@nuevaventa, 'c2_02',8,3.80); -- new.codventa = @nuevaventa; new.refart = 'c2_02'; new.cant = 8; new.precioventa=3.80
	commit;
*/
drop trigger if exists compruebastock;
delimiter $$
create trigger compruebastock
		before insert on detalleventa
for each row
begin
	if (select stock from articulos where refart = new.refart) < new.cant then
    begin
		signal sqlstate '45000' set message_text = 'No se puede realizar la venta por falta de stock';
    end;
    end if;
end $$
delimiter ;

/* VAMOS A COMPROBAR SI FUNCIONA */
drop procedure if exists insertaVentaDosArticulos;
delimiter $$
create procedure insertaVentaDosArticulos
(cliente int,
 fecha date,
 vendedor int,
 articulo1 char(5),
 cantidad1 int,
 precio1 decimal(6,2),
 articulo2 char(5),
 cantidad2 int,
 precio2 decimal(6,2)
 )
 begin
	declare nuevaventa int;
    declare exit handler for sqlstate '45000'
		begin
			rollback;
        end;
	start transaction;
		select ifnull(max(codventa),0) + 1 into nuevaventa
        from ventas;
        
        insert into ventas
			(codventa, codcli, fecventa, codvende)
		values
			(nuevaventa, cliente, fecha,vendedor);
		insert into detalleventa
			(codventa, refart, cant, precioventa)
		values
			(nuevaventa, articulo1,cantidad1,precio1),
            (nuevaventa, articulo2,cantidad2,precio2);
	commit;
 end $$
 delimiter ;
 select * from ventas;
 select * from detalleventa;
 select * from articulos;
 
 call insertaVentaDosArticulos
	(1,curdate(),1,'C1_01',5,2.95,'C1_02',12,3.99); -- el articulo 'C1_02' no tiene suficiente stock
													-- se deshacen todos los cambios
call insertaVentaDosArticulos
	(1,curdate(),1,'C1_03',5,2.95,'C1_04',6,3.99); 

/* Crear la tabla pedidos:
	codpedido, fecpedido, fecentrega, codarticulo, cantidad */
drop table if exists pedidos;
create table pedidos
	(codpedido int,
	 fecpedido date not null,
     fecentrega date null,
     refart char(12),
     cantidad int,
     constraint pk_pedidos primary key (codpedido),
     constraint fk_pedidos_articulos foreign key (refart) references articulos(refart)
		on delete no action on update cascade
	);
    
/* Cuando hacemos una venta y el stock resultante es menor que 5
   genera un pedido automático de 5 unidades */
/* podemos hacer de nuevo el trigger after insert sobre detalleventa añadiendo que se haga el pedido
	pero también podemos hacerlo sobre la tabla ARTICULOS
		cuando se modifique el stock ==> UPDATE
        , si este es menor que 5 ==> ¿ES DE CONTROL DE DATOS ? ==> NO
								 ==> ¡ES DE MODIFICACIÓN DE OTROS DATOS AFECTADOS ==> SI
	por tanto es un trigger AFTER UPDATE ON ARTICULOS
    
    en los triggers update:
     old ==> valores previos a la modificación de la fila que se va a modificar en la tabla que se modifica
     new ==> valores después de la modificación de la fila que se va a modificar en la tabla que se modifica
*/
drop trigger if exists pedidoautomatico;
delimiter $$
create trigger pedidoautomatico
	after update on articulos
for each row
begin

	/*
    
    
    */
	declare nuevopedido int;
	-- solo queremos hacer el pedido automático cuando se haya modificado el stock
    -- sino añadimos "old.stock <> new.stock" haríamos un pedido automatico para cualquier modificación en la tabla artículos
    -- cuando el stock fuera menor que 5 (por ejemplo cuando modificáramos la descripción del artículo
	if new.stock<5 and old.stock <> new.stock then
	begin
		select ifnull(max(codpedido),0)+1 into nuevopedido from pedidos;
		insert into pedidos
			(codpedido, fecpedido,fecentrega, refart, cantidad)
		values
			(nuevopedido, curdate(),null, new.refart, 5);
	end;
    end if;
end $$
delimiter ;

-- probemos:
update articulos
	set stock = 3
where refart = 'C2_01';
 SELECT * FROM pedidos;
    
    
    