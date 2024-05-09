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
        Constraint pk_planProducto PRIMARY KEY (codPlan)
        );
        
CREATE TABLE IF NOT EXISTS Clientes
		(
        codCli int not null,
        nombre varchar(40) not null,
        ape1cli varchar(50) ,
        cuentaBancaria varchar(100) not null,
        correo varchar(100) not null,
        fechaNac date not null,
        dni varchar(9) not null,
        fecAltaPlan date not null,
        codEntidad int not null,
        Constraint pk_clientes PRIMARY KEY(codCli),
        Constraint fk_clientes_entidad FOREIGN KEY(codEntidad) references Entidades(codEntidad)
        );
        
CREATE TABLE IF NOT EXISTS Recibos 
		(
        codRecibo int not null,
        fecRecibo datetime not null,
        importeFinal double not null,
        pagado boolean not null,
        codCliente int not null,
        constraint pk_recibos PRIMARY KEY (codRecibo),
        constraint fk_recibos_clientes FOREIGN KEY (codCliente) references Clientes(codCli)
        );
CREATE TABLE IF NOT EXISTS detallePlan
		(
        codCli int not null,
        codPlan int not null,
		estadoPlan ENUM('Pagado','Impagado'),
        fecAltaPlan date not null,
        fecBajaPlan date not null,
		PRIMARY KEY (codCli, codPlan),
		FOREIGN KEY (codCli) REFERENCES Clientes(codCli),
		FOREIGN KEY (codPlan) REFERENCES PlanProducto(codPlan) 
        );
        
        
-- index 
CREATE INDEX indexEntidad ON Clientes(codEntidad);
SHOW INDEX FROM Clientes; 

SELECT codEntidad
FROM indexEntidad;