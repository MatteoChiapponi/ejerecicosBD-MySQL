SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE emarket;

-- 1) Empleados
-- a) Crear un SP que liste los apellidos y nombres de los empleados ordenados
-- alfabéticamente.
delimiter $$
create procedure sp_nombreCompleto_empleados()
begin
	select apellido, nombre from empleados
    order by apellido;
end $$

-- b) Invocar el SP para verificar el resultado.
call sp_nombreCompleto_empleados();


-- 2) Empleados por ciudad
-- a) Crear un SP que reciba el nombre de una ciudad y liste los empleados de esa
-- ciudad.
delimiter$$
create procedure sp_empleadosCiudad(in nombreCiudad varchar(20))
begin
	select concat(nombre, ' ', apellido), ciudad from empleados
    where nombreCiudad = ciudad;
end$$

-- b) Invocar al SP para listar los empleados de Seattle.
call sp_empleadosCiudad('Seattle');


-- 3) Clientes por país
-- a) Crear un SP que reciba el nombre de un país y devuelva la cantidad de clientes
-- en ese país.
delimiter$$
create procedure sp_cantidadClientes_porPais(in nombrePais varchar(20))
begin
	select pais, count(clienteid) as 'Cantida Clientes' from clientes
    where pais = nombrePais
	group by pais;
end$$

-- b) Invocar el SP para consultar la cantidad de clientes en Portugal.
call sp_cantidadClientes_porPais('Portugal');


-- 4) Productos sin stock
-- a) Crear un SP que reciba un número y liste los productos cuyo stock está por
-- debajo de ese número. El resultado debe mostrar el nombre del producto, el
-- stock actual y el nombre de la categoría a la que pertenece el producto.
delimiter$$
create procedure sp_productosStock(in numero smallint)
begin
	select p.ProductoNombre, p.UnidadesStock, c.CategoriaNombre from productos p
		join categorias c on c.categoriaid = p.categoriaid
	where p.UnidadesStock < numero;
end$$

-- b) Listar los productos con menos de 10 unidades en stock.
call sp_productosStock(10);

-- c) Listar los productos sin stock.
call sp_productosStock(1);


-- 5) Ventas con descuento
-- a) Crear un SP que reciba un porcentaje y liste los nombres de los productos que
-- hayan sido vendidos con un descuento igual o superior al valor indicado,
-- indicando además el nombre del cliente al que se lo vendió.

delimiter$$
create procedure sp_productosConDescuento(in porcentaje int)
begin
	declare porcentajeDecimal int default 0;
	set @porcentajeDecimal = porcentaje / 100;
    select c.contacto, p.ProductoNombre, fd.descuento from facturadetalle fd
		join productos p on p.productoid = fd.productoid
		join facturas f on f.facturaid = fd.facturaid
        join clientes c on c.clienteid = f.clienteid
	where fd.descuento >= @porcentajeDecimal and fd.descuento != 0
    order by fd.descuento;
end$$

-- b) Listar la información de los productos que hayan sido vendidos con un
-- descuento mayor al 10%.
call sp_productosConDescuento(10);
