-- ============================================================
-- UNIGRADES - 10_malla_isis.sql
-- Malla curricular completa de Ingeniería de Sistemas y
-- Computación (Plan 2A74) - UNAL Bogotá
-- Reemplaza las materias ficticias del 07/08 con datos reales.
-- EJECUTAR EN RAILWAY después de conectar a unigrades
-- ============================================================

USE unigrades;

-- ============================================================
-- PASO 1: Obtener el programa_id de ISIS en la UNAL
-- ============================================================
SET @unal_id = (
    SELECT universidad_id FROM universidad
    WHERE universidad_sigla = 'UNAL' LIMIT 1
);

SET @prog_isis = (
    SELECT programa_id FROM programa
    WHERE programa_universidad_id = @unal_id
      AND programa_nombre = 'Ingeniería de Sistemas y Computación'
    LIMIT 1
);

SELECT CONCAT('prog_isis = ', @prog_isis) AS info;

-- ============================================================
-- PASO 2: Limpiar materias y tipologías antiguas de ISIS
-- (las ficticias del script 07/08)
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM materia
WHERE materia_tipologia_id IN (
    SELECT tipologia_id FROM tipologia
    WHERE tipologia_programa_id = @prog_isis
);

DELETE FROM tipologia WHERE tipologia_programa_id = @prog_isis;

SET FOREIGN_KEY_CHECKS = 1;

-- Actualizar total de créditos del programa
UPDATE programa SET programa_total_creditos = 165
WHERE programa_id = @prog_isis;

-- ============================================================
-- PASO 3: Insertar tipologías reales
-- ============================================================
INSERT INTO tipologia (tipologia_programa_id, tipologia_nombre, tipologia_creditos_requeridos, tipologia_cuenta_promedio) VALUES
(@prog_isis, 'Fundamentación Obligatoria',  51, 1),
(@prog_isis, 'Disciplinar Obligatoria',     81, 1),
(@prog_isis, 'Disciplinar Optativa',        33, 1),
(@prog_isis, 'Nivelación',                  0,  0),  -- no cuenta para promedio
(@prog_isis, 'Trabajo de Grado',            16, 1);

-- Variables de tipología
SET @t_fund_ob = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_isis AND tipologia_nombre='Fundamentación Obligatoria');
SET @t_disc_ob = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_isis AND tipologia_nombre='Disciplinar Obligatoria');
SET @t_disc_op = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_isis AND tipologia_nombre='Disciplinar Optativa');
SET @t_niv     = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_isis AND tipologia_nombre='Nivelación');
SET @t_grado   = (SELECT tipologia_id FROM tipologia WHERE tipologia_programa_id=@prog_isis AND tipologia_nombre='Trabajo de Grado');

-- ============================================================
-- PASO 4: Materias de Fundamentación Obligatoria
-- (Semestres 1–5 según malla)
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
-- Semestre 1
(@t_fund_ob, '1000004-B', 'Cálculo Diferencial',                      4, 1, 3.0),
(@t_fund_ob, '1000019-B', 'Fundamentos de Mecánica',                   4, 1, 3.0),
-- Semestre 2
(@t_fund_ob, '1000005-B', 'Cálculo Integral',                          4, 2, 3.0),
(@t_fund_ob, '1000017-B', 'Fundamentos de Electricidad y Magnetismo',  4, 2, 3.0),
(@t_fund_ob, '1000003-B', 'Álgebra Lineal',                            4, 2, 3.0),
-- Semestre 3
(@t_fund_ob, '1000006-B', 'Cálculo en Varias Variables',               4, 3, 3.0),
(@t_fund_ob, '1000013-B', 'Probabilidad y Estadística Fundamental',    3, 3, 3.0),
(@t_fund_ob, '2025963',   'Matemáticas Discretas I',                   4, 3, 3.0),
-- Semestre 4
(@t_fund_ob, '2015703',   'Ingeniería Económica',                      3, 4, 3.0),
(@t_fund_ob, '2025964',   'Matemáticas Discretas II',                  4, 4, 3.0),
-- Semestre 5
(@t_fund_ob, '2015702',   'Gerencia y Gestión de Proyectos',           3, 5, 3.0);

