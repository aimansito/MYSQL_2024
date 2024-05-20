DROP PROCEDURE IF EXISTS crearTablasTemporales;
DELIMITER $$
CREATE PROCEDURE crearTablasTemporales()
BEGIN
    DECLARE var BOOLEAN DEFAULT 0;
    DECLARE codEntidades INT;
    DECLARE nomEntidades VARCHAR(40);
    DECLARE nomTabla VARCHAR(100);
    DECLARE codigo INT DEFAULT 0;

    DECLARE cur_entidades CURSOR FOR
        SELECT codEntidad, nomEntidad FROM Entidades;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var = 1;

    -- Crear tabla temporal para almacenar los nombres de las entidades
    CREATE TEMPORARY TABLE IF NOT EXISTS nombreEntidades (
        codTabla INT,
        entidadNom VARCHAR(40),
        PRIMARY KEY (codTabla)
    );

    OPEN cur_entidades;

    FETCH cur_entidades INTO codEntidades, nomEntidades;

    WHILE var = 0 DO
        BEGIN
            -- Incrementar el código de tabla para cada entidad
            SET codigo = codigo + 1;

            -- Eliminar espacios en blanco iniciales en el nombre de la entidad
            SET nomEntidades = LTRIM(nomEntidades);
            SET nomTabla = CONCAT('tmp_', REPLACE(nomEntidades, ' ', '_')); -- Reemplazar espacios en el nombre de la tabla

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
                INSERT INTO nombreEntidades (codTabla, entidadNom) VALUES (codigo, nomTabla);
            ELSE
                -- Insertar un mensaje de error si el nombre de la entidad es inválido
                INSERT INTO nombreEntidades (codTabla, entidadNom) VALUES (codigo, 'Nombre de entidad inválido');
            END IF;

            FETCH cur_entidades INTO codEntidades, nomEntidades;
        END;
    END WHILE;

    CLOSE cur_entidades;

    -- Seleccionar registros para verificación
    SELECT * FROM nombreEntidades;
END$$
DELIMITER ;
call crearTablasTemporales();