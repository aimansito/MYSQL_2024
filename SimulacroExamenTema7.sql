-- Simulacro examen Tema 7
use ventapromoscompleta;
/*Ejercicio 1*/
-- Queremos saber el importe de las ventas de artículos a cada uno de nuestros clientes (muestra el nombre).
-- Queremos que cada cliente se muestre una sola vez y que aquellos a los que hayamos vendido más se muestren primero.

drop procedure if exists ej1;
delimiter $$
create procedure ej1()
	begin
		
        select concat(ape1cli,' ',ifnull(ape2cli,''),', ',nomcli) as 'Nombre Cliente', sum(detalleventa.precioventa) as 'Total Venta'
        from clientes 
			join ventas on clientes.codcli = ventas.codcli
			join detalleventa on ventas.codventa = detalleventa.codventa
		group by concat(ape1cli,' ',ifnull(ape2cli,''),', ',nomcli)
        order by sum(detalleventa.precioventa) desc;
        
	end $$
delimiter ;
-- 
call ej1();
-- 
/*Ejercicio 2*/
-- Muestra un listado de todos los artículos vendidos, queremos mostrar la descripción del artículo y entre paréntesis la descripción de la categoría
-- a la que pertenecen y la fecha de la venta con el formato “march - 2016, 1 (tuesday)”. 
-- Haz que se muestren todos los artículos de la misma categoría juntos.
drop procedure if exists ej2;
delimiter $$
create procedure ej2()
	
    begin
    
		select articulos.refart, articulos.desart,concat(' (',categorias.descat,')'),date_format(fecventa, '%M - %Y, %d (%W)')
			from categorias 
			join articulos on categorias.codcat = articulos.codcat
			join detalleventa on articulos.refart = detalleventa.refart
			join ventas on detalleventa.codventa = ventas.codventa
            order by categorias.descat
		;
        
    end $$

delimiter ;
-- 
call ej2();
--
/*Ejercicio 3*/
-- Obtener el precio medio de los artículos de cada promoción (muestra la descripción de la promoción) del año 2012.
-- (Se usará en el ejercicio 7).
drop procedure if exists ej3;
delimiter $$
create procedure ej3(in anio int)

	begin
		select avg(catalogospromos.precioartpromo) as 'Precio medio'
        from catalogospromos 
        join promociones on catalogospromos.codpromo = promociones.codpromo
        where year(promociones.fecinipromo) = anio;
		
	end $$

delimiter ;
--
call ej3(2012);
-- 
/*Ejercicio 4*/
-- Prepara una rutina que muestre un listado de artículos, su referencia, su nombre y la categoría
-- que no hayan estado en ninguna promoción que haya empezado en este año.
drop procedure if exists ej4;
delimiter $$
create procedure ej4()

	begin
		select articulos.nomart, articulos.refart, articulos.codcat
        from articulos
        where articulos.refart not in (
				select catalogospromos.refart
                from catalogospromos
                join promociones on catalogospromos.codpromo = promociones.codpromo
                where year(promociones.fecinipromo) = year(curdate())
        );
	end $$

delimiter ;
--
call ej4();
--
/*Ejercicio 5*/
-- Queremos asignar una contraseña a nuestros clientes para la APP de la cadena, prepara una rutuina que dado un dni y un teléfono,
-- nos devueltva la contraseña inicial que estará formada por: la inicial del nombre, los números correspondientes a las posiciones 3ª, 4ª Y 5ª del dni
-- y el número de caracteres de su nombre completo. Asegúrate que el nombre no lleva espacios a izquierda ni derecha.
drop function if exists ej5;
delimiter $$
create function ej5(dni char(9),telefo char(9))
returns varchar(6)
deterministic
	begin
		declare contrasenia char(9);
        
        set contrasenia = (select concat(left(clientes.nomcli,1), substring(dni,3,3), length(trim(concat_ws('', clientes.nomcli, clientes.ape1cli, ifnull(clientes.ape2cli,'')))))
							from clientes
                            where clientes.tlfcli = telefo
        );
	return contrasenia;
	end $$
delimiter ;
--
select ej5('31014322H','911 703 9');
--
/*Ejercicio 6*/
-- Sabemos que de nuestros vendedores almacenamos en nomvende su nombre y su primer apellido y su segundo apellido, no hay vendedores con nombres ni apellidos compuestos.
-- Obten su contraseña formada por la inicial del nombre, las 3 primeras letras del primer apellido y las 3 primeras letras del segundo apellido.
drop procedure if exists ej6;
delimiter $$
create procedure ej6(in codVendedor int)
begin
	select concat(left(vendedores.nomvende,1),'',substring(ape1vende,1,3),'',substring(ape2vende,1,3))
    from vendedores
    where vendedores.codvende = codVendedor;
end $$
delimiter ;
-- 
call ej6(1);
--
/*Ejercicio 7*/
-- Queremos saber las promociones que comiencen en el mes actual y para las que la media de los precios de los artículos de dichas promociones coincidan
-- con alguna de las de un año determinado (utiliza el ejercicio P3. Tendrás que hacer alguna modificación).
drop procedure if exists ej7;
delimiter $$
CREATE PROCEDURE ej7(IN anio INT)
BEGIN
    SELECT promociones.despromo
    FROM promociones 
    JOIN catalogospromos ON promociones.codpromo = catalogospromos.codpromo
    WHERE MONTH(promociones.fecinipromo) = MONTH(CURDATE()) 
         GROUP BY promociones.codpromo, promociones.despromo
    HAVING AVG(catalogospromos.precioartpromo) IN (
        SELECT AVG(catalogospromos.precioartpromo)
        FROM catalogospromos 
        JOIN promociones ON catalogospromos.codpromo = promociones.codpromo
        WHERE YEAR(promociones.fecinipromo) = anio
        GROUP BY promociones.codpromo
    );
END$$

delimiter ;
--
call ej7(2012);
--
/*Ejercicio 8*/
-- Obtén un listado de artículos (referencia y nombre) cuyo precio venta sin promocionar sea el mismo que el que han tenido en alguna promoción.
drop procedure if exists ej8;
delimiter $$
create procedure ej8()
	begin
		select articulos.refart, articulos.nomart
        from articulos
        where articulos.precioventa = any (
					select catalogospromos.precioartpromo
                    from catalogospromos join articulos on catalogospromos.refart = articulos.refart
                    )
        ;
	end $$
delimiter ;
--
call ej8();
-- 
-- CREATE VIEW nombre_de_la_vista AS SELECT columna1, columna2, columna3 FROM nombre_de_la_tabla WHERE condición;
-- select nombre_de_la_vista;