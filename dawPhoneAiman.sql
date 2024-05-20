-- Creacion BADAT Proyecto 
drop database dawPhoneAiman;
create database if not exists dawPhoneAiman;
use dawPhoneAiman;
CREATE TABLE IF NOT EXISTS Entidades
		(
		codEntidad int not null,
        nomEntidad varchar(40),
        dirPostal varchar(9),
        dirEnvio varchar(30),
        Constraint pk_entidades PRIMARY KEY (codEntidad)
        );
CREATE TABLE IF NOT EXISTS PlanProducto 
		(
        codPlan int not null,
        importe double,
        nombrePlan varchar(40),
        Constraint pk_planProducto PRIMARY KEY (codPlan)
        );
        
CREATE TABLE IF NOT EXISTS Clientes
		(
        codCli int not null,
        nombre varchar(40) not null,
        ape1cli varchar(50) not null,
        ape2cli varchar(70),
        cuentaBancaria varchar(100) not null,
        correo varchar(100) not null,
        fechaNac date not null,
        dni varchar(9) not null,
        codEntidad int not null,
        Constraint pk_clientes PRIMARY KEY(codCli),
        Constraint fk_clientes_entidad FOREIGN KEY(codEntidad) references Entidades(codEntidad)
        );
CREATE TABLE IF NOT EXISTS Recibos 
		(
        codRecibo int not null,
        fecRecibo datetime not null,
        importeFinal double not null,
        pagado boolean ,
        codCliente int not null,
        constraint pk_recibos PRIMARY KEY (codRecibo),
        constraint fk_recibos_clientes FOREIGN KEY (codCliente) references Clientes(codCli)
        );
CREATE TABLE IF NOT EXISTS detallePlan
		(
        codCli int not null,
        codPlan int not null,
		estadoPlan ENUM('Pagado','Impagado','Pendiente'),
        fecAltaPlan date not null,
        fecBajaPlan date not null,
		PRIMARY KEY (codCli, codPlan),
		FOREIGN KEY (codCli) REFERENCES Clientes(codCli),
		FOREIGN KEY (codPlan) REFERENCES PlanProducto(codPlan) 
        );
        
