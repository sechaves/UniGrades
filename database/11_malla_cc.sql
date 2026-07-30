-- ============================================================
-- UNIGRADES - 11_malla_cc.sql
-- Malla curricular CIENCIAS DE LA COMPUTACIÓN - UNAL
-- Acuerdo 487 de 2022 | Facultad de Ciencias
-- programa_id = 1
-- Total: 139 créditos
-- ============================================================

USE unigrades;

SET @prog_cc = 1;

-- ============================================================
-- PASO 1: Limpiar materias y tipologías antiguas
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM materia WHERE materia_tipologia_id IN (
    SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id = @prog_cc
);
DELETE FROM tipologia WHERE tipologia_programa_id = @prog_cc;
SET FOREIGN_KEY_CHECKS = 1;

UPDATE programa SET programa_total_creditos = 139 WHERE programa_id = @prog_cc;

-- ============================================================
-- PASO 2: Tipologías reales según agrupaciones del PDF
-- ============================================================
INSERT INTO tipologia (tipologia_programa_id, tipologia_nombre, tipologia_creditos_requeridos, tipologia_cuenta_promedio) VALUES
(@prog_cc, 'Matemáticas y Estructuras Discretas',        48, 1),
(@prog_cc, 'Programación y Estructuras de Datos',         9, 1),
(@prog_cc, 'Algoritmos y Teoría de la Computación',      14, 1),
(@prog_cc, 'Seguridad Informática y Codificación',        7, 1),
(@prog_cc, 'Sistemas Operativos, Cómputo y Compiladores', 9, 1),
(@prog_cc, 'Computación Científica',                      7, 1),
(@prog_cc, 'Computación Aplicada',                        6, 1),
(@prog_cc, 'Ciencias Naturales y Estadística',            3, 1),
(@prog_cc, 'Trabajo de Grado',                            8, 1),
(@prog_cc, 'Nivelación',                                  0, 0);

-- Variables de tipología
SET @t_mat  = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Matemáticas y Estructuras Discretas');
SET @t_prog = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Programación y Estructuras de Datos');
SET @t_alg  = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Algoritmos y Teoría de la Computación');
SET @t_seg  = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Seguridad Informática y Codificación');
SET @t_sis  = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Sistemas Operativos, Cómputo y Compiladores');
SET @t_cien = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Computación Científica');
SET @t_apl  = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Computación Aplicada');
SET @t_nat  = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Ciencias Naturales y Estadística');
SET @t_grado= (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Trabajo de Grado');
SET @t_niv  = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Nivelación');

-- ============================================================
-- PASO 3: Matemáticas y Estructuras Discretas
-- Obligatorias (40 cr) + Optativas (8 cr)
-- Semestres según malla: I-VIII
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
-- OBLIGATORIAS (aparecen en la malla con semestre)
(@t_mat, '2015168', 'Fundamentos de Matemáticas',                  4, 1, 3.0),
(@t_mat, '2015181', 'Sistemas Numéricos',                          4, 2, 3.0),
(@t_mat, '2025819', 'Introducción a la Teoría de Conjuntos',       4, 3, 3.0),
(@t_mat, '2015555', 'Álgebra Lineal Básica',                       4, 2, 3.0),
(@t_mat, '2016377', 'Cálculo Diferencial en una Variable',         4, 1, 3.0),
(@t_mat, '2015556', 'Cálculo Integral en una Variable',            4, 2, 3.0),
(@t_mat, '2015162', 'Cálculo Vectorial',                           4, 3, 3.0),
(@t_mat, '2016342', 'Cálculo de Ecuaciones Diferenciales Ordinarias',4,4, 3.0),
(@t_mat, '2015155', 'Introducción al Análisis Real',               4, 4, 3.0),
(@t_mat, '2015178', 'Probabilidad',                                4, 3, 3.0),
-- OPTATIVAS (8 cr, sin semestre fijo)
(@t_mat, '2015152', 'Grupos y Anillos',                            4, NULL, 3.0),
(@t_mat, '2015184', 'Teoría de Grafos',                            4, NULL, 3.0),
(@t_mat, '2027312', 'Introducción al Análisis Combinatorio',       4, NULL, 3.0),
(@t_mat, '2028838', 'Cadenas de Markov y Aplicaciones',            4, NULL, 3.0);

-- ============================================================
-- PASO 4: Programación y Estructuras de Datos (9 cr - todo obligatorio)
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_prog, '2026573', 'Introducción a las CC y a la Programación',  3, 1, 3.0),
(@t_prog, '2016375', 'Programación Orientada a Objetos',           3, 2, 3.0),
(@t_prog, '2016699', 'Estructuras de Datos',                       3, 3, 3.0);

