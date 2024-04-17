DROP PROCEDURE IF EXISTS InsertaEmpleados;
DELIMITER $$
CREATE PROCEDURE InsertaEmpleados(
    OUT out_numem INT, 
    IN numde INT, 
    IN extelem INT, 
    IN fecnaem DATE, 
    IN fecinem DATE, 
    IN salarem FLOAT, 
    IN comisem DOUBLE, 
    IN numhiem INT, 
    IN nomem VARCHAR(50), 
    IN ape1em VARCHAR(50), 
    IN ape2em VARCHAR(50), 
    IN dniem VARCHAR(9), 
    IN userem VARCHAR(10), 
    IN paseem INT
)
BEGIN
    DECLARE numMax INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    ROLLBACK;

    START TRANSACTION;

    SET numMax = (SELECT MAX(numem) FROM empleados) + 1;

    INSERT INTO empleados 
    (numem, numde, extelem, fecnaem, fecinem, salarem, comisem, numhiem, nomem, ape1em, ape2em, dniem, userem, passem)
    VALUES
    (numMax, numde, extelem, fecnaem, fecinem, salarem, comisem, numhiem, nomem, ape1em, ape2em, dniem, userem, paseem);

    COMMIT;

    SET out_numem = numMax;
END$$
DELIMITER ;
