create database Evento;
use Evento;
CREATE TABLE test(
 evento VARCHAR(50),
 fecha DATETIME 
); 
-- Lo primero que debemos de hacer es habilitar nuestro servidor para que pueda ejecutar eventos.

SET GLOBAL event_scheduler = ON;

-- Posteriormente creamos nuestro evento; En mi caso, tendrá el nombre de insertion event. 
-- Este evento se ejecutará dentro de 1 min, y lo que hará, será insertar un registro en mi tabla.
CREATE EVENT evento_insercion
ON SCHEDULE AT current_timestamp() + interval 5 minute
do insert into test VALUES('Evento 1',now());
-- para ejecutar el evento en una fecha en concreto
-- ON SCHEDULE AT '2018-12-31 12:00:00'


-- Si nuestro evento ejecutará más de una sentencia SQL debemos de apoyarnos de BEGIN y END.

DELIMITER //

CREATE EVENT insercion
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
DO
BEGIN
	INSERT INTO test VALUES ('Evento 2', NOW());
    INSERT INTO test VALUES ('Evento 3', NOW());
    INSERT INTO test VALUES ('Evento 4', NOW());
END//

DELIMITER ;
-- listar eventos
show events;
-- borrar eventos
drop event nombre_evento;
-- para que una vez ejecutado el evento no se elimine
-- ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
-- ON COMPLETION PRESERVE
