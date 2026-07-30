-- ============================================================
-- UNIGRADES - 11_malla_cc.sql
-- Malla curricular completa de Ciencias de la Computación
-- UNAL Bogotá - Facultad de Ciencias
-- programa_id = 1
-- ============================================================

USE unigrades;

SET @prog_cc = 1;

-- ============================================================
-- PASO 1: Limpiar materias y tipologías antiguas de CC
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM materia
WHERE materia_tipologia_id IN (
    SELECT tipologia_id FROM tipologia
    WHERE tipologia_programa_id = @prog_cc
);

DELETE FROM tipologia WHERE tipologia_programa_id = @prog_cc;

SET FOREIGN_KEY_CHECKS = 1;

UPDATE programa SET programa_total_creditos = 139
WHERE programa_id = @prog_cc;

-- ============================================================
-- PASO 2: Tipologías de CC
-- ============================================================
INSERT INTO tipologia (tipologia_programa_id, tipologia_nombre, tipologia_creditos_requeridos, tipologia_cuenta_promedio) VALUES
(@prog_cc, 'Fundamentación Obligatoria',  48, 1),
(@prog_cc, 'Disciplinar Obligatoria',     55, 1),
(@prog_cc, 'Disciplinar Optativa',        28, 1),
(@prog_cc, 'Nivelación',                   0, 0),
(@prog_cc, 'Trabajo de Grado',             8, 1);

SET @t_fund_ob = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Fundamentación Obligatoria');
SET @t_disc_ob = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Disciplinar Obligatoria');
SET @t_disc_op = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Disciplinar Optativa');
SET @t_niv     = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Nivelación');
SET @t_grado   = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_cc AND tipologia_nombre='Trabajo de Grado');

-- ============================================================
-- PASO 3: Fundamentación Obligatoria
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
-- Semestre 1
(@t_fund_ob, '2015168',   'Fundamentos de Matemáticas',              4, 1, 3.0),
(@t_fund_ob, '2015181',   'Sistemas Numéricos',                      4, 1, 3.0),
(@t_fund_ob, '2026573',   'Introducción a las CC y a la Programación',3, 1, 3.0),
-- Semestre 2
(@t_fund_ob, '2016377',   'Cálculo Diferencial en una Variable',     4, 2, 3.0),
(@t_fund_ob, '2025819',   'Introducción a la Teoría de Conjuntos',   4, 2, 3.0),
(@t_fund_ob, '2015555',   'Álgebra Lineal Básica',                   4, 2, 3.0),
(@t_fund_ob, '2016375',   'Programación Orientada a Objetos',        3, 2, 3.0),
-- Semestre 3
(@t_fund_ob, '2015556',   'Cálculo Integral en una Variable',        4, 3, 3.0),
(@t_fund_ob, '2015174',   'Introducción a la Teoría de la Computación',4, 3, 3.0),
(@t_fund_ob, '2016699',   'Estructuras de Datos',                    3, 3, 3.0),
-- Semestre 4
(@t_fund_ob, '2015162',   'Cálculo Vectorial',                       4, 4, 3.0),
(@t_fund_ob, '2015155',   'Introducción al Análisis Real',           4, 4, 3.0);

-- ============================================================
-- PASO 4: Disciplinar Obligatoria
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
-- Semestre 3
(@t_disc_ob, '2016696',   'Algoritmos',                              3, 3, 3.0),
-- Semestre 4
(@t_disc_ob, '2026555',   'Álgebra Abstracta y Computacional',       4, 4, 3.0),
(@t_disc_ob, '2015178',   'Probabilidad',                            4, 4, 3.0),
-- Semestre 5
(@t_disc_ob, '2016698',   'Elementos de Computadores',               3, 5, 3.0),
(@t_disc_ob, '2016707',   'Sistemas Operativos',                     3, 5, 3.0),
(@t_disc_ob, '2019072',   'Análisis Numérico I',                     4, 5, 3.0),
-- Semestre 6
(@t_disc_ob, '2016701',   'Ingeniería de Software I',                3, 6, 3.0);

