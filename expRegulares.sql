-- Sabiendo que los dos primeros dígitos del código postal se corresponden con la provincia 
-- y los 3 siguientes a la población dentro de esa provincia. 
-- Busca los clientes (todos sus datos) de las 9 primeras poblaciones de la provincia de Málaga (29001 a 29009).

use GBDturRural2015;
-- ej 1
SELECT *
FROM clientes
WHERE SUBSTRING(codpostalcli, 1, 5) BETWEEN '29001' AND '29009';

-- ej 2
SELECT *
FROM clientes
WHERE SUBSTRING(codpostalcli, 1, 5) BETWEEN '29001' AND '29020';
-- ej 3
SELECT *
FROM clientes
WHERE correoelectronico LIKE '%@%.com'
    OR correoelectronico LIKE '%@%.es'
    OR correoelectronico LIKE '%@%.eu'
    OR correoelectronico LIKE '%@%.net';
   
   
 -- ej4  
SELECT *
FROM clientes
WHERE correoelectronico NOT LIKE '%@%.com'
    AND correoelectronico NOT LIKE '%@%.es'
    AND correoelectronico NOT LIKE '%@%.eu'
    AND correoelectronico NOT LIKE '%@%.net'
    AND correoelectronico LIKE '%@%';