-- ============================================================
-- PASO 5: Algoritmos y Teoría de la Computación (14 cr)
-- Obligatorias: 11 cr | Optativas: 3 cr
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
-- OBLIGATORIAS
(@t_alg, '2016696', 'Algoritmos',                                  3, 4, 3.0),
(@t_alg, '2015174', 'Introducción a la Teoría de la Computación',  4, 5, 3.0),
(@t_alg, '2026555', 'Álgebra Abstracta y Computacional',           4, 5, 3.0),
-- OPTATIVAS
(@t_alg, '2019267', 'Teoría de la Recursión',                      4, NULL, 3.0),
(@t_alg, '2027628', 'Teoría de Lenguajes Formales',                3, NULL, 3.0),
(@t_alg, '2027629', 'Lógica Computacional',                        3, NULL, 3.0),
(@t_alg, '2028641', 'Quantum Computer Programming',                4, NULL, 3.0),
(@t_alg, '2029273', 'Advanced Data Structures',                    4, NULL, 3.0),
(@t_alg, '2029274', 'Topics on Advanced Algorithms',               4, NULL, 3.0),
(@t_alg, '2029275', 'Complejidad Computacional',                   4, NULL, 3.0);

-- ============================================================
-- PASO 6: Seguridad Informática y Codificación (7 cr - todo optativo)
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_seg, '2027311', 'Introducción a la Criptografía y Teoría de Información', 4, NULL, 3.0),
(@t_seg, '2027310', 'Criptografía',                                           3, NULL, 3.0),
(@t_seg, '2027313', 'Teoría de la Codificación',                              4, NULL, 3.0);

-- ============================================================
-- PASO 7: Sistemas Operativos, Cómputo y Compiladores (9 cr)
-- Obligatorias: 6 cr | Optativas: 3 cr
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
-- OBLIGATORIAS (según malla: sem 5 y 6)
(@t_sis, '2016698', 'Elementos de Computadores',          3, 5, 3.0),
(@t_sis, '2016707', 'Sistemas Operativos',                3, 6, 3.0),
-- OPTATIVAS
(@t_sis, '2016697', 'Arquitectura de Computadores',       3, NULL, 3.0),
(@t_sis, '2016722', 'Computación Paralela y Distribuida', 3, NULL, 3.0),
(@t_sis, '2025966', 'Lenguajes de Programación',          3, NULL, 3.0),
(@t_sis, '2027642', 'Compiladores',                       3, NULL, 3.0);

-- ============================================================
-- PASO 8: Computación Científica (7 cr)
-- Obligatoria: 4 cr (Análisis Numérico I) | Optativas: 3 cr
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_cien, '2019072', 'Análisis Numérico I',                                    4, 7, 3.0),
(@t_cien, '2015173', 'Introducción a la Optimización',                         4, NULL, 3.0),
(@t_cien, '2019082', 'Modelos Matemáticos I',                                  4, NULL, 3.0),
(@t_cien, '2019103', 'Análisis Numérico II',                                   4, NULL, 3.0),
(@t_cien, '2025971', 'Optimización',                                           3, NULL, 3.0),
(@t_cien, '2026377', 'Métodos Numéricos en Finanzas',                          4, NULL, 3.0),
(@t_cien, '2026519', 'Ecuaciones en Diferencias Finitas y Sistemas Dinámicos', 4, NULL, 3.0),
(@t_cien, '2028836', 'Álgebra Lineal Numérica',                                4, NULL, 3.0);

