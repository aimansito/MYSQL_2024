/*
No debe haber 2 promociones activas, es decir, no deben solaparse
*/
/* PISTA:
Dos promociones se solapan si:
1. La nueva fecha inicio está entre la fecha de inicio y la de fin de alguna promoción existente
o bien
2. La nueva fecha de fin está entre la fecha de inicio y la de fin de alguna promoción existente
(ver hoja de cálculo aclararotia)
*/
use ventapromoscompleta;
delimiter $$
drop trigger if exists compruebaFechasPromo $$
create trigger compruebaFechaPromo
	before insert on promociones
for each row
begin

	if exists(select count(*)
			  from promociones 
			  where new.fecinipromo between fecinipromo 
						and date_add(fecinipromo, interval duracionpromo day)
				OR 
					date_add(new.fecinipromo, interval new.duracionpromo day) between fecinipromo
						and date_add(fecinipromo, interval duracionpromo day)) then
		signal sqlstate '70000' set message_text = 'Se solapan las promociones';
	end if;

end $$
delimiter ;
-- comprobamos: intentamos insertar una promoción que utilice un tramo de una promoción que ya existe
insert into promociones
(codpromo,despromo,fecinipromo,duracionpromo)
values
(8, 'segunda promocion de primavera 2016',
	'2016/4/15', 45);

-- para comprobarlo también en la modificación:

delimiter $$
drop trigger if exists compruebaFechasPromoUpdate $$
create trigger compruebaFechasPromoUpdate
	before update on promociones
for each row
begin
	if old.fecinipromo <> new.fecinipromo or old.duracion <> new.duracion then
    begin
    
	if exists(select count(*)
			  from promociones 
			  where new.fecinipromo between fecinipromo 
						and date_add(fecinipromo, interval duracionpromo day)
				OR 
					date_add(new.fecinipromo, interval new.duracionpromo day) between fecinipromo
						and date_add(fecinipromo, interval duracionpromo day)) then
		signal sqlstate '70000' set message_text = 'Se solapan las promociones';
	end if;
    end;
    end if;

end $$
delimiter ;

/*
El precio en promoción debe ser menor al previo venta normal
*/
delimiter $$
drop trigger if exists compruebaPrecioPromo $$
create trigger compruebaPrecioPromo
	before insert on catalogospromos
for each row
begin
	if new.precioartpromo >= (select precioventa
							  from articulos
							  where refart = new.refart) then
	begin
		signal sqlstate '70000' set message_text = 'El precio en promoción debe ser menor al habitual';
    
    end;
    end if;
    
end $$
delimiter ;

/*
Actualizamos los puntos acumulados de los clientes
Esto solo se hará si:
1. Hay una promoción actual
2. El artículo que compra el cliente está en la promoción actual
*/
delimiter $$
drop trigger if exists actualizaPuntosAcum $$
create trigger actualizaPuntosAcum
	after insert on detalleventa
for each row
begin
	declare promoActual int default null;
    declare puntos int default null;
    declare cliente int;
  
    select codpromo into promoActual
    from promociones
    where curdate() between fecinipromo and date_add(fecinipromo, interval duracion day);
    if promoActual is not null then
		begin
			select ptosparacli into puntos
			from catalogospromos
			where refart = new.refart and codpromo = promoActual;
            if puntos is not null then
				begin
					select codcli into cliente
					from ventas
					where codventa = new.codventa;
    
					update clientes
					set puntosacumulados = puntosacumulados + puntos
					where codcli = cliente;
				end;
            end if;
         end;
	end if;
    
end $$
delimiter ;

/*
Añadimos las columnas usuario y password a clientes:
*/
Alter table clientes
	add column usuario char(12) default null,
    add column passUser char(12) default null;
    
/* Preparamos función para asignar user por defecto:*/
drop function if exists nuevoUser;
delimiter $$
create function nuevoUser
	(nombre varchar(20), ape1 varchar(20), ape2 varchar(20))
returns varchar(12)

DETERMINISTIC

begin
	/*
    El sistema obtiene el usuario con la siguiente regla:
        A <== primera letra del nombre + 2
        B <== 3 primeras letras del primer apellido + 5
        C <== 3 primeras letras del segundo apellido (o ramdom si no existe) + 5
        D <== el número de caracteres de su nombre completo
    CONTRASEÑA = A + B + C + D
   POR EJEMPLO:
        PARA EVA TORTOSA SÁNCHEZ
		A ==> E+2 ==> G
        B ==> T+5-O+5-R+5 ==> Z-T-W
        C ==> S+5-A+5-N+5 ==> X-F-S
        D ==> 12
        USUARIO: GZTWXFS12
    */
	declare apellido2 varchar(20);
    declare A char(1);
    declare B, C char(3);
    declare D int;
    declare usuario char(10);
    /* NOTA.- Al utilizar variables y devolver variables, 
    es necesario usar la función CONVERT para convertir a "CHAR(n)" el resultado de
    ejecutar CHAR(ASCII(X))
    En caso contrario, la función devolverá un tipo "blob" del que no podemos ver el resultado
    */
    
    -- PRUEBA EL RESULTADO DE CADA FUNCIÓN POR SEPARADO, POR EJEMPLO, EJECUTA EN EL EDITOR:
    -- SELECT convert(char(ascii(left('EVA',1))+2),char(1));
    set A = convert(char(ascii(left(nombre,1))+2),char(1));
    set B = concat(convert(CHAR(ASCII(LEFT(ape1,1))+5),char(1)),
				   convert(CHAR(ASCII(substring(ape1,2,1))+5),char(1)),
				   convert(CHAR(ASCII(substring(ape1,3,1))+5), char(1))
				  );
	set apellido2 = ape2;
    if apellido2 is null then
		begin
        -- valor entre 65 y 90 en números enteros: truncate(floor(rand()*(90-65+1)+65),0);
			set apellido2 = concat(convert(char(truncate(floor(rand()*(90-65+1)+65),0)),char(1)),
								   convert(char(truncate(floor(rand()*(90-65+1)+65),0)),char(1)),
                                   convert(char(truncate(floor(rand()*(90-65+1)+65),0)),char(1))
								   );
        end;
	end if;
    set C = concat(convert(CHAR(ASCII(LEFT(apellido2,1))+5),char(1)),
				   convert(CHAR(ASCII(substring(apellido2,2,1))+5),char(1)),
				   convert(CHAR(ASCII(substring(apellido2,3,1))+5),char(1))
					);
	set D = len(concat_ws('',nombre,ape1,ape2));
    return concat(A,B,C,convert(D,char(2)));
    
end $$
delimiter ;

/*
En la inserción de clientes, asignamos usuario por defecto:

*/

delimiter $$
drop trigger if exists AsignaUser $$
create trigger AsignaUser
	before insert on clientes
for each row
begin
	if new.usuario is null then
		begin
			set new.usuario = nuevoUser(new.nomcli, new.ape1cli, new.ape2cli);
		end;
	end if;
end $$
delimiter ;
