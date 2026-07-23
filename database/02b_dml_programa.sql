-- ============================================================
-- UNIGRADES - 02b_dml_programa.sql
-- Programa, tipologías, materias, prerrequisitos y correquisitos
-- Ciencias de la Computación — UNAL Bogotá
--
-- ORDEN DE EJECUCIÓN:
--   1. unigrades.sql              (DDL)
--   2. 02_dml.sql                 (universidades, usuarios, semestres)
--   3. 02b_dml_programa.sql       (este archivo)
--   4. 03_plsql.sql               (triggers, funciones, procedimientos)
--
-- NOTA: Este archivo busca la UNAL por nombre, no asume un ID fijo.
-- La universidad debe existir antes de ejecutar este script
-- (la inserta 02_dml.sql).
-- ============================================================

USE unigrades;

-- ============================================================
-- 1. PROGRAMA
-- Se busca la universidad_id de la UNAL Bogotá por nombre.
-- ============================================================

INSERT INTO programa (programa_universidad_id, programa_nombre, programa_facultad, programa_total_creditos)
SELECT universidad_id, 'Ciencias de la Computación', 'Facultad de Ciencias', 139
FROM   universidad
WHERE  universidad_nombre = 'Universidad Nacional de Colombia'
  AND  universidad_ciudad = 'Bogotá'
LIMIT  1;

-- programa_id resultante: 1 (primer programa insertado)

-- ============================================================
-- 2. TIPOLOGÍAS
-- Se busca el programa_id por nombre para no asumir ID fijo.
-- ============================================================

INSERT INTO tipologia (tipologia_programa_id, tipologia_nombre, tipologia_creditos_requeridos, tipologia_cuenta_promedio)
SELECT p.programa_id, t.nombre, t.creditos, 1
FROM   programa AS p
CROSS  JOIN (
    SELECT 'Matemáticas y Estructuras Discretas'          AS nombre, 48 AS creditos UNION ALL
    SELECT 'Ciencias Naturales y Estadística',             3  UNION ALL
    SELECT 'Programación y Estructuras de Datos',          9  UNION ALL
    SELECT 'Algoritmos y Teoría de la Computación',       14  UNION ALL
    SELECT 'Seguridad Informática y Codificación',         7  UNION ALL
    SELECT 'Sistemas Operativos, de Cómputo y Compiladores', 9 UNION ALL
    SELECT 'Computación Científica',                       7  UNION ALL
    SELECT 'Computación Aplicada',                         6  UNION ALL
    SELECT 'Trabajo de Grado',                             8  UNION ALL
    SELECT 'Libre Elección',                              28
) AS t
WHERE  p.programa_nombre = 'Ciencias de la Computación'
LIMIT  10;

-- ============================================================
-- 3. MATERIAS
-- tipologia_id se resuelve por nombre para no asumir IDs fijos.
-- ============================================================

-- Matemáticas y Estructuras Discretas
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '2015168' AS codigo, 'Fundamentos de matemáticas'                       AS nombre, 4 AS creditos UNION ALL
    SELECT '2015181', 'Sistemas numéricos',                                         4 UNION ALL
    SELECT '2025819', 'Introducción a la teoría de conjuntos',                      4 UNION ALL
    SELECT '2015555', 'Algebra lineal básica',                                      4 UNION ALL
    SELECT '2016377', 'Cálculo diferencial en una variable',                        4 UNION ALL
    SELECT '2015556', 'Cálculo integral en una variable',                           4 UNION ALL
    SELECT '2015162', 'Cálculo vectorial',                                          4 UNION ALL
    SELECT '2016342', 'Cálculo de ecuaciones diferenciales ordinarias',             4 UNION ALL
    SELECT '2015155', 'Introducción al análisis real',                              4 UNION ALL
    SELECT '2015178', 'Probabilidad',                                               4 UNION ALL
    SELECT '2015152', 'Grupos y anillos',                                           4 UNION ALL
    SELECT '2015184', 'Teoría de grafos',                                           4 UNION ALL
    SELECT '2027312', 'Introducción al análisis combinatorio',                      4 UNION ALL
    SELECT '2028838', 'Cadenas de markov y aplicaciones',                           4
) AS m
WHERE  t.tipologia_nombre = 'Matemáticas y Estructuras Discretas';

-- Ciencias Naturales y Estadística
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '1000010' AS codigo, 'Biología molecular y celular'              AS nombre, 3 AS creditos UNION ALL
    SELECT '1000013', 'Probabilidad y estadística fundamental',              3 UNION ALL
    SELECT '1000041', 'Química básica',                                      3 UNION ALL
    SELECT '2015176', 'Mecánica newtoniana',                                 4 UNION ALL
    SELECT '2016651', 'Fundamentos de física teórica',                       3 UNION ALL
    SELECT '2022689', 'Fundamentos de física',                               3
) AS m
WHERE  t.tipologia_nombre = 'Ciencias Naturales y Estadística';

