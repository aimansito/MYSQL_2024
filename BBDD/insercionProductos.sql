USE DawFoodTomas1;
-- Creacion de las categorias y subcategorias de los productos
-- Cuando creo los productos le añado descripciones como ensalada cesar por ejemplo. 
INSERT INTO tipoproducto (nomCategoria, descripcionCategoria)
VALUES ('COMIDA', 'Ensalada'),
	   ('COMIDA', 'Pastas'),
       ('COMIDA', 'Carnes'),
       
       ('BEBIDA', 'Refrescos'),
	   ('BEBIDA', 'Vinos'),
       ('BEBIDA', 'Alcohol'),
       
       ('POSTRE', 'Tartas');
       
-- Creacion de los productos
INSERT INTO productos (precio, stock, IVA, descripcion, IdTipoProducto)
VALUES 
    (10.99, 50, 10.00, 'Ensalada César', 1),
    (12.50, 40, 10.00, 'Spaghetti Bolognese', 2),
    (15.00, 30, 10.00, 'Filete de Ternera', 3),
    
    (2.50, 100, 21.00, 'Coca Cola', 4),
    (18.00, 60, 21.00, 'Vino Tinto', 5),
    (7.00, 80, 21.00, 'Roncola', 6),
    
    (5.50, 20, 10.00, 'Tarta de Queso', 7);


       
       
       



