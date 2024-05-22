drop database if exists dawphone;
create database if not exists dawphone;
use dawphone;
create table clientes (
    codCliente INT,
    nombre VARCHAR(255) NOT NULL,
    dni VARCHAR(20) NOT NULL,
    correoElectronico VARCHAR(255) NOT NULL,
    edad INT,
    numeroCuenta VARCHAR(22) NOT NULL,
    constraint pk_clientes primary key (codCliente)
);

create table planes (
    codPlan INT,
    nombre VARCHAR(255) NOT NULL,
    importeMensual DECIMAL(10, 2) NOT NULL,
    constraint pk_planes primary key (codPlan)
);

create table entidades_bancarias (
    codEntidad VARCHAR(4),
    codCliente int,
    nombreBanco VARCHAR(255) NOT NULL,
    direccionSedeCentral VARCHAR(255) NOT NULL,
    direccionDomiciliacion VARCHAR(255) NOT NULL,
    constraint pk_codEntidad primary key (codEntidad),
    constraint fk_codClientes foreign key (codCliente) references clientes(codCliente)
);

CREATE TABLE clientes_planes (
    cod_clientes_planes INT,
    codCliente INT,
    codPlan INT,
    fechaAlta DATE,
    fechaBaja DATE,
    planActivo BOOLEAN,
    constraint pk_cod_clientes_planes primary key (cod_clientes_planes),
    constraint fk_clientes FOREIGN KEY (codCliente) REFERENCES clientes(codCliente),
    constraint fk_planes FOREIGN KEY (codPlan) REFERENCES planes(codPlan)
);

CREATE TABLE recibos (
    codRecibo INT,
    codCliente INT,
    fechaGeneracion DATE,
    estadoRecibo enum('Cobrado', 'pendiente') not null, -- Añadido nuevo para saber si están ya cobrados o pendientes
    constraint pk_codRecibo primary key (codRecibo),
    constraint fk_codCliente FOREIGN KEY (codCliente) REFERENCES clientes(codCliente)
);

-- insercción de los datos
-- Tabla Clientes
INSERT INTO clientes (codCliente, nombre, dni, correoElectronico, edad, numeroCuenta) VALUES
(1, 'Juan Pérez', '12345678A', 'juanperez@email.com', 35, 'ES12345678901234567890'),
(2, 'María García', '87654321B', 'mariagarcia@email.com', 28, 'ES09876543210987654321'),
(3, 'Luis Martínez', '56789123C', 'luismartinez@email.com', 40, 'ES56789123456789123456'),
(4, 'Ana López', '32145678D', 'analopez@email.com', 45, 'ES32145678901234567890'),
(5, 'Laura Sánchez', '98765432E', 'laurasanchez@email.com', 32, 'ES98765432109876543210');

-- Tabla Planes
INSERT INTO planes (codPlan, nombre, importeMensual) VALUES
(1, 'Plan Básico', 25.99),
(2, 'Plan Estándar', 39.99),
(3, 'Plan Premium', 59.99);

-- Tabla Bancos
INSERT INTO entidades_bancarias (codEntidad, codCliente, nombreBanco, direccionSedeCentral, direccionDomiciliacion) VALUES
('SANT', 2, 'Santander', 'Plaza España 3', 'Avenida Libertad 4'),
('BBVA', 4, 'BBVA', 'Calle Mayor 1', 'Avenida del Mar 7');

-- Tabla clientes_planes
INSERT INTO clientes_planes (cod_clientes_planes, codCliente, codPlan, fechaAlta, fechaBaja, planActivo) VALUES
(1, 1, 1, '2023-01-15', NULL, true),
(2, 2, 2, '2023-02-20', NULL, true),
(3, 3, 3, '2023-03-10', NULL, true),
(4, 4, 1, '2023-04-05', '2023-06-06', false),
(5, 5, 2, '2023-05-12', '2023-06-04', false);

-- Tabla Recibos
INSERT INTO recibos (codRecibo, codCliente, fechaGeneracion, estadoRecibo) VALUES
(1, 1, '2024-04-01', 'pendiente'),
(2, 2, '2024-04-05', 'pendiente'),
(3, 3, '2024-04-10', 'pendiente'),
(4, 4, '2024-04-15', 'Cobrado'),
(5, 5, '2024-04-20', 'pendiente');


