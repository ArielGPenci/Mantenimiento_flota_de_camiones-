-- =====================================================
-- MANTENIMIENTO FLOTA ACTROS (versión corregida)
-- Tabla: maintenance_log_actros_usd
-- =====================================================

-- 1. PROMEDIO DE COSTO DE REPARACION POR CAMION
-- Se elimina Description (no estaba agrupada). Camiones 1 y 33 suelen salir arriba.
SELECT Truck_ID,
       ROUND(AVG(Cost_USD), 2) AS Costo_promedio_USD
FROM maintenance_log_actros_usd
GROUP BY Truck_ID
ORDER BY Costo_promedio_USD DESC;

-- 2. MANTENIMIENTOS CORRECTIVOS POR CAMION Y PIEZA
SELECT Truck_ID, Part_Replaced,
       COUNT(*) AS Cantidad_de_reparaciones
FROM maintenance_log_actros_usd
WHERE Maintenance_Type = 'Corrective'
GROUP BY Truck_ID, Part_Replaced
ORDER BY Cantidad_de_reparaciones DESC;

-- 3. CAMIONES CON MAS REPARACIONES CORRECTIVAS
SELECT Truck_ID,
       COUNT(*) AS Cantidad_de_reparaciones_correctivas
FROM maintenance_log_actros_usd
WHERE Maintenance_Type = 'Corrective'
GROUP BY Truck_ID
ORDER BY Cantidad_de_reparaciones_correctivas DESC;

-- 4. COSTO TOTAL CORRECTIVO POR CAMION
SELECT Truck_ID,
       SUM(Cost_USD) AS Costo_total_correctivo
FROM maintenance_log_actros_usd
WHERE Maintenance_Type = 'Corrective'
GROUP BY Truck_ID
ORDER BY Costo_total_correctivo DESC;

-- 5. COSTO TOTAL PREVENTIVO POR CAMION
SELECT Truck_ID,
       SUM(Cost_USD) AS Costo_total_preventivo
FROM maintenance_log_actros_usd
WHERE Maintenance_Type = 'Preventive'
GROUP BY Truck_ID
ORDER BY Costo_total_preventivo DESC;

-- 6. COSTO TOTAL DE MANTENIMIENTO POR CAMION (preventivo + correctivo)
-- Se desglosa en columnas para comparar de un vistazo.
SELECT Truck_ID,
       SUM(CASE WHEN Maintenance_Type = 'Preventive' THEN Cost_USD ELSE 0 END) AS Preventivo,
       SUM(CASE WHEN Maintenance_Type = 'Corrective' THEN Cost_USD ELSE 0 END) AS Correctivo,
       SUM(Cost_USD) AS Costo_total
FROM maintenance_log_actros_usd
GROUP BY Truck_ID
ORDER BY Costo_total DESC;

-- 7. PIEZAS MAS CAMBIADAS - PREVENTIVOS (agrupa solo por pieza)
SELECT Part_Replaced,
       COUNT(*) AS Veces_cambiada
FROM maintenance_log_actros_usd
WHERE Maintenance_Type = 'Preventive'
GROUP BY Part_Replaced
ORDER BY Veces_cambiada DESC;

-- 8. PIEZAS MAS CAMBIADAS - CORRECTIVOS
SELECT Part_Replaced,
       COUNT(*) AS Veces_cambiada
FROM maintenance_log_actros_usd
WHERE Maintenance_Type = 'Corrective'
GROUP BY Part_Replaced
ORDER BY Veces_cambiada DESC;

-- 9. DIAS FUERA DE SERVICIO POR CAMION
-- SUM en lugar de COUNT: COUNT solo contaba filas, no días.
SELECT Truck_ID,
       SUM(Downtime_Days) AS Dias_fuera_de_servicio
FROM maintenance_log_actros_usd
GROUP BY Truck_ID
ORDER BY Dias_fuera_de_servicio DESC;

-- 10. REPARACIONES NO PROGRAMADAS POR CONDUCTOR
-- Se usa una lista DISTINCT conductor-camión para que el JOIN no multiplique filas.
-- LIMITACION: si un camión tuvo varios conductores, se atribuye a todos.
-- Para precisión, agregar un cruce por fecha si driver_performance la tiene.
SELECT d.Driver_Name,
       m.Truck_ID,
       COUNT(*) AS Cantidad_reparaciones_no_programadas
FROM maintenance_log_actros_usd m
JOIN (SELECT DISTINCT Driver_Name, Truck_ID
      FROM driver_performance_actros_usd) d
  ON d.Truck_ID = m.Truck_ID
WHERE m.Remarks LIKE '%Unsch%'
GROUP BY d.Driver_Name, m.Truck_ID
ORDER BY Cantidad_reparaciones_no_programadas DESC;

-- 11. ACLARACIONES DE REPARACIONES NO PROGRAMADAS POR CAMION Y CONDUCTOR
SELECT d.Driver_Name,
       m.Truck_ID,
       m.Remarks
FROM maintenance_log_actros_usd m
JOIN (SELECT DISTINCT Driver_Name, Truck_ID
      FROM driver_performance_actros_usd) d
  ON d.Truck_ID = m.Truck_ID
WHERE m.Remarks LIKE '%Unsch%'
ORDER BY m.Truck_ID;

-- 12. SERVICIOS PREVENTIVOS 2025 POR MES Y CAMION
-- Rango semiabierto: incluye todo el 31/12 aunque Date sea DATETIME.
SELECT MONTH(Date) AS Mes,
       Truck_ID,
       COUNT(*) AS Cantidad_servicios_al_mes
FROM maintenance_log_actros_usd
WHERE Date >= '2025-01-01' AND Date < '2026-01-01'
  AND Maintenance_Type = 'Preventive'
GROUP BY MONTH(Date), Truck_ID
ORDER BY Mes, Truck_ID;

-- 13. SERVICIOS CORRECTIVOS 2025 POR MES Y CAMION
SELECT MONTH(Date) AS Mes,
       Truck_ID,
       COUNT(*) AS Cantidad_servicios_al_mes
FROM maintenance_log_actros_usd
WHERE Date >= '2025-01-01' AND Date < '2026-01-01'
  AND Maintenance_Type = 'Corrective'
GROUP BY MONTH(Date), Truck_ID
ORDER BY Mes, Truck_ID;
