-- vistas
create view vista1
as select evento from test ;
select * from vista1;
-- modificar una vista
ALTER VIEW `sueldos_actuales` AS
    SELECT `salaries`.`salary` AS `salary`
    FROM `salaries`
    WHERE (`salaries`.`to_date` >= CURDATE())
    ORDER BY salary;