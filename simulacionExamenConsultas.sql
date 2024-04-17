-- simulacion examen 
use bdmuseo2021;
-- ej1 
select * from obras 
join salas on obras.codsala=salas.codsala
where salas.codsala=1 or salas.codsala=3;
-- ej2
select concat(nombreobra,'(',nomartista,')','Sala:',codsala,'Valoracion:',valoracion) as Obras_de_Arte
from obras
join artistas on obras.codartista=artistas.codartista
order by valoracion desc;


drop procedure if exists ejercicio2;
delimiter $$
create procedure ejercicio2
	(in fecha1 date,in fecha2 date)
begin
	select obras.nombreobra, nomres as Restauraciones
    from obras 
    join restauraciones on obras.codobra = restauraciones.codobra
    join restaurador on restauraciones.codrestaurador = restaurador.codres
	where restauraciones.fecfinrest between fecha1 and fecha2;
end $$
delimiter $$;
call ejercicio2('1990-01-01','2016-01-01');
drop procedure if exists ejercicio4;
delimiter $$
create procedure ejercicio4
	(in obra varchar(60),
	 out autor varchar(60),
	 out valor decimal (12,2)
	)
begin 
	select ifnull(nombreobra,'Obra anónima'), valoracion as Obras  into autor, valor 
    from obras join artistas on obras.codartista = artistas.codartista
	where obras.nombreobra = obra;
end $$
delimiter $$
set @autor = null;
set @valor = null;
call ejercicio4('LA MASÍA',@autor,@valor);
-- ej5 
drop procedure if exists ejercicio5
delimiter $$
create procedure ejercicio5
	(in fecha1 date,
     in fecha2 date)
begin
	select concat_ws('-','nombre artista',nomartista,'-','nombre obra',nombreobra)
    from artistas 
    join obras on artistas.codartista=obras.codartista
	join restauraciones on obras.codobra=restauraciones.codobra
    where fecfinrest between fecha1 and fecha2;
end $$
delimiter $$
call ejercicio5('1990-01-01','2016-01-01');
drop procedure if exists ejercicio6
delimiter $$
create procedure ejercicio6
	()
begin 
	select concat(nombreobra,' ',ifnull(valoracion,"sin valor"),' ',nomsala) as Obras
    from obras 
    join salas on obras.codsala=salas.codsala
    order by salas.codsala,nombreobra;
end $$
delimiter $$
call ejercicio6();
