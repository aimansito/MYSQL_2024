-- Eventos 
use dawPhoneAiman;
DELIMITER $$
CREATE EVENT IF NOT EXISTS EventoRecibos
	ON SCHEDULE 
	EVERY 1 MONTH
    STARTS CASE
			WHEN DAY(CURRENT_DATE()) > 5 THEN CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()) + 1,':', '-05 15:00:00') 
                ELSE CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()), ':','-05 02:00:00')
                
			END
	ON COMPLETION PRESERVE
DO 
BEGIN
    CALL GenerarRecibosMensuales();
    CALL crearTablasTemporales();
    CALL insertarDatosTablasTemporales();
    CALL ActualizarEstadoRecibos();
END$$
DELIMITER ;

SHOW EVENTS;
