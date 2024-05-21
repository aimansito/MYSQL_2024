-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 192.168.1.170    Database: dawPhoneAiman
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.20.04.1
create database if not exists dawPhoneAiman;
use dawPhoneAiman;
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
INSERT INTO `Entidades` VALUES (1,'Caixa','29680','Calle 1'),(2,'Sabadell','29680','Calle 2'),(3,'Santander','29680','Calle 3'),(4,'CajaRural','29680','Calle 4'),(5,'Unicaja','29680','Avenida 5');
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-21 14:40:15
