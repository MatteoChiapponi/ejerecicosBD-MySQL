SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE adventureworks;

-- WHERE
-- 1. Mostrar las personas que la segunda letra de su apellido es una s.
-- Tablas: person
-- Campos: LastName
select lastname from contact where lastname like '_s%';

-- 2. Mostrar el nombre concatenado con el apellido de las personas cuyo apellido tenga
-- terminación (ez).
-- Tablas: person
select concat(firstname, ' ', lastname) as nombreCompleto from contact where lastname like '%ez';

-- 3. Mostrar los nombres de los productos que terminan en un número.
-- Tablas: product
-- Campos: Name
select name from product 
where name like '%0' or name like '%1' or name like '%2' or name like '%3' or name like '%4' 
or name like '%5' or name like '%6' or name like '%7' or name like '%8' or name like '%9';


-- 4. Mostrar las personas cuyo nombre tenga una "c" como primer carácter, cualquier otro como
-- segundo carácter, ni d, e, f, g como tercer carácter, cualquiera entre j y r o entre s y w como
-- cuarto carácter y el resto sin restricciones.
-- Tablas: person
-- Campos: FirstName

-- select firstname from contact
-- where firstname like 'c_';


-- BETWEEN
-- 1. Mostrar todos los productos cuyo precio de lista esté entre 240 y 305.
-- Tablas: product
-- Campos: ListPrice
select listprice from product where listprice between 240 and 305;

-- 2. Mostrar todos los empleados que nacieron entre 1977 y 1981.
-- Tablas: employee
-- Campos: BirthDate
select birthdate from employee where birthdate between '1977-01-01' and '1981-12-31'
order by birthdate;

-- OPERADORES
-- 1. Mostrar el código, fecha de ingreso y horas de vacaciones de los empleados que ingresaron a
-- partir del año 2010.
-- Tablas: employee
-- Campos: BusinessEntityID, HireDate, VacationHours
select employeeid, HireDate, VacationHours from employee where extract(year from hiredate) > 2010;

-- 2. Mostrar el nombre, número de producto, precio de lista y el precio de lista incrementado en
-- un 10% de los productos cuya fecha de fin de venta sea anterior al día de hoy.
-- Tablas: product
-- Campos: Name, ProductNumber, ListPrice, SellEndDate
select Name, ProductNumber, (ListPrice + (listprice * 0.1)) as 'Precio lista incrementado 10%', SellEndDate
from product where sellenddate = now() - 1;


-- CONSULTAS CON "NULL"
-- 1. Mostrar los representantes de ventas (vendedores) que no tienen definido el número de
-- territorio.
-- Tablas: salesperson
-- Campos: TerritoryID, BusinessEntityID
select TerritoryID, SalesPersonID from salesperson where territoryid is null;

-- 2. Mostrar el peso de todos los artículos. Si el peso no estuviese definido, reemplazar por cero.
-- Tablas: product
-- Campos: Weight
select weight,
	case 
		when weight is null then weight = 0
	end as Peso
 from product;

-- FUNCIONES DE AGREGACIÓN
-- 1. Mostrar solamente la fecha de nacimiento del empleado más joven.
-- Tablas: employee
-- Campos: BirthDate
select birthdate from employee;
select concat(extract(year from birthdate),' - ', extract(month from birthdate), ' - ',
extract(day from birthdate)) as fecha_de_nacimiento from employee order by BirthDate desc limit 1;


-- 2. Mostrar el promedio de la lista de precios de productos con 2 dígitos después de la coma.
-- Además, agregar el signo $.
-- Tablas: product
-- Campos: ListPrice
select concat('$',round(avg(listprice), 2)) from product;


-- GROUP BY
-- 1. Mostrar los productos y la suma total vendida de cada uno de ellos, ordenados
-- ascendentemente por el total vendido. Redondear el total para abajo.
-- Tablas: salesorderdetail
-- Campos: ProductID, LineTotal
select ProductID, floor(sum(LineTotal)) as totalVendido
from salesorderdetail group by productid
order by sum(linetotal);


-- 2. Mostrar el promedio vendido por factura.
-- Tablas: salesorderdetail
-- Campos: SalesOrderID, LineTotal
select SalesOrderID, avg(LineTotal) as promedioVendido from salesorderdetail group by salesorderid;


-- HAVING
-- 1. Mostrar las subcategorías de los productos que tienen cuatro o más productos que cuestan
-- menos de $150.
-- Tablas: product
-- Campos: ProductSubcategoryID, ListPrice

-- select ProductSubcategoryID, ListPrice, count(ProductID) from product 
-- where listprice < 150 and count(ProductID) >= 4;


-- 2. Mostrar todos los códigos de subcategorías existentes junto con la cantidad de productos
-- cuyo precio de lista sea mayor a $70 y el precio promedio sea mayor a $700.
-- Tablas: product
-- Campos: ProductSubcategoryID, ListPrice
select ProductSubcategoryID, count(productid), ListPrice from product
where ListPrice > 70 and avg(listprice) > 700
group by ProductSubcategoryID, ListPrice;


-- JOINS
-- 1. Mostrar los precios de venta de aquellos productos donde el precio de venta sea inferior al
-- precio de lista recomendado para ese producto ordenados por nombre de producto.
-- Tablas: salesorderdetail, product
-- Campos: ProductID, Name, ListPrice, UnitPrice
select p.ProductID, p.Name, p.ListPrice, sd.UnitPrice from salesorderdetail sd
	join product p on p.ProductID = sd.ProductID
where UnitPrice < listprice
order by p.name;


-- 2. Mostrar todos los productos que tengan el mismo precio (precio de venta y precio de lista) y
-- que tengan un color asignado (no nulo). Se deben mostrar de a pares, código y nombre de cada
-- uno de los dos productos y el precio de ambos.
-- Ordenar por precio de venta en forma descendente.
-- Tablas: product, salesorderdetail
-- Campos: ProductID, Name, ListPrice, UnitPrice, Color
select p.ProductID, p.Name, p.ListPrice, sd.UnitPrice, p.Color from salesorderdetail sd
	join product p on p.ProductID = sd.ProductID
where sd.unitprice = p.listprice and color is not null;


-- 3. Mostrar el nombre de los productos y el nombre de los proveedores cuya subcategoría es 15.
-- Tablas: product, productVendor, vendor
-- Campos: Name, ProductID, BusinessEntityID, ProductSubcategoryID
select p.Name as productos, v.name, p.ProductSubcategoryID from productvendor pv
	join product p on p.ProductID = pv.ProductID
    join vendor v on v.VendorID = pv.VendorID
where ProductSubcategoryID = 15;


-- 4. Mostrar todas las personas (nombre y apellido) y en el caso que sean empleados mostrar
-- también el login id. Además, mostrar solo aquellos que tienen un ID de territorio 1, 4, 7 y 10.
-- Tablas: employee, person, salesperson
-- Campos: FirstName, LastName, LoginID, BusinessEntityID, TerritoryID