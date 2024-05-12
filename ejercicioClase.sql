select zonas.nomzona, count(reservas.fecanulacion) as efectivas,
            COUNT(*) - count(fecanulacion) as Anuladas,
                avg(reservas.numdiasestancia) as Numero_dia
from reservas join casas 
        on reservas.codcasa = casas.codcasa
    join zonas
        on casas.codzona = zonas.numzona
where zonas.numzona = 1
group by zonas.nomzona
having numdia > 3;