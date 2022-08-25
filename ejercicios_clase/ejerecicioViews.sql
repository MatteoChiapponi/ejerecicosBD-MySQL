use muestra_basica;

-- Crear vista
create view view_cliente as
	select * from cliente;

select * from view_cliente;

-- Modificar vista
Alter view view_cliente as
	Select count(*) from cliente;

-- Borrar vista
Drop view view_cliente;

-- consultar vista
Select * from view_cliente;

-- CRUD vista simple
insert into view_cliente values (default, 'Perez', 'Ricardo', '23658898');
insert into view_cliente values (1, 'Fernandez', 'Ruben', '17896588');
update view_cliente set nombre='Antonio Javier' where id=1;
Delete from view_cliente where id=1;


Select * from cliente;

-- Vista compleja
create view v_cliente2 as 
	select c.* from cliente c
		inner join factura f on f.cliente_id = c.id; 

Select * from v_cliente2;
insert into v_cliente2  values (default, 'Garcia', 'Ramon', '35874789');
insert into v_cliente2 (id, apellido, nombre, documento_nro) values(default, 'Paz', 'Carlos', '35874789');
Delete from v_cliente2 where idusuario=9;
update v_cliente2 set nombre = 'Martin' where id=1;
