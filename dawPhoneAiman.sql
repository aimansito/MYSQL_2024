-- Creacion BADAT Proyecto 
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
        Constraint pk_planProducto PRIMARY KEY (PlanProducto)
        );