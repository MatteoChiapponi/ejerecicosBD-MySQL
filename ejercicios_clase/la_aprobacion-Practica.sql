SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE la_aprobacion;

-- Consigna - CheckPoint III
-- 1. Listar los servicios básicos de la habitación número 25.
select h.numero as 'numero habitacion', sb.* from servicio_basico sb
	join habitacion_x_servicio_basico hxs on hxs.servicio_basico_id = sb.id
    join habitacion h on h.numero = hxs.habitacion_numero
where h.numero = 25;
-- 4 row(s) returned

-- 2. Listar absolutamente todos los servicios básicos y la cantidad de habitaciones en
-- las que están instalados. Mostrar sólo el nombre del servicio básico y cantidad.
select count(hxs.habitacion_numero) as 'Cantidad habitaciones instalados', sb.nombre
from servicio_basico sb
	join habitacion_x_servicio_basico hxs on hxs.servicio_basico_id = sb.id
group by sb.nombre;
-- 10 row(s) returned

-- 3. Listar todos los huéspedes que tengan tres o más check-in. Mostrar el número
-- de huésped, apellido y nombre separado por un espacio dentro de una misma
-- columna denominada "Cliente" y, la cantidad de check-in que posee.
select count(c.id) as 'cantidad de check-in', h.id, concat(h.apellido, ' ', h.nombre) as Cliente
from huesped h
	join checkin c on c.huesped_id = h.id
group by h.id
having count(c.id) >= 3;
-- 23 row(s) returned

-- 4. Listar todos los huéspedes que no tengan un check-in. Mostrar el número de
-- huésped, apellido y nombre en mayúsculas dentro de una misma columna
-- denominada "huésped sin check-in".
select h.id as 'numero de huesped', concat(h.apellido, ' ', h.nombre) as "huésped sin check-in", c.id
from huesped h
	left join checkin c on c.huesped_id = h.id
where c.id is null;
-- 16 row(s) returned

-- 5. Listar todos los huéspedes que tengan al menos un check-in que corresponda a
-- la habitación de clase 'Classic'. Se debe mostrar el número de huésped, apellido,
-- nombre, número de habitación y la clase.
select count(ch.id) as 'cantidad de check-in',  cl.nombre as 'tipo de clase', hue.id as 'numero de huesped',
hue.apellido, hue.nombre, hab.numero as 'nro habitacion' from habitacion hab
	join checkin ch on ch.habitacion_numero = hab.numero
    join huesped hue on hue.id = ch.huesped_id
    join clase cl on cl.id = hab.clase_id
group by  hue.id, hue.apellido, hue.nombre, hab.numero, cl.nombre
having count(ch.id) >= 1 and cl.nombre = 'Classic';
-- 44 row(s) returned

-- 6. Listar los huéspedes que tengan una o más reservas y que en la segunda letra de
-- su apellido contenga una "u". Se debe mostrar el número de huésped, apellido,
-- nombre, nombre del servicio.
select count(r.id) as 'cantidad reservas', hue.id as 'nro huesped', hue.apellido, hue.nombre,
sb.nombre as 'Servicio Basico', se.nombre as 'Servicio Extra'
from huesped hue
	join reserva r on r.huesped_id = hue.id
    join habitacion_x_servicio_basico hxs
    join servicio_basico sb on sb.id = hxs.servicio_basico_id
    join servicio_extra se on se.id = r.servicio_extra_id
group by hue.id, hue.apellido, hue.nombre, sb.nombre, se.nombre
having count(r.id) >= 1 and hue.apellido like '_u%';
-- La cantidad de reservas esta mal
-- 90 row(s) affected
select count(*), huesped_id from reserva group by huesped_id;

-- 7. Listar absolutamente todos los países y la cantidad de huéspedes que tengan.
select count(hue.id) as 'cantidad huespedes', p.nombre from pais p
	left join huesped hue on hue.pais_id = p.id
group by p.nombre;
-- 20 row(s) returned

-- 8. Calcular el importe total y la cantidad de reservas realizadas en el mes de marzo
-- por cada huésped. Mostrar el apellido del huésped, importe total y cantidad de
-- reservas.
select count(r.id) as 'cantidad reservas', sum(r.importe) as 'importe total', hue.apellido
from reserva r
	join huesped hue on hue.id = r.huesped_id
where r.fecha like '%-03-%'
group by hue.apellido;
-- sin el where anda, con el where se caga


-- 0 row(s) affected

select h.apellido, sum(r.importe), count(r.id) as 'cantidad reservas' from reserva r
	join huesped h on h.id = r.huesped_id
group by h.apellido
having h.apellido = 'Medina';


-- 9. Calcular el importe total recaudado por mes (fecha de entrada) para la
-- habitación número 22. Mostrar el número de habitación, nombre de la
-- decoración, clase, nombre del mes y el importe total.
select ch.habitacion_numero, date_format(ch.fecha_entrada, '%M') as 'Mes', d.nombre, sum(ch.importe) 
as 'importe total', cl.nombre from checkin ch
	join habitacion h on h.numero = ch.habitacion_numero
    join clase cl on cl.id = h.clase_id
    join decoracion d on d.id = h.decoracion_id
