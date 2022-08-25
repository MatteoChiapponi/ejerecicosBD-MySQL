SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

use emarket;

-- Ejercicio 1

-- 1. Crear una vista para poder organizar los envíos de las facturas. Indicar número
-- de factura, fecha de la factura y fecha de envío, ambas en formato dd/mm/yyyy,
-- valor del transporte formateado con dos decimales, y la información del
-- domicilio del destino incluyendo dirección, ciudad, código postal y país, en una
-- columna llamada Destino.
CREATE VIEW v_enviosFacturas AS
    SELECT 
        f.facturaid,
        DATE_FORMAT(f.fechafactura, '%d''/''%m''/''%Y') AS 'Fecha Factura',
        DATE_FORMAT(f.fechaenvio, '%d''/''%m''/''%Y') AS 'Fecha Envio',
        FORMAT(f.transporte, 2) AS 'Valor Transporte',
        CONCAT(DireccionEnvio, ',', CiudadEnvio, ',', CodigoPostalEnvio,',', PaisEnvio) AS destino
    FROM
        facturas f;


-- 2. Realizar una consulta con todos los correos y el detalle de las facturas que
-- usaron ese correo. Utilizar la vista creada.
select ef.*, c.compania from v_enviosFacturas ef
	join facturas f on f.facturaid = ef.facturaid
    right join correos c on c.correoid = f.enviovia;

-- 3. ¿Qué dificultad o problema encontrás en esta consigna? Proponer alguna
-- alternativa o solución.

-- Ejercicio 2

-- 1. Crear una vista con un detalle de los productos en stock. Indicar id, nombre del
-- producto, nombre de la categoría y precio unitario.
create view v_productosEnStock as
select p.productoid, p.productonombre, c.categorianombre, p.preciounitario from productos p
	join categorias c on p.CategoriaID = c.CategoriaID;
    
-- 2. Escribir una consulta que liste el nombre y la categoría de todos los productos
-- vendidos. Utilizar la vista creada.
select p.productonombre, c.categorianombre, fd.facturaid from v_productosEnStock v
	join productos p on p.productoid = v.productoid
    join categorias c on c.categoriaid = p.categoriaid 
    join facturadetalle fd on fd.productoid = v.productoid;

-- 3. ¿Qué dificultad o problema encontrás en esta consigna? Proponer alguna
-- alternativa o solución.
select p.productonombre, c.categorianombre, count(fd.facturaid) from v_productosEnStock v
	join productos p on p.productoid = v.productoid
    join categorias c on c.categoriaid = p.categoriaid 
    join facturadetalle fd on fd.productoid = v.productoid
group by p.productonombre, c.categorianombre
order by count(fd.facturaid) desc;