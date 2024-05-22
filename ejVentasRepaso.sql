use ventapromoscompleta;

/*
Para la bd promociones:
Prepara una vista que se llamará CATALOGOPRODUCTOS  que tenga la referencia del artículo,
código y nombre de categoría, nombre del artículo, el precio base y el precio de venta HOY */

drop view if exists catalogoproductos;
create view catalogoproductos
-- (ref articulo, cod.categoria, nombre categoria, nombre articulo, precio y el precio de venta hoy)
as 
select articulos.refart, articulos.nomart, articulos.precioventa
from articulos
where articulos.refart not in (
								select catalogospromos.refart
                                from catalogospromos 
									join promociones on catalogospromos.codpromo=promociones.codpromo
								where curdate() between promociones.fecinipromo and
                                date_add(promociones.fecinipromo, interval promociones.duracionpromo day)
								)
union all

select  articulos.refart, articulos.nomart, catalogospromos.precioartpromo
from articulos
	join catalogospromos on articulos.refart=catalogospromos.refart
     join promociones on catalogospromos.codpromo=promociones.codpromo
where curdate() between promociones.fecinipromo and 
date_add(promociones.fecinipromo, interval promociones.duracionpromo day);

select * from catalogoproductos ;

/* Para la bd de empresaclase:
Prepara una vista que se llamerá LISTINTELEFONICO en la que cada usuario podrá consultar la extensión
telefónica de los empleados de SU DEPARTAMENTO
PISTA ==> USAR FUNCIÓN DE MYSQL USER()
AL CREAR LA VISTA TENER EN CUENTA ESTO:
[SQL SECURITY { DEFINER | INVOKER }]
*/
use empresaclase ;

drop view if exists listintelefonico;
create sql security invoker view listintelefonico

	-- (extension, empleado, departamento)
as 
select empleados.extelem, empleados.nomem, departamentos.nomde
	from empleados 
		join departamentos on empleados.numde=departamentos.numde
	where departamentos.numde=( select departamentos.numde from departamentos 
						join empleados on departamentos.numde=empleados.numde
					where userem = left(user(),locate('@',user())-1 )) ;

use empresaclase ;

/Comprueba que no podamos contratar a empleados que no tengan 16 años./

drop trigger if exists Comprobar_edad
delimiter $$
create trigger Comprobar_edad before insert 
on empleados
for each row
begin
	if date_add(nuevofecnaem, interval 16 year) > curdate() then
		signal sqlstate '45000' set message_text = 'no se cumple la edad';
	end if;
end $$
delimiter ;

/*
Comprueba que el departamento de las personas que ejercen la dirección de los departamentos pertenezcan 
a dicho departamento.*/

drop trigger if exists Comprobardirigir;
delimiter $$
create trigger Comprobardirigir before insert
on dirigir
for each row
begin
	if (select numde from empleados where numem= new.numempdirec) <> new.numdepto then
		signal sqlstate '45000' set message_text = 'No coincide con el departamento';
    
    end if;
end $$
delimiter ;

/*
Añade lo que consideres oportuno para que las comprobaciones anteriores se hagan también cuando se
 modifiquen la fecha de nacimiento de un empleado o al director/a de un departamento.*/
 
 drop trigger if exists Comprobar_edad
delimiter $$
create trigger Comprobar_edad before update
on empleados
for each row
begin
	
    if old.fecnaem <> new.fecnaem 
    and
    date_add(nuevofecnaem, interval 16 year) > curdate() then
		signal sqlstate '45000' set message_text = 'no se cumple la edad';
	end if;
end $$
delimiter ;
 
 /*
Añade una columna numempleados en la tabla departamentos.
 En ella vamos a almacenar el número de empleados de cada departamento.*/
 
 alter table departamentos
	add column num_empleados int;
    
    select * from departamentos ;
 
 /*
Prepara un procecdimiento que para cada departamento calcule el número de empleados y
 guarde dicho valor en la columna creada en el apartado 4.*/
 
 drop procedure if exists num_empleados;
 delimiter $$
 create procedure num_empleados()
 begin
	update departamentos
    set num_empleados = (select count(*) from empleados where empleados.numde = departamentos.numde);
    
 end $$
 delimiter ;
 
 call num_empleados();
 
/*Prepara lo que consideres necesario para que cada trimestre se compruebe y actualice, en caso de ser necesario, 
el número de empleados de cada departamento.*/

delimiter $$
create event actualizarnumempleados
on schedule every 1 quarter
starts '2023-15-05'
do
	begin
        call num_empleados();
	end $$
delimiter ;

/*
Asegúrate de que cuando eliminemos a un empleado, se actualice el número de empleados del
departamento al que pertenece dicho empleado.*/

drop trigger if exists actualizarempleadoeliminado;
delimiter $$
create trigger actualizarempleadoelimnado after delete
on empleados
for each row
begin
update departamentos
	set num_empleado = num_empleado -1 
    where numde=old.numde;
