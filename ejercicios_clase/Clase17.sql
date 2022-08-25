use emarket;
-- Crear una vista con los siguientes datos de los clientes: Id, contacto, y el Fax. En caso que no tenga Fax, colocar el teléfono y en este caso aclararlo. 
-- Por ejemplo 'TEL: (01) 123-4567'
create view v_clientes as
	select Clienteid, contacto, 
		case 
			when fax = '' or fax is null then Concat('TEL:', Telefono)
			else fax
		end as fax
	from clientes;

select * from v_clientes;

-- Se necesita listar los números de teléfono de los clientes que no tengan fax.
-- Hacerlo de dos formas distintas:
-- a. Consultando la tabla de clientes
-- b. Consultando la vista de clientes
select telefono from v_clientes where fax = '' or fax is null;
select telefono from clientes where fax = '' or fax is null;

-- Crear una vista con los siguientes datos de los proveedores: Id, contacto,
-- compañia y la dirección. Para la dirección tomar la dirección, ciudad, código
-- postal y país.
Create view v_proveedores as
	select ProveedorId, contacto, compania, Concat(direccion, ', ', ciudad, ', ', codigoPostal, ', ', pais) as direccion from proveedores;

Select * from v_proveedores;
-- Listar los proveedores que vivan la calle Americanas en Brazil. Hacerlo de dos
-- formas distintas:
-- a. Consultando la tabla de proveedores
-- b. Consultando la vista de proveedores

select * from proveedores where direccion like '%Americanas%' and pais='Brazil';
select * from v_proveedores where direccion like '%Americanas%Brazil';

-- Crear una vista de productos que se usará para control de stock. Incluir el id y
-- nombre del producto, el precio unitario redondeado sin decimales, las unidades
-- en stock y las unidades pedidas. Incluir además una nueva columna PRIORIDAD
-- con los siguientes valores:
-- 	BAJA si unidades pedidas es cero
-- 	MEDIA si unidades pedidas es menor que unidades en stock
-- 	URGENTE si unidades pedidas no duplica al número de unidades en stock
-- 	SUPERURGENTE en caso contrario
create view v_productos as
	select ProductoId, ProductoNombre, round(preciounitario) as preciounitario, unidadesstock, unidadespedidas, 
	case 
		when unidadespedidas = 0 then 'Baja'
		when unidadespedidas < unidadesstock then 'Media'
		when unidadespedidas < (unidadesstock*2) then 'Urgente'
		else 'Superurgente'
	end as prioridad
	from productos;

select * from v_productos;

-- Se necesita un reporte de productos para identificar problemas de stock. Para
-- cada prioridad indicar cuántos productos hay y su precio promedio. No incluir
-- las prioridades para las que haya menos de 5 productos.
Select prioridad, sum(unidadesstock) as cantidad, avg(preciounitario) promedio from v_productos
group by prioridad
having cantidad > 5;