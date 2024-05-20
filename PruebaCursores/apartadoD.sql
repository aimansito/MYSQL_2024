DROP PROCEDURE IF EXISTS GenerarFicheros;
DELIMITER $$
CREATE PROCEDURE GenerarFicheros()
BEGIN
    DECLARE var BOOLEAN DEFAULT 0;
    DECLARE NomEntidad VARCHAR(40);
    DECLARE nomBanco VARCHAR(200);
    
    DECLARE cur_entidades CURSOR FOR
        SELECT entidadNom FROM nombreEntidades;
    
    DECLARE CONTINUE HANDLER FOR sqlstate '02000' SET var = 1;

    OPEN cur_entidades;
    
    FETCH cur_entidades INTO NomEntidad;
    
    WHILE var = 0 DO
        BEGIN
         select NomEntidad;
            IF NomEntidad IS NOT NULL AND NomEntidad <> '' THEN
				select NomEntidad;
                SET nomBanco = CONCAT('/var/lib/mysql-files/', NomEntidad, '.txt');

                SET @sql = CONCAT('SELECT * FROM `', NomEntidad, '` INTO OUTFILE \'', nomBanco, '\' FIELDS TERMINATED BY \',\' LINES TERMINATED BY \'\n\'');

                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
          
            END IF;
            
            FETCH cur_entidades INTO NomEntidad;
        END;
    END WHILE;
    
    CLOSE cur_entidades;
END $$
DELIMITER ;
call GenerarFicheros();