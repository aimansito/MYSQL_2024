-- simulacro tema 8-9

use ventapromoscompleta;

-- ej 1
DROP TRIGGER IF EXISTS ej1 
DELIMITER $$
CREATE TRIGGER ej1
BEFORE INSERT ON catalogospromos
FOR EACH ROW 
BEGIN
	DECLARE precioHabitual decimal (5,2);
    SELECT precioventa into precioHabitual from articulos where refart = new.refart;
	IF(new.precioartpromo >= articulos.precioventa) then
		signal sqlstate '70000' set message_text = 'El precio no puede ser mayor ni igual al precio habitual ';
    END IF;
END $$
DELIMITER ;
