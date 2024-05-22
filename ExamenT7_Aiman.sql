-- Examen de Aiman Harrar Daoud 1ºDAW
 USE GBDgestionaTests;
 -- ej1 

ALTER TABLE tests modify column descrip varchar(30) unique;
 -- ej2
CREATE INDEX ej2 
	ON materias(nommateria(3));
SHOW INDEX FROM materias;
SELECT * 
FROM materias USE INDEX(ej2) 
WHERE nommateria rlike 'MAT';
 -- ej3
 ALTER TABLE preguntas modify column resvaLida ENUM('A','B','C');
 -- ej4 
 ALTER TABLE preguntas modify column resvalida SET('A','B','C');
 -- ej5 
 
 -- A)
DROP PROCEDURE IF EXISTS incrementaNotas;
DELIMITER $$
CREATE PROCEDURE incrementaNotas()
BEGIN
	UPDATE matriculas
	SET nota = nota + 1
	WHERE numexped IN (SELECT numexped
					   FROM respuestas
                       WHERE respuestas.codmateria = matriculas.codmateria
					   GROUP BY numexped
					   HAVING count(DISTINCT codtest) >= 10); 
END $$
DELIMITER ;
-- B 
DROP EVENT IF EXISTS evento_incrementaNotas;
CREATE EVENT evento_incrementaNotas
ON SCHEDULE every 1 year 
	STARTS '2024/06/20' + interval 1 day
	ENDS   '2024/06/20' + interval 10 year
DO CALL incrementaNotas(); 
show events;

 -- ej6
DROP TRIGGER IF EXISTS ej6;
DELIMITER $$
CREATE TRIGGER ej6
BEFORE UPDATE on matriculas
FOR EACH ROW
BEGIN
	IF (old.nota <> new.nota and new.nota > 10) THEN
    BEGIN
		set new.nota = 10;
        signal sqlstate '01000' 
			set message_text = 'la nota asignada es un 10 debido a que no puede ser superior';
    END;
    END IF;
END $$
DELIMITER ; 
-- ej7
-- A
SELECT numexped
FROM alumnos 
WHERE nomuser rlike '^[^0-9]([a-z]+)([0-9]+)([=_?!]+)(.{6}.*)'
ORDER BY numexped;
-- B 
SELECT * 
FROM alumnos
WHERE email rlike ".+@.+([.][a-z]{2,3})$";
-- C
SELECT *
FROM alumnos
WHERE telefono rlike '^[679][0-9]{2} [0-9]{3} [0-9]{3}';
-- ej8
DROP TRIGGER IF EXISTS ej8;
DELIMITER $$
CREATE TRIGGER ej8
BEFORE UPDATE ON preguntas
FOR EACH ROW 
BEGIN
	if old.resa <> new.resa or old.resb <> new.resb or old.resc <> new.resc
		and (new.resa = new.resb or new.resb = new.resc or new.resa = new.resc) then
	begin
		
		signal sqlstate '70000' set message_text = 'No puede haber dos respuestas iguales en la misma pregunta';
        
    end;
    end if;

END $$
DELIMITER ; 
-- ej9
DROP VIEW IF EXISTS ej9;
CREATE VIEW ej9
	(codtest,descrip,nommateria,numpreg,nomexped)
AS
	SELECT tests.codtest,tests.descrip,materias.nommateria,preguntas.numpreg,count(alumnos.numexped)
    FROM tests
    LEFT JOIN preguntas on tests.codtest = preguntas.codtest and tests.codtest = preguntas.numpreg
    LEFT JOIN materias on tests.codmateria = materias.codmateria
    LEFT JOIN matriculas on materias.codmateria = matriculas.codmateria and materias.codmateria = matriculas.numexped
    LEFT JOIN alumnos on matriculas.numexped = alumnos.numexped and matriculas.codmateria = alumnos.numexped
    -- WHERE alumnos.numexped IN (SELECT respuestas.numexped
	-- 				   FROM respuestas
                       -- WHERE respuestas.codtest = matriculas.codtest
		-- 			   GROUP BY alumnos.numexped
		-- 			   HAVING count(DISTINCT codtest) >1)
    GROUP BY codtest;
    ;
    
SELECT * FROM ej9;

create view misTests
(codigo, descripcion, materia, numpreguntas, numalumnos)
as
	select tests.codtest, tests.descrip, materias.nommateria, count(distinct respuestas.codpregunta), count(distinct respuestas.numexped)
    from (tests join materias on tests.codmateria = materias.codmateria)
		left join respuestas on tests.codtest=respuestas.codtest)
    group by tests.codtest, tests.descrip, materias.nommateria;