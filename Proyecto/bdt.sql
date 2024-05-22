-- 	Inserción datos del proyecto
use bodyfitness;
start transaction;
insert into Clientes
	(codcli,nomcli,ape1cli,ape2cli)
    values
    (1,'Tomás','González','Atienza');
commit;
set @numMax = (select max(codcli) from Clientes)+1;
insert into Clientes
	(codcli,nomcli,ape1cli,ape2cli)
    values
    (@numMax,'Aiman','Harrar','Daoud');
commit;
set @numMax = (select max(codmonitores) from Monitores)+1;
start transaction;
insert into Monitores
	(codmonitores,nommonitores,ape1monitores,ape2monitores)
    values
    (1,'Aiman','Harrar','Daoud');
commit;
set @numMax = (select max(codmonitores) from Monitores)+1;
insert into Monitores
	(codmonitores,nommonitores,ape1monitores,ape2monitores)
    values
    (1,'Jose','Rodríguez','Díaz');
commit;
start transaction;
set @numMax = (select max(codmonitores) from Monitores)+1;
insert into Monitores
	(codmonitores,nommonitores,ape1monitores,ape2monitores)
    values
    (@numMax,'Alejandro','Luque','Maillo');
commit;
start transaction;
insert into Dias
	(coddia,desdia)
    values
	(1, 'Lunes'),
	(2, 'Martes'),
	(3, 'Miércoles'),
	(4, 'Jueves'),
	(5, 'Viernes'),
	(6, 'Sábado'),
	(7, 'Domingo');
commit;
start transaction ;
insert into Salas
	(codsala,plazas,datos)
    values
	(1, 50, 'Zumba'),
	(2, 30, 'Yoga'),
	(3, 20, 'Sala fitness'),
	(4, 40, 'Core');
commit;
start transaction ;
INSERT INTO TipoDeporte 
	(codtipodeporte, desdeporte) 
	values
	(1, 'Fútbol'),
	(2, 'Baloncesto'),
	(3, 'Tenis'),
	(4, 'Natación'),
	(5, 'Atletismo');
commit;
start transaction;
INSERT INTO TramoHorario 	
	(codtramo, horaini, horafin)
    values
	(1, '2024-02-18 08:00:00', '2024-02-18 10:00:00'),
	(2, '2024-02-18 10:00:00', '2024-02-18 12:00:00'),
	(3, '2024-02-18 13:00:00', '2024-02-18 15:00:00'),
	(4, '2024-02-18 15:00:00', '2024-02-18 17:00:00');
commit;
start transaction;
insert into Horarios
	(codhora, plazadisp, fecinihora, fecfinhora, codcli, codmonitores, codtipodeporte, coddia, codtramo, codsala) 
    VALUES
	(1, 20, '2024-02-18 08:00:00', '2024-02-18 10:00:00', NULL, 1, 1, 1, 1, 1),
	(2, 15, '2024-02-18 10:00:00', '2024-02-18 12:00:00', NULL, 2, 2, 1, 2, 2),
	(3, 25, '2024-02-18 13:00:00', '2024-02-18 15:00:00', NULL, 3, 3, 1, 3, 3),
	(4, 10, '2024-02-18 15:00:00', '2024-02-18 17:00:00', NULL, 4, 4, 1, 4, 4);
commit;
start transaction ;
INSERT INTO Reservas 
		(codreserva, descripreserva, codhora) 
        values
		(1, 'Reserva de sala para reunión de equipo', 1),
		(2, 'Reserva para hacer boxeo', 3),
		(3, 'Reserva para hacer extreme fit', 2),
		(4, 'Reserva para zumba', 4);
commit;
start transaction;
INSERT INTO Detalles_Reservas
	(coddetreserva, fecreservacli, codreserva, codhora, codcli) 
	values
	(1, '2024-02-18', 1, 1, 1),
	(2, '2024-02-18', 2, 2, 2),
	(3, '2024-02-18', 3, 3, 3),
	(4, '2024-02-18', 4, 4, 4);
commit;