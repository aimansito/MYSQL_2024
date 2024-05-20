-- Apartado A
DROP PROCEDURE IF EXISTS GenerarRecibosMensuales;
DELIMITER $$
CREATE PROCEDURE GenerarRecibosMensuales()
BEGIN
    DECLARE finCursor BOOLEAN DEFAULT FALSE;
    DECLARE cliente_id INT;
    DECLARE importe DOUBLE;
    DECLARE fechaAlta DATE;
    DECLARE maxRecibo INT;
    DECLARE fecha_recibo DATETIME;
    DECLARE numDias INT;

    DECLARE cliente_cursor CURSOR FOR
        SELECT Clientes.codCli, PlanProducto.importe, detallePlan.fecAltaPlan
        FROM Clientes 
        JOIN detallePlan ON Clientes.codCli = detallePlan.codCli
        JOIN PlanProducto ON detallePlan.codPlan = PlanProducto.codPlan
        WHERE detallePlan.estadoPlan = 'Pagado' 
          AND detallePlan.fecAltaPlan <= CURRENT_DATE()
          AND (detallePlan.fecBajaPlan IS NULL OR detallePlan.fecBajaPlan >= CURRENT_DATE());

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCursor = TRUE;

    OPEN cliente_cursor;
    FETCH cliente_cursor INTO cliente_id, importe, fechaAlta;

    REPEAT
        IF NOT finCursor THEN
            SET fecha_recibo = CURRENT_DATE();
            SELECT IFNULL(MAX(codRecibo), 0) + 1 INTO maxRecibo FROM Recibos;

            SET numDias = DATEDIFF(CURRENT_DATE(), fechaAlta);
            IF numDias <= 35 THEN
                SET importe = (importe / 30) * (numDias - 5);
                else
					set importe = importe;
            END IF;

            INSERT INTO Recibos (codRecibo, fecRecibo, importeFinal, pagado, codCliente)
            VALUES (maxRecibo, fecha_recibo, importe, FALSE, cliente_id);

            FETCH cliente_cursor INTO cliente_id, importe, fechaAlta;
        END IF;
    UNTIL finCursor END REPEAT;
    CLOSE cliente_cursor;
END$$
DELIMITER ;
call GenerarRecibosMensuales();