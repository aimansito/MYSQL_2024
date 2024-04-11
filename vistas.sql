use ventapromoscompleta;
DROP VIEW IF EXISTS articulosActuales;
CREATE VIEW articulosActuales
	(codart,nombreart,precioart)
AS 	
	SELECT articulos.refart, nomart, precioartpromo as Articulos
    FROM articulos
    JOIN catalogospromos on articulos.refart = catalogospromos.refart 
    JOIN promociones on catalogospromos.codpromo = promociones.codpromo
    WHERE curdate() between promociones.fecinipromo and date_add(promociones.fecinipromo, interval promociones.duracionpromo day);
  /*  UNION 
    SELECT articulos.refart , articulos.nomart, articulos.precioventa 
    FROM articulos 
    WHERE refart not in (SELECT articulos.refart, nomart, precioartpromo as Articulos
    FROM articulos
    JOIN catalogospromos on articulos.refart = catalogospromos.refart 
    JOIN promociones on catalogospromos.codpromo = promociones.codpromo
    WHERE curdate() between promociones.fecinipromo and date_add(promociones.fecinipromo, interval promociones.duracionpromo day));*/
    
select * from articulosActuales ;
select * from articulos;

-- para la badat d test codtest y codpregunta que este repetida

