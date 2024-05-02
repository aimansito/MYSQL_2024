/*
Prepara un procedimiento que dado un alumno (su número de expediente) nos de un listado mostrando el número de respuestas válidas de dicho alumno por materia (nombre de materia) y test (código y descripción de test), vamos a utilizar las respuestas correspondientes a la última repetición de cada test y solo nos interesan los tests de los que haya más de una repetición, es decir, aquellos que el alumno haya hecho más de una vez. 
Haz lo mismo que en el apartado anterior, pero ahora prepara un objeto en el que podamos ver lo anterior para cada alumno y consultarlo cuando deseemos.
*/
-- AIMAN HARRAR DAOUD 
-- ej 1
use GBDgestionaTests; 
DROP PROCEDURE IF EXISTS ej1;
DELIMITER $$
CREATE PROCEDURE ej1
	(IN numero char(12)) -- Cambié el tipo de dato a char(12) para coincidir con el tipo de `respuestas.numexped`
BEGIN
	 SELECT
        
        materias.nommateria AS nombre_materia,
        tests.codtest AS codigo_test,
        tests.descrip AS descripcion_test,
        COUNT(DISTINCT respuestas.respuesta) AS numero_respuestas_validas
    FROM respuestas
    JOIN preguntas ON respuestas.codtest = preguntas.codtest AND respuestas.numpreg = preguntas.numpreg
    JOIN tests ON preguntas.codtest = tests.codtest
    JOIN materias ON tests.codmateria = materias.codmateria
    WHERE respuestas.numexped = numero
        AND respuestas.respuesta = preguntas.resvalida
        AND respuestas.numrepeticion = (
            SELECT MAX(sub_respuestas.numrepeticion)
            FROM respuestas AS sub_respuestas
            WHERE sub_respuestas.numexped = numero
                AND sub_respuestas.codtest = respuestas.codtest AND sub_respuestas.numpreg = respuestas.numpreg
      --  AND EXISTS (
        --    SELECT 1
          --  FROM respuestas AS sub_respuestas
           -- WHERE sub_respuestas.numexped = numero
             --   AND sub_respuestas.codtest = respuestas.codtest
               -- AND COUNT(DISTINCT sub_respuestas.numrepeticion) > 1
        )
        group by materias.nommateria, respuestas.codtest;
    -- GROUP BY materias.nommateria, tests.codtest, tests.descrip;
END $$
DELIMITER ;


call ej1(12);

-- ej2
DROP VIEW IF EXISTS ej2;

CREATE VIEW ej2 AS
SELECT
    distinct(respuestas.numexped) AS numero_expediente,
    materias.nommateria AS nombre_materia,
    tests.codtest AS codigo_test,
    tests.descrip AS descripcion_test,
    COUNT(DISTINCT respuestas.numrepeticion) AS numero_respuestas_validas
FROM respuestas
JOIN preguntas ON respuestas.codtest = preguntas.codtest AND respuestas.numpreg = preguntas.numpreg
JOIN tests ON preguntas.codtest = tests.codtest
JOIN materias ON tests.codmateria = materias.codmateria
WHERE respuestas.numexped IN (
    SELECT DISTINCT numexped
    FROM respuestas
    GROUP BY numexped, codtest
    HAVING COUNT(DISTINCT numrepeticion) >= 1
)
AND respuestas.numrepeticion = (
    SELECT MAX(numrepeticion)
    FROM respuestas
    WHERE respuestas.numexped = respuestas.numexped
    GROUP BY codtest
)
GROUP BY respuestas.numexped, materias.nommateria, tests.codtest, tests.descrip;

SELECT * FROM ej2;
