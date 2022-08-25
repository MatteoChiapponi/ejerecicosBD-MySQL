SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE adventureworks;

-- Where
-- 1. Mostrar los nombre de los productos que tengan cualquier combinación de
-- ‘mountain bike’
-- Tablas: Product
-- Campos: Name

select name from product where name like 'mountain bike%';


-- 2. Mostrar las personas cuyo nombre empiece con la letra “y”
-- Tablas: Contact
-- Campos: FirstName

select firstname from contact where firstname like 'y%';


-- Order by
-- 1. Mostrar cinco productos más caros y su nombre ordenado en forma alfabética
-- Tablas: Product
-- Campos: Name, ListPrice

select name, listprice from product order by listprice desc, name limit 5;


-- Operadores & joins
-- 1. Mostrar el nombre concatenado con el apellido de las personas cuyo apellido sea
-- johnson
-- Tablas: Contact
-- Campos: FirstName, LastName

select concat(firstname, ' ', lastname) as nombreCompleto from contact where lastname = 'johnson';


-- 2. Mostrar todos los productos cuyo precio sea inferior a 150$ de color rojo o cuyo
-- precio sea mayor a 500$ de color negro
-- Tablas: Product
-- Campos: ListPrice, Color

select listprice, color from product 
where listprice < 150 and color = 'red' 
or listprice > 500 and color = 'black';


-- Funciones de agregación
-- 1. Mostrar la fecha más reciente de venta
-- Tablas: SalesOrderHeader
-- Campos: OrderDate

select max(orderdate) from salesorderheader;


-- 2. Mostrar el precio más barato de todas las bicicletas
-- Tablas: Product
-- Campos: ListPrice, Name

select min(listprice), name from product where listprice != 0;

-- Group by
-- 1. Mostrar los productos y la cantidad total vendida de cada uno de ellos
-- Tablas: SalesOrderDetail
-- Campos: ProductID, OrderQty

select productid, count(orderqty) as 'Cantidad total vendida' from salesorderdetail group by ProductID;


-- Having
-- 1. Mostrar la cantidad de facturas que vendieron más de 20 unidades.
-- Tablas: Sales.SalesOrderDetail
-- Campos: SalesOrderID, OrderQty

select count(salesorderid) as 'Cantidad facturas', orderqty from SalesOrderDetail 
group by orderqty 
having orderqty > 20;



-- Joins
-- 1. Mostrar el código de logueo, número de territorio y sueldo básico de los
-- vendedores
-- Tablas: Employee, SalesPerson
-- Campos: LoginID, TerritoryID, Bonus, BusinessEntityID

-- select e.loginid, s.territoryid, s.bonus, businessentityid from 


-- 2. Mostrar los productos que sean ruedas
-- Tablas: Product, ProductSubcategory
-- Campos: Name, ProductSubcategoryID

select p.name, ps.ProductSubcategoryID, ps.name from product p
	join productsubcategory ps on ps.ProductsubCategoryID = p.ProductsubCategoryID
where ps.name = 'Wheels';


-- 3. Mostrar los nombres de los productos que no son bicicletas
-- Tablas: Product, ProductSubcategory
-- Campos: Name, ProductSubcategoryID

select p.name, ps.productsubcategoryid, ps.name from product p
	join productsubcategory ps on ps.ProductsubCategoryID = p.ProductsubCategoryID
where ps.name not like '%bikes%';