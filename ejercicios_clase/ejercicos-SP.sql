SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE emarket;

-- 1) Cálculo de edad
-- a) Crear un SP que muestre apellidos, nombres y edad de cada empleado, debe
-- calcular la edad de los empleados a partir de la fecha de nacimiento y que
-- tengan entre n y n años de edad.
delimiter $$
create procedure sp_edadesEmpleados (in n1 tinyint, in n2 tinyint)
begin
	select apellido, nombre, timestampdiff(year, empleados.fechaNacimiento, now()) as edad from empleados
	where timestampdiff(year, empleados.fechaNacimiento, now()) between n1 and n2;
end $$

-- b) Ejecutar el SP indicando un rango de edad entre 50 y 60 años de edad.
call sp_edadesEmpleados(50, 60);


-- 2) Actualización de productos
-- a) Crear un SP que reciba un porcentaje y un nombre de categoría y actualice los
-- productos pertenecientes a esa categoría, incrementando las unidades pedidas
-- según el porcentaje indicado. Por ejemplo: si un producto de la categoría Seafood
-- tiene 30 unidades pedidas, al invocar el SP con categoría Seafood y porcentaje
-- 10%, el SP actualizará el valor de unidades pedidas con el nuevo valor 33.
DELIMITER $$
create procedure sp_incrementarUnidadesPedidas (in porcentaje int, in categoria varchar(20))
BEGIN
	declare porcentajeDecimal int default 0;
    set @porcentajeDecimal = porcentaje / 100;
    
    update productos
    join categorias on productos.CategoriaID = categorias.CategoriaID
	set productos.UnidadesPedidas = (productos.UnidadesPedidas * @porcentajeDecimal) + productos.UnidadesPedidas
    where categorias.CategoriaNombre = categoria;
END $$

-- b) Listar los productos de la categoría Beverages para ver cuántas unidades
-- pedidas hay de cada uno de ellos.
select p.unidadesPedidas, c.categorianombre from productos p
join categorias c on c.categoriaid = p.categoriaid
where c.categorianombre = 'Beverages';

-- c) Invocar al SP con los valores Beverages como categoría y 15 como porcentaje. 
 -- call sp_incrementarUnidadesPedidas(0, 'Beverages');

-- d) Volver a listar los productos como en (a), y validar los resultados. 
select *,  c.categorianombre from productos p
join categorias c on c.categoriaid = p.categoriaid;


-- 3) Actualización de empleados
-- a) Crear un SP que cree una tabla con los nombres, apellidos y teléfono de contacto de
-- todos los empleados que hayan sido contratados con fecha anterior a una fecha
-- dada.
DELIMITER $$
create procedure sp_crearTabla_contratados(in fechaLimite date)
BEGIN
	CREATE TABLE empleadosContratacion AS
    SELECT nombre, apellido, telefono, FechaContratacion FROM empleados
    WHERE FechaContratacion < fechaLimite;
END $$


-- b) Ejecutar el SP para generar una tabla de empleados con fecha de contratación
-- anterior a 01/01/1994.
call sp_crearTabla_contratados('1994-01-01');

-- c) Consultar la tabla generada y validar los resultados.
select * from empleadosContratacion;
