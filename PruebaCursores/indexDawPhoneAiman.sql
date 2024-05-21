use dawPhoneAiman;
-- index 
DROP INDEX indexEntidad ON Clientes;
-- Necesitamos asegurarnos que las búsquedas de clientes por entidad bancaria sean eficientes. 
CREATE INDEX indexEntidad ON Clientes(codCli,nombre,codEntidad);
SHOW INDEX FROM Clientes; 

SELECT *
FROM Clientes USE INDEX(indexEntidad)	
WHERE codEntidad=4;