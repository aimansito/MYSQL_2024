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
		(IN numero int)
BEGIN
	SELECT respuestas.numexped,count(resvalida), materias.nommateria, tests.codtest, tests.descrip
    FROM preguntas 
    JOIN respuestas ON preguntas.codtest = respuestas.codtest
   	 and preguntas.codtest = respuestas.numexped 
		and preguntas.codtest = respuestas.numpreg 
			and preguntas.numpreg = respuestas.codtest 
				and preguntas.numpreg = respuestas.numexped 
					and preguntas.numpreg = respuestas.numexped
    JOIN tests ON preguntas.codtest = tests.codtest and preguntas.numpreg = tests.codtest
	JOIN materias on tests.codmateria = materias.codmateria
    WHERE respuestas.numexped = numero and numrepeticion in (select max(numrepeticion) from respuestas)
    GROUP BY materias.nommateria, tests.codtest, tests.descrip
    HAVING count(DISTINCT respuestas.numrepeticion) >1;
END $$
DELIMITER ;

call ej1(1);

-- ej2
DROP VIEW IF EXISTS ej2;
CREATE VIEW ej2
	(numexped,resvalida,nommateria,codtest,descrip,numexped)
AS
	SELECT numexped,respuestas.numexped,count(resvalida), materias.nommateria, tests.codtest, tests.descrip
    FROM preguntas 
    JOIN respuestas ON preguntas.codtest = respuestas.codtest
   	 and preguntas.codtest = respuestas.numexped 
		and preguntas.codtest = respuestas.numpreg 
			and preguntas.numpreg = respuestas.codtest 
				and preguntas.numpreg = respuestas.numexped 
					and preguntas.numpreg = respuestas.numexped
    JOIN tests ON preguntas.codtest = tests.codtest and preguntas.numpreg = tests.codtest
	JOIN materias on tests.codmateria = materias.codmateria
    WHERE numrepeticion in (select max(numrepeticion) from respuestas)
    GROUP BY materias.nommateria, tests.codtest, tests.descrip
    HAVING count(DISTINCT respuestas.numrepeticion) >1;
    ;
SELECT * FROM ej2;