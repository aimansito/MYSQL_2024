-- crear un procedimiento que devuelva el resultado de una consulta sobre
-- una base de datos que pasemos por una base de datos dada 
-- una tabla dada
-- listado de campos de dicha tabla 

use empresaclase;
DROP PROCEDURE IF EXISTS consultarDatos;

DELIMITER $$
CREATE PROCEDURE ConsultarDatos
	(IN nombre varchar(50),in nomBd varchar(50),in nomTabla varchar(50))
BEGIN 
				SET @sql = CONCAT('SELECT ',nombre,'FROM ', nomBd,'.',nomTabla);
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;
call consultarDatos('*','dawPhoneAiman','Clientes');

-- para bdturural obtener un listado de casas disponibles entre sus fechas 
-- numero de casas de las que se han anulado reseras con menos de 15 dias de antelacion 
-- en cada zona qu tiene al menos de 10 reservas anuladas

/* NÚMERO DE CASAS CASAS DE LAS QUE SE HAN ANULADO RESERVAS CON MENOS DE 15 DÍAS DE ANTELACIÓN 
EN CADA ZONA QUE TIENE AL MENOS 10 RESERVAS ANULADAS
*/
use GBDturRural2015;
DROP PROCEDURE IF EXISTS devolverReservarAnuladas;
DELIMITER $$
CREATE PROCEDURE devolverReservarAnuladas()
BEGIN
	-- NÚMERO DE CASAS CASAS DE LAS QUE SE HAN ANULADO RESERVAS
	SELECT distinct nomzona, count(reservas.codcasa) as reservas_anuladas
    FROM reservas
    JOIN casas ON reservas.codcasa = casas.codcasa and reservas.codcliente = casas.codcasa and reservas.codreserva = casas.codcasa
    JOIN zonas ON casas.codzona = zonas.numzona
    -- CON MENOS DE 15 DÍAS DE ANTELACIÓN
    WHERE datediff(fecreserva,fecanulacion) < 15 and zonas.numzona in (select casas.codzona
																	from reservas join casas on reservas.codcasa = casas.codcasa 
                                                                    and casas.codcasa = reservas.codcliente and casas.codcasa = reservas.codcasa
																	where fecanulacion is not null
                                                                    group by codzona
																	having count(*) > 10)
                                                                    
    GROUP BY numzona;
END $$
DELIMITER ;
call devolverReservarAnuladas;

-- prepara una vista para el apartado anterior

-- sabemos que en nuestra base de datos clientes y propietarios sacar su dni


/* PREPARA UNA VISTA DEL APARTADO ANTERIOR */

/* SABEMOS QUE EN NUESTRA BASE DE DATOS TENEMOS CLIENTES QUE SON TAMBIÉN PROPIETARIOS, PREPARA UNA VISTA 
EN LA QUE PODAMOS TENER A LOS CLIENTES Y LWOS PROPIETARIOS JUNTOS Y SIN REPETIR
QUEREMOS MOSTRAR SUS DNIS Y SU NOMBRE */
CREATE VIEW ejClase
	(dni, nombre)
AS 
	SELECT dni_cif, nompropietario
    from propietarios
union
	select dnicli, concat_ws(' ',nomcli,ape1cli,ape2cli)
    from clientes;
select *  from
ejClase;
SELECT DISTINCT dni_cif, nompropietario, dnicli,  nomcli
FROM propietarios
JOIN casas on propietarios.codpropietario = casas.codcasa
JOIN reservas on casas.codcasa = reservas.codcasa and casas.codcasa = reservas.codreserva and casas.codcasa = reservas.codcliente
JOIN clientes on clientes.codcli = reservas.codreserva and clientes.codcli = reservas.codreserva and clientes.codcli = reservas.codcasa;