-- Programación y Estructuras de Datos
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '2026573' AS codigo, 'Introducción a las ciencias de la computación y a la programación' AS nombre, 3 AS creditos UNION ALL
    SELECT '2016375', 'Programación orientada a objetos',                    3 UNION ALL
    SELECT '2016699', 'Estructuras de datos',                                3
) AS m
WHERE  t.tipologia_nombre = 'Programación y Estructuras de Datos';

-- Algoritmos y Teoría de la Computación
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '2016696' AS codigo, 'Algoritmos'                                        AS nombre, 3 AS creditos UNION ALL
    SELECT '2015174', 'Introducción a la teoría de la computación',                 4 UNION ALL
    SELECT '2026555', 'Algebra abstracta y computacional',                          4 UNION ALL
    SELECT '2019267', 'Teoría de la recursión',                                     4 UNION ALL
    SELECT '2027628', 'Teoría de lenguajes formales',                               3 UNION ALL
    SELECT '2027629', 'Lógica computacional',                                       3 UNION ALL
    SELECT '2028641', 'Quantum computer programming',                               4 UNION ALL
    SELECT '2029273', 'Advanced data structures',                                   4 UNION ALL
    SELECT '2029274', 'Topics on advanced algorithms',                              4 UNION ALL
    SELECT '2029275', 'Complejidad computacional',                                  4
) AS m
WHERE  t.tipologia_nombre = 'Algoritmos y Teoría de la Computación';

-- Seguridad Informática y Codificación
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '2027311' AS codigo, 'Introducción a la criptografía y a la teoría de información' AS nombre, 4 AS creditos UNION ALL
    SELECT '2027310', 'Criptografía',                                                3 UNION ALL
    SELECT '2027313', 'Teoría de la codificación',                                   4
) AS m
WHERE  t.tipologia_nombre = 'Seguridad Informática y Codificación';

-- Sistemas Operativos, de Cómputo y Compiladores
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '2016698' AS codigo, 'Elementos de computadores'              AS nombre, 3 AS creditos UNION ALL
    SELECT '2016707', 'Sistemas operativos',                              3 UNION ALL
    SELECT '2016697', 'Arquitectura de computadores',                     3 UNION ALL
    SELECT '2016722', 'Computación paralela y distribuida',               3 UNION ALL
    SELECT '2025966', 'Lenguajes de programación',                        3 UNION ALL
    SELECT '2027642', 'Compiladores',                                     3
) AS m
WHERE  t.tipologia_nombre = 'Sistemas Operativos, de Cómputo y Compiladores';

-- Computación Científica
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '2019072' AS codigo, 'Análisis numérico I'                                         AS nombre, 4 AS creditos UNION ALL
    SELECT '2015173', 'Introducción a la optimización',                                        4 UNION ALL
    SELECT '2019082', 'Modelos matemáticos I',                                                 4 UNION ALL
    SELECT '2019103', 'Análisis numérico II',                                                  4 UNION ALL
    SELECT '2025971', 'Optimización',                                                          3 UNION ALL
    SELECT '2026377', 'Métodos numéricos en finanzas',                                         4 UNION ALL
    SELECT '2026519', 'Ecuaciones en diferencias finitas y sistemas dinámicos',                4 UNION ALL
    SELECT '2028836', 'Álgebra lineal numérica',                                               4
) AS m
WHERE  t.tipologia_nombre = 'Computación Científica';

-- Computación Aplicada
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '2016353' AS codigo, 'Bases de datos'                                            AS nombre, 3 AS creditos UNION ALL
    SELECT '2016701', 'Ingeniería de software I',                                            3 UNION ALL
    SELECT '2025196', 'Introducción a la biología computacional',                            4 UNION ALL
    SELECT '2025960', 'Computación visual',                                                  3 UNION ALL
    SELECT '2025967', 'Redes de computadores',                                               3 UNION ALL
    SELECT '2025995', 'Introducción a los sistemas inteligentes',                            3 UNION ALL
    SELECT '2027309', 'Análisis forense digital',                                            4 UNION ALL
    SELECT '2027631', 'Tópicos de aprendizaje de máquinas',                                 3 UNION ALL
    SELECT '2027632', 'Introducción a la inteligencia artificial',                           3 UNION ALL
    SELECT '2027641', 'Tópicos de computación aplicada',                                    3 UNION ALL
    SELECT '2028837', 'Matemáticas del aprendizaje de máquinas',                            4 UNION ALL
    SELECT '2028839', 'Fundamentos de analítica de datos y aplicaciones',                   4 UNION ALL
    SELECT '2029090', 'Redes neuronales, arquitecturas y aplicaciones',                     4 UNION ALL
    SELECT '2029272', 'Práctica Profesional',                                                6
) AS m
WHERE  t.tipologia_nombre = 'Computación Aplicada';

