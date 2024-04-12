
use dawFoodAiman;
CREATE TABLE TPV
(
  idTPV INT NOT NULL,
  ubicacion varchar(100) NOT NULL,
  fechaHora datetime NOT NULL,
  listaTicketVentas varchar(100) NOT NULL,
  Constraint pk_tpv PRIMARY KEY (idTPV)
);

CREATE TABLE Ticket
(
  idTicket INT NOT NULL,
  numPedido INT NOT NULL,
  listaProducto varchar(100) NOT NULL,
  importeTotal decimal(6,2) NOT NULL,
  fechaHora datetime NOT NULL,
  idTPV INT NOT NULL,
  Constraint pk_ticket PRIMARY KEY (idTicket),
  Constraint fk_ticket_tpv FOREIGN KEY (idTPV) REFERENCES TPV(idTPV)
);

CREATE TABLE tipoProducto
(
  tipoCat INT NOT NULL,
  codTipoProducto INT NOT NULL,
  subCategorias INT NOT NULL,
  constraint pk_tipoprod PRIMARY KEY (codTipoProducto)
);

CREATE TABLE Producto
(
  idProducto INT NOT NULL,
  IVA enum('21','10') NOT NULL,
  precio decimal(6,2) NOT NULL,
  stock INT NOT NULL,
  descripcion varchar(50) NOT NULL,
  codTipoProducto INT NOT NULL,
  constraint pk_prod PRIMARY KEY (idProducto),
  constraint fk_prod_tipoProd FOREIGN KEY (codTipoProducto) REFERENCES tipoProducto(codTipoProducto)
);

CREATE TABLE detalleTicket
(
  cantidadProducto INT NOT NULL,
  idTicket INT NOT NULL,
  idProducto INT NOT NULL,
  Constraint pk_detalleTicket PRIMARY KEY (cantidadProducto),
  Constraint fk_detalleTicket_ticket FOREIGN KEY (idTicket) REFERENCES Ticket(idTicket),
  Constraint fk_detalleTicket_prod FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);