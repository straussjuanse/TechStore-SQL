-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes.
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(id_venta) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-- Consulta 2 — Ranking de productos
-- Top 5 de id_producto por total facturado, unidades vendidas y total generado.
SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC
LIMIT 5;

-- Consulta 3 — Clientes recurrentes
-- Clientes con más de un pedido, mostrando cantidad de pedidos y total gastado.
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- Consulta 4 — Meses por encima/por debajo del promedio
-- Total facturado por mes etiquetado con CASE WHEN comparado al promedio mensual.
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT SUM(cantidad * precio_unitario) / COUNT(DISTINCT EXTRACT(MONTH FROM fecha_venta)) 
            FROM ventas
        ) THEN 'Por encima'
        WHEN SUM(cantidad * precio_unitario) = (
            SELECT SUM(cantidad * precio_unitario) / COUNT(DISTINCT EXTRACT(MONTH FROM fecha_venta)) 
            FROM ventas
        ) THEN 'Igual al promedio'
        ELSE 'Por debajo'
    END AS desempeno_mensual
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

/*
1. El producto con ID 1 (Laptop Pro 15) concentra más del 55% de la facturación total generada ($3600 sobre un total de $6444), siendo la pieza fundamental para la rentabilidad de la tienda.
2. Todos los clientes registrados en la base (IDs del 1 al 5) realizaron exactamente 2 compras cada uno, lo que evidencia una base inicial de ventas pequeña pero con un 100% de recurrencia en clientes.
3. El 100% de las transacciones registradas hasta el momento ocurrieron en el mes 3 (marzo). Esto hace que en el análisis de desempeño mensual (Consulta 4), el mes 3 registre exactamente el promedio total al no haber dispersión de datos.
*/
