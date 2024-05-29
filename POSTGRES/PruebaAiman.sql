
-- implementando la opción A parcial disjunta.

INSERT INTO jugador (nombre, apellido1, apellido2, fechaNacimiento, dorsal, posicion)
VALUES ('Lionel', 'Messi', 'Cuccittini', '1987-06-24', '10', 'Delantero');

INSERT INTO entrenador (nombre, apellido1, apellido2, fechaNacimiento, formacion)
VALUES ('Pep', 'Guardiola', 'Sala', '1971-01-18', 'Formación 4-3-3');

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
	dorsal VARCHAR(2),
	posicion VARCHAR(50),
	Constraint pk_jugador PRIMARY KEY(idJugador)
)inherits(persona);
CREATE TABLE entrenador(
	idEntrenador SERIAL,
	formacion varchar(100),
	Constraint pk_entrenador PRIMARY KEY(idEntrenador)
)inherits(persona);

SELECT * FROM entrenador;
-- Trigger para entrenador
CREATE RULE evitarDuplicarEntrenador2 AS
ON INSERT TO entrenador
WHERE EXISTS (
    SELECT *
    FROM jugador
    WHERE jugador.id = NEW.id
)
DO INSTEAD NOTHING;
CREATE RULE evitarDuplicarJugador3 AS
ON INSERT TO jugador
WHERE EXISTS (
    SELECT *
    FROM entrenador
    WHERE entrenador.id = NEW.id
)
DO INSTEAD NOTHING;
CREATE RULE evitarPersona2 AS
	ON INSERT TO persona
	DO INSTEAD NOTHING;
INSERT INTO persona (id,nombre, apellido1, apellido2, fechaNacimiento) 
VALUES 
(1,'Aiman', 'Harrar', 'Daoud', '1987-06-24');
select  * from persona;
select * from persona;
