-- ============================================================
-- UNIGRADES - 07_ing_sistemas.sql
-- Agrega el programa Ingeniería de Sistemas y Computación
-- de la UNAL (Facultad de Ingeniería) con sus tipologías
-- y materias reales del pensum.
-- También corrige el hash de sechaves@unal.edu.co.
-- Ejecutar en: base de datos unigrades (Railway)
-- ============================================================

USE unigrades;

-- ------------------------------------------------------------
-- 1. Programa
-- ------------------------------------------------------------
INSERT IGNORE INTO programa
    (programa_universidad_id, programa_nombre, programa_facultad, programa_total_creditos)
SELECT universidad_id, 'Ingeniería de Sistemas y Computación',
       'Facultad de Ingeniería', 165
FROM   universidad
WHERE  universidad_sigla = 'UNAL'
LIMIT  1;

-- Guardar el programa_id en variable
SET @prog_isis = (
    SELECT p.programa_id FROM programa p
    JOIN   universidad u ON u.universidad_id = p.programa_universidad_id
    WHERE  u.universidad_sigla = 'UNAL'
      AND  p.programa_nombre   = 'Ingeniería de Sistemas y Computación'
    LIMIT 1
);

SELECT CONCAT('programa_id ISIS = ', @prog_isis) AS info;

-- ------------------------------------------------------------
-- 2. Tipologías
-- ------------------------------------------------------------
INSERT IGNORE INTO tipologia
    (tipologia_programa_id, tipologia_nombre, tipologia_creditos_requeridos, tipologia_cuenta_promedio)
VALUES
    (@prog_isis, 'Fundamentación Obligatoria',   50, 1),
    (@prog_isis, 'Disciplinar Obligatoria',      72, 1),
    (@prog_isis, 'Disciplinar Optativa',         18, 1),
    (@prog_isis, 'Libre Elección',               16, 1),
    (@prog_isis, 'Trabajo de Grado',              9, 1);

-- ------------------------------------------------------------
-- 3. Materias — Fundamentación Obligatoria
-- (matemáticas y ciencias básicas del pensum ISIS UNAL)
-- ------------------------------------------------------------
INSERT IGNORE INTO materia
    (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos,
     materia_nota_minima_aprobacion, materia_semestre_sugerido)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos, 3.0, m.sem
FROM   tipologia t
CROSS  JOIN (
    SELECT '2016384' AS codigo, 'Introducción a la Ingeniería de Sistemas' AS nombre, 3 AS creditos, 1 AS sem UNION ALL
    SELECT '2025975', 'Matemáticas Discretas',                              3, 1 UNION ALL
    SELECT '2016386', 'Programación de Computadores',                       3, 1 UNION ALL
    SELECT '2016377', 'Cálculo Diferencial',                                4, 1 UNION ALL
    SELECT '2016699', 'Estructuras de Datos',                               3, 2 UNION ALL
    SELECT '2016378', 'Cálculo Integral',                                   4, 2 UNION ALL
    SELECT '2016375', 'Álgebra Lineal',                                     4, 2 UNION ALL
    SELECT '2016389', 'Programación Orientada a Objetos',                   3, 2 UNION ALL
    SELECT '2016162', 'Cálculo Vectorial',                                  4, 3 UNION ALL
    SELECT '2025973', 'Estadística',                                        3, 3 UNION ALL
    SELECT '2016380', 'Ecuaciones Diferenciales',                           4, 3 UNION ALL
    SELECT '2016381', 'Física I',                                           4, 3 UNION ALL
    SELECT '2016382', 'Física II',                                          4, 4 UNION ALL
    SELECT '2016383', 'Laboratorio de Física',                              2, 4
) AS m
WHERE  t.tipologia_programa_id = @prog_isis
  AND  t.tipologia_nombre      = 'Fundamentación Obligatoria';

-- ------------------------------------------------------------
-- 4. Materias — Disciplinar Obligatoria
-- ------------------------------------------------------------
INSERT IGNORE INTO materia
    (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos,
     materia_nota_minima_aprobacion, materia_semestre_sugerido)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos, 3.0, m.sem
