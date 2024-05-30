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
CREATE TABLE entrenador (
    idEntrenador SERIAL ,
    formacion VARCHAR(100),
	Constraint pk_entrenador PRIMARY KEY(idEntrenador)
)inherits(personaa);

CREATE RULE evitarDuplicJugadorA AS
	ON INSERT TO jugador
	    WHERE NOT EXISTS 
(SELECT * 
 FROM entrenador 
 where entrenador.id  = new.id)

DO INSTEAD NOTHING;


CREATE RULE evitarDuplicEntrenadorA AS
	ON INSERT TO entrenador
	    WHERE NOT EXISTS 
(SELECT * 
 FROM jugador 
 where jugador.id  = new.id)

DO INSTEAD NOTHING;

INSERT INTO jugador
	(nombre,apellido1,apellido2,fechaNacimiento,dorsal,posicion)
VALUES 
	('Aiman','Morata','Morata','2024-12-12','9','ld');
INSERT INTO entrenador
	(nombre,apellido1,apellido2,fechaNacimiento,formacion)
VALUES 
	('Aiman','Morata','Morata','2024-12-12','4-3-3')

INSERT INTO persona
	(nombre,apellido1,apellido2,fechaNacimiento)
VALUES 
	('Aiman','Harrar','Daoud','2024-12-12');
	
select * from persona;