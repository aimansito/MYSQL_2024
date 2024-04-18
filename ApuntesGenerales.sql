-- ENUM y SET
-- set , puedes tener varias opciones , no estas limitado a coger una 
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    preferencias_contacto SET('email', 'teléfono', 'SMS', 'correo postal')
);
-- enum 
-- enum, solo puede contener un valor de los asignados
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estado ENUM('pendiente', 'en proceso', 'completado')
);
-- Crea una tabla de candidatos a una beca erasmus en la que almacenamos los datos
-- personales de los candidatos, una dirección de correo electrónico y un teléfono de contacto y los
-- idiomas que habla cada uno de ellos (podría ser más de uno entre los que se hablan en la UE) y el
-- nivel medio con el que habla lenguas extranjeras (solo un valor).
create table candidatos(
	nombre varchar(30) primary key,
    apellidos varchar(50),
    email varchar(100),
    tlf char(9),
    idiomas set ('español','inglés','francés'),
    nivel enum('medio','avanzado','baja')
	);
    
-- operadores lógicos
-- ALL, ANY, SOME
-- AND, OR, NOT, 
-- BETWEEN, EXISTS, IN, LIKE, RLIKE, REGEXP
-- Apuntes Triggers y Eventos

-- Triggers: Paso por paso
/*
delimiter $$
Create Trigger (nombre del trigger)
[cuando saltará] before o after + insert, update o delete 
ON (nombre de la tabla donde actua) 
for each row 
begin
[aquí se declara alguna var si se tiene que usar]
if (condición) then
begin

end;

end if;
end$$

delimiter ;
*/
-- EJEMPLO
/*
signals con 01xxx provocan warnings
signals con otro provoca errores
*/
drop trigger mitrigger;
DELIMITER $$
CREATE TRIGGER mitrigger BEFORE UPDATE ON departamentos
FOR EACH ROW
BEGIN
-- 	DECLARE numero int;
	if (new.presude < old.presude) then
		begin
			set new.presude = old.presude;
            -- SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'El presupuesto no se modificará';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El presupuesto no se modificará';
		end;
	end if;
END $$
DELIMITER ;

UPDATE departamentos 
SET 
    presude = 100
WHERE
    numde = 112;
    
    
/*
EVENTOS PASO A PASO

delimiter $$
create event (nombre)
on schedule
	every (numero) (unidad temporal)
    starts '(fecha de inicio)'
    ends (fecha de fin)
do
	begin
		(llamada a un método o código)
    end $$
    
delimiter ;
*/

-- EJEMPLO
delimiter $$
create procedure subirSueldoAnti()
BEGIN
    UPDATE empleados
    SET salarem = salarem * 1.0005; -- Aumentar el salario en un 0.05%
END $$
DELIMITER ;

delimiter $$
	drop event if exists subidaAntiguedad $$
    create event subidaAntiguedad
    on schedule
    every 1 year
    starts '2023-01-01'
    
    do
		begin
			call subirSueldoAnti();       
        end $$
delimiter ;

-- REGEX
/*
[not] Like -> es el operador básico para usar regexs
% es como el * del sistema operativo -> Es cualquier cadena
_ es como el ? del sistema operativo -> Cualquier caracter
^ -> cadenas que empiecen por un caracter determinado
$ -> cadenas que terminen por un caracter determinado
(a|b|c) -> | separa las opciones es como poner o
[0-9] números del 0 al 9
^[XY] que empiece por X o Y
^ dentro del corchete sirve para negar
[]{n} -> Siendo n el número de coincidencias del caracter dentro del corchete
*/

/*
^: Representa el inicio de una cadena.
$: Representa el final de una cadena.
.: Representa cualquier carácter individual.
[]: Representa un conjunto de caracteres permitidos.
*: Representa cero o más repeticiones del carácter anterior.
+: Representa una o más repeticiones del carácter anterior.
?: Representa cero o una repetición del carácter anterior.
*/

select * from empleados
where nomem regexp '^c';

-- Aquí hay algunos puntos clave sobre la cláusula UNION:

-- Número de columnas: Las consultas que se combinan con UNION deben tener el mismo número de columnas y los tipos de datos de las columnas deben ser compatibles.

-- Eliminación de duplicados: Por defecto, UNION eliminará las filas duplicadas del conjunto de resultados combinado. Si deseas incluir todas las filas, incluidas las duplicadas, puedes utilizar UNION ALL.

-- Orden de las filas: El orden de las filas en el conjunto de resultados combinado no está garantizado a menos que utilices la cláusula ORDER BY al final de la consulta.

SELECT producto, cantidad, fecha
FROM ventas_enero
UNION
SELECT producto, cantidad, fecha
FROM ventas_febrero;
-- sentencia unique 
ALTER TABLE Empleados
ADD CONSTRAINT unique_nombre_apellido UNIQUE (nombre, apellido);