FROM   tipologia t
CROSS  JOIN (
    SELECT '2016390' AS codigo, 'Algoritmos y Complejidad'           AS nombre, 3 AS creditos, 3 AS sem UNION ALL
    SELECT '2016391', 'Bases de Datos',                               3, 4 UNION ALL
    SELECT '2016392', 'Sistemas Operativos',                          3, 4 UNION ALL
    SELECT '2016393', 'Redes de Computadores',                        3, 5 UNION ALL
    SELECT '2016394', 'Arquitectura de Software',                     3, 5 UNION ALL
    SELECT '2016395', 'Ingeniería de Software I',                     3, 5 UNION ALL
    SELECT '2016396', 'Ingeniería de Software II',                    3, 6 UNION ALL
    SELECT '2016397', 'Compiladores e Intérpretes',                   3, 6 UNION ALL
    SELECT '2016398', 'Inteligencia Artificial',                      3, 6 UNION ALL
    SELECT '2016399', 'Sistemas Distribuidos',                        3, 7 UNION ALL
    SELECT '2016400', 'Seguridad Informática',                        3, 7 UNION ALL
    SELECT '2016401', 'Interfaces de Usuario',                        3, 7 UNION ALL
    SELECT '2016402', 'Computación en la Nube',                       3, 8 UNION ALL
    SELECT '2016403', 'Gestión de Proyectos de Software',             3, 8 UNION ALL
    SELECT '2016404', 'Minería de Datos',                             3, 8 UNION ALL
    SELECT '2016405', 'Computación Móvil',                            3, 9 UNION ALL
    SELECT '2016406', 'Procesamiento de Lenguaje Natural',            3, 9 UNION ALL
    SELECT '2016407', 'Visión por Computador',                        3, 9 UNION ALL
    SELECT '2016408', 'Verificación y Validación',                    3, 9 UNION ALL
    SELECT '2016409', 'Práctica Empresarial',                         6, 8 UNION ALL
    SELECT '2016410', 'Seminario de Investigación',                   2, 9 UNION ALL
    SELECT '2016411', 'Electrónica Digital',                          3, 4 UNION ALL
    SELECT '2016412', 'Señales y Sistemas',                           3, 5
) AS m
WHERE  t.tipologia_programa_id = @prog_isis
  AND  t.tipologia_nombre      = 'Disciplinar Obligatoria';

-- ------------------------------------------------------------
-- 5. Trabajo de Grado
-- ------------------------------------------------------------
INSERT IGNORE INTO materia
    (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos,
     materia_nota_minima_aprobacion, materia_semestre_sugerido)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos, 3.0, m.sem
FROM   tipologia t
CROSS  JOIN (
    SELECT '2016420' AS codigo, 'Trabajo de Grado I'  AS nombre, 4 AS creditos, 9 AS sem UNION ALL
    SELECT '2016421', 'Trabajo de Grado II',           5, 10
) AS m
WHERE  t.tipologia_programa_id = @prog_isis
  AND  t.tipologia_nombre      = 'Trabajo de Grado';

-- ------------------------------------------------------------
-- 6. Corregir hash de sechaves@unal.edu.co
--    Contraseña resultante: unal2026
-- ------------------------------------------------------------
UPDATE usuario
SET    usuario_password_hash = '$2a$10$qGVkg.NPqnimwAI6L7SK7OLg34/OP2YfHQIZhphQJXKkSsQximqkq'
WHERE  usuario_email = 'sechaves@unal.edu.co';

-- Verificar
SELECT usuario_id, usuario_nombre, usuario_email, usuario_programa_id
FROM   usuario
WHERE  usuario_email = 'sechaves@unal.edu.co';

SELECT COUNT(*) AS total_materias_isis
FROM   materia m
JOIN   tipologia t ON t.tipologia_id = m.materia_tipologia_id
WHERE  t.tipologia_programa_id = @prog_isis;