-- insercion de datos
-- Entidades
INSERT INTO Entidades (codEntidad, nomEntidad, dirPostal, dirEnvio) VALUES (1, 'Vodafone', '29680', 'Calle 1');
INSERT INTO Entidades (codEntidad, nomEntidad, dirPostal, dirEnvio) VALUES (2, 'Entidad B', '29680', 'Calle 2');
INSERT INTO Entidades (codEntidad, nomEntidad, dirPostal, dirEnvio) VALUES (3, 'Entidad C', '29680', 'Calle 3');
INSERT INTO Entidades (codEntidad, nomEntidad, dirPostal, dirEnvio) VALUES (4, 'Entidad D', '29680', 'Calle 4');
INSERT INTO Entidades (codEntidad, nomEntidad, dirPostal, dirEnvio) VALUES (5, 'Entidad E', '29680', 'Avenida 5');
-- PlanProducto 
INSERT INTO PlanProducto (codPlan, importe, nombrePlan) VALUES (1, 100.50, 'Netflix');
INSERT INTO PlanProducto (codPlan, importe, nombrePlan) VALUES (2, 75.25, 'Amazon Prime');
INSERT INTO PlanProducto (codPlan, importe, nombrePlan) VALUES (3, 150.75, 'Dazn');
INSERT INTO PlanProducto (codPlan, importe, nombrePlan) VALUES (4, 200.00, 'Movistar Plus');
INSERT INTO PlanProducto (codPlan, importe, nombrePlan) VALUES (5, 50.00, 'Netflix');	
-- Clientes
INSERT INTO Clientes (codCli, nombre, ape1cli, ape2cli, cuentaBancaria, correo, fechaNac, dni, codEntidad) 
VALUES (1, 'Luis', 'Hernández', 'Martínez', 'ES5432167890543216789054', 'luis@gmail.com', '1987-09-12', '56789012F',  1);
INSERT INTO Clientes (codCli, nombre, ape1cli, ape2cli, cuentaBancaria, correo, fechaNac, dni, codEntidad) 
VALUES (2, 'Sofía', 'Sánchez', 'García', 'ES9876543210987654321098', 'sofia@gmail.com', '1993-04-18', '67890123G',  2);
INSERT INTO Clientes (codCli, nombre, ape1cli, ape2cli, cuentaBancaria, correo, fechaNac, dni, codEntidad) 
VALUES (3, 'Elena', 'Martín', 'López', 'ES1357924680135792468013', 'elena@gmail.com', '1980-11-30', '78901234H',  3);
INSERT INTO Clientes (codCli, nombre, ape1cli, ape2cli, cuentaBancaria, correo, fechaNac, dni, codEntidad) 
VALUES (4, 'Carlos', 'García', 'Fernández', 'ES1234567890123456789012', 'carlos@gmail.com', '1998-02-25', '89012345I',  4);
INSERT INTO Clientes (codCli, nombre, ape1cli, ape2cli, cuentaBancaria, correo, fechaNac, dni, codEntidad) 
VALUES (5, 'Laura', 'Díaz', 'Pérez', 'ES2468013579246801357924', 'laura@gmail.com', '1991-06-07', '90123456J',  5);
-- Recibos
INSERT INTO Recibos (codRecibo, fecRecibo, importeFinal, pagado, codCliente) VALUES (1, '2024-05-12 08:00:00', 50.00, 1, 1);
INSERT INTO Recibos (codRecibo, fecRecibo, importeFinal, pagado, codCliente) VALUES (2, '2024-05-12 09:15:00', 75.25, 1, 2);
INSERT INTO Recibos (codRecibo, fecRecibo, importeFinal, pagado, codCliente) VALUES (3, '2024-05-12 10:30:00', 100.50, 0, 3);
INSERT INTO Recibos (codRecibo, fecRecibo, importeFinal, pagado, codCliente) VALUES (4, '2024-05-12 11:45:00', 200.00, 1, 4);
INSERT INTO Recibos (codRecibo, fecRecibo, importeFinal, pagado, codCliente) VALUES (5, '2024-05-12 13:00:00', 150.75, 0, 5);
-- detallePlan
INSERT INTO detallePlan (codCli, codPlan, estadoPlan, fecAltaPlan, fecBajaPlan) VALUES (1, 1, 'Pagado', '2024-01-01', '2024-12-31');
INSERT INTO detallePlan (codCli, codPlan, estadoPlan, fecAltaPlan, fecBajaPlan) VALUES (2, 2, 'Pagado', '2024-02-01', '2024-12-31');
INSERT INTO detallePlan (codCli, codPlan, estadoPlan, fecAltaPlan, fecBajaPlan) VALUES (3, 3, 'Impagado', '2024-03-01', '2024-12-31');
INSERT INTO detallePlan (codCli, codPlan, estadoPlan, fecAltaPlan, fecBajaPlan) VALUES (4, 4, 'Pagado', '2024-04-01', '2024-12-31');
INSERT INTO detallePlan (codCli, codPlan, estadoPlan, fecAltaPlan, fecBajaPlan) VALUES (5, 5, 'Impagado', '2024-05-01', '2024-12-31');


-- index 
CREATE INDEX indexEntidad ON Clientes(codCli,codEntidad);
SHOW INDEX FROM Clientes; 

SELECT codCli
FROM Clientes USE INDEX(indexEntidad)	
WHERE codEntidad=1;

-- y a generar dos procesos automáticos, el primero para preparar los ficheros de cobro para los bancos 
-- y el segundo para que una vez recibidos los ficheros de los bancos poner como pendientes de cobro 
-- los recibos de los clientes a los que no se le haya podido cobrar dicho fichero.


-- insert en recibos 
-- se genera una tabla temporal para cada entidad
-- guardar en la tabla temporal corresponiente a cobrar a cad acliente 
-- generar el fichero 

