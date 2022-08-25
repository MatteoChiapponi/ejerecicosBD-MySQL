SELECT @@sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

USE musimundos;

-- Realizar una consulta sobre la tabla canciones con la siguiente información:
-- ● Solo los 10 primeros caracteres del nombre de la canción en mayúscula.
-- ● Los años de antigüedad que tiene cada canción desde su publicación. Ej:
-- 25 años.
-- ● El peso en KBytes en número entero (sin decimales, 1024 Bytes = 1 KB)
-- ● El precio formateado con 3 decimales, Ej: $100.123
-- ● El primer compositor de la canción (notar que si hay más de uno, estos
-- se separan por coma)

select substring(upper(nombre), 1, 10) as nombre, (round(bytes) / 1000) as KiloBytes,
round(precio_unitario, 3) as 'Precio',
case
	when compositor = '' then 'SIN DATOS'
    else compositor
end as compositor
from canciones;
