-- ejercicios triggers circo
use CIRCO;
-- ej1
DELIMITER $$
CREATE TRIGGER ej1
BEFORE INSERT ON ANIMALES
FOR EACH ROW
BEGIN
	IF new.tipo='León' AND anhos = 20 THEN
     SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pueden insertar animales';
	END IF;
END $$
DELIMITER ;
-- ej 2
DROP TRIGGER IF EXISTS ej2;
DELIMITER $$
CREATE TRIGGER ej2
AFTER INSERT ON ANIMALES
FOR EACH ROW
BEGIN 
	DECLARE v_nifArtista char(9);
    DECLARE v_temp int default 0;
	-- buscamos el artista que cuida a menos animales
    SELECT nif_artista, COUNT(*) as num
    INTO v_nifArtista,v_temp
    FROM ANIMALES_ARTISTAS
    GROUP BY nif_artista
    ORDER BY num asc
    LIMIT 1; -- solo devuelve una fila 
    IF (v_nifArtista IS NULL) THEN -- quiere decir que no hay
    -- buscamos el primer artista que no sea jefe
    SELECT nif 
    INTO v_nifArtista
    FROM ARTISTAS
    WHERE nif NOT IN(SELECT nif_jefe 
						FROM ARTISTAS 
                        WHERE nif_jefe IS NOT NULL ) -- necesario ya que con valores nulos not in devuelve nulo
                        LIMIT 1;
	END IF;
    IF (V_nifArtista IS NULL) THEN -- ERROR
    -- en este caso se mantendría el animal en la tabla ya que el trigger es after , se tendria
    -- que hacer el control donde se hacer la orden de insert 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No hay artistas para cuidar animales';
	END IF;
	INSERT INTO ANIMALES_ARTISTAS
    (nombre_animal,nif_artista)
    values
    (new.nombre, v_nifArtista);
END $$
DELIMITER ;
-- ej 3
DROP TRIGGER IF EXISTS ej3;
DELIMITER $$
CREATE TRIGGER ej3
AFTER INSERT ON ATRACCION_DIA
FOR EACH ROW 
BEGIN 
	DECLARE v_fecha date;
    SELECT IFNULL(fecha_inicio,curdate())
    INTO v_fecha 
    FROM ATRACCIONES
    WHERE nombre = new.nombre_atraccion;
    
    UPDATE ATRACCIONES
    SET ganancias = IFNULL(ganancias,0) + NEW.ganancias,
    fecha_inicio = v_fecha
    WHERE nombre = new.nombre_atraccion;
END $$
DELIMITER ; 
DROP TRIGGER IF EXISTS ej3_2;
DELIMITER $$
CREATE TRIGGER ej3_2
AFTER UPDATE
ON ATRACCION_DIA 
FOR EACH ROW 
BEGIN 
	UPDATE ATRACCIONES 
    SET ganancias = ganancias + new.ganancias-old.ganancias
    where nombre = old.nombre_atraccion;
END $$
DELIMITER ; 
DELIMITER $$
CREATE TRIGGER ej3_3
AFTER DELETE ON ATRACCION_DIA
FOR EACH ROW 
BEGIN 
	UPDATE ATRACCIONES 
    SET ganancias = ganancias - old.ganancias
    WHERE nombre = old.nombre_atraccion ;
END $$
DELIMITER ; 
-- comprobaciones ej3
INSERT INTO `CIRCO`.`ATRACCION_DIA` (`nombre_atraccion`, `fecha`, `num_espectadores`, `ganancias`) VALUES ('El orangután', '2020-03-02', '500', '30000.00');
INSERT INTO `CIRCO`.`ATRACCION_DIA` (`nombre_atraccion`, `fecha`, `num_espectadores`, `ganancias`) VALUES ('El orangután', '2020-03-05', '100', '10000.00');
UPDATE `CIRCO`.`ATRACCION_DIA` SET `ganancias` = '35000.00' WHERE (`nombre_atraccion` = 'El orangután') and (`fecha` = '2020-03-02');
DELETE FROM `CIRCO`.`ATRACCION_DIA` WHERE (`nombre_atraccion` = 'El orangután') and (`fecha` = '2020-03-05');
-- ej4
ALTER TABLE ATRACCIONES ADD COLUMN contador int default 0;
DROP TRIGGER IF EXISTS ej4;
DELIMITER $$
CREATE TRIGGER ej4
AFTER INSERT ON ATRACCION_DIA 
FOR EACH ROW 
BEGIN 
	/*DECLARE numAtracciones int ;
    SET numAtracciones = (SELECT COUNT(*) FROM ATRACCIONES);*/
	UPDATE ATRACCIONES
    SET contador = contador + 1
    WHERE nombre = new.nombre_atraccion;
END $$
DELIMITER ;
DROP TRIGGER IF EXISTS ej4_2;
DELIMITER $$
CREATE TRIGGER ej4_2
AFTER DELETE ON ATRACCION_DIA 
FOR EACH ROW 
BEGIN 
	/*DECLARE numAtracciones int ;
    SET numAtracciones = (SELECT COUNT(*) FROM ATRACCIONES);*/
	UPDATE ATRACCIONES
    SET contador = contador - 1
    WHERE nombre = old.nombre_atraccion;