-- buscar plan activo antes de esa fecha en la que se ejecuta
DROP PROCEDURE IF EXISTS GenerarRecibosMensuales;
DELIMITER $$
CREATE PROCEDURE GenerarRecibosMensuales()
BEGIN
    DECLARE finCursor BOOLEAN DEFAULT FALSE;
    DECLARE cliente_id INT;
    DECLARE importe DOUBLE;
    DECLARE fechaAlta DATE;
    DECLARE maxRecibo INT;
    DECLARE fecha_recibo DATETIME;
    DECLARE numDias INT;

    DECLARE cliente_cursor CURSOR FOR
        SELECT Clientes.codCli, PlanProducto.importe, detallePlan.fecAltaPlan
        FROM Clientes 
        JOIN detallePlan ON Clientes.codCli = detallePlan.codCli
        JOIN PlanProducto ON detallePlan.codPlan = PlanProducto.codPlan
        WHERE detallePlan.estadoPlan = 'Pagado' 
          AND detallePlan.fecAltaPlan <= CURRENT_DATE()
          AND (detallePlan.fecBajaPlan IS NULL OR detallePlan.fecBajaPlan >= CURRENT_DATE());

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCursor = TRUE;

    OPEN cliente_cursor;
    FETCH cliente_cursor INTO cliente_id, importe, fechaAlta;

    REPEAT
        IF NOT finCursor THEN
            SET fecha_recibo = CONCAT(CURRENT_DATE(), ' ', '5:00:00');
            SELECT IFNULL(MAX(codRecibo), 0) + 1 INTO maxRecibo FROM Recibos;

            SET numDias = DATEDIFF(CURRENT_DATE(), fechaAlta);
            IF numDias <= 35 THEN
                SET importe = (importe / 30) * (numDias - 5);
            END IF;

            INSERT INTO Recibos (codRecibo, fecRecibo, importeFinal, pagado, codCliente)
            VALUES (maxRecibo, fecha_recibo, importe, FALSE, cliente_id);

            FETCH cliente_cursor INTO cliente_id, importe, fechaAlta;
        END IF;
    UNTIL finCursor END REPEAT;

    CLOSE cliente_cursor;
END$$
DELIMITER ;

call GenerarRecibosMensuales();
DELIMITER $$
CREATE EVENT IF NOT EXISTS EventoRecibos
ON SCHEDULE 
	EVERY 1 MONTH
    STARTS CASE
			WHEN DAY(CURRENT_DATE()) > 5 THEN CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()) + 1,':', '-05 15:00:00') 
                ELSE CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()), ':','-05 02:00:00')
                
			END
	ON COMPLETION PRESERVE
DO CALL GenerarRecibosMensuales();
SHOW EVENTS;

DROP PROCEDURE IF EXISTS GenerarFicherosBancarios;
DELIMITER $$
CREATE PROCEDURE GenerarFicherosBancarios()
BEGIN
    DECLARE entidad INT;
    DECLARE nombEntidad VARCHAR(20);
    DECLARE var boolean DEFAULT FALSE;
    DECLARE codCliente INT;
    DECLARE importeFinal DOUBLE;
    DECLARE fechaRecibo DATE;

    -- Crear tabla temporal para cada entidad bancaria
    CREATE TEMPORARY TABLE IF NOT EXISTS BancoA (
        codCli INT,
        importeFinal DOUBLE,
        fechaRecibo DATE
    );
	CREATE TEMPORARY TABLE IF NOT EXISTS BancoB (
        codCli INT,
        importeFinal DOUBLE,
        fechaRecibo DATE
    );

    -- Insertar los recibos de los clientes en las tablas temporales correspondientes
    INSERT INTO BancoA (codCli, importeFinal,fechaRecibo)
    SELECT R.codCliente, R.importeFinal, R.fecRecibo
    FROM Recibos R
    INNER JOIN Clientes C ON R.codCliente = C.codCli
    WHERE C.codEntidad = 1 ; -- Cambiar por el código de entidad bancaria de BancoA

    SET entidad = 2; -- Cambiar por el código de entidad bancaria de BancoA
    WHILE NOT var DO
        SELECT codCliente, importeFinal, fechaRecibo
        INTO codCliente, importeFinal, fechaRecibo
        FROM Recibos R
        INNER JOIN Clientes C ON R.codCliente = C.codCli
        WHERE C.codEntidad = entidad and fechaRecibo = fecRecibo;

        IF codCliente IS NOT NULL THEN
            -- Insertar en la tabla temporal correspondiente
            INSERT INTO BancoB (codCli, importeFinal, fechaRecibo)
            VALUES (codCliente, importeFinal, fechaRecibo);
        ELSE
            SET var = TRUE;
        END IF;
    END WHILE;

    -- Escribir los resultados en un archivo
    SELECT *
    INTO OUTFILE '/var/lib/mysql-files/banco.txt'
    FIELDS TERMINATED BY ','
    FROM BancoB;

    -- Eliminar las tablas temporales
    DROP TEMPORARY TABLE IF EXISTS BancoA;
    DROP TEMPORARY TABLE IF EXISTS BancoB;