-- 1. Primer evento, generar el registro del nuevo recibo
drop event if exists generar_recibos_mensuales;
delimiter $$
create event if not exists generar_recibos_mensuales
on schedule
    EVERY 1 MONTH -- que se ejecute una vez al mes
	STARTS CASE -- case para que si el mes actual ya ha pasado el día 5 el evento se ejecutara el mes siguiente
				-- ejemplo: ahora mismo estamos en el día 9 de mayo por lo tanto el día 5 ya ha pasado y no se ejecutara el evento, entonces se suma un mes
                WHEN DAY(CURRENT_DATE()) > 5 THEN CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()) + 1, '-05 02:00:00') 
                ELSE CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()), '-05 02:00:00') -- que comience cada día 5 del mes a las 2am
           END 
    ON COMPLETION PRESERVE -- que se mantenga el evento una vez ejecutado
DO
BEGIN
    DECLARE anioActual INT;
    DECLARE mesActual INT;
    
    SET anioActual = YEAR(CURRENT_DATE());
    SET mesActual = MONTH(CURRENT_DATE());

    INSERT INTO recibos (codCliente, fechaGeneracion, estadoRecibo) -- inserto nuevos registros en la tabla 'recibos' para los clientes que aún no tienen recibos generados este mes
    SELECT clientes.codCliente, CURRENT_DATE(), 'pendiente' -- selecciono los datos a insertar en la tabla 'recibos'
    FROM clientes
    LEFT JOIN recibos ON clientes.codCliente = recibos.codCliente -- realizo (LEFT JOIN) con la tabla 'recibos' para saber si ya existe 
																-- un recibo generado para el cliente en el mes actual
        AND YEAR(recibos.fechaGeneracion) = current_year
        AND MONTH(recibos.fechaGeneracion) = current_month
    WHERE recibos.codRecibo IS NULL; -- filtro solo los clientes no tienen un recibo generado para el mes actual(es decir, donde el 'codRecibo' es NULL):
END $$
DELIMITER ;

SHOW EVENTS;


-- Apartado 2 preparar ficheros para las entidades bancarias
drop event if exists preparar_ficheros_bancarios;
delimiter $$
create event if not exists preparar_ficheros_bancarios
on schedule
    EVERY 1 MONTH
    STARTS CASE
                WHEN DAY(CURRENT_DATE()) > 5 THEN CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()) + 1, '-05 02:30:00')
                ELSE CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()), '-05 02:30:00')
           END
    ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE idCliente INT;
    DECLARE idRecibo INT;
    DECLARE importe_recibo DECIMAL(10, 2);
    
    -- cursor para obtener los recibos de este mes 
    declare cur_recibos CURSOR FOR 
        select recibos.codCliente, recibos.codRecibo
        from recibos
			where YEAR(recibos.fechaGeneracion) = YEAR(CURRENT_DATE())
				and MONTH(recibos.fechaGeneracion) = MONTH(CURRENT_DATE());
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- declaro un manejador para el cursor

    open cur_recibos;
    repeat  -- inicio el bucle para recorrer los recibos
        FETCH cur_recibos INTO idCliente, idRecibo; -- obtengo los datos del recibo actual

        -- obtengo el importe del recibo
        select importeMensual into importe_recibo
        from planes
			join clientes_planes on planes.codPlan = clientes_planes.codPlan
			where clientes_planes.codCliente = idCliente;

        -- inserto en la tabla temporal la entidad bancaria del cliente
        INSERT INTO tmp_banco_A (codCliente, importe)
        SELECT idCliente, importe_recibo
        FROM entidades_bancarias
        WHERE codCliente = idCliente AND nombreBanco = 'bancoUno';

        INSERT INTO tmp_banco_B (codCliente, importe)
        SELECT idCliente, importe_recibo
        FROM entidades_bancarias
        WHERE codCliente = idCliente AND nombreBanco = 'bancoDos';

    until done end repeat;
    close cur_recibos;
END$$
delimiter ;
SHOW EVENTS;