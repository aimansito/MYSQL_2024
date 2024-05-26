-- Aiman Harrar Daoud 
-- Examen 3 Evaluacion


use dawPhone;

-- ej1
ALTER TABLE clientes 
MODIFY column dniCli varchar(9) unique ;
-- ej2
CREATE INDEX ej2 
	ON clientes(idCliente,numCuentaCli);
SELECT * 
FROM clientes USE INDEX(ej2)
WHERE idCliente = 1;
-- ej3

DROP TRIGGER IF EXISTS ej3;
CREATE TRIGGER ej3
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN 
	
	IF(new.numCuentaCli NOT LIKE '^ES') THEN
	BEGIN
	set new.numCuentaCli = concat('ES',new.numCuentaCli);
		signal sqlstate '01000' 
			set message_text = 'No incluye ES en el número de cuenta';
	END
	END IF
END$$
DELIMITER ;

-- ej4
DROP TRIGGER IF EXISTS ej4;
CREATE TRIGGER ej4
AFTER INSERT ON planesclientes
FOR EACH ROW 
BEGIN
    DECLARE planActivo boolean default false
    DECLARE fechaFin date 
    SET planActivo = SELECT Activo FROM planesclientes  where idCliente = new.idCliente
    SET fechaFin = SELECT fecFinPlan FROM planesclientes where idCliente = new.idCliente
    if(planactivo is true) then 
		set planActivo = false
        set fechaFin = date_add(CURRENT_DATE()- 1 day)
END $$
DELIMITER ;
	
-- ej 5
DROP TRIGGER IF EXISTS ej5;
CREATE TRIGGER ej5
AFTER INSERT ON planes
BEGIN
	DECLARE planActivo boolean default false
    DECLARE fechaFin date 
    SET planActivo = SELECT Activo FROM planesclientes  where idCliente = new.idCliente
    SET fechaFin = SELECT fecFinPlan FROM planesclientes where idCliente = new.idCliente
    if(planactivo is true) then 
		set planActivo = false
        set fechaFin = date_add(CURRENT_DATE()- 1 day)
        UPDATE planesclientes 
        SET fecFinPlan = date_add(CURRENT_DATE()- 1 day)
        SET planActivo = false
        WHERE idCliente = new.idCliente;
	 END IF
END $$
DELIMITER ;

-- ej6
DELIMITER $$
CREATE EVENT IF NOT EXISTS EventoRecibos
	ON SCHEDULE 
	EVERY 1 MONTH
    STARTS CASE
			WHEN DAY(CURRENT_DATE()) > 5 THEN CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()) + 1,':', '-10 02:00:00') 
                ELSE CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()), ':','-10 10:00:00')
                
			END
	ON COMPLETION PRESERVE
DO 
BEGIN
    CALL compruebaCobro();
END$$
DELIMITER ;

SHOW EVENTS;

-- ej7
SELECT nombrePlan, count(idcliente)
FROM planes
JOIN planesclientes on planes.idPlan = planesclientes.idPlan and planes.idPlan = planesClientes.idCliente
WHERE Activo = 1 and idCliente in (select idCliente,avg(datediff(fecIniPlan,fecFinPlan))
					from planesclientes
                    having count(idPlan)>1)
UNION 
SELECT idCliente
FROM planes
JOIN planesclientes on planes.idPlan = planesclientes.idPlan and planes.idPlan = planesClientes.idCliente
WHERE Activo = 1 
GROUP BY idPlan
HAVING count(idPlan>1) and datediff(fecIniPlan,fecFinPlan)> 365;

-- ej8
DROP PROCEDURE IF EXISTS condicionEj8;
DELIMITER $$
CREATE PROCEDURE condicionEj8
	(IN condicion varchar(30))
BEGIN 
				SET @sql = CONCAT('SELECT nombrePlan ',condicion,'(idCliente)
									FROM planes
									JOIN planesclientes on planes.idPlan = planesclientes.idPlan and planes.idPlan = planesClientes.idCliente
									WHERE Activo = 1 and idCliente in (select idCliente,avg(datediff(fecIniPlan,fecFinPlan))
																		from planesclientes
																		having count(idPlan)>1)
									UNION 
									SELECT idCliente
									FROM planes
									JOIN planesclientes on planes.idPlan = planesclientes.idPlan and planes.idPlan = planesClientes.idCliente
									WHERE Activo = 1 
									GROUP BY idPlan
									HAVING count(idPlan>1) and datediff(fecIniPlan,fecFinPlan)> 365;');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;
call condicionEj8('max');


-- ej9
SELECT date_add(current_date(), INTERVAL 5 YEAR), count(dirEnvioFicheros)
FROM entidades
WHERE idEntidad in (select idEntidad
					from entidades
					where ifnull(dirEnvioFicheros,0)=0)
group by idEntidad;