use empresaclase;
show tables;
alter table empleados modify column fecinem date check (fecinem>= date_add(curdate(), interval -16 year));
alter table empleados 
change column fecinem fecinem date check (date_add(fecnaem, interval 16 year)<= fecinem),
change column userem userem varchar(12) unique;

DELIMITER $$
CREATE TRIGGER uniqueEx
BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN 
    
END $$
DELIMITER ; 