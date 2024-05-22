-- 
-- ej 15
use empresaclase;
select nomem 
from empleados
where ifnull(comisem,0)=0
order by length(nomem) asc;
-- ej16 
