use ventapromoscompleta;
DROP VIEW IF EXISTS articulosActuales;
CREATE VIEW articulosActuales
	(codart,nomart,precioart)
AS 	
	SELECT articulos.refart, nomart, precioartpromo as Articulos
    FROM articulos
    JOIN catalogospromos on articulos.refart = catalogospromos.refart 
    JOIN promociones on catalogospromos.codpromo = promociones.codpromo
    WHERE curdate() between promociones.fecinipromo and date_add(promociones.fecinipromo, interval promociones.duracionpromo day)
    UNION 
    SELECT articulos.refart , articulos.nomart, articulos.precioventa 
    FROM articulos 
    WHERE refart not in (SELECT articulos.refart, nomart, precioartpromo as Articulos
    FROM articulos
    JOIN catalogospromos on articulos.refart = catalogospromos.refart 
    JOIN promociones on catalogospromos.codpromo = promociones.codpromo
    WHERE curdate() between promociones.fecinipromo and date_add(promociones.fecinipromo, interval promociones.duracionpromo day));
    
select precio from articulosActuales 
where codigo = 'C1_01'
;

-- para la badat d test codtest y codpregunta que este repetida

