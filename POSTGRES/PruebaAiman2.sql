-- las tablas se crean sin herencia ,
-- con claves foraneas cada una, creamos e insertamos datos en persona
-- luego buscamos esos datos de persona para insertarlas en las clases jugador entrenador
-- 1. Implementando la opción A de tu jerarquía de forma que sea total no disjunta.

CREATE TABLE persona (
    id SERIAL,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    fechaNacimiento DATE,
	Constraint pk_persona PRIMARY KEY(id)
);
CREATE TABLE jugador (
    idJugador SERIAL ,
	nombre varchar(50),
	apellidos varchar(100),
    dorsal VARCHAR(2),
    posicion VARCHAR(50),
	Constraint pk_jugador PRIMARY KEY(idJugador),
    idPersona INT REFERENCES persona(id)
);
CREATE TABLE entrenador (
    idEntrenador SERIAL ,
	nombre varchar(100),
	apellidos varchar(100),
    formacion VARCHAR(100),
	Constraint pk_entrenador PRIMARY KEY(idEntrenador),
    idPersona INT REFERENCES persona(id)
);
INSERT INTO persona (nombre, apellido1, apellido2, fechaNacimiento) 
VALUES 
('Lionel', 'Messi', 'Cuccittini', '1987-06-24'),
('Pep', 'Guardiola', 'Sala', '1971-01-18');

SELECT id  FROM persona WHERE nombre = 'Pep' AND apellido1 = 'Guardiola' AND apellido2 = 'Sala';
SELECT id FROM persona WHERE nombre = 'Lionel' AND apellido1 = 'Messi' AND apellido2 = 'Cuccittini';

INSERT INTO jugador(nombre,apellidos,dorsal,idPersona)
VALUES('Pep','Guardiola','2',2);

INSERT INTO jugador (nombre, apellidos, dorsal, posicion, idPersona) 
VALUES ('Lionel', 'Messi Cuccittini', '10', 'Delantero', 1);
SELECT id FROM persona WHERE nombre = 'Pep' AND apellido1 = 'Guardiola' AND apellido2 = 'Sala';
INSERT INTO entrenador (nombre, apellidos, formacion, idPersona) 
VALUES ('Pep', 'Guardiola Sala', 'Formación 4-3-3', (SELECT id FROM persona WHERE nombre = 'Pep' AND apellido1 = 'Guardiola' AND apellido2 = 'Sala'));

select * from entrenador;
select * from jugador;

CREATE RULE evitarDuplicacionJugador AS
ON INSERT TO jugador
WHERE EXISTS (
	ON INSERT TO jugador
	    WHERE EXISTS 
(SELECT * 
 FROM jugadores 
 where jugador.idJugador  = new.idJugador)

)
DO ALSO NOTHING;

-- Trigger para entrenador
CREATE RULE evitarDuplicacionEntrenador AS
ON INSERT TO entrenador
WHERE EXISTS (
    SELECT 1
    FROM jugador
    WHERE jugador.id = NEW.id
)
DO ALSO NOTHING;
select * from jugador;
