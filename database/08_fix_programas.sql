-- ============================================================
-- UNIGRADES - 08_fix_programas.sql
-- Deja solo la UNAL con sus 2 programas reales.
-- Todos los usuarios quedan en programa_id correcto.
-- EJECUTAR EN RAILWAY (base de datos unigrades)
-- ============================================================

USE unigrades;

-- ============================================================
-- PASO 1: Obtener el universidad_id de la UNAL
-- ============================================================
SET @unal_id = (SELECT universidad_id FROM universidad WHERE universidad_sigla = 'UNAL' LIMIT 1);
SELECT CONCAT('UNAL universidad_id = ', @unal_id) AS info;

-- ============================================================
-- PASO 2: Obtener los programa_ids actuales de la UNAL
-- ============================================================
SET @prog_cs = (
    SELECT programa_id FROM programa
    WHERE programa_universidad_id = @unal_id
      AND programa_nombre = 'Ciencias de la Computación'
    LIMIT 1
);
SET @prog_isis = (
    SELECT programa_id FROM programa
    WHERE programa_universidad_id = @unal_id
      AND programa_nombre = 'Ingeniería de Sistemas y Computación'
    LIMIT 1
);

SELECT CONCAT('Ciencias Computación programa_id = ', IFNULL(@prog_cs,'NULL')) AS info
UNION ALL
SELECT CONCAT('Ing. Sistemas programa_id = ', IFNULL(@prog_isis,'NULL'));

-- ============================================================
-- PASO 3: Crear ISIS si no existe
-- ============================================================
INSERT IGNORE INTO programa
    (programa_universidad_id, programa_nombre, programa_facultad, programa_total_creditos)
VALUES
    (@unal_id, 'Ingeniería de Sistemas y Computación', 'Facultad de Ingeniería', 165);

-- Refrescar variable
SET @prog_isis = (
    SELECT programa_id FROM programa
    WHERE programa_universidad_id = @unal_id
      AND programa_nombre = 'Ingeniería de Sistemas y Computación'
    LIMIT 1
);

-- ============================================================
-- PASO 4: Eliminar programas de otras universidades
-- (sus tipologías y materias se borran en cascada)
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM programa
WHERE programa_universidad_id != @unal_id;

-- Eliminar universidades que no son la UNAL
DELETE FROM universidad
WHERE universidad_id != @unal_id;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- PASO 5: Reasignar usuarios huérfanos al programa CS de la UNAL
-- ============================================================
UPDATE usuario
SET usuario_programa_id = @prog_cs
WHERE usuario_programa_id NOT IN (@prog_cs, @prog_isis);

-- ============================================================
-- PASO 6: Asegurar tipologías para ISIS (si no existen)
-- ============================================================
INSERT IGNORE INTO tipologia
    (tipologia_programa_id, tipologia_nombre, tipologia_creditos_requeridos, tipologia_cuenta_promedio)
VALUES
    (@prog_isis, 'Fundamentación Obligatoria',  50, 1),
    (@prog_isis, 'Disciplinar Obligatoria',     72, 1),
    (@prog_isis, 'Disciplinar Optativa',        18, 1),
    (@prog_isis, 'Libre Elección',              16, 1),
    (@prog_isis, 'Trabajo de Grado',             9, 1);

-- ============================================================
-- PASO 7: Materias de Fundamentación Obligatoria (ISIS)
-- ============================================================
INSERT IGNORE INTO materia
    (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos,
     materia_nota_minima_aprobacion, materia_semestre_sugerido)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos, 3.0, m.sem
FROM   tipologia t
CROSS  JOIN (
    SELECT '2016384' AS codigo, 'Introducción a la Ingeniería de Sistemas' AS nombre, 3 AS creditos, 1 AS sem UNION ALL
    SELECT '2025975', 'Matemáticas Discretas',                              3, 1 UNION ALL
    SELECT '2016386', 'Programación de Computadores',                       3, 1 UNION ALL
    SELECT '2016387', 'Cálculo Diferencial',                                4, 1 UNION ALL
    SELECT '2016388', 'Álgebra Lineal',                                     4, 2 UNION ALL
    SELECT '2016699', 'Estructuras de Datos',                               3, 2 UNION ALL
    SELECT '2016389', 'Cálculo Integral',                                   4, 2 UNION ALL
    SELECT '2016160', 'Programación Orientada a Objetos',                   3, 2 UNION ALL
    SELECT '2016162', 'Cálculo Vectorial',                                  4, 3 UNION ALL
    SELECT '2025973', 'Probabilidad y Estadística',                         3, 3 UNION ALL
    SELECT '2016380', 'Ecuaciones Diferenciales',                           4, 3 UNION ALL
    SELECT '2016381', 'Física General',                                     4, 3 UNION ALL
    SELECT '2016382', 'Física Moderna',                                     4, 4 UNION ALL
    SELECT '2016383', 'Laboratorio de Física',                              2, 4
) AS m
WHERE  t.tipologia_programa_id = @prog_isis
  AND  t.tipologia_nombre      = 'Fundamentación Obligatoria';

