-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 192.168.1.170    Database: dawPhoneAiman
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Clientes`
--

DROP TABLE IF EXISTS `Clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clientes` (
  `codCli` int NOT NULL,
  `nombre` varchar(40) NOT NULL,
  `ape1cli` varchar(50) NOT NULL,
  `ape2cli` varchar(70) DEFAULT NULL,
  `cuentaBancaria` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `fechaNac` date NOT NULL,
  `dni` varchar(9) NOT NULL,
  `codEntidad` int NOT NULL,
  PRIMARY KEY (`codCli`),
  KEY `fk_clientes_entidad` (`codEntidad`),
  KEY `indexEntidad` (`codCli`,`codEntidad`),
  CONSTRAINT `fk_clientes_entidad` FOREIGN KEY (`codEntidad`) REFERENCES `Entidades` (`codEntidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clientes`
--

LOCK TABLES `Clientes` WRITE;
/*!40000 ALTER TABLE `Clientes` DISABLE KEYS */;
INSERT INTO `Clientes` VALUES (1,'Luis','Hernández','Martínez','ES5432167890543216789054','luis@gmail.com','1987-09-12','56789012F',1),(2,'Sofía','Sánchez','García','ES9876543210987654321098','sofia@gmail.com','1993-04-18','67890123G',2),(3,'Elena','Martín','López','ES1357924680135792468013','elena@gmail.com','1980-11-30','78901234H',3),(4,'Carlos','García','Fernández','ES1234567890123456789012','carlos@gmail.com','1998-02-25','89012345I',4),(5,'Laura','Díaz','Pérez','ES2468013579246801357924','laura@gmail.com','1991-06-07','90123456J',5);
/*!40000 ALTER TABLE `Clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Entidades`
--

DROP TABLE IF EXISTS `Entidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Entidades` (
  `codEntidad` int NOT NULL,
  `nomEntidad` varchar(40) DEFAULT NULL,
  `dirPostal` varchar(9) DEFAULT NULL,
  `dirEnvio` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`codEntidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Entidades`
--

LOCK TABLES `Entidades` WRITE;
/*!40000 ALTER TABLE `Entidades` DISABLE KEYS */;
INSERT INTO `Entidades` VALUES (1,'Caixa','29680','Calle 1'),(2,'Entidad B','29680','Calle 2'),(3,'Entidad C','29680','Calle 3'),(4,'Entidad D','29680','Calle 4'),(5,'Entidad E','29680','Avenida 5');
/*!40000 ALTER TABLE `Entidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PlanProducto`
--

DROP TABLE IF EXISTS `PlanProducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PlanProducto` (
  `codPlan` int NOT NULL,
  `importe` double DEFAULT NULL,
  `nombrePlan` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`codPlan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PlanProducto`
--

LOCK TABLES `PlanProducto` WRITE;
/*!40000 ALTER TABLE `PlanProducto` DISABLE KEYS */;
INSERT INTO `PlanProducto` VALUES (1,100.5,'Netflix'),(2,75.25,'Amazon Prime'),(3,150.75,'Dazn'),(4,200,'Movistar Plus'),(5,50,'Netflix');
/*!40000 ALTER TABLE `PlanProducto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Recibos`
--

DROP TABLE IF EXISTS `Recibos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Recibos` (
  `codRecibo` int NOT NULL,
  `fecRecibo` datetime NOT NULL,
  `importeFinal` double NOT NULL,
  `pagado` tinyint(1) DEFAULT NULL,
  `codCliente` int NOT NULL,
  PRIMARY KEY (`codRecibo`),
  KEY `fk_recibos_clientes` (`codCliente`),
  CONSTRAINT `fk_recibos_clientes` FOREIGN KEY (`codCliente`) REFERENCES `Clientes` (`codCli`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Recibos`
--

