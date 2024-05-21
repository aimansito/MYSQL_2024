DROP PROCEDURE IF EXISTS insertarDatosTablasTemporales;
DELIMITER $$
CREATE PROCEDURE insertarDatosTablasTemporales()
BEGIN
    DECLARE var BOOLEAN DEFAULT false;
    DECLARE codEntidades INT;
    DECLARE nomEntidades VARCHAR(40);
    DECLARE nomTabla VARCHAR(100);

    DECLARE cur_entidades CURSOR FOR
        SELECT codEntidad, nomEntidad FROM Entidades;

    DECLARE CONTINUE HANDLER FOR sqlstate '02000' SET var = true;

    OPEN cur_entidades;

    FETCH cur_entidades INTO codEntidades, nomEntidades;

    WHILE var = 0 DO
        BEGIN
            -- Eliminar espacios en blanco iniciales en el nombre de la entidad
            SET nomEntidades = LTRIM(nomEntidades);
            SET nomTabla = CONCAT('tmp_', REPLACE(nomEntidades, ' ', '_')); -- Reemplazar espacios en el nombre de la tabla

            -- Verificar si el nombre de la entidad no es NULL ni vacío
            IF nomTabla IS NOT NULL AND nomTabla <> '' THEN
                -- Insertar datos en la tabla temporal específica, evitando duplicados
                SET @sql = CONCAT('INSERT IGNORE INTO `', nomTabla, '` 
                    SELECT c.codCli, c.nombre, c.ape1cli, c.ape2cli, c.dni, c.cuentaBancaria, r.importeFinal
                    FROM Clientes c
                    JOIN Recibos r ON c.codCli = r.codCliente
                    WHERE c.codEntidad = ', codEntidades, ';');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
            END IF;

            FETCH cur_entidades INTO codEntidades, nomEntidades;
        END;
    END WHILE;

    CLOSE cur_entidades;
END$$
DELIMITER ;
call insertarDatosTablasTemporales();
drop table nombreEntidades;