-- ============================================================
-- PASO 8: Materias de Disciplinar Obligatoria (ISIS)
-- ============================================================
INSERT IGNORE INTO materia
    (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos,
     materia_nota_minima_aprobacion, materia_semestre_sugerido)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos, 3.0, m.sem
FROM   tipologia t
CROSS  JOIN (
    SELECT '2016390' AS codigo, 'Algoritmos y Complejidad'                AS nombre, 3 AS creditos, 3 AS sem UNION ALL
    SELECT '2016391', 'Bases de Datos',                                    3, 4 UNION ALL
    SELECT '2016392', 'Sistemas Operativos',                               3, 4 UNION ALL
    SELECT '2016411', 'Electrónica Digital',                               3, 4 UNION ALL
    SELECT '2016393', 'Redes de Computadores',                             3, 5 UNION ALL
    SELECT '2016394', 'Arquitectura de Software',                          3, 5 UNION ALL
    SELECT '2016395', 'Ingeniería de Software I',                          3, 5 UNION ALL
    SELECT '2016412', 'Señales y Sistemas',                                3, 5 UNION ALL
    SELECT '2016396', 'Ingeniería de Software II',                         3, 6 UNION ALL
    SELECT '2016397', 'Compiladores e Intérpretes',                        3, 6 UNION ALL
    SELECT '2016398', 'Inteligencia Artificial',                           3, 6 UNION ALL
    SELECT '2016399', 'Sistemas Distribuidos',                             3, 7 UNION ALL
    SELECT '2016400', 'Seguridad Informática',                             3, 7 UNION ALL
    SELECT '2016401', 'Interfaces de Usuario',                             3, 7 UNION ALL
    SELECT '2016402', 'Computación en la Nube',                            3, 8 UNION ALL
    SELECT '2016403', 'Gestión de Proyectos de Software',                  3, 8 UNION ALL
    SELECT '2016404', 'Minería de Datos',                                  3, 8 UNION ALL
    SELECT '2016405', 'Computación Móvil',                                 3, 9 UNION ALL
    SELECT '2016406', 'Procesamiento de Lenguaje Natural',                 3, 9 UNION ALL
    SELECT '2016407', 'Visión por Computador',                             3, 9 UNION ALL
    SELECT '2016408', 'Verificación y Validación de Software',             3, 9
) AS m
WHERE  t.tipologia_programa_id = @prog_isis
  AND  t.tipologia_nombre      = 'Disciplinar Obligatoria';

-- ============================================================
-- PASO 9: Trabajo de Grado (ISIS)
-- ============================================================
INSERT IGNORE INTO materia
    (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos,
     materia_nota_minima_aprobacion, materia_semestre_sugerido)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos, 3.0, m.sem
FROM   tipologia t
CROSS  JOIN (
    SELECT '2016420' AS codigo, 'Trabajo de Grado I'  AS nombre, 4 AS creditos, 9 AS sem UNION ALL
    SELECT '2016421', 'Trabajo de Grado II',            5, 10
) AS m
WHERE  t.tipologia_programa_id = @prog_isis
  AND  t.tipologia_nombre      = 'Trabajo de Grado';

-- ============================================================
-- PASO 10: Corregir contraseña de sechaves@unal.edu.co
--           Contraseña: unal2026
-- ============================================================
UPDATE usuario
SET    usuario_password_hash = '$2a$10$qGVkg.NPqnimwAI6L7SK7OLg34/OP2YfHQIZhphQJXKkSsQximqkq'
WHERE  usuario_email = 'sechaves@unal.edu.co';

-- ============================================================
-- VERIFICACIÓN FINAL
-- ============================================================
SELECT 'Universidades:' AS seccion, universidad_nombre AS nombre FROM universidad
UNION ALL
SELECT 'Programa:', programa_nombre FROM programa
UNION ALL
SELECT 'Total materias CS:', CAST(COUNT(*) AS CHAR)
FROM materia m JOIN tipologia t ON t.tipologia_id=m.materia_tipologia_id
WHERE t.tipologia_programa_id = @prog_cs
UNION ALL
SELECT 'Total materias ISIS:', CAST(COUNT(*) AS CHAR)
FROM materia m JOIN tipologia t ON t.tipologia_id=m.materia_tipologia_id
WHERE t.tipologia_programa_id = @prog_isis;
