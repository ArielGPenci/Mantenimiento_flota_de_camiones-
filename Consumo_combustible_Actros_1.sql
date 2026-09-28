-- =====================================================
-- CONSUMO DE COMBUSTIBLE - FLOTA ACTROS (versión corregida)
-- Tabla: fuel_sheet_actros_usd
-- =====================================================

-- 1. RUTAS QUE MAS COMBUSTIBLE GASTAN
-- Km_por_Lit bajo = peor rendimiento = mayor gasto, por eso ORDER BY ASC.
-- Se agrupa solo por Route (antes también por Dist_Covered).
SELECT Route,
       ROUND(AVG(Km_por_Lit), 2) AS Promedio_km_por_litro
FROM fuel_sheet_actros_usd
GROUP BY Route
ORDER BY Promedio_km_por_litro ASC;

-- 2. CONSUMO PROMEDIO POR CONDUCTOR (peores rendimientos primero)
SELECT Driver_Name,
       ROUND(AVG(Km_por_Lit), 2) AS Consumo_promedio_por_conductor
FROM fuel_sheet_actros_usd
GROUP BY Driver_Name
ORDER BY Consumo_promedio_por_conductor ASC;

-- 3. CUPONES DE COMBUSTIBLE POR CONDUCTOR Y CAMION
SELECT Driver_Name,
       Truck_ID,
       COUNT(Coupon_ID) AS Cantidad_cupones
FROM fuel_sheet_actros_usd
GROUP BY Driver_Name, Truck_ID
ORDER BY Cantidad_cupones DESC;

-- 4. ESTACIONES DONDE MAS SE CARGA COMBUSTIBLE
SELECT Pump_Location,
       COUNT(Coupon_ID) AS Cantidad_recargas
FROM fuel_sheet_actros_usd
GROUP BY Pump_Location
ORDER BY Cantidad_recargas DESC;

-- 5. COSTO DE COMBUSTIBLE POR CONDUCTOR
-- 'Total fuel cost: $' tiene 18 caracteres; se usa CHAR_LENGTH para no
-- depender de un número fijo. Luego se convierte a número para poder sumar.
-- Si Remarks no contiene el texto, la fila se ignora.
SELECT Driver_Name,
       COUNT(*) AS Cantidad_cargas,
       ROUND(SUM(costo), 2) AS Costo_total_USD,
       ROUND(AVG(costo), 2) AS Costo_promedio_por_carga_USD
FROM (
    SELECT Driver_Name,
           CAST(
               REPLACE(
                   REPLACE(
                       SUBSTRING(Remarks,
                                 LOCATE('Total fuel cost: $', Remarks)
                                 + CHAR_LENGTH('Total fuel cost: $')),
                       ' USD', ''),
                   ',', '')
               AS DECIMAL(12,2)) AS costo
    FROM fuel_sheet_actros_usd
    WHERE LOCATE('Total fuel cost: $', Remarks) > 0
) AS t
GROUP BY Driver_Name
ORDER BY Costo_total_USD DESC;