LOCK TABLES `Recibos` WRITE;
/*!40000 ALTER TABLE `Recibos` DISABLE KEYS */;
INSERT INTO `Recibos` VALUES (1,'2024-05-12 08:00:00',50,1,1),(2,'2024-05-12 09:15:00',75.25,1,2),(3,'2024-05-12 10:30:00',100.5,0,3),(4,'2024-05-12 11:45:00',200,1,4),(5,'2024-05-12 13:00:00',150.75,0,5),(6,'2024-05-20 05:00:00',100.5,0,1),(7,'2024-05-20 05:00:00',75.25,0,2),(8,'2024-05-20 05:00:00',200,0,4),(9,'2024-05-20 00:00:00',100.5,0,1),(10,'2024-05-20 00:00:00',75.25,0,2),(11,'2024-05-20 00:00:00',200,0,4);
/*!40000 ALTER TABLE `Recibos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detallePlan`
--

DROP TABLE IF EXISTS `detallePlan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detallePlan` (
  `codCli` int NOT NULL,
  `codPlan` int NOT NULL,
  `estadoPlan` enum('Pagado','Impagado','Pendiente') DEFAULT NULL,
  `fecAltaPlan` date NOT NULL,
  `fecBajaPlan` date NOT NULL,
  PRIMARY KEY (`codCli`,`codPlan`),
  KEY `codPlan` (`codPlan`),
  CONSTRAINT `detallePlan_ibfk_1` FOREIGN KEY (`codCli`) REFERENCES `Clientes` (`codCli`),
  CONSTRAINT `detallePlan_ibfk_2` FOREIGN KEY (`codPlan`) REFERENCES `PlanProducto` (`codPlan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detallePlan`
--

LOCK TABLES `detallePlan` WRITE;
/*!40000 ALTER TABLE `detallePlan` DISABLE KEYS */;
INSERT INTO `detallePlan` VALUES (1,1,'Pagado','2024-01-01','2024-12-31'),(2,2,'Pagado','2024-02-01','2024-12-31'),(3,3,'Impagado','2024-03-01','2024-12-31'),(4,4,'Pagado','2024-04-01','2024-12-31'),(5,5,'Impagado','2024-05-01','2024-12-31');
/*!40000 ALTER TABLE `detallePlan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'dawPhoneAiman'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `EventoRecibos` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`aiman33`@`192.168.1.134`*/ /*!50106 EVENT `EventoRecibos` ON SCHEDULE EVERY 1 MONTH STARTS '2024-06-05 15:00:00' ON COMPLETION PRESERVE ENABLE DO BEGIN
    CALL GenerarRecibosMensuales();
    CALL generarTablasTemporales();
    CALL insertarDatos();
    CALL ActualizarEstadoRecibos();
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'dawPhoneAiman'
--
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarEstadoRecibos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aiman33`@`192.168.1.134` PROCEDURE `ActualizarEstadoRecibos`()
BEGIN
    DECLARE finCursor BOOLEAN DEFAULT FALSE;
    DECLARE cliente_id INT;
    DECLARE plan_id INT;
    DECLARE estado_recibo ENUM('Pagado', 'Impagado');
    
    DECLARE pagos_cursor CURSOR FOR
        SELECT codCli, codPlan, estadoPlan
        FROM detallePlan; 

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCursor = TRUE;

    OPEN pagos_cursor;
    
    REPEAT
        FETCH pagos_cursor INTO cliente_id, plan_id, estado_recibo;
        
        IF NOT finCursor THEN
            UPDATE detallePlan
            SET estadoPlan = estado_recibo
            WHERE detallePlan.codCli = cliente_id AND codPlan = plan_id;
        END IF;
    UNTIL finCursor END REPEAT;

    CLOSE pagos_cursor;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `crearTablasTemporales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aiman33`@`192.168.1.134` PROCEDURE `crearTablasTemporales`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GenerarFicheros` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aiman33`@`192.168.1.134` PROCEDURE `GenerarFicheros`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GenerarRecibosMensuales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aiman33`@`192.168.1.134` PROCEDURE `GenerarRecibosMensuales`()
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
            SET fecha_recibo = CURRENT_DATE();
            SELECT IFNULL(MAX(codRecibo), 0) + 1 INTO maxRecibo FROM Recibos;

            SET numDias = DATEDIFF(CURRENT_DATE(), fechaAlta);
            IF numDias <= 35 THEN
                SET importe = (importe / 30) * (numDias - 5);
                else
					set importe = importe;
            END IF;

            INSERT INTO Recibos (codRecibo, fecRecibo, importeFinal, pagado, codCliente)
            VALUES (maxRecibo, fecha_recibo, importe, FALSE, cliente_id);

            FETCH cliente_cursor INTO cliente_id, importe, fechaAlta;
        END IF;
    UNTIL finCursor END REPEAT;
    CLOSE cliente_cursor;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `generarTablasTemporales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aiman33`@`192.168.1.134` PROCEDURE `generarTablasTemporales`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertarDatos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aiman33`@`192.168.1.134` PROCEDURE `insertarDatos`()
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
            SET nomTabla = CONCAT('tmp_', nomEntidades);
            
            -- Verificar si el nombre de la entidad no es NULL ni vacío
            IF nomTabla IS NOT NULL AND nomTabla <> '' THEN
                
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
            END IF;
            
            FETCH cur_entidades INTO codEntidades, nomEntidades;
        END;
    END WHILE;
    
    CLOSE cur_entidades;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertarDatosTablasTemporales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aiman33`@`192.168.1.134` PROCEDURE `insertarDatosTablasTemporales`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-21  0:59:16
