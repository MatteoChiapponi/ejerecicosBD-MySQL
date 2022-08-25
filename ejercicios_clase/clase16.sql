SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE emarket;

-- Reportes parte I - Repasamos INNER JOIN

-- Realizar una consulta de la facturación de e-market. Incluir la siguiente información:
-- ● Id de la factura
-- ● fecha de la factura
-- ● nombre de la empresa de correo
-- ● nombre del cliente
-- ● categoría del producto vendido
-- ● nombre del producto
-- ● precio unitario
-- ● cantidad

SELECT 
    f.facturaid,
    f.fechafactura,
	co.compania,
    cl.contacto,
	ca.categorianombre,
    p.productonombre,
    fd.preciounitario,
    fd.cantidad
FROM
    facturadetalle fd
JOIN facturas f on f.facturaid = fd.facturaid
JOIN correos co on co.correoid = f.enviovia
JOIN clientes cl on cl.clienteid = f.clienteid
JOIN productos p on p.productoid = fd.productoid
JOIN categorias ca on ca.categoriaid = p.categoriaid ;
-- 2155 row(s) returned


-- Reportes parte II - INNER, LEFT Y RIGHT JOIN

-- 1. Listar todas las categorías junto con información de sus productos. Incluir todas
-- las categorías aunque no tengan productos.
select c.categorianombre, p.* from productos p
	right join categorias c on c.categoriaid = p.categoriaid;
-- 79 row(s) returned

-- 2. Listar la información de contacto de los clientes que no hayan comprado nunca
-- en emarket.
select c.contacto, f.clienteid from facturas f
	right join clientes c on c.clienteid = f.clienteid
where f.clienteid is null;
-- 2 row(s) returned

-- 3. Realizar un listado de productos. Para cada uno indicar su nombre, categoría, y
-- la información de contacto de su proveedor. Tener en cuenta que puede haber
-- productos para los cuales no se indicó quién es el proveedor.
select prod.productonombre, c.categorianombre, prov.contacto from productos prod
	join categorias c on c.categoriaid = prod.categoriaid
    join proveedores prov on prov.proveedorid = prod.proveedorid;
-- 77 row(s) returned
-- Que quiere decir con: Tener en cuenta que puede haber productos para los cuales no se indicó quién es el proveedor

-- 4. Para cada categoría listar el promedio del precio unitario de sus productos.
select c.categorianombre, avg(p.preciounitario) from productos p 
	join categorias c on c.categoriaid = p.categoriaid
group by c.categorianombre;
-- 8 row(s) returned

-- 5. Para cada cliente, indicar la última factura de compra. Incluir a los clientes que
-- nunca hayan comprado en e-market.
select cl.contacto, max(f.fechafactura) from facturas f
	right join clientes cl on cl.clienteid = f.clienteid
group by cl.contacto ;
-- 91 row(s) returned

-- 6. Todas las facturas tienen una empresa de correo asociada (enviovia). Generar un
-- listado con todas las empresas de correo, y la cantidad de facturas
-- correspondientes. Realizar la consulta utilizando RIGHT JOIN.
select c.compania, count(f.facturaid) as 'cantidad facturas' from facturas f
	right join correos c on c.correoid = f.enviovia
group by c.compania;
-- 6 row(s) returned
