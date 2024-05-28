drop database if exists dawFoodAiman;
create database dawFoodAiman;
use dawFoodAiman;
CREATE TABLE TPV
(
  idTPV INT auto_increment  NOT NULL,
  ubicacion varchar(100) NOT NULL,
  fechaHora datetime NOT NULL,
  contraseña varchar(8) not null,
  Constraint pk_tpv PRIMARY KEY (idTPV)
);

CREATE TABLE Ticket
(
  idTicket INT auto_increment NOT NULL,
  numPedido INT NOT NULL,
  importeTotal decimal(5,2) NOT NULL,
  fechaHora datetime NOT NULL,
  idTPV INT NOT NULL,
  Constraint pk_ticket PRIMARY KEY (idTicket),
  Constraint fk_ticket_tpv FOREIGN KEY (idTPV) REFERENCES TPV(idTPV)
);

CREATE TABLE tipoProducto
(
  codTipoProducto INT auto_increment NOT NULL,
  nomCat enum('COMIDAS','BEBIDAS','POSTRES') NOT NULL,
  tipoProdDescripcion varchar(100) NOT NULL,
  constraint pk_tipoprod PRIMARY KEY (codTipoProducto)
);

CREATE TABLE Producto
(
  idProducto INT auto_increment NOT NULL,
  IVA enum('21','10') NOT NULL,
  precio decimal(6,2) NOT NULL,
  stock INT default 0,
  descripcion varchar(100) NOT NULL,
  codTipoProducto INT NOT NULL,
  constraint pk_prod PRIMARY KEY (idProducto),
  constraint fk_prod_tipoProd FOREIGN KEY (codTipoProducto) REFERENCES tipoProducto(codTipoProducto)
);

DROP TABLE detalleTicket;
CREATE TABLE detalleTicket
(
  idTicket INT NOT NULL,
  idProducto INT NOT NULL,
  cantidadProducto INT NOT NULL,
  CONSTRAINT pk_detalleTicket PRIMARY KEY (idTicket, idProducto),
  CONSTRAINT fk_detalleTicket_ticket FOREIGN KEY (idTicket) REFERENCES Ticket(idTicket),
  CONSTRAINT fk_detalleTicket_prod FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

-- triggers 
DROP TRIGGER IF EXISTS control_stock;
DELIMITER $$ 
CREATE TRIGGER control_stock 
BEFORE INSERT ON detalleTicket 
FOR EACH ROW 
BEGIN 
	 DECLARE stock_actual INT; -- creamos una variable en la que se almacenará el stock actual
	 SELECT stock INTO stock_actual 
	 FROM Producto
	 WHERE idProducto = NEW.idProducto; 
	 IF NEW.cantidadProducto > stock_actual THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock'; 
	 END IF; 
END;$$
DELIMITER ;

DELIMITER $$ 
CREATE TRIGGER decrementoStock 
AFTER INSERT ON detalleTicket
FOR EACH ROW 
	BEGIN DECLARE stock_actual INT; -- creamos una variable en la que se almacenará el stock actual 
    SELECT stock INTO stock_actual 
    FROM Producto 
    WHERE codProducto = NEW.Producto.codProducto; 
	IF NEW.cantidadProducto > stock_actual THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock'; 
            ELSE UPDATE Producto SET stock = stock - NEW.cantidadProducto WHERE Producto.codProducto = NEW.Producto.codProducto; 
	END IF; 
END;$$ 
DELIMITER ;
