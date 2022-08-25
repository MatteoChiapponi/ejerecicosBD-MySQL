use musimundos;

DELIMITER $$
create procedure sp_ver_artistas()
Begin
	select * from artistas;
end$$;

call sp_ver_artistas();

DELIMITER $$
create procedure sp_ver_artistas2(IN pid INT)
Begin
	select * from artistas where id = pid;
end$$;

call sp_ver_artistas2(5);

DELIMITER $$
create procedure sp_actualizar_artistas(IN pid INT, IN pnombre varchar(50))
Begin
	select * from artistas where id = pid;
	update artistas set nombre = pnombre where id = pid;
    select * from artistas where id = pid;
end$$

call sp_actualizar_artistas(5, 'xxx');

DELIMITER $$
create procedure sp_ver_nombre_genero(IN pid INT, OUT pnombre varchar(50), OUT pgenero varchar(50))
Begin
	select c.nombre, g.nombre into pnombre, pgenero
	from canciones c
		join generos g on g.id = c.id_genero
	where c.id = pid;
end$$

call sp_ver_nombre_genero(25, @nombre, @genero);
select @nombre, @genero;

DELIMITER $$
create procedure sp_ver_total_rock(INOUT total INT)
Begin
	select count(*) into total
    from canciones c
		join generos g on g.id = c.id_genero
	where g.nombre='rock';
end$$

set @total = 0;
call sp_ver_total_rock(@total);
select @total;