END$$
DELIMITER ;
-- cojo el directorio que me aparece para exportar el archivo
SHOW VARIABLES LIKE "secure_file_priv";
DELIMITER $$
CREATE EVENT IF NOT EXISTS EventoFicheros
ON SCHEDULE 
	EVERY 1 MONTH
    STARTS CASE
			WHEN DAY(CURRENT_DATE()) > 5 THEN CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()) + 1, '-05 02:00:00') 
                ELSE CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()), '-05 02:00:00')
                
			END
	ON COMPLETION PRESERVE
DO CALL GenerarFivherosBancarios();
SHOW EVENTS;
call GenerarFicherosBancarios();

-- opcional 
DROP PROCEDURE IF EXISTS ActualizarEstadoRecibos;
DELIMITER $$
CREATE PROCEDURE ActualizarEstadoRecibos()
BEGIN
    -- Variables para almacenar datos del archivo de pagos
    DECLARE finCursor BOOLEAN DEFAULT FALSE;
    DECLARE cliente_id INT;
    DECLARE plan_id INT;
    DECLARE estado_recibo ENUM('Pagado', 'Impagado');
    
    -- Declarar cursor para recorrer los datos del archivo de pagos del banco
    DECLARE pagos_cursor CURSOR FOR
        SELECT codCli, codPlan, estadoPlan
        FROM detallePlan; 

    -- Declarar manejador para el fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCursor = TRUE;

    -- Abrir el cursor
    OPEN pagos_cursor;
    
    -- Iniciar bucle para recorrer los datos del archivo de pagos
    REPEAT
        FETCH pagos_cursor INTO cliente_id, plan_id, estado_recibo;
        
        IF NOT finCursor THEN
            UPDATE detallePlan
            SET estadoPlan = estado_recibo
            WHERE detallePlan.codCli = cliente_id AND codPlan = plan_id;
        END IF;
    UNTIL finCursor END REPEAT;

    CLOSE pagos_cursor;
END$$
DELIMITER ;

call ActualizarEstadoRecibos();
CREATE EVENT IF NOT EXISTS EventoActualizar
ON SCHEDULE 
	EVERY 1 MONTH
    STARTS CASE
			WHEN DAY(CURRENT_DATE()) > 10 THEN CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()) + 1, '-05 02:00:00') 
                ELSE CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()), '-10 02:00:00')
                
			END
	ON COMPLETION PRESERVE
DO CALL GenerarRecibosMensuales();
DROP PROCEDURE IF EXISTS generarTablasTemporales;
DELIMITER $$
CREATE PROCEDURE generarTablasTemporales()
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

                -- Insertar datos en la tabla temporal específica, evitando duplicados
                SET @sql = CONCAT('INSERT IGNORE INTO `', nomTabla, '` 
                    SELECT c.codCli, c.nombre, c.ape1cli, c.ape2cli, c.dni, c.cuentaBancaria, r.importeFinal
                    FROM Clientes c
                    JOIN Recibos r ON c.codCli = r.codCliente
                    WHERE c.codEntidad = ', codEntidades, ';');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
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
DROP PROCEDURE IF EXISTS insertarDatosTablasTemporales;
-- --------------------
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
DELIMITER $$
CREATE PROCEDURE insertarDatosTablasTemporales()
BEGIN
    DECLARE var BOOLEAN DEFAULT 0;
    DECLARE codEntidades INT;
    DECLARE nomEntidades VARCHAR(40);
    DECLARE nomTabla VARCHAR(100);

    DECLARE cur_entidades CURSOR FOR
        SELECT codEntidad, nomEntidad FROM Entidades;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var = 1;

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
            ELSE
                -- Manejo de error si el nombre de la entidad es inválido
                -- (puede registrar el error o simplemente continuar)
                SET @sql = 'SELECT "Nombre de entidad inválido" AS Error';
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
select * from tmp_Caixa;
delete  from tmp_Caixa;
-- Llamar al procedimiento para generar las tablas temporales
CALL generarTablasTemporales();
DELETE FROM nombreEntidades;
SELECT * FROM nombreEntidades;
DROP TABLE nombreEntidades;
-- procedimiento de generar los ficheros
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
SELECT * FROM nombreEntidades;

SELECT *  FROM t;
SELECT * FROM tmp_Caixa;
call GenerarFicheros();