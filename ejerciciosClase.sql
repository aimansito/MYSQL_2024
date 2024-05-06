/* para turRural ==> Número de reservas efectivas por zona, numero de reservas anuladas por zona , número medio de días
solo nos interesan las estancias medias superiores a 3 días
*/
use GBDturRural2015;

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

/*
queremos saber cuantas reservas se anulan por periodos de meses, esto es,
cuantas reservas se anulan un mes antes del inicio de estancia
cuantas reservas se anulan dos meses antes del inicio de estancia 
*/
SELECT feciniestancia, fecanulacion, 
       DATEDIFF(feciniestancia, fecanulacion) DIV 30 AS numMeses,
       COUNT(codreserva) AS total_anulaciones
FROM reservas
WHERE fecanulacion is not null
GROUP BY feciniestancia, fecanulacion, numMeses
HAVING numMeses BETWEEN 0 AND 2;