SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE musimundos;

-- SP: Clientes por País y Ciudad
-- Tabla: Clientes
-- 1. Crear un stored procedure que solicite como parámetros de entrada el
-- nombre de un país y una ciudad, y que devuelva como resultado la
-- información de contacto de todos los clientes de ese país y ciudad.
-- En el caso que el parámetro de ciudad esté vacío, se debe devolver todos los
-- clientes del país indicado.
DELIMITER $$
create procedure sp_clientesPor_pais_ciudad (in nombrePais varchar(15), in nombreCiudad varchar(20))
BEGIN
	if 
		nombreCiudad is null then select * from clientes where pais = nombrePais;
	else 
		select * from clientes where pais = nombrePais and ciudad = nombreCiudad;
	end if;
END $$


-- 2. Invocar el procedimiento para obtener la información de los clientes de
-- Brasilia en Brazil.
call sp_clientesPor_pais_ciudad('Brazil', 'Brasilia');

-- 3. Invocar el procedimiento para obtener la información de todos los clientes
-- de Brazil.
call sp_clientesPor_pais_ciudad('Brazil', null);


-- SP: Géneros musicales
-- Tabla: Generos
-- 1. Crear un stored procedure que reciba como parámetro un nombre de
-- género musical y lo inserte en la tabla de géneros.
-- Además, el stored procedure debe devolver el id de género que se insertó.
-- TIP! Para calcular el nuevo id incluir la siguiente línea dentro del bloque de
-- código del SP: SET nuevoid = (SELECT MAX(id) FROM generos) + 1;
DELIMITER $$
create procedure sp_generosMusicales (in nombreGenero varchar(20))
BEGIN
	declare nuevoid int default 0;
	SET @nuevoid = (SELECT MAX(id) FROM generos) + 1;
    
	insert into generos (id, nombre) values (@nuevoid, nombreGenero);
    select * from generos where nombre = nombreGenero;
END $$

-- 2. Invocar el stored procedure creado para insertar el género Funk. ¿Qué id
-- devolvió el SP ? Consultar la tabla de géneros para ver los cambios.
call sp_generosMusicales ('Funk');

-- 3. Repetir el paso anterior insertando esta vez el género Tango.
call sp_generosMusicales ('Tango');



