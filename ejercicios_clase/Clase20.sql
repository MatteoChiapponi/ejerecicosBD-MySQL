SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE adventureworks;

-- Where
-- 1. Mostrar el nombre, precio y color de los accesorios para asientos de las bicicletas
-- cuyo precio sea mayor a 100 pesos
-- Tablas: Production.Product
-- Campos: Name, ListPrice, Color

select name, listprice, color from product where name like '%seat%' and listprice > 100;


-- Operadores & joins
-- 1. Mostrar los empleados que tienen más de 90 horas de vacaciones
-- Tablas: Employee
-- Campos: VacationHours, BusinessEntityID

select e.vacationhours, concat(c.firstname, ' ', c.lastname) as nombreCompleto from employee e
	join contact c on c.contactid = e.contactid
where vacationhours > 90;


-- 2. Mostrar el nombre, precio y precio con iva de los productos con precio distinto de cero
-- Tablas: Product
-- Campos: Name, ListPrice

select name, listprice, (listprice * 1.21 ) as IVA from product where listprice != 0;


-- 3. Mostrar precio y nombre de los productos 776, 777, 778
-- Tablas: Product
-- Campos: ProductID, Name, ListPrice
-- Order by

select productid, name, listprice from product where ProductID = 776 or ProductID = 777 or ProductID = 778;


-- 1. Mostrar las personas ordenadas primero por su apellido y luego por su nombre
-- Tablas: Contact
-- Campos: Firstname, Lastname

select firstname, lastname from contact order by lastname, firstname;


-- Funciones de agregación
-- 1. Mostrar la cantidad y el total vendido por productos
-- Tablas: SalesOrderDetail
-- Campos: LineTotal

select productid, sum(linetotal) as totalVendido, sum(orderqty) as Cantidad from SalesOrderDetail
group by productid;


-- Group by
-- 1. Mostrar el código de subcategoría y el precio del producto más barato de cada una
-- de ellas
-- Tablas: Product
-- Campos: ProductSubcategoryID, ListPrice

select ProductSubcategoryID, min(listPrice) from product 
group by ProductSubcategoryID
having min(listprice) != 0;


-- Having
-- 1. Mostrar todas las facturas realizadas y el total facturado de cada una de ellas
-- ordenado por número de factura pero sólo de aquellas órdenes superen un total de
-- $10.000
-- Tablas: SalesOrderDetail
-- Campos: SalesOrderID, LineTotal

select salesorderid, sum(linetotal) as totalFacturado from salesorderdetail
group by SalesOrderID 
having sum(LineTotal) > 10000
order by salesorderid;


-- Joins
-- 1. Mostrar los empleados que también son vendedores
-- Tablas: Employee, SalesPerson
-- Campos: BusinessEntityID

-- concat(c.LastName, ' ', c.FirstName) as nombreCompleto,
select  vc.vendorid, e.employeeid from vendorcontact vc
    join employee e on e.ContactID = vc.ContactID;
    

-- 2. Mostrar los empleados ordenados alfabéticamente por apellido y por nombre
-- Tablas: Employee, Contact
-- Campos: BusinessEntityID, LastName, FirstName

select e.employeeid, c.LastName, c.FirstName from contact c
	join employee e on c.contactid = e.contactid
order by c.lastname, c.FirstName;