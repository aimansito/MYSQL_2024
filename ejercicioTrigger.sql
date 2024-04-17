
-- trigger 
-- ej 1 
use ventapromoscompleta;
-- Crear un trigger que se activa antes de insertar una nueva venta
DELIMITER $$
CREATE TRIGGER verificarStockVenta
BEFORE INSERT ON articulos
FOR EACH ROW
BEGIN
    DECLARE stock_disponible INT;
    SELECT stock INTO stock_disponible FROM articulos WHERE refart = NEW.refart;

    IF NEW.stock > stock_disponible THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para esta venta';
    END IF;
END $$
DELIMITER ;

-- ej 2 
DELIMITER $$
CREATE TRIGGER verificarStockVentaBajada
BEFORE INSERT ON articulos
FOR EACH ROW
BEGIN
    DECLARE stock_disponible INT;
    SELECT stock INTO stock_disponible FROM articulos WHERE refart = NEW.refart;

    IF NEW.stock > stock_disponible THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para esta venta';
    ELSE
        -- Actualizar el stock después de la venta
        SET stock_disponible = stock_disponible - NEW.stock;
        UPDATE articulos SET stock = stock_disponible WHERE refart = NEW.refart;
    END IF;
END $$
DELIMITER ;
-- ej3
DELIMITER //
CREATE TRIGGER pedidoAutomatico
AFTER UPDATE ON articulos
FOR EACH ROW
BEGIN
    DECLARE stock_minimo INT;
    SET stock_minimo = 5; -- Define el umbral de stock mínimo para realizar el pedido

    IF NEW.stock < stock_minimo THEN
	INSERT INTO pedidos_pendientes (refart, cantidad) VALUES (NEW.refart, stock_minimo - NEW.stock);
    END IF;
END;
//
DELIMITER ;