where ch.habitacion_numero = 22
group by ch.habitacion_numero, ch.fecha_entrada, d.nombre, cl.nombre;
-- 3 row(s) affected

-- 10. Determinar la recaudación total por país para las habitaciones número 5, 10 y 22. Mostrar 
-- nombre del país, número de habitación y el total recaudado.
select p.nombre, ch.habitacion_numero, sum(ch.importe) as 'Total recaudado' from checkin ch
	join huesped h on h.id = ch.huesped_id
	join pais p on p.id = h.pais_id
where ch.habitacion_numero = 5 or ch.habitacion_numero = 10 or ch.habitacion_numero = 22
group by p.nombre, ch.habitacion_numero;
-- 8 row(s) affected

-- 11. Calcular la recaudación total de cada forma de pago para las reservas. Mostrar la
-- forma de pago y el total.
select f.nombre, sum(r.importe) as 'total' from reserva r
	join forma_pago f on f.id = r.forma_pago_id
group by f.nombre;
-- 4 row(s) affected

-- 12. Listar los empleados del sector 'administración' que su país de origen sea
-- 'Argentina'. Mostrar el número de legajo, apellido, la primera inicial del primer
-- nombre y un punto, nombre de su país de origen y el nombre del sector.
select e.legajo, e.apellido, concat(substring(e.nombre, 1,1), '.') as 'Primer nombre', p.nombre, s.nombre from empleado e
	join pais p on p.id = e.pais_id
	join sector s on s.id = e.sector_id
where s.nombre = 'Administración' and p.nombre = 'Argentina';
-- 3 row(s) affected

-- 13. Listar todos los servicios básicos que tienen las habitaciones (desde la 20 hasta
-- la 24) y su clase. Mostrar número de habitación, clase y el nombre de los
-- servicios básicos. Ordenar por número de habitación y servicio.
select sb.nombre 'servicio basico', cl.nombre as 'clase', hxs.habitacion_numero 
from habitacion_x_servicio_basico hxs
	join servicio_basico sb on sb.id = hxs.servicio_basico_id
	join habitacion h on h.numero = hxs.habitacion_numero
	join clase cl on cl.id = h.clase_id
where hxs.habitacion_numero between 20 and 24
order by hxs.habitacion_numero, sb.nombre;
-- 28 row(s) affected

-- 14. Listar las decoraciones que no están aplicadas en ninguna habitación.
select d.nombre as 'decoracion', h.numero as 'habitacion nro' from habitacion h
	right join decoracion d on d.id = h.decoracion_id
where h.numero is null;
-- 2 row(s) affected

-- 15. Listar todos los empleados categorizándolos por edad. Las categorías son:
-- 'junior' (hasta 35 años), 'semi-senior' (entre 36 a 40 años) y 'senior' (más de 40).
-- Mostrar el apellido, nombre, edad, categoría y ordenar por edad.
select apellido, nombre, (extract(year from now()) - extract(year from fecha_nacimiento)) as 'edad',
case 
	when (extract(year from now()) - extract(year from fecha_nacimiento)) <= 35 then 'junior'
    when (extract(year from now()) - extract(year from fecha_nacimiento)) <= 40 then 'semi-senior'
	when (extract(year from now()) - extract(year from fecha_nacimiento)) > 40 then 'senior'
end as 'categorias'
from empleado
order by (extract(year from now()) - extract(year from fecha_nacimiento)) desc;
-- 25 row(s) affected

-- 16. Calcular la cantidad y el promedio de cada forma de pago para los check-in.
-- Mostrar la forma de pago, cantidad y el promedio formateado con dos
-- decimales.
select fp.nombre, count(c.forma_pago_id) as 'cantidad', round(avg(c.importe), 2) as 'promedio' from checkin c
	join forma_pago fp on fp.id = c.forma_pago_id
group by fp.nombre ;
-- 4 row(s) affected

-- 17. Calcular la edad de los empleados de Argentina. Mostrar el apellido, nombre y la
-- edad del empleado.
select e.apellido, e.nombre, (extract(year from now()) - extract(year from e.fecha_nacimiento)) as 'edad' 
from empleado e
	join pais p on p.id = e.pais_id
where p.nombre = 'Argentina';
-- 17 row(s) affected

-- 18. Calcular el importe total para los check-in realizados por el huésped 'Mercado
-- Joel'. Mostrar apellido, nombre, importe total y el país de origen.
select sum(c.importe) as 'importe total', h.apellido, h.nombre, p.nombre from checkin c
	join huesped h on h.id = c.huesped_id
    join pais p on p.id = h.pais_id; 
-- 4 row(s) affected

-- 19. Listar la forma de pago empleada por cada servicio extra. Se debe mostrar el
-- nombre del servicio extra, nombre de la forma de pago y calcular la cantidad y
-- total recaudado.

-- 4 row(s) affected

-- 20. Listar la forma de pago empleada para el servicio extra 'Sauna' y los huéspedes
-- correspondientes. Se debe mostrar el nombre del servicio extra, nombre de la
-- forma de pago, número del cliente e importe total.

-- 4 row(s) affected