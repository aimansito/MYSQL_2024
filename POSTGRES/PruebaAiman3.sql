-- 2. Implementando la opción A parcial disjunta. esta jerarquia
CREATE TABLE persona (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    fechaNacimiento DATE
);
CREATE TABLE jugador (
    idJugador SERIAL PRIMARY KEY,
    dorsal VARCHAR(2),
    posicion VARCHAR(50),
    idPersona INT UNIQUE REFERENCES persona(id) ON DELETE CASCADE
);
CREATE TABLE entrenador (
    idEntrenador SERIAL PRIMARY KEY,
    formacion VARCHAR(100),
    idPersona INT UNIQUE REFERENCES persona(id) ON DELETE CASCADE
);
INSERT INTO persona (nombre, apellido1, apellido2, fechaNacimiento) 
VALUES 
('Lionel', 'Messi', 'Cuccittini', '1987-06-24'),
('Pep', 'Guardiola', 'Sala', '1971-01-18');
SELECT id FROM persona WHERE nombre = 'Lionel' AND apellido1 = 'Messi' AND apellido2 = 'Cuccittini';
SELECT id FROM persona WHERE nombre = 'Pep' AND apellido1 = 'Guardiola' AND apellido2 = 'Sala';

SELECT * FROM jugador;
SELECT * FROM entrenador;