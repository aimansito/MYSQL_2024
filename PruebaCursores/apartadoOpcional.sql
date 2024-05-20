DROP PROCEDURE IF EXISTS ActualizarEstadoRecibos;
DELIMITER $$
CREATE PROCEDURE ActualizarEstadoRecibos()
BEGIN
    DECLARE finCursor BOOLEAN DEFAULT FALSE;
    DECLARE cliente_id INT;
    DECLARE plan_id INT;
    DECLARE estado_recibo ENUM('Pagado', 'Impagado');
    
    DECLARE pagos_cursor CURSOR FOR
        SELECT codCli, codPlan, estadoPlan
        FROM detallePlan; 

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCursor = TRUE;

    OPEN pagos_cursor;
    
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