DROP PROCEDURE IF EXISTS generarTablasTemporales;
DELIMITER $$
CREATE PROCEDURE generarTablasTemporales()
BEGIN
    DECLARE var BOOLEAN DEFAULT 0;
    DECLARE codEntidades INT;
    DECLARE nomEntidades VARCHAR(40);
    DECLARE nomTabla VARCHAR(100);
    
    DECLARE cur_entidades CURSOR FOR
        SELECT codEntidad, nomEntidad FROM Entidades;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var = 1;

    -- Crear tabla temporal para almacenar los nombres de las entidades
    CREATE TEMPORARY TABLE IF NOT EXISTS nombreEntidades (
        entidadNom VARCHAR(40)
    );

    OPEN cur_entidades;
    
    FETCH cur_entidades INTO codEntidades, nomEntidades;
    
    WHILE var = 0 DO
        BEGIN
            -- Eliminar espacios en blanco iniciales en el nombre de la entidad
            SET nomEntidades = LTRIM(nomEntidades);
            SET nomTabla = CONCAT('tmp_', nomEntidades);
            
            -- Verificar si el nombre de la entidad no es NULL ni vacío
            IF nomTabla IS NOT NULL AND nomTabla <> '' THEN
                -- Crear la tabla temporal específica para la entidad con un índice único en idCliente
                SET @sql = CONCAT('CREATE TEMPORARY TABLE IF NOT EXISTS `', nomTabla, '` (
                    idCliente INT,
                    nombreCli VARCHAR(40),
                    ape1cli VARCHAR(100) NOT NULL,
                    ape2cli VARCHAR(100),
                    dniCli VARCHAR(9),
                    numCuentaCli VARCHAR(100),
                    importeRecibo DOUBLE,
                    PRIMARY KEY (idCliente)
                );');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                
                -- Insertar el nombre de la tabla en nombreEntidades
                INSERT INTO nombreEntidades (entidadNom) VALUES (nomTabla);
                
                -- Insertar datos en la tabla temporal específica, evitando duplicados
                SET @sql = CONCAT('INSERT IGNORE INTO `', nomTabla, '` 
                    SELECT c.codCli, CONCAT(c.nombre, " ", c.ape1cli, " ", IFNULL(c.ape2cli, "")), c.ape1cli, c.ape2cli, c.dni, c.cuentaBancaria, r.importeFinal
                    FROM Clientes c
                    JOIN Recibos r ON c.codCli = r.codCliente
                    WHERE c.codEntidad = ', codEntidades, ';');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
            ELSE
                -- Insertar un mensaje de error si el nombre de la entidad es inválido
                INSERT INTO nombreEntidades (entidadNom) VALUES ('Nombre de entidad inválido');
            END IF;
            
            FETCH cur_entidades INTO codEntidades, nomEntidades;
        END;
    END WHILE;
    
    CLOSE cur_entidades;
END$$

DELIMITER ;



CALL generarTablasTemporales();
SELECT * FROM nombreEntidades;
DELETE FROM nombreEntidades;
SELECT * FROM tmp_Caixa;