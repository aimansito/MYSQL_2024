use ventapromoscompleta;
-- ej1
--  No debe haber dos promociones activas a la vez.
DELIMITER $$
CREATE TRIGGER ejercicio1
BEFORE INSERT ON promociones
FOR EACH ROW
BEGIN 
	DECLARE numPromosActivas int;
    SET numPromosActivas = 
    (SELECT COUNT(*)
    FROM promociones
    WHERE NEW.fecinipromo BETWEEN fecinipromo AND DATE_ADD(fecinipromo, INTERVAL duracionpromo DAY)
    OR DATE_ADD(NEW.fecinipromo, INTERVAL NEW.duracionpromo DAY)
    BETWEEN fecinipromo AND DATE_ADD(fecinipromo, INTERVAL duracionpromo DAY));
    IF numPromosActivas > 0 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Error, ya hay una promocion activa';
	END IF;
END $$
DELIMITER ; 

-- ej2
-- Los artículos promocionados deben tener un precio inferior que el precio 
-- habitual de venta (el que está en la tabla artículos).
DELIMITER $$ 
DROP TRIGGER IF EXISTS ejercicio2 ;
DELIMITER $$
CREATE TRIGGER ejercicio2
BEFORE INSERT ON promociones
FOR EACH ROW 
BEGIN 
    DECLARE precio_habitual DECIMAL(5, 2);
    
    SELECT precio_venta INTO precio_habitual FROM articulos
    JOIN catalogospromos on articulos.refart = catalogospromos.refart
    WHERE refart = NEW.codpromo;
    
    IF NEW.articulos.preciobase > precio_habitual THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El precio de la promoción debe ser inferior al precio habitual de venta.';
    END IF;
END $$
DELIMITER ;
-- ej 3
--  Cuando un cliente compra artículos promocionados, se debe añadir automáticamente los puntos de dicho artículo en puntos acumulados.
DROP TRIGGER IF EXISTS ejercicio3;
DELIMITER $$
CREATE TRIGGER ejercicio3
AFTER INSERT ON articulos
FOR EACH ROW 
BEGIN 
	DECLARE puntos_promocion int default 0;
    
    -- Obtener los puntos asociados a la promoción del artículo comprado
    SELECT ptosparacli INTO puntos_promocion
    FROM catalogospromos
    WHERE refart = NEW.refart;
    
    -- Sumar los puntos de la promoción a los puntos acumulados del cliente
    UPDATE clientes
    SET ptosacumulados = ptosacumulados + puntos_promocion
    WHERE codcli = NEW.articulos.codcli;
END $$
DELIMITER ;
-- ej4 
-- Añade en clientes las columnas usuario y password.
ALTER TABLE clientes
ADD COLUMN
usuario VARCHAR(50) NULL,
ADD COLUMN 
passwd VARCHAR(50) NULL;
-- ej5
-- primero creamos la funcion
DROP FUNCTION generar_usuario
DELIMITER $$ 
CREATE FUNCTION generar_usuario(nombre VARCHAR(20), apellido1 VARCHAR(20), apellido2 VARCHAR(20))
RETURNS VARCHAR(50)
NO SQL
BEGIN
    DECLARE usuario VARCHAR(50);
    DECLARE segundo_apellido VARCHAR(3);

		SET usuario = CONCAT_WS(
        '**',
        LEFT(nombre, 1),         -- La inicial del nombre
        SUBSTRING(apellido1, 1, 5),  -- Las tres primeras letras del primer apellido más 5 caracteres cada una
        IFNULL(SUBSTRING(apellido2, 1, 5),  -- Las tres primeras letras del segundo apellido más 5 caracteres cada una (o caracteres aleatorios)
            CONCAT(CHAR(65 + FLOOR(RAND() * 26)), 
                   CHAR(65 + FLOOR(RAND() * 26)), 
                   CHAR(65 + FLOOR(RAND() * 26)))), 
        LENGTH(nombre) + LENGTH(apellido1) + IFNULL(LENGTH(apellido2), 3) -- El número total de caracteres de nombre y apellidos
    );

    RETURN usuario;
END$$
DROP TRIGGER IF EXISTS ejercicio5;
DELIMITER $$
CREATE TRIGGER ejercicio5
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN 
    DECLARE nuevo_usuario VARCHAR(50);
    
    SET nuevo_usuario = generar_usuario(NEW.nomcli, NEW.ape1cli, NEW.ape2cli);
    
    SET NEW.usuario = nuevo_usuario;
END $$
DELIMITER ; 
SELECT generar_usuario('Aiman', 'Harrar', 'Daoud') AS usuario;