end $$
 
/* Para la base de datos gestionTests haz los siguientes ejercicios:
El profesorado también puede matricularse en nuestro centro pero no de las materias que imparte.
 Para ello tendrás que hacer lo sigjuiente:
Añade el campo dni en la tabla de alumnado.
Añade la tabla profesorado (codprof, nomprof, ape1prof, ape2prof, dniprof).
Añade una clave foránea en materias ⇒ codprof references a profesorado (codprof).
Introduce datos en las tablas y campos creados para hacer pruebas.*/

alter table alumnado 
add column dni char (9);

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
	add constraint fk_materias_profesorado foreign key (codprof) references profesorado(codprof)



/*
Comprueba que un profesor no se matricule de las materias que imparte.
before insert on matriculas
si el dni del alumno = dni profesor que imparte la materia de la matricula entonces
	provocar error*/
    
    drop trigger if exists Profesorenmaterias
    delimiter $$
    create trigger Profesorenmaterias before insert
    on matriculas
    for each row 
    begin
		if new.dni=dniprof then
      signal sqlstate '45000' set message_text = 'Error' ;
      end if;
    end $$
    delimiter ; 
    
/La fecha de publicación de un test no puede ser anterior a la de creación./

drop trigger if exists fechas
    delimiter $$
    create trigger fechas before insert 
    on tests
    for each row 
    begin
		if  new.fecpublicacion < new.feccreacion then
      signal sqlstate '45000' set message_text = 'Error' ;
      end if;
    end $$
    delimiter ; 

/*
El alumnado no podrá hacer más de una vez un test (ya existe el registro de dicho test para el alumno/a) 
si dicho test no es repetible (tests.repetible = 0|false).*/
use gbdgestionatests ;

drop trigger if exists repetibletest;
delimiter $$
create trigger repetibletest
before insert on respuestas
for each row
begin
	if (select repetible from tests where codtest=new.codtest)= false and
    (select count(*) from respuestas where codtest=new.codtest and numexped=new.numexped) > 1 then
    signal sqlstate '45000' set message_text = "Error" ;
    end if;
end $$

delimiter ;


/* El precio de un artículo en promoción nunca debe ser mayor o igual al precio habitual de venta 
(el de la tabla artículos). */ 

use ventapromoscompleta ;

drop trigger if exists preciopromocion;
delimiter $$
create trigger preciopromocion
before insert on catalogospromos
for each row
begin 
	if (select precioventa from articulos where refart=new.refart ) < new.precioartpromo then
		signal sqlstate '45000' set message_text = 'Error: no puede ser superior al precio habitual';
    end if ;
end $$
delimiter ;

select * from catalogospromos;

insert catalogospromos
value
('C6_04',6,20,2);

/* Crea/Utiliza la base de datos BDALMACEN y para dicha base de datos:
1. Hemos detectado que hay usuarios que consiguen que el precio del pedido sea negativo, con lo cual no
 se hace un cobro del cliente sino un pago, por esta razón hemos decidido comprobar el precio del pedido
 y hacer que siempre sea un valor positivo.*/
 
 use bdalmacen ;
 drop trigger if exists cantidadpositiva;
 delimiter $$
 create trigger cantidadpositiva
 before insert on pedidos
 for each row
 begin
	set new.cantidad = abs(new.cantidad); 
 end $$
 delimiter ;
 
 
 /*
2. Cuando vendemos un producto:
Comprobar si tenemos suficiente stock para ello, si no es así, mostraremos un mensaje de no disponibilidad.
Si tenemos suficiente stock, se hará la venta y se disminuirá de forma automática el stock de dicho producto.*/


drop trigger if exists stock;
delimiter $$
create trigger stock
before insert on pedidos
for each row
begin
	if (select stock from productos where codproducto=new.codproducto) < new.cantidad then 
    signal sqlstate '45000' set message_text = 'Error: no hay suficiente stock';
    end if;
end $$
delimiter ;

/*Queremos que, cuando queden menos de 5 unidades almacenadas  en nuestro almacén, se realice un pedido automático
 a nuestro proveedor.*/
 drop trigger if exists pedir;
 delimiter $$
 create trigger pedir
 after update on productos
 for each row
 begin 
 
		if old.stock<>new.sotck and new.stock < 5 then
			set nuevo_pedido = (select sum(codpedido) from pedidos) + 1;
            insert into pedidos
            -- (codpedido, fecpedido, fecentrega, codproducto, cantidad)
            values
            (nuevo_pedido, curdate(), null, new.codproducto, 5);
            end if;
 end $$
 delimiter ;
 
 /*
Añade una columna de tipo bit para indicar los empleados jubilados y otra con la fecha de jubilación.*/

alter table empleados
	add column jubilados bit ,
    add column fecha_jubi date;