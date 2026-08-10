-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- Combina ventas, clientes, productos y territorios en una sola vista.
SELECT 
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    p.categoria,
    v.cantidad,
    p.precio AS precio_unitario,
    v.total_venta,
    v.canal
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN territorios t ON v.id_territorio = t.id_territorio;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
-- Identifica clientes registrados que aún no realizaron compras.
SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- Identifica productos del catálogo que no tienen movimiento.
SELECT 
    p.nombre_producto,
    p.categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Consulta 4 — Consolidado por canal (UNION ALL)
-- Combina ventas Online y Presencial y calcula el total por canal con GROUP BY.
SELECT 
    canal_origen AS canal,
    SUM(total_venta) AS total_por_canal
FROM (
    SELECT total_venta, 'Online' AS canal_origen
    FROM ventas
    WHERE canal = 'Online'
    
    UNION ALL
    
    SELECT total_venta, 'Presencial' AS canal_origen
    FROM ventas
    WHERE canal = 'Presencial'
) AS ventas_consolidadas
GROUP BY canal_origen;
