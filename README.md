# Mantenimiento_flota_de_camiones-
Análisis rápido de costos y eficiencia operativa de una flota de transporte de carga. Una empresa con camiones Mercedes-Benz Actros quiere conocer los costos de las unidades, rutas o conductores que generan pérdidas. Los dos scripts abordan los dos mayores costos de operar camiones: el combustible y el mantenimiento.

Script de combustible: eficiencia y control del gasto

Busca responder:

¿Qué rutas son menos rentables? Si una ruta tiene mal rendimiento (km por litro), conviene renegociar tarifas, cambiar el trayecto o asignarle otro tipo de unidad.
¿Qué conductores consumen más? El estilo de manejo influye mucho en el consumo. Sirve para capacitar, dar incentivos o detectar malas prácticas.
¿Dónde se carga y cuánto? Concentrar las cargas en ciertas estaciones permite negociar descuentos por volumen y detectar posibles irregularidades en los cupones.
¿Cuánto gasta cada conductor en dólares? Convierte el consumo en un costo concreto para presupuestar y controlar.
Script de mantenimiento: costo del ciclo de vida y disponibilidad

Busca responder:

¿Qué camiones cuestan demasiado? Tu comentario sobre los camiones 1 y 33 apunta a esto: decidir si conviene seguir reparándolos o reemplazarlos.
¿Preventivo o correctivo? Comparar ambos costos permite ver si se está invirtiendo lo suficiente en prevención. En general, un mantenimiento correctivo (por avería) cuesta más y para más tiempo al camión.
¿Qué piezas fallan más? Sirve para negociar con proveedores, tener repuestos en stock y detectar defectos recurrentes.
¿Cuántos días está parado cada camión? Un camión parado no factura, así que es un costo de oportunidad muy alto.
¿Qué conductores se asocian a más reparaciones no programadas? Puede indicar mal uso de la unidad, aunque con la limitación del JOIN que comentamos.
¿Cuándo se hacen los servicios? Ver el calendario de 2025 ayuda a planificar el mantenimiento y evitar que varias unidades queden fuera de servicio a la vez.
El objetivo de fondo

Combinados, los scripts alimentan decisiones como:

Reducir el costo por kilómetro, que es el indicador clave en transporte.
Decidir renovación de flota: qué camiones vender o reemplazar.
Optimizar rutas y asignación de conductores.
Pasar de mantenimiento reactivo a preventivo, con menos paradas y mayor disponibilidad.
Detectar fraudes o ineficiencias en consumo y cupones.
