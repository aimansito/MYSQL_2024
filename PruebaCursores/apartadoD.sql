DROP PROCEDURE IF EXISTS GenerarFicheros;
DELIMITER $$
CREATE PROCEDURE GenerarFicheros()
BEGIN
    DECLARE var BOOLEAN DEFAULT 0;
    DECLARE entidadNom VARCHAR(40);
    DECLARE nomBanco VARCHAR(200);
    
    DECLARE cur_entidades CURSOR FOR
        SELECT entidadNom FROM nombreEntidades;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var = 1;

    OPEN cur_entidades;
    
    FETCH cur_entidades INTO entidadNom;
    
    WHILE var = 0 DO
        BEGIN
            -- Asegurarse de que el nombre de la entidad no sea NULL ni esté vacío
            IF entidadNom IS NOT NULL AND entidadNom <> '' THEN
                -- Concatenar el nombre del archivo de salida
                SET nomBanco = CONCAT('/var/lib/mysql-files/', entidadNom, '.txt');
                
                -- Construir la consulta SQL dinámica para exportar los datos
                SET @sql = CONCAT('SELECT * FROM `', entidadNom, '` INTO OUTFILE \'', nomBanco, '\' FIELDS TERMINATED BY \',\' LINES TERMINATED BY \'\n\'');

                -- Preparar y ejecutar la consulta
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
          
            END IF;
            
            FETCH cur_entidades INTO entidadNom;
        END;
    END WHILE;
    
    CLOSE cur_entidades;
END $$
DELIMITER ;
call GenerarFicheros();