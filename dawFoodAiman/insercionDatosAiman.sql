INSERT INTO TPV (ubicacion, fechaHora, contraseña)
VALUES
('Estepona', '2024-05-24 00:00:00', '1234'),
('Marbella', '2024-05-24 00:30:00', '5678');

INSERT INTO Ticket (numPedido, importeTotal, fechaHora, idTPV)
VALUES
(1001, 150.75, '2024-05-24 12:00:00', 1),
(1002, 89.50, '2024-05-24 12:30:00', 2);

INSERT INTO tipoProducto (nomCat, tipoProdDescripcion)
VALUES
('COMIDAS', 'Pasta'),
('BEBIDAS', 'Refrescos'),
('POSTRES', 'Pasteles');

INSERT INTO Producto (IVA, precio, stock, descripcion, codTipoProducto)
VALUES
('21', 19.99, 100, 'Pizza', 1),
('10', 1.50, 200, 'Coca-Cola', 2),
('21',3.50,100,'Bizcocho de chocolate',3);

INSERT INTO detalleTicket (cantidadProducto, idTicket, idProducto)
VALUES
(2, 1, 1),
(3, 1, 2),
(1, 2, 1),
(4, 2, 2);