-- ============================================================
-- PASO 5: Materias Disciplinar Obligatoria
-- (Semestres 1–8)
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
-- Semestre 1
(@t_disc_ob, '2025975', 'Introducción a la Ingeniería de Sistemas y Computación', 3, 1, 3.0),
(@t_disc_ob, '2015734', 'Programación de Computadores',                           3, 1, 3.0),
(@t_disc_ob, '2016703', 'Pensamiento Sistémico',                                  3, 1, 3.0),
-- Semestre 2
(@t_disc_ob, '2016375', 'Programación Orientada a Objetos',                       4, 2, 3.0),
(@t_disc_ob, '2016698', 'Elementos de Computadores',                              3, 2, 3.0),
(@t_disc_ob, '2016353', 'Bases de Datos',                                         3, 2, 3.0),
-- Semestre 3
(@t_disc_ob, '2016699', 'Estructuras de Datos',                                   4, 3, 3.0),
(@t_disc_ob, '2016697', 'Arquitectura de Computadores',                           3, 3, 3.0),
(@t_disc_ob, '2015174', 'Introducción a la Teoría de la Computación',             3, 3, 3.0),
-- Semestre 4
(@t_disc_ob, '2016707', 'Sistemas Operativos',                                    3, 4, 3.0),
(@t_disc_ob, '2016696', 'Algoritmos',                                             3, 4, 3.0),
-- Semestre 5
(@t_disc_ob, '2025970', 'Modelos y Simulación',                                   3, 5, 3.0),
(@t_disc_ob, '2025967', 'Redes de Computadores',                                  3, 5, 3.0),
(@t_disc_ob, '2016701', 'Ingeniería de Software I',                               3, 5, 3.0),
(@t_disc_ob, '2025966', 'Lenguajes de Programación',                              3, 5, 3.0),
(@t_disc_ob, '2025995', 'Introducción a los Sistemas Inteligentes',               3, 5, 3.0),
-- Semestre 6
(@t_disc_ob, '2025982', 'Sistemas de Información',                                3, 6, 3.0),
(@t_disc_ob, '2015970', 'Métodos Numéricos',                                      3, 6, 3.0),
(@t_disc_ob, '2025971', 'Optimización',                                           3, 6, 3.0),
(@t_disc_ob, '2016702', 'Ingeniería de Software II',                              3, 6, 3.0),
-- Semestre 7
(@t_disc_ob, '2025983', 'Arquitectura de Infraestructura y Gobierno de TICs',    3, 7, 3.0),
(@t_disc_ob, '2025994', 'Teoría de la Información y Sistemas de Comunicación',   3, 7, 3.0),
(@t_disc_ob, '2025969', 'Modelos Estocásticos y Simulación en Cómputo y Comun.', 3, 7, 3.0),
(@t_disc_ob, '2016716', 'Arquitectura de Software',                              3, 7, 3.0),
-- Semestre 8
(@t_disc_ob, '2016722', 'Computación Paralela y Distribuida',                    3, 8, 3.0),
(@t_disc_ob, '2025972', 'Introducción a la Criptografía y Seguridad',            3, 8, 3.0),
(@t_disc_ob, '2025960', 'Computación Visual',                                    3, 8, 3.0),
(@t_disc_ob, '2024045', 'Taller de Proyectos Interdisciplinarios',               3, 8, 3.0);

