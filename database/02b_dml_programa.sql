-- ============================================================
-- UNIGRADES - 02b_dml_programa.sql
-- Programa, tipologías, materias, prerrequisitos y correquisitos
-- Ciencias de la Computación — UNAL Bogotá
--
-- ORDEN DE EJECUCIÓN:
--   1. unigrades.sql         (DDL)
--   2. 02_dml.sql            (universidades, usuarios, semestres)
--   3. 02b_dml_programa.sql  (este archivo)
--   4. 03_plsql.sql          (triggers, funciones, procedimientos)
--
-- NOTA: Este archivo asume que la UNAL ya fue insertada por
-- 02_dml.sql con universidad_id = 1. Si los IDs cambian,
-- ajustar los valores correspondientes.
-- ============================================================

USE unigrades;

-- ============================================================
-- 1. PROGRAMA
-- universidad_id = 1 → Universidad Nacional de Colombia
-- ============================================================

INSERT INTO programa (programa_universidad_id, programa_nombre, programa_facultad, programa_total_creditos)
VALUES (1, 'Ciencias de la Computación', 'Facultad de Ciencias', 139);

-- programa_id resultante: 1 (primer programa insertado)

-- ============================================================
-- 2. TIPOLOGÍAS (programa_id = 1)
-- ============================================================

INSERT INTO tipologia (tipologia_programa_id, tipologia_nombre, tipologia_creditos_requeridos, tipologia_cuenta_promedio)
VALUES
(1, 'Matemáticas y Estructuras Discretas',        48, 1),  -- tipologia_id = 1
(1, 'Ciencias Naturales y Estadística',             3, 1),  -- tipologia_id = 2
(1, 'Programación y Estructuras de Datos',          9, 1),  -- tipologia_id = 3
(1, 'Algoritmos y Teoría de la Computación',       14, 1),  -- tipologia_id = 4
(1, 'Seguridad Informática y Codificación',         7, 1),  -- tipologia_id = 5
(1, 'Sistemas Operativos, de Cómputo y Compiladores', 9, 1), -- tipologia_id = 6
(1, 'Computación Científica',                       7, 1),  -- tipologia_id = 7
(1, 'Computación Aplicada',                         6, 1),  -- tipologia_id = 8
(1, 'Trabajo de Grado',                             8, 1),  -- tipologia_id = 9
(1, 'Libre Elección',                              28, 1);  -- tipologia_id = 10

-- ============================================================
-- 3. MATERIAS
-- ============================================================

-- Matemáticas y Estructuras Discretas (tipologia_id = 1)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(1, '2015168', 'Fundamentos de matemáticas',                        4),
(1, '2015181', 'Sistemas numéricos',                                4),
(1, '2025819', 'Introducción a la teoría de conjuntos',             4),
(1, '2015555', 'Algebra lineal básica',                             4),
(1, '2016377', 'Cálculo diferencial en una variable',               4),
(1, '2015556', 'Cálculo integral en una variable',                  4),
(1, '2015162', 'Cálculo vectorial',                                 4),
(1, '2016342', 'Cálculo de ecuaciones diferenciales ordinarias',    4),
(1, '2015155', 'Introducción al análisis real',                     4),
(1, '2015178', 'Probabilidad',                                      4),
(1, '2015152', 'Grupos y anillos',                                  4),
(1, '2015184', 'Teoría de grafos',                                  4),
(1, '2027312', 'Introducción al análisis combinatorio',             4),
(1, '2028838', 'Cadenas de markov y aplicaciones',                  4);

-- Ciencias Naturales y Estadística (tipologia_id = 2)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(2, '1000010', 'Biología molecular y celular',                      3),
(2, '1000013', 'Probabilidad y estadística fundamental',            3),
(2, '1000041', 'Química básica',                                    3),
(2, '2015176', 'Mecánica newtoniana',                               4),
(2, '2016651', 'Fundamentos de física teórica',                     3),
(2, '2022689', 'Fundamentos de física',                             3);

-- Programación y Estructuras de Datos (tipologia_id = 3)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(3, '2026573', 'Introducción a las ciencias de la computación y a la programación', 3),
(3, '2016375', 'Programación orientada a objetos',                  3),
(3, '2016699', 'Estructuras de datos',                              3);

-- Algoritmos y Teoría de la Computación (tipologia_id = 4)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(4, '2016696', 'Algoritmos',                                        3),
(4, '2015174', 'Introducción a la teoría de la computación',        4),
(4, '2026555', 'Algebra abstracta y computacional',                 4),
(4, '2019267', 'Teoría de la recursión',                            4),
(4, '2027628', 'Teoría de lenguajes formales',                      3),
(4, '2027629', 'Lógica computacional',                              3),
(4, '2028641', 'Quantum computer programming',                      4),
(4, '2029273', 'Advanced data structures',                          4),
(4, '2029274', 'Topics on advanced algorithms',                     4),
(4, '2029275', 'Complejidad computacional',                         4);

-- Seguridad Informática y Codificación (tipologia_id = 5)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(5, '2027311', 'Introducción a la criptografía y a la teoría de información', 4),
(5, '2027310', 'Criptografía',                                      3),
(5, '2027313', 'Teoría de la codificación',                         4);

-- Sistemas Operativos, de Cómputo y Compiladores (tipologia_id = 6)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(6, '2016698', 'Elementos de computadores',                         3),
(6, '2016707', 'Sistemas operativos',                               3),
(6, '2016697', 'Arquitectura de computadores',                      3),
(6, '2016722', 'Computación paralela y distribuida',                3),
(6, '2025966', 'Lenguajes de programación',                         3),
(6, '2027642', 'Compiladores',                                      3);

-- Computación Científica (tipologia_id = 7)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(7, '2019072', 'Análisis numérico I',                               4),
(7, '2015173', 'Introducción a la optimización',                    4),
(7, '2019082', 'Modelos matemáticos I',                             4),
(7, '2019103', 'Análisis numérico II',                              4),
(7, '2025971', 'Optimización',                                      3),
(7, '2026377', 'Métodos numéricos en finanzas',                     4),
(7, '2026519', 'Ecuaciones en diferencias finitas y sistemas dinámicos', 4),
(7, '2028836', 'Álgebra lineal numérica',                           4);

-- Computación Aplicada (tipologia_id = 8)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(8, '2016353', 'Bases de datos',                                    3),
(8, '2016701', 'Ingeniería de software I',                          3),
(8, '2025196', 'Introducción a la biología computacional',          4),
(8, '2025960', 'Computación visual',                                3),
(8, '2025967', 'Redes de computadores',                             3),
(8, '2025995', 'Introducción a los sistemas inteligentes',          3),
(8, '2027309', 'Análisis forense digital',                          4),
(8, '2027631', 'Tópicos de aprendizaje de máquinas',               3),
(8, '2027632', 'Introducción a la inteligencia artificial',         3),
(8, '2027641', 'Tópicos de computación aplicada',                  3),
(8, '2028837', 'Matemáticas del aprendizaje de máquinas',          4),
(8, '2028839', 'Fundamentos de analítica de datos y aplicaciones', 4),
(8, '2029090', 'Redes neuronales, arquitecturas y aplicaciones',   4),
(8, '2029272', 'Práctica Profesional',                              6);

-- Trabajo de Grado (tipologia_id = 9)
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos) VALUES
(9, '2027633', 'Trabajo de Grado - Trabajos investigativos',        8),
(9, '2027634', 'Trabajo de Grado - Asignaturas de Posgrado',        8),
(9, '2027636', 'Trabajo de Grado - Pasantías',                      8);

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