-- Trabajo de Grado
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos)
SELECT t.tipologia_id, m.codigo, m.nombre, m.creditos
FROM   tipologia AS t
CROSS  JOIN (
    SELECT '2027633' AS codigo, 'Trabajo de Grado - Trabajos investigativos' AS nombre, 8 AS creditos UNION ALL
    SELECT '2027634', 'Trabajo de Grado - Asignaturas de Posgrado',           8 UNION ALL
    SELECT '2027636', 'Trabajo de Grado - Pasantías',                         8
) AS m
WHERE  t.tipologia_nombre = 'Trabajo de Grado';

-- ============================================================
-- 4. PRERREQUISITOS
-- Se usan subconsultas por código para ser robustos ante
-- variaciones en el AUTO_INCREMENT de materia_id.
-- ============================================================

INSERT INTO materia_prerrequisito (materia_id, prerrequisito_materia_id) VALUES
-- Matemáticas
((SELECT materia_id FROM materia WHERE materia_codigo = '2015181'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015168')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025819'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015181')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015556'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016377')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015162'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015556')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016342'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015555')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016342'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015556')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015155'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015162')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015155'), (SELECT materia_id FROM materia WHERE materia_codigo = '2025819')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015178'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015556')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015152'), (SELECT materia_id FROM materia WHERE materia_codigo = '2025819')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015184'), (SELECT materia_id FROM materia WHERE materia_codigo = '2025819')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027312'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015181')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028838'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015178')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028838'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015555')),
-- Programación
((SELECT materia_id FROM materia WHERE materia_codigo = '2016375'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016699'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016375')),
-- Algoritmos
((SELECT materia_id FROM materia WHERE materia_codigo = '2016696'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016699')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015174'), (SELECT materia_id FROM materia WHERE materia_codigo = '2025819')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2026555'), (SELECT materia_id FROM materia WHERE materia_codigo = '2025819')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2019267'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015174')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027628'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015174')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027629'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015174')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027629'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015555')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028641'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016696')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028641'), (SELECT materia_id FROM materia WHERE materia_codigo = '2025819')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2029273'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015178')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2029273'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016696')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2029274'), (SELECT materia_id FROM materia WHERE materia_codigo = '2025819')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2029274'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015178')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2029274'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015555')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2029274'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016696')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2029275'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015174')),
-- Seguridad
((SELECT materia_id FROM materia WHERE materia_codigo = '2027311'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015178')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027311'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015181')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027311'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027310'), (SELECT materia_id FROM materia WHERE materia_codigo = '2027311')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027313'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015152')),
-- Sistemas y Compiladores
((SELECT materia_id FROM materia WHERE materia_codigo = '2016698'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016707'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016698')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016697'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016698')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016722'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016696')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025966'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015174')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025966'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016699')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027642'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015174')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027642'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016699')),
-- Computación Científica
((SELECT materia_id FROM materia WHERE materia_codigo = '2019072'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015155')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2019072'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015173'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015162')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2015173'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2019082'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016342')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2019103'), (SELECT materia_id FROM materia WHERE materia_codigo = '2019072')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2019103'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015162')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025971'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025971'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016342')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2026377'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015178')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2026519'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2026519'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016342')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028836'), (SELECT materia_id FROM materia WHERE materia_codigo = '2019072')),
-- Computación Aplicada
((SELECT materia_id FROM materia WHERE materia_codigo = '2016353'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016699')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016701'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016699')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025196'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015555')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025196'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025960'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016696')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025967'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016698')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025967'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016699')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2025995'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016696')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027309'), (SELECT materia_id FROM materia WHERE materia_codigo = '2027311')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027631'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015162')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027631'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015178')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027631'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016696')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027641'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016699')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2027632'), (SELECT materia_id FROM materia WHERE materia_codigo = '2019072')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028837'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015162')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028837'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015178')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028837'), (SELECT materia_id FROM materia WHERE materia_codigo = '2026573')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028839'), (SELECT materia_id FROM materia WHERE materia_codigo = '2015178')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2028839'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016699')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2029090'), (SELECT materia_id FROM materia WHERE materia_codigo = '2028837'));

-- ============================================================
-- 5. CORREQUISITOS
-- ============================================================

INSERT INTO materia_correquisito (materia_id, correquisito_materia_id) VALUES
((SELECT materia_id FROM materia WHERE materia_codigo = '2015176'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016377')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016651'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016377')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2022689'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016377'));

-- ============================================================
-- FIN DEL ARCHIVO 02b_dml_programa.sql
-- ============================================================
