/*EJERICIO 1*/

select concat(clientes.ape1cli,' ', ifnull(clientes.ape2cli, ''), ', ', clientes.nomcli) as 'clientes'
from proyectos
	join clientes
			on clientes.numcli = proyectos.numcli
where year(proyectos.feciniproy) = 2020 and proyectos.aprobado = 0;

/*EJERCICIO 2*/

select empleados.numem
from empleados
where length(nomem) >= 6 
	or nomem like "%(0|1|2|3|4|5|6|7|8|9)%";

/*EJERCICIO 3*/

delimiter $$
create procedure ejercicio_3
		(
        in numero int
        )

begin

	select count(tecnicos.numtec) as 'tecnicos', count(colaboradores.numcol) as 'colaboradores'
	from proyectos
		join tecnicosenproyectos
						on tecnicosenproyectos.numproyecto = proyectos.numproyecto
            join tecnicos
						on tecnicos.numtec = tecnicosenproyectos.numtec	
			join funciones
						on funciones.codfuncion = tecnicosenproyectos.codfuncion
                join colaboradoresenproyectos
						on colaboradoresenproyectos.codfuncion = funciones.codfuncion
                    join colaboradores
						on colaboradores.numcol = colaboradoresenproyectos.numcol
	where proyectos.numproyecto = numero;

end $$

delimiter ;
/*Al llamar al procedimieno no se me ejecuta bien pero la consulta se ejecuta de manera correcta, pruebe en vez de numeroa  poner 1
call ejercicio_3(1);*/

/*EJERCICIO 5*/
 drop function ejercicio5;
delimiter $$
create function ejercicio5
	(tecnico int, proyecto int)
    returns int
    deterministic
begin
	declare semanas int;
	set semanas =
    (	
		select ifnull(PERIOD_DIFF(week(tecnicosenproyectos.fecfintrabajo),week(tecnicosenproyectos.fecinitrabajo)),0)
		from tecnicosenproyectos
			join tecnicos
				on tecnicos.numem = tecnicosenproyectos.numtec
			join proyectos
				on proyectos.numproyecto = tecnicosenproyectos.numproyecto
		where tecnicos.numem = tecnico and proyectos.numproyecto = proyecto
	);
    return semanas;
end $$
delimiter ;

 /*select ejercicio5(1,1);*/
 
 /*EJERCICIO 7*/
 
select proyectos.numproyecto,
	concat_ws(' ', empleados.nomem, empleados.ape1em, empleados.ape2em),
	count(tecnicos.numtec), count(colaboradores.numcol)
from proyectos
	join tecnicos
						on tecnicos.numtec = proyectos.director
		join empleados
						on empleados.numem = tecnicos.numem
	join tecnicosenproyectos
						on tecnicosenproyectos.numproyecto = proyectos.numproyecto
		join tecnicos
						on tecnicos.numtec = tecnicosenproyectos.numtec	
			join funciones
						on funciones.codfuncion = tecnicosenproyectos.codfuncion
				join colaboradoresenproyectos
						on colaboradoresenproyectos.codfuncion = funciones.codfuncion
					join colaboradores
						on colaboradores.numcol = colaboradoresenproyectos.numcol
where period_diff(day(proyectos.fecfinproy), day(proyectos.feciniproy)) <= proyectos.duracionprevista;