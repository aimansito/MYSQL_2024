use dawPhoneAiman;
-- index 
CREATE INDEX indexEntidad ON Clientes(codCli,codEntidad);
SHOW INDEX FROM Clientes; 

SELECT codCli
FROM Clientes USE INDEX(indexEntidad)	
WHERE codEntidad=1;