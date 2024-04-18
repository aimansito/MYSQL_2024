-- simulacion examen
-- En el procedimiento NuevoPromo cuyo código puedes ver a continuación, 
-- añade lo que consideres oportuno para que se garantice el acceso adecuado 
-- a la base de datos por más de un usuario a la vez. Además, 
-- asegurate que en caso de producirse un error inesperado, se deshicidera todo. 
use ventapromoscompleta;
-- Crear el trigger en la tabla Productos_Promociones
DELIMITER $$
CREATE TRIGGER verificar_precio_promocionado
BEFORE INSERT ON Productos_Promociones
FOR EACH ROW
BEGIN
    DECLARE precio_habitual DECIMAL(10, 2);

    -- Obtener el precio habitual del producto a partir de la tabla Productos
    SELECT precio_habitual
    INTO precio_habitual
    FROM Productos
    WHERE id = NEW.id_producto;

    -- Verificar que el precio promocionado sea menor que el precio habitual
    IF NEW.precio_promocionado >= precio_habitual THEN
        -- Si el precio promocionado es mayor o igual al precio habitual, lanzar un error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El precio promocionado debe ser menor que el precio habitual.';
    END IF;
END $$
DELIMITER ;
use empresaclase;
select nomde from departamentos;
show index from departamentos;

select presude from departamentos;
drop index presupuestoDepto on departamentos;

create index presupuestoDepto on departamentos(presude);