-- ============================================================
-- PASO 5: Disciplinar Optativa
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_disc_op, '2029273', 'Advanced Data Structures',                   4, NULL, 3.0),
(@t_disc_op, '2016697', 'Arquitectura de Computadores',               3, NULL, 3.0),
(@t_disc_op, '2016353', 'Bases de Datos',                             3, NULL, 3.0),
(@t_disc_op, '2016342', 'Cálculo de Ecuaciones Diferenciales Ordinarias',4,NULL,3.0),
(@t_disc_op, '2027642', 'Compiladores',                               3, NULL, 3.0),
(@t_disc_op, '2016722', 'Computación Paralela y Distribuida',         3, NULL, 3.0),
(@t_disc_op, '2025960', 'Computación Visual',                         3, NULL, 3.0),
(@t_disc_op, '2027310', 'Criptografía',                               3, NULL, 3.0),
(@t_disc_op, '2021834', 'Informática Aplicada',                       3, NULL, 3.0),
(@t_disc_op, '2025196', 'Introducción a la Biología Computacional',   4, NULL, 3.0),
(@t_disc_op, '2027311', 'Introducción a la Criptografía y Teoría de Información',4,NULL,3.0),
(@t_disc_op, '2027631', 'Introducción a la Inteligencia Artificial',  3, NULL, 3.0),
(@t_disc_op, '2015173', 'Introducción a la Optimización',             4, NULL, 3.0),
(@t_disc_op, '2025995', 'Introducción a los Sistemas Inteligentes',   3, NULL, 3.0),
(@t_disc_op, '2027312', 'Introducción al Análisis Combinatorio',      4, NULL, 3.0),
(@t_disc_op, '2025966', 'Lenguajes de Programación',                  3, NULL, 3.0),
(@t_disc_op, '2027629', 'Lógica Computacional',                       3, NULL, 3.0),
(@t_disc_op, '2028837', 'Matemáticas del Aprendizaje de Máquinas',   4, NULL, 3.0),
(@t_disc_op, '2026377', 'Métodos Numéricos en Finanzas',              4, NULL, 3.0),
(@t_disc_op, '2024065', 'Mundos Virtuales',                           3, NULL, 3.0),
(@t_disc_op, '2025971', 'Optimización',                               3, NULL, 3.0),
(@t_disc_op, '2029272', 'Práctica Profesional',                       6, NULL, 3.0),
(@t_disc_op, '2025967', 'Redes de Computadores',                      3, NULL, 3.0),
(@t_disc_op, '2029090', 'Redes Neuronales, Arquitecturas y Aplicaciones',4,NULL,3.0),
(@t_disc_op, '2027313', 'Teoría de Codificación',                     4, NULL, 3.0),
(@t_disc_op, '2015184', 'Teoría de Grafos',                           4, NULL, 3.0),
(@t_disc_op, '2027628', 'Teoría de Lenguajes Formales',               3, NULL, 3.0),
(@t_disc_op, '2029274', 'Topics on Advanced Algorithms',              4, NULL, 3.0),
(@t_disc_op, '2028641', 'Quantum Computer Programming',               4, NULL, 3.0),
-- Fund. Optativas (disponibles para libre elección)
(@t_disc_op, '1000010-B','Biología Molecular y Celular',              3, NULL, 3.0),
(@t_disc_op, '2022689',  'Fundamentos de Física',                     3, NULL, 3.0),
(@t_disc_op, '2016651',  'Fundamentos de Física Teórica',             3, NULL, 3.0),
(@t_disc_op, '2015152',  'Grupos y Anillos',                          4, NULL, 3.0),
(@t_disc_op, '2015176',  'Mecánica Newtoniana',                       4, NULL, 3.0),
(@t_disc_op, '1000013-B','Probabilidad y Estadística Fundamental',    3, NULL, 3.0),
(@t_disc_op, '1000041-B','Química Básica',                            3, NULL, 3.0);

-- ============================================================
-- PASO 6: Nivelación
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_niv, '1000001-B', 'Matemáticas Básicas',        4, 1, 3.0),
(@t_niv, '1000002-B', 'Lecto-Escritura',             4, 2, 3.0),
(@t_niv, '1000044-B', 'Inglés I - Semestral',        3, 3, 3.0),
(@t_niv, '1000045-B', 'Inglés II - Semestral',       3, 4, 3.0),
(@t_niv, '1000046-B', 'Inglés III - Semestral',      3, 5, 3.0),
(@t_niv, '1000047-B', 'Inglés IV - Semestral',       3, 6, 3.0),
(@t_niv, '1000052-B', 'Inglés Intensivo I y II',     6, NULL, 3.0),
(@t_niv, '1000053-B', 'Inglés Intensivo III y IV',   6, NULL, 3.0);

-- ============================================================
-- PASO 7: Trabajo de Grado
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_grado, '2027634', 'Trabajo de Grado - Asignaturas de Posgrado', 8, 9, 3.0),
(@t_grado, '2027636', 'Trabajo de Grado - Pasantías',               8, 9, 3.0),
(@t_grado, '2027633', 'Trabajo de Grado - Trabajos Investigativos', 8, 9, 3.0);

-- ============================================================
-- VERIFICACIÓN
-- ============================================================
SELECT t.tipologia_nombre, COUNT(m.materia_id) AS total, SUM(m.materia_creditos) AS creditos
FROM tipologia t
LEFT JOIN materia m ON m.materia_tipologia_id = t.tipologia_id
WHERE t.tipologia_programa_id = @prog_cc
GROUP BY t.tipologia_nombre;