-- ============================================================
-- PASO 9: Computación Aplicada (6 cr - todo optativo)
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_apl, '2016353', 'Bases de Datos',                                         3, NULL, 3.0),
(@t_apl, '2016701', 'Ingeniería de Software I',                               3, NULL, 3.0),
(@t_apl, '2025196', 'Introducción a la Biología Computacional',               4, NULL, 3.0),
(@t_apl, '2025960', 'Computación Visual',                                     3, NULL, 3.0),
(@t_apl, '2025967', 'Redes de Computadores',                                  3, NULL, 3.0),
(@t_apl, '2025995', 'Introducción a los Sistemas Inteligentes',               3, NULL, 3.0),
(@t_apl, '2027309', 'Análisis Forense Digital',                               4, NULL, 3.0),
(@t_apl, '2027631', 'Introducción a la Inteligencia Artificial',              3, NULL, 3.0),
(@t_apl, '2027632', 'Física Computacional',                                   3, NULL, 3.0),
(@t_apl, '2027641', 'Análisis de Bases de Datos',                             3, NULL, 3.0),
(@t_apl, '2028837', 'Matemáticas del Aprendizaje de Máquinas',                4, NULL, 3.0),
(@t_apl, '2028839', 'Fundamentos de Analítica de Datos y Aplicaciones',       4, NULL, 3.0),
(@t_apl, '2029090', 'Redes Neuronales, Arquitecturas y Aplicaciones',         4, NULL, 3.0),
(@t_apl, '2029272', 'Práctica Profesional',                                   6, NULL, 3.0);

-- ============================================================
-- PASO 10: Ciencias Naturales y Estadística (3 cr - todo optativo)
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_nat, '1000010-B', 'Biología Molecular y Celular',     3, NULL, 3.0),
(@t_nat, '1000013-B', 'Probabilidad y Estadística Fundamental',3,NULL,3.0),
(@t_nat, '1000041-B', 'Química Básica',                   3, NULL, 3.0),
(@t_nat, '2015176',   'Mecánica Newtoniana',               4, NULL, 3.0),
(@t_nat, '2016651',   'Fundamentos de Física Teórica',     3, NULL, 3.0),
(@t_nat, '2022689',   'Fundamentos de Física',             3, NULL, 3.0);

-- ============================================================
-- PASO 11: Trabajo de Grado (8 cr - obligatorio)
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_grado, '2027633', 'Trabajo de Grado - Trabajos Investigativos', 8, 9, 3.0),
(@t_grado, '2027634', 'Trabajo de Grado - Asignaturas de Posgrado', 8, 9, 3.0),
(@t_grado, '2027636', 'Trabajo de Grado - Pasantías',               8, 9, 3.0);

-- ============================================================
-- PASO 12: Nivelación (Idiomas - no cuenta para promedio)
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_niv, '1000001-B', 'Matemáticas Básicas',        4, 1, 3.0),
(@t_niv, '1000002-B', 'Lecto-Escritura',             4, 2, 3.0),
(@t_niv, '1000044-B', 'Idioma I',                    3, 1, 3.0),
(@t_niv, '1000045-B', 'Idioma II',                   3, 2, 3.0),
(@t_niv, '1000046-B', 'Idioma III',                  3, 3, 3.0),
(@t_niv, '1000047-B', 'Idioma IV',                   3, 4, 3.0),
(@t_niv, '1000052-B', 'Inglés Intensivo I y II',     6, NULL, 3.0),
(@t_niv, '1000053-B', 'Inglés Intensivo III y IV',   6, NULL, 3.0);

-- ============================================================
-- VERIFICACIÓN FINAL
-- ============================================================
SELECT t.tipologia_nombre, COUNT(m.materia_id) AS total_materias,
       SUM(CASE WHEN m.materia_semestre_sugerido IS NOT NULL THEN m.materia_creditos ELSE 0 END) AS creditos_obligatorios,
       SUM(CASE WHEN m.materia_semestre_sugerido IS NULL     THEN m.materia_creditos ELSE 0 END) AS creditos_optativos
FROM tipologia t
LEFT JOIN materia m ON m.materia_tipologia_id = t.tipologia_id
WHERE t.tipologia_programa_id = @prog_cc
GROUP BY t.tipologia_nombre
ORDER BY t.tipologia_nombre;