END $$
DELIMITER ;
-- comprobaciones ej4
INSERT INTO `CIRCO`.`ATRACCION_DIA` (`nombre_atraccion`, `fecha`, `num_espectadores`, `ganancias`) VALUES ('La gigante', '2020-04-01', '120', '11232');   -- La gigante tendrá una atracción en contador
INSERT INTO `CIRCO`.`ATRACCION_DIA` (`nombre_atraccion`, `fecha`, `num_espectadores`, `ganancias`) VALUES ('La gigante', '2020-04-02', '220', '21232.00'); -- La gigante pasa a tener dos en contador
DELETE FROM `CIRCO`.`ATRACCION_DIA` WHERE (`nombre_atraccion` = 'La gigante') and (`fecha` = '2020-04-01');    -- La gigante pasa a tener uno en contador
-- ej5
DROP TRIGGER IF EXISTS ej5;
DELIMITER $$ 
CREATE TRIGGER ej5
BEFORE INSERT ON PISTAS 
FOR EACH ROW 
BEGIN
	IF (new.aforo > 1000 OR new.aforo < 10) then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='el aforo no puede mayor que 1000 ni menor que 10';
	END IF;
END $$
DELIMITER ;
DROP TRIGGER IF EXISTS ej5_2;
DELIMITER $$ 
CREATE TRIGGER ej5_2
BEFORE UPDATE ON PISTAS 
FOR EACH ROW 
BEGIN
	IF (new.aforo > 1000 OR new.aforo < 10) then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='el aforo no puede mayor que 1000 ni menor que 10';
	END IF;
END $$
DELIMITER ;
UPDATE `CIRCO`.`PISTAS` SET `aforo` = '1' WHERE (`nombre` = 'SUPER');
INSERT INTO `CIRCO`.`PISTAS` (`nombre`, `aforo`) VALUES ('ELEVADA', '20000');
-- ej6
DROP TRIGGER IF EXISTS ej6;
DELIMITER $$
CREATE TRIGGER ej6
BEFORE INSERT ON ARTISTAS
FOR EACH ROW
BEGIN 
	DECLARE v_existeJefe tinyint default 0;
    if((select count(*)
		from ARTISTAS
		where nif = new.nif_jefe)=0)then
        set new.nif_jefe = null;
	end if;
                
END $$
DELIMITER ; 
INSERT INTO `CIRCO`.`ARTISTAS` (`nif`, `apellidos`, `nombre`, `nif_jefe`) VALUES ('99999999I', 'Román Díaz', 'Eva', '12343333A');

-- ej7 
create table REGISTRO (
	id int AUTO_INCREMENT PRIMARY KEY,
    usuario varchar(100),
    tabla varchar(100),
    operacion varchar(10),
    datos_antiguos varchar(100),
    datos_nuevos varchar(100),
    fechahora datetime
    );
USE CIRCO;
DROP TRIGGER IF EXISTS pistas_addRegistro_INSERT;
DELIMITER $$
CREATE TRIGGER pistas_addRegistro_INSERT AFTER INSERT ON PISTAS FOR EACH ROW
BEGIN
    
    INSERT INTO REGISTRO (usuario,tabla,operacion,datos_nuevos)
    VALUES (USER(),'PISTAS','ALTA',CONCAT(NEW.nombre,':',NEW.aforo));
    
END $$
DELIMITER ;
USE CIRCO;
DROP TRIGGER IF EXISTS pistas_addRegistro_DELETE;
DELIMITER $$
CREATE TRIGGER pistas_addRegistro_DELETE AFTER DELETE ON PISTAS FOR EACH ROW
BEGIN
    
    INSERT INTO REGISTRO (usuario,tabla,operacion,datos_antiguos)
    VALUES (USER(),'PISTAS','BAJA',CONCAT(OLD.nombre,':',OLD.aforo));
    
END $$
DELIMITER ;
USE CIRCO;
DROP TRIGGER IF EXISTS pistas_addRegistro_UPDATE;
DELIMITER $$
CREATE TRIGGER pistas_addRegistro_UPDATE AFTER UPDATE ON PISTAS FOR EACH ROW
BEGIN
    
    INSERT INTO REGISTRO (usuario,tabla,operacion,datos_antiguos,datos_nuevos)
    VALUES (USER(),'PISTAS','MODIFICAR',CONCAT(OLD.nombre,':',OLD.aforo),CONCAT(NEW.nombre,':',NEW.aforo));

END $$
DELIMITER ;
INSERT INTO `CIRCO`.`PISTAS` (`nombre`, `aforo`) VALUES ('LATERAL3', '120');
UPDATE `CIRCO`.`PISTAS` SET `aforo` = '150' WHERE (`nombre` = 'LATERAL3');
DELETE FROM `CIRCO`.`PISTAS` WHERE (`nombre` = 'LATERAL3');

-- ej8
create table CONTADOR(
	id int AUTO_INCREMENT PRIMARY KEY,
    tipo varchar(100) not null,
    valor int not null
    );
insert into CONTADOR 
values
(1,"PISTAS",0),
(2,"ANIMALES",0);
DROP TRIGGER IF EXISTS ej8
DELIMITER $$
CREATE TRIGGER ej8
 