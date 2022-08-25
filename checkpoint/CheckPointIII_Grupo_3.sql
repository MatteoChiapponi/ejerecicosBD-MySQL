-- 0522tdbd1n1c10laed0222pt
-- grupo 3
-- Matteo Chiapponi
-- Pablo Nicolas Merino 
-- Martin Fernandez
-- Gregorio Santolaya

use dhespegar;
-- 1.
select r.*, h.ciudad from reservas r
left join hotelesxreserva hxr on hxr.idreserva = r.idreserva
join hoteles h on h.idhotel = hxr.idhotel
where h.ciudad = "napoles";
-- 6 rows returned

-- 2. 
select * from pagos p
join metodospago mp on mp.idmetodospago = p.idmetodospago
where mp.nombre = "tarjeta de credito";
-- 19 rows returned

-- 3. 
select count(r.idreserva), mp.nombre
from reservas r
join pagos p on p.idpago = r.idpago
join metodospago mp on mp.idmetodospago = p.idmetodospago
group by mp.nombre;
-- 3 rows returned

-- 4.
select r.idreserva, c.nombres, c.apellidos, pa.nombre, mp.nombre
from reservas r
join clientes c on c.idcliente = r.idcliente
join pagos p on p.idpago = r.idpago
join metodospago mp on mp.idmetodospago = p.idmetodospago
join paises pa on pa.idpais = c.idpais
where mp.nombre = "tarjeta de credito";
-- 19 rows returned

-- 5.
select count(hxr.idreserva), p.nombre
from hotelesxreserva hxr
join reservas r on r.idreserva = hxr.idreserva
join clientes c on c.idcliente = r.idcliente
join paises p on p.idpais = c.idpais
group by p.nombre;
-- 9 rows returned

-- 6.
select c.nombres, c.apellidos, c.numeropasaporte, c.ciudad, pa.nombre
from clientes c
join paises pa on pa.idpais = c.idpais
where pa.nombre = "peru" ;
-- 5 rows returned

-- 7.
select count(r.idreserva), concat(c.nombres," ", c.apellidos) as "nombre completo", mp.nombre
from reservas r
join pagos p on p.idpago = r.idpago
join metodospago mp on mp.idmetodospago = p.idmetodospago
join clientes c on c.idcliente = r.idcliente
group by concat(c.nombres," ", c.apellidos), mp.nombre;
-- 51 rows returned

-- 8.
select count(c.idcliente), p.nombre
from clientes c
join paises p on p.idpais = c.idpais
group by p.nombre;
-- 11 rows returned

-- 9.
select hxr.idhotel, h.nombre, h.direccion, h.ciudad, pa.nombre, th.nombre
from hotelesxreserva hxr 
join hoteles h on h.idhotel = hxr.idhotel
join tiposhospedaje th on th.idtiposhospedaje = hxr.idtiposhospedaje
join reservas r on r.idreserva = hxr.idreserva
join clientes c on c.idcliente = r.idcliente
join paises pa on pa.idpais = c.idpais
where th.nombre = "media pension";
-- 22 row returned

-- 10.
select mp.nombre, sum(p.preciototal) as total
from pagos p
join metodospago mp on mp.idmetodospago = p.idmetodospago
group by mp.nombre;
-- 3 rows returned

-- 11.
select sum(p.preciototal) as "total mendoza", s.ciudad
from sucursales s
join reservas r on r.idsucursal = s.idsucursal
join pagos p on p.idpago = r.idpago
where s.ciudad = "mendoza";
-- 1 row returned

-- 12.
select c.nombres, r.*
from clientes c
left join reservas r on r.idCliente = c.idcliente
where r.idreserva is null;
-- 33 rows returned

-- 13.
select vxr.idreserva, v.idvuelo, v.fechaPartida, v.fechaLlegada, r.fecharegistro, v.destino,v.origen
from vuelosxreserva vxr
join vuelos v on v.idvuelo = vxr.idvuelo
join reservas r on r.idreserva = vxr.idreserva
where v.destino = "ecuador" and v.origen = "chile";
-- 3 rows returned

-- 14.
select h.nombre, h.cantidadHabitaciones, p.nombre
from hoteles h
join paises p on p.idpais = h.idpais
where h.cantidadhabitaciones between 30 and 70 and p.nombre = "argentina";
-- 3 rows returned

-- 15.
select * from hotelesxreserva
where idHotel = 16;
select count(r.idreserva), h.nombre, hxr.idHotel
from hotelesxreserva hxr
join hoteles h on h.idhotel = hxr.idHotel
join reservas r on r.idReserva = hxr.idReserva
group by h.nombre, hxr.idHotel
order by count(r.idreserva) desc
limit 10;
-- 10 rows returned

-- 16.
select c.nombres, c.apellidos, mp.nombre
from clientes c
join reservas r on r.idcliente = c.idcliente
join pagos p on p.idpago = r.idPago
join metodospago mp on mp.idmetodospago = p.idMetodosPago
order by c.apellidos;
-- 62 rows returned

-- 17.
select count(r.idReserva),v.origen
from vuelosxreserva vxr
join vuelos v on v.idvuelo = vxr.idVuelo
join reservas r on r.idreserva = vxr.idReserva
where v.origen = "argentina" or v.origen = "colombia"
group by v.origen, v.fechaPartida,v.destino, v.nroVuelo
having v.fechaPartida like "% 18%";
-- 3 rows returned

-- 18.
select sum(pa.precioTotal) as total, p.nombre
from reservas r
join pagos pa on pa.idpago = r.idPago
join sucursales s on s.idsucursal = r.idsucursal
join paises p on p.idpais = s.idpais
group by p.nombre
order by total desc;
-- 2 rows returned

-- 19.
select p.nombre, c.nombres
from clientes c
right join paises p on p.idpais = c.idPais
where c.nombres is null
order by p.nombre desc;
-- 19 rows returned

-- 20.
select h.nombre, hxr.idreserva
from hoteles h
left join hotelesxreserva hxr on h.idhotel = hxr.idHotel
where hxr.idReserva > 2;
-- 33 rows returned