-- ============================================================
-- PASO 6: Materias Disciplinar Optativa (Libre Elección)
-- Todas las que aparecen en el catálogo pero no tienen
-- semestre fijo — el estudiante elige libremente
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_disc_op, '2027641', 'Análisis de Bases de Datos',                             3, NULL, 3.0),
(@t_disc_op, '2027309', 'Análisis Forense Digital',                               4, NULL, 3.0),
(@t_disc_op, '2019072', 'Análisis Numérico I',                                    4, NULL, 3.0),
(@t_disc_op, '2016498', 'Electrónica Digital I',                                  4, NULL, 3.0),
(@t_disc_op, '2016492', 'Comunicaciones',                                         3, NULL, 3.0),
(@t_disc_op, '2026551', 'Creación y Gestión de Empresas',                         3, NULL, 3.0),
(@t_disc_op, '2027310', 'Criptografía',                                           3, NULL, 3.0),
(@t_disc_op, '2016028', 'Diseño, Gestión y Evaluación de Proyectos',             4, NULL, 3.0),
(@t_disc_op, '2016741', 'Finanzas',                                               3, NULL, 3.0),
(@t_disc_op, '2016037', 'Finanzas Avanzadas',                                     4, NULL, 3.0),
(@t_disc_op, '2016007', 'Fundamentos de Administración',                          4, NULL, 3.0),
(@t_disc_op, '2025986', 'Ingeniería Económica y Análisis de Riesgo',              3, NULL, 3.0),
(@t_disc_op, '2016748', 'Inteligencia Artificial',                                3, NULL, 3.0),
(@t_disc_op, '2023251', 'Inteligencia Artificial y Mini-Robots',                  3, NULL, 3.0),
(@t_disc_op, '2027311', 'Introducción a la Criptografía y Teoría de Información', 4, NULL, 3.0),
(@t_disc_op, '2027631', 'Introducción a la Inteligencia Artificial',              3, NULL, 3.0),
(@t_disc_op, '2015173', 'Introducción a la Optimización',                         4, NULL, 3.0),
(@t_disc_op, '2026573', 'Introducción a las CC y a la Programación',             3, NULL, 3.0),
(@t_disc_op, '2025965', 'Complemento a Teoría de la Computación',                1, NULL, 3.0),
(@t_disc_op, '2025966', 'Lenguajes de Programación',                              3, NULL, 3.0),
(@t_disc_op, '2017293', 'Modelación Matemática',                                  3, NULL, 3.0),
(@t_disc_op, '2025969', 'Modelos Estocásticos',                                   3, NULL, 3.0),
(@t_disc_op, '2028837', 'Matemáticas del Aprendizaje de Máquinas',               4, NULL, 3.0),
(@t_disc_op, '2027642', 'Compiladores',                                           3, NULL, 3.0),
(@t_disc_op, '2016600', 'Gestión Tecnológica',                                    3, NULL, 3.0),
(@t_disc_op, '2016599', 'Gestión de la Ciencia, Tecnología e Innovación',        3, NULL, 3.0),
(@t_disc_op, '2016053', 'Sistemas de Información Gerencial',                      4, NULL, 3.0),
(@t_disc_op, '2027313', 'Teoría de Codificación',                                 4, NULL, 3.0),
(@t_disc_op, '2027628', 'Teoría de Lenguajes Formales',                           3, NULL, 3.0),
(@t_disc_op, '2017290', 'Técnicas de Inteligencia Artificial',                    3, NULL, 3.0),
(@t_disc_op, '2016615', 'Taller de Invención y Creatividad',                     3, NULL, 3.0),
(@t_disc_op, '2019082', 'Modelos Matemáticos I',                                  4, NULL, 3.0),
(@t_disc_op, '2016788', 'Tecnología Digital',                                     3, NULL, 3.0),
-- Fundamentación optativa (también disponible como libre elección)
(@t_disc_op, '2015555', 'Álgebra Lineal Básica',                                  4, NULL, 3.0),
(@t_disc_op, '2016377', 'Cálculo Diferencial en Una Variable',                    4, NULL, 3.0),
(@t_disc_op, '2015556', 'Cálculo Integral en Una Variable',                       4, NULL, 3.0),
(@t_disc_op, '2015162', 'Cálculo Vectorial',                                      4, NULL, 3.0),
(@t_disc_op, '2015168', 'Fundamentos de Matemáticas',                             4, NULL, 3.0),
(@t_disc_op, '2015181', 'Sistemas Numéricos',                                     4, NULL, 3.0),
(@t_disc_op, '2015178', 'Probabilidad',                                           4, NULL, 3.0),
(@t_disc_op, '2025963', 'Matemáticas Discretas I (optativa)',                     4, NULL, 3.0),
(@t_disc_op, '2025964', 'Matemáticas Discretas II (optativa)',                    4, NULL, 3.0),
(@t_disc_op, '2016047', 'Modelos Económicos Computacionales',                     3, NULL, 3.0);

-- ============================================================
-- PASO 7: Materias de Nivelación (no cuentan para promedio)
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
-- PASO 8: Trabajo de Grado
-- ============================================================
INSERT INTO materia (materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_semestre_sugerido, materia_nota_minima_aprobacion) VALUES
(@t_grado, '2016843', 'Trabajo de Grado - Asignaturas de Posgrado',     6, 10, 3.0),
(@t_grado, '2025973', 'Trabajo de Grado - Práctica de Extensión',       6, 10, 3.0),
(@t_grado, '2025974', 'Trabajo de Grado - Trabajos Investigativos',     6, 10, 3.0);

-- ============================================================
-- VERIFICACIÓN
-- ============================================================
SELECT t.tipologia_nombre, COUNT(m.materia_id) AS total_materias,
       SUM(m.materia_creditos) AS total_creditos
FROM tipologia t
LEFT JOIN materia m ON m.materia_tipologia_id = t.tipologia_id
WHERE t.tipologia_programa_id = @prog_isis
GROUP BY t.tipologia_nombre;
