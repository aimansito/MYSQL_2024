-- Esquema Relacional

/*
Clientes(Pk[codcli], nomcli, ape1cli, ape2cli)
Reservas(Pk[codreserva, codhora*], descripreserva)
Monitores(Pk[])
Tipo de Deportes(Pk[codtipodeporte], desdeporte)
Días(Pk[coddia], desdia)
Tramos Horarios(Pk[codtramo], horaini, horafin)
Salas(Pk[codsala], plazas, datos)
Horarios(Pk[codhora], plazadisp, fecinihora, fecfinhora, codcli*, codmonitores*, codtipodeporte*, coddia*, codtramo*, codsala*)
*/
create database if not exists bodyfitness;

use bodyfitness;

create table if not exists Clientes
(
	codcli int,
    nomcli varchar(60),
    ape1cli varchar(60),
    ape2cli varchar(60),
    email varchar(120),
    constraint pk_clientes primary key (codcli)
);

create table if not exists Monitores
(
	codmonitores int,
    nommonitores varchar(60),
    ape1monitores varchar(60),
    ape2monitores varchar(60),
    email varchar(120),
    constraint pk_monitores primary key (codmonitores)
);

create table if not exists TipoDeporte
(
	codtipodeporte int,
    desdeporte varchar(60),
    constraint pk_tipodeporte primary key (codtipodeporte)
);

create table if not exists Dias
(
	coddia int,
    desdia varchar(60),
    constraint pk_dias primary key (coddia)
);

create table if not exists TramoHorario
(
	codtramo int,
    horaini datetime,
    horafin datetime,
    constraint pk_tramohorario primary key (codtramo)
);

create table if not exists Salas
(
	codsala int,
	plazas int,
    datos varchar(120),
    constraint pk_sala primary key (codsala)
);

create table if not exists Horarios
(
	codhora int,
    plazadisp int,
    fecinihora datetime,
    fecfinhora datetime,
    codcli int,
    codmonitores int,
    codtipodeporte int,
    coddia int,
    codtramo int,
    codsala int,
    constraint pk_horario primary key (codhora),
    constraint fk_hora_cli foreign key(codcli)
		references Clientes(codcli)
			on delete no action on update cascade,
	constraint fk_hora_moni foreign key(codmonitores)
		references Monitores(codmonitores)
			on delete no action on update cascade,
	constraint fk_hora_tipodeporte foreign key(codtipodeporte)
		references TipoDeporte(codtipodeporte)
			on delete no action on update cascade,
	constraint fk_hora_dia foreign key(coddia)
		references Dias(coddia)
			on delete no action on update cascade,
	constraint fk_hora_tramo foreign key(codtramo)
		references TramoHorario(codtramo)
			on delete no action on update cascade,
	constraint fk_hora_sala foreign key(codsala)
		references Salas(codsala)
			on delete no action on update cascade
);

create table if not exists Reservas
(
	codreserva int,
    descripreserva varchar(60),
    codhora int,
    constraint pk_reserva primary key (codreserva, codhora),
    constraint fk_reserva_hora foreign key(codhora)
		references Horarios(codhora)
			on delete no action on update cascade
);







