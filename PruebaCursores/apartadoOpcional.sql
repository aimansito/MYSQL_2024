DROP PROCEDURE IF EXISTS ActualizarEstadoRecibos;
DELIMITER $$
CREATE PROCEDURE ActualizarEstadoRecibos()
BEGIN
    -- Variables para almacenar datos del archivo de pagos
    DECLARE finCursor BOOLEAN DEFAULT FALSE;
    DECLARE cliente_id INT;
    DECLARE plan_id INT;
    DECLARE estado_recibo ENUM('Pagado', 'Impagado');
    
    -- Declarar cursor para recorrer los datos del archivo de pagos del banco
    DECLARE pagos_cursor CURSOR FOR
        SELECT codCli, codPlan, estadoPlan
        FROM detallePlan; 

    -- Declarar manejador para el fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCursor = TRUE;

    -- Abrir el cursor
    OPEN pagos_cursor;
    
    -- Iniciar bucle para recorrer los datos del archivo de pagos
    REPEAT
        FETCH pagos_cursor INTO cliente_id, plan_id, estado_recibo;
        
        IF NOT finCursor THEN
            UPDATE detallePlan
            SET estadoPlan = estado_recibo
            WHERE detallePlan.codCli = cliente_id AND codPlan = plan_id;
        END IF;
    UNTIL finCursor END REPEAT;

    CLOSE pagos_cursor;
END$$
DELIMITER ;

call ActualizarEstadoRecibos();