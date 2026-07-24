-- ============================================================
-- UNIGRADES - 02_dml.sql
-- Archivo DML único fusionado y corregido:
--   1. Universidades (10)
--   2. Programas (10)
--   3. Tipologías (10)
--   4. Materias por Tipología
--   5. Prerrequisitos y Correquisitos
--   6. Usuarios (200)
--   7. Semestres
-- ============================================================

USE unigrades;

-- ============================================================
-- 1. UNIVERSIDADES (10 instituciones reales de Colombia)
-- ============================================================

INSERT INTO universidad (universidad_nombre, universidad_sigla, universidad_pais, universidad_ciudad) VALUES
('Universidad Nacional de Colombia',          'UNAL',   'Colombia', 'Bogotá'),
('Universidad de los Andes',                  'UNIANDES','Colombia','Bogotá'),
('Universidad del Rosario',                   'UR',      'Colombia', 'Bogotá'),
('Pontificia Universidad Javeriana',          'PUJ',    'Colombia', 'Bogotá'),
('Universidad EAFIT',                         'EAFIT',  'Colombia', 'Medellín'),
('Universidad de Antioquia',                  'UDEA',   'Colombia', 'Medellín'),
('Universidad del Valle',                     'UNIVALLE','Colombia','Cali'),
('Universidad Industrial de Santander',       'UIS',    'Colombia', 'Bucaramanga'),
('Universidad Tecnológica de Pereira',        'UTP',    'Colombia', 'Pereira'),
('Universidad Distrital Francisco José de Caldas','UDFJC','Colombia','Bogotá');

-- ============================================================
-- 2. PROGRAMAS ACADÉMICOS
-- Se crea un programa por cada universidad para asegurar
-- que existan los programa_id del 1 al 10 para los usuarios.
-- ============================================================

INSERT INTO programa (programa_universidad_id, programa_nombre, programa_facultad, programa_total_creditos)
SELECT universidad_id, 'Ciencias de la Computación', 'Facultad de Ciencias', 139
FROM   universidad
ORDER BY universidad_id;

-- ============================================================
-- 3. TIPOLOGÍAS
-- Se enlazan al programa de la UNAL Bogotá (programa_id = 1).
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
WHERE  p.programa_universidad_id = 1
  AND  p.programa_nombre = 'Ciencias de la Computación'
LIMIT  10;

-- ============================================================
-- 4. MATERIAS POR TIPOLOGÍA
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
-- 5. PRERREQUISITOS Y CORREQUISITOS
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

INSERT INTO materia_correquisito (materia_id, correquisito_materia_id) VALUES
((SELECT materia_id FROM materia WHERE materia_codigo = '2015176'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016377')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2016651'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016377')),
((SELECT materia_id FROM materia WHERE materia_codigo = '2022689'), (SELECT materia_id FROM materia WHERE materia_codigo = '2016377'));

-- ============================================================
-- 6. USUARIOS (200 estudiantes)
-- ============================================================

INSERT INTO usuario (usuario_programa_id, usuario_nombre, usuario_apellido, usuario_email, usuario_password_hash, usuario_codigo_estudiantil) VALUES
(1,'Sergio','Chaves','sechaves@unal.edu.co','$2b$10$hashed_placeholder_001','1000123456'),
(1,'Valentina','García','vgarcia@unal.edu.co','$2b$10$hashed_placeholder_002','1000123457'),
(1,'Mateo','Rodríguez','mrodriguez@unal.edu.co','$2b$10$hashed_placeholder_003','1000123458'),
(1,'Isabella','Martínez','imartinez@unal.edu.co','$2b$10$hashed_placeholder_004','1000123459'),
(1,'Santiago','López','slopez@unal.edu.co','$2b$10$hashed_placeholder_005','1000123460'),
(1,'Camila','Hernández','chernandez@unal.edu.co','$2b$10$hashed_placeholder_006','1000123461'),
(1,'Daniel','González','dgonzalez@unal.edu.co','$2b$10$hashed_placeholder_007','1000123462'),
(1,'Sofía','Pérez','sperez@unal.edu.co','$2b$10$hashed_placeholder_008','1000123463'),
(1,'Sebastián','Sánchez','ssanchez@unal.edu.co','$2b$10$hashed_placeholder_009','1000123464'),
(1,'Lucía','Ramírez','lramirez@unal.edu.co','$2b$10$hashed_placeholder_010','1000123465'),
(1,'Felipe','Torres','ftorres@unal.edu.co','$2b$10$hashed_placeholder_011','1000123466'),
(1,'Mariana','Flores','mflores@unal.edu.co','$2b$10$hashed_placeholder_012','1000123467'),
(1,'Andrés','Rivera','arivera@unal.edu.co','$2b$10$hashed_placeholder_013','1000123468'),
(1,'Gabriela','Gómez','ggomez@unal.edu.co','$2b$10$hashed_placeholder_014','1000123469'),
(1,'Juan','Díaz','jdiaz@unal.edu.co','$2b$10$hashed_placeholder_015','1000123470'),
(1,'Paula','Morales','pmorales@unal.edu.co','$2b$10$hashed_placeholder_016','1000123471'),
(1,'David','Jiménez','djimenez@unal.edu.co','$2b$10$hashed_placeholder_017','1000123472'),
(1,'Laura','Ruiz','lruiz@unal.edu.co','$2b$10$hashed_placeholder_018','1000123473'),
(1,'Miguel','Vargas','mvargas@unal.edu.co','$2b$10$hashed_placeholder_019','1000123474'),
(1,'Natalia','Castro','ncastro@unal.edu.co','$2b$10$hashed_placeholder_020','1000123475'),
(2,'Carlos','Suárez','csuarez@uniandes.edu.co','$2b$10$hashed_placeholder_021','202010001'),
(2,'Ana','Ortega','aortega@uniandes.edu.co','$2b$10$hashed_placeholder_022','202010002'),
(2,'Julián','Reyes','jreyes@uniandes.edu.co','$2b$10$hashed_placeholder_023','202010003'),
(2,'Daniela','Cruz','dcruz@uniandes.edu.co','$2b$10$hashed_placeholder_024','202010004'),
(2,'Tomás','Moreno','tmoreno@uniandes.edu.co','$2b$10$hashed_placeholder_025','202010005'),
(2,'Alejandra','Muñoz','amunoz@uniandes.edu.co','$2b$10$hashed_placeholder_026','202010006'),
(2,'Ricardo','Álvarez','ralvarez@uniandes.edu.co','$2b$10$hashed_placeholder_027','202010007'),
(2,'Sara','Romero','sromero@uniandes.edu.co','$2b$10$hashed_placeholder_028','202010008'),
(2,'Esteban','Herrera','eherrera@uniandes.edu.co','$2b$10$hashed_placeholder_029','202010009'),
(2,'Mónica','Medina','mmedina@uniandes.edu.co','$2b$10$hashed_placeholder_030','202010010'),
(3,'Pablo','Aguilar','paguilar@urosario.edu.co','$2b$10$hashed_placeholder_031','3001001'),
(3,'Valeria','Gutiérrez','vgutierrez@urosario.edu.co','$2b$10$hashed_placeholder_032','3001002'),
(3,'Nicolás','Espinosa','nespinosa@urosario.edu.co','$2b$10$hashed_placeholder_033','3001003'),
(3,'Catalina','Ríos','crios@urosario.edu.co','$2b$10$hashed_placeholder_034','3001004'),
(3,'Diego','Mendoza','dmendoza@urosario.edu.co','$2b$10$hashed_placeholder_035','3001005'),
(3,'Verónica','Rojas','vrojas@urosario.edu.co','$2b$10$hashed_placeholder_036','3001006'),
(3,'Rodrigo','Silva','rsilva@urosario.edu.co','$2b$10$hashed_placeholder_037','3001007'),
(3,'Paola','Cárdenas','pcardenas@urosario.edu.co','$2b$10$hashed_placeholder_038','3001008'),
(3,'Mauricio','Guerrero','mguerrero@urosario.edu.co','$2b$10$hashed_placeholder_039','3001009'),
(3,'Adriana','Navarro','anavarro@urosario.edu.co','$2b$10$hashed_placeholder_040','3001010'),
(4,'Camilo','Fuentes','cfuentes@javeriana.edu.co','$2b$10$hashed_placeholder_041','4001001'),
(4,'Jessica','Cabrera','jcabrera@javeriana.edu.co','$2b$10$hashed_placeholder_042','4001002'),
(4,'Iván','Delgado','idelgado@javeriana.edu.co','$2b$10$hashed_placeholder_043','4001003'),
(4,'Stephanie','Vega','svega@javeriana.edu.co','$2b$10$hashed_placeholder_044','4001004'),
(4,'Alexis','Castillo','acastillo@javeriana.edu.co','$2b$10$hashed_placeholder_045','4001005'),
(4,'Lorena','Peña','lpena@javeriana.edu.co','$2b$10$hashed_placeholder_046','4001006'),
(4,'Gustavo','Lara','glara@javeriana.edu.co','$2b$10$hashed_placeholder_047','4001007'),
(4,'Marcela','Pardo','mpardo@javeriana.edu.co','$2b$10$hashed_placeholder_048','4001008'),
(4,'Ernesto','Campos','ecampos@javeriana.edu.co','$2b$10$hashed_placeholder_049','4001009'),
(4,'Claudia','Varela','cvarela@javeriana.edu.co','$2b$10$hashed_placeholder_050','4001010');

INSERT INTO usuario (usuario_programa_id, usuario_nombre, usuario_apellido, usuario_email, usuario_password_hash, usuario_codigo_estudiantil) VALUES
(5,'Fernando','Ossa','fossa@eafit.edu.co','$2b$10$hashed_placeholder_051','5001001'),
(5,'Andrea','Zapata','azapata@eafit.edu.co','$2b$10$hashed_placeholder_052','5001002'),
(5,'Hernán','Cano','hcano@eafit.edu.co','$2b$10$hashed_placeholder_053','5001003'),
(5,'Luisa','Betancur','lbetancur@eafit.edu.co','$2b$10$hashed_placeholder_054','5001004'),
(5,'Jorge','Arango','jarango@eafit.edu.co','$2b$10$hashed_placeholder_055','5001005'),
(5,'Diana','Restrepo','drestrepo@eafit.edu.co','$2b$10$hashed_placeholder_056','5001006'),
(5,'Álvaro','Giraldo','agiraldo@eafit.edu.co','$2b$10$hashed_placeholder_057','5001007'),
(5,'Patricia','Cardona','pcardona@eafit.edu.co','$2b$10$hashed_placeholder_058','5001008'),
(5,'César','Londoño','clondono@eafit.edu.co','$2b$10$hashed_placeholder_059','5001009'),
(5,'Ximena','Montoya','xmontoya@eafit.edu.co','$2b$10$hashed_placeholder_060','5001010'),
(6,'Jhon','Carvajal','jcarvajal@udea.edu.co','$2b$10$hashed_placeholder_061','6001001'),
(6,'Lina','Vélez','lvelez@udea.edu.co','$2b$10$hashed_placeholder_062','6001002'),
(6,'Óscar','Patiño','opatino@udea.edu.co','$2b$10$hashed_placeholder_063','6001003'),
(6,'Yuliana','Acosta','yacosta@udea.edu.co','$2b$10$hashed_placeholder_064','6001004'),
(6,'Wilmar','Castaño','wcastano@udea.edu.co','$2b$10$hashed_placeholder_065','6001005'),
(6,'Leidy','Palacio','lpalacio@udea.edu.co','$2b$10$hashed_placeholder_066','6001006'),
(6,'Alexánder','Duque','aduque@udea.edu.co','$2b$10$hashed_placeholder_067','6001007'),
(6,'Bibiana','Jaramillo','bjaramillo@udea.edu.co','$2b$10$hashed_placeholder_068','6001008'),
(6,'Giovanny','Marulanda','gmarulanda@udea.edu.co','$2b$10$hashed_placeholder_069','6001009'),
(6,'Tatiana','Hoyos','thoyos@udea.edu.co','$2b$10$hashed_placeholder_070','6001010'),
(7,'Édgar','Caicedo','ecaicedo@univalle.edu.co','$2b$10$hashed_placeholder_071','7001001'),
(7,'Nathaly','Pizarro','npizarro@univalle.edu.co','$2b$10$hashed_placeholder_072','7001002'),
(7,'Rubén','Salcedo','rsalcedo@univalle.edu.co','$2b$10$hashed_placeholder_073','7001003'),
(7,'Claudia','Mosquera','cmosquera@univalle.edu.co','$2b$10$hashed_placeholder_074','7001004'),
(7,'Henry','Lozano','hlozano@univalle.edu.co','$2b$10$hashed_placeholder_075','7001005'),
(7,'Carolina','Mina','cmina@univalle.edu.co','$2b$10$hashed_placeholder_076','7001006'),
(7,'Javier','Angulo','jangulo@univalle.edu.co','$2b$10$hashed_placeholder_077','7001007'),
(7,'Yaneth','Riascos','yriascos@univalle.edu.co','$2b$10$hashed_placeholder_078','7001008'),
(7,'Jhonatan','Sinisterra','jsinisterra@univalle.edu.co','$2b$10$hashed_placeholder_079','7001009'),
(7,'Marta','Quiñones','mquinones@univalle.edu.co','$2b$10$hashed_placeholder_080','7001010'),
(8,'Luis','Serrano','lserrano@uis.edu.co','$2b$10$hashed_placeholder_081','8001001'),
(8,'Gloria','Mantilla','gmantilla@uis.edu.co','$2b$10$hashed_placeholder_082','8001002'),
(8,'Omar','Díaz','odiaz@uis.edu.co','$2b$10$hashed_placeholder_083','8001003'),
(8,'Francy','Villamizar','fvillamizar@uis.edu.co','$2b$10$hashed_placeholder_084','8001004'),
(8,'Nelson','Blanco','nblanco@uis.edu.co','$2b$10$hashed_placeholder_085','8001005'),
(8,'Adriana','Gómez','agomez@uis.edu.co','$2b$10$hashed_placeholder_086','8001006'),
(8,'Fabián','Jaimes','fjaimes@uis.edu.co','$2b$10$hashed_placeholder_087','8001007'),
(8,'Sandra','Suárez','ssuarez@uis.edu.co','$2b$10$hashed_placeholder_088','8001008'),
(8,'Raúl','Pineda','rpineda@uis.edu.co','$2b$10$hashed_placeholder_089','8001009'),
(8,'Yenny','Prada','yprada@uis.edu.co','$2b$10$hashed_placeholder_090','8001010'),
(9,'Jhon','Tabares','jtabares@utp.edu.co','$2b$10$hashed_placeholder_091','9001001'),
(9,'Angie','Trejos','atrejos@utp.edu.co','$2b$10$hashed_placeholder_092','9001002'),
(9,'Mauricio','Gallego','mgallego@utp.edu.co','$2b$10$hashed_placeholder_093','9001003'),
(9,'Milena','Salazar','msalazar@utp.edu.co','$2b$10$hashed_placeholder_094','9001004'),
(9,'Elkin','Arias','earias@utp.edu.co','$2b$10$hashed_placeholder_095','9001005'),
(9,'Julieth','Valencia','jvalencia@utp.edu.co','$2b$10$hashed_placeholder_096','9001006'),
(9,'Brayan','Castaño','bcastano@utp.edu.co','$2b$10$hashed_placeholder_097','9001007'),
(9,'Heidy','Marín','hmarin@utp.edu.co','$2b$10$hashed_placeholder_098','9001008'),
(9,'Cristian','Ospina','cospina@utp.edu.co','$2b$10$hashed_placeholder_099','9001009'),
(9,'Vanessa','Largo','vlargo@utp.edu.co','$2b$10$hashed_placeholder_100','9001010');

INSERT INTO usuario (usuario_programa_id, usuario_nombre, usuario_apellido, usuario_email, usuario_password_hash, usuario_codigo_estudiantil) VALUES
(10,'Yesid','Bernal','ybernal@udistrital.edu.co','$2b$10$hashed_placeholder_101','101001001'),
(10,'Karen','Nieto','knieto@udistrital.edu.co','$2b$10$hashed_placeholder_102','101001002'),
(10,'Germán','Rincón','grincon@udistrital.edu.co','$2b$10$hashed_placeholder_103','101001003'),
(10,'Stefany','Cortés','scortes@udistrital.edu.co','$2b$10$hashed_placeholder_104','101001004'),
(10,'Jhonnier','Chaparro','jchaparro@udistrital.edu.co','$2b$10$hashed_placeholder_105','101001005'),
(10,'Nury','Fonseca','nfonseca@udistrital.edu.co','$2b$10$hashed_placeholder_106','101001006'),
(10,'Edwin','Useche','euseche@udistrital.edu.co','$2b$10$hashed_placeholder_107','101001007'),
(10,'Marcela','Cuervo','mcuervo@udistrital.edu.co','$2b$10$hashed_placeholder_108','101001008'),
(10,'Harold','Becerra','hbecerra@udistrital.edu.co','$2b$10$hashed_placeholder_109','101001009'),
(10,'Luisa','Trujillo','ltrujillo@udistrital.edu.co','$2b$10$hashed_placeholder_110','101001010');

INSERT INTO usuario (usuario_programa_id, usuario_nombre, usuario_apellido, usuario_email, usuario_password_hash, usuario_codigo_estudiantil) VALUES
(1,'José','Pinzón','jpinzon@unal.edu.co','$2b$10$hashed_placeholder_111','1000223001'),
(1,'María','Bohórquez','mbohorquez@unal.edu.co','$2b$10$hashed_placeholder_112','1000223002'),
(2,'Alejandro','Sandoval','asandoval@uniandes.edu.co','$2b$10$hashed_placeholder_113','202020001'),
(2,'Camila','Barrera','cbarrera@uniandes.edu.co','$2b$10$hashed_placeholder_114','202020002'),
(3,'Ricardo','León','rleon@urosario.edu.co','$2b$10$hashed_placeholder_115','3002001'),
(3,'Marcela','Quintero','mquintero@urosario.edu.co','$2b$10$hashed_placeholder_116','3002002'),
(4,'Sebastián','Mora','smora@javeriana.edu.co','$2b$10$hashed_placeholder_117','4002001'),
(4,'Vanessa','Pineda','vpineda@javeriana.edu.co','$2b$10$hashed_placeholder_118','4002002'),
(5,'Andrés','Mejía','amejia@eafit.edu.co','$2b$10$hashed_placeholder_119','5002001'),
(5,'Daniela','Escobar','descobar@eafit.edu.co','$2b$10$hashed_placeholder_120','5002002'),
(6,'Carlos','Henao','chenao@udea.edu.co','$2b$10$hashed_placeholder_121','6002001'),
(6,'Paola','Ríos','prios@udea.edu.co','$2b$10$hashed_placeholder_122','6002002'),
(7,'Felipe','Valencia','fvalencia@univalle.edu.co','$2b$10$hashed_placeholder_123','7002001'),
(7,'Sandra','Obando','sobando@univalle.edu.co','$2b$10$hashed_placeholder_124','7002002'),
(8,'Juan','Acevedo','jacevedo@uis.edu.co','$2b$10$hashed_placeholder_125','8002001'),
(8,'Natalia','Flórez','nflorez@uis.edu.co','$2b$10$hashed_placeholder_126','8002002'),
(9,'David','Morales','dmorales@utp.edu.co','$2b$10$hashed_placeholder_127','9002001'),
(9,'Laura','Gutiérrez','lgutierrez@utp.edu.co','$2b$10$hashed_placeholder_128','9002002'),
(10,'Miguel','Avella','mavella@udistrital.edu.co','$2b$10$hashed_placeholder_129','101002001'),
(10,'Tatiana','Contreras','tcontreras@udistrital.edu.co','$2b$10$hashed_placeholder_130','101002002'),
(1,'Julián','Parra','jparra@unal.edu.co','$2b$10$hashed_placeholder_131','1000223003'),
(1,'Stephany','Cepeda','scepeda@unal.edu.co','$2b$10$hashed_placeholder_132','1000223004'),
(2,'Nicolás','Vargas','nvargas@uniandes.edu.co','$2b$10$hashed_placeholder_133','202020003'),
(2,'Isabella','Castro','icastro@uniandes.edu.co','$2b$10$hashed_placeholder_134','202020004'),
(3,'Santiago','Rueda','srueda@urosario.edu.co','$2b$10$hashed_placeholder_135','3002003'),
(3,'Valentina','Pulido','vpulido@urosario.edu.co','$2b$10$hashed_placeholder_136','3002004'),
(4,'Daniel','Alarcón','dalarcon@javeriana.edu.co','$2b$10$hashed_placeholder_137','4002003'),
(4,'Sofía','Cifuentes','scifuentes@javeriana.edu.co','$2b$10$hashed_placeholder_138','4002004'),
(5,'Pablo','Uribe','puribe@eafit.edu.co','$2b$10$hashed_placeholder_139','5002003'),
(5,'Alejandra','Villa','avilla@eafit.edu.co','$2b$10$hashed_placeholder_140','5002004'),
(6,'Tomás','Correa','tcorrea@udea.edu.co','$2b$10$hashed_placeholder_141','6002003'),
(6,'Valeria','Agudelo','vagudelo@udea.edu.co','$2b$10$hashed_placeholder_142','6002004'),
(7,'Iván','Mena','imena@univalle.edu.co','$2b$10$hashed_placeholder_143','7002003'),
(7,'Mariana','Ordóñez','mordonez@univalle.edu.co','$2b$10$hashed_placeholder_144','7002004'),
(8,'Germán','Cáceres','gcaceres@uis.edu.co','$2b$10$hashed_placeholder_145','8002003'),
(8,'Luisa','Hernández','lhernandez@uis.edu.co','$2b$10$hashed_placeholder_146','8002004'),
(9,'Mateo','Muñoz','mmunoz@utp.edu.co','$2b$10$hashed_placeholder_147','9002003'),
(9,'Carolina','Giraldo','cgiraldo@utp.edu.co','$2b$10$hashed_placeholder_148','9002004'),
(10,'Sergio','Cubides','scubides@udistrital.edu.co','$2b$10$hashed_placeholder_149','101002003'),
(10,'Andrea','Téllez','atellez@udistrital.edu.co','$2b$10$hashed_placeholder_150','101002004'),
(1,'Esteban','Niño','enino@unal.edu.co','$2b$10$hashed_placeholder_151','1000223005'),
(1,'Lina','Castellanos','lcastellanos@unal.edu.co','$2b$10$hashed_placeholder_152','1000223006'),
(2,'Diego','Amaya','damaya@uniandes.edu.co','$2b$10$hashed_placeholder_153','202020005'),
(2,'Paula','Caro','pcaro@uniandes.edu.co','$2b$10$hashed_placeholder_154','202020006'),
(3,'Andrés','Fierro','afierro@urosario.edu.co','$2b$10$hashed_placeholder_155','3002005'),
(3,'Catalina','Morales','cmorales@urosario.edu.co','$2b$10$hashed_placeholder_156','3002006'),
(4,'Luis','Triana','ltriana@javeriana.edu.co','$2b$10$hashed_placeholder_157','4002005'),
(4,'Jessica','Muñoz','jmunoz@javeriana.edu.co','$2b$10$hashed_placeholder_158','4002006'),
(5,'Camilo','Aristizábal','caristizabal@eafit.edu.co','$2b$10$hashed_placeholder_159','5002005'),
(5,'Gloria','Ochoa','gochoa@eafit.edu.co','$2b$10$hashed_placeholder_160','5002006');

INSERT INTO usuario (usuario_programa_id, usuario_nombre, usuario_apellido, usuario_email, usuario_password_hash, usuario_codigo_estudiantil) VALUES
(6,'Javier','Zapata','jzapata@udea.edu.co','$2b$10$hashed_placeholder_161','6002005'),
(6,'Diana','Osorio','dosorio@udea.edu.co','$2b$10$hashed_placeholder_162','6002006'),
(7,'Ernesto','Bejarano','ebejarano@univalle.edu.co','$2b$10$hashed_placeholder_163','7002005'),
(7,'Patricia','Zambrano','pzambrano@univalle.edu.co','$2b$10$hashed_placeholder_164','7002006'),
(8,'Álvaro','Moreno','amoreno@uis.edu.co','$2b$10$hashed_placeholder_165','8002005'),
(8,'Yaneth','Rueda','yrueda@uis.edu.co','$2b$10$hashed_placeholder_166','8002006'),
(9,'Omar','Cárdenas','ocardenas@utp.edu.co','$2b$10$hashed_placeholder_167','9002005'),
(9,'Heidy','Restrepo','hrestrepo@utp.edu.co','$2b$10$hashed_placeholder_168','9002006'),
(10,'Fernando','Daza','fdaza@udistrital.edu.co','$2b$10$hashed_placeholder_169','101002005'),
(10,'Adriana','Salinas','asalinas@udistrital.edu.co','$2b$10$hashed_placeholder_170','101002006'),
(1,'Ricardo','Aya','raya@unal.edu.co','$2b$10$hashed_placeholder_171','1000223007'),
(1,'Mónica','Buitrago','mbuitrago@unal.edu.co','$2b$10$hashed_placeholder_172','1000223008'),
(2,'Rafael','Ospina','rospina@uniandes.edu.co','$2b$10$hashed_placeholder_173','202020007'),
(2,'Claudia','Pedraza','cpedraza@uniandes.edu.co','$2b$10$hashed_placeholder_174','202020008'),
(3,'Mauricio','Arenas','marenas@urosario.edu.co','$2b$10$hashed_placeholder_175','3002007'),
(3,'Lorena','Bernal','lbernal@urosario.edu.co','$2b$10$hashed_placeholder_176','3002008'),
(4,'Nelson','Guzmán','nguzman@javeriana.edu.co','$2b$10$hashed_placeholder_177','4002007'),
(4,'Marcela','Roa','mroa@javeriana.edu.co','$2b$10$hashed_placeholder_178','4002008'),
(5,'Álvaro','Calle','acalle@eafit.edu.co','$2b$10$hashed_placeholder_179','5002007'),
(5,'Bibiana','Tobón','btobon@eafit.edu.co','$2b$10$hashed_placeholder_180','5002008'),
(6,'Elkin','Peñaranda','epenaranda@udea.edu.co','$2b$10$hashed_placeholder_181','6002007'),
(6,'Milena','Álvarez','malvarez@udea.edu.co','$2b$10$hashed_placeholder_182','6002008'),
(7,'Wilmar','Cabal','wcabal@univalle.edu.co','$2b$10$hashed_placeholder_183','7002007'),
(7,'Nathaly','Cabezas','ncabezas@univalle.edu.co','$2b$10$hashed_placeholder_184','7002008'),
(8,'Fabián','Leal','fleal@uis.edu.co','$2b$10$hashed_placeholder_185','8002007'),
(8,'Sandra','Ramón','sramon@uis.edu.co','$2b$10$hashed_placeholder_186','8002008'),
(9,'Jhonatan','López','jlopez@utp.edu.co','$2b$10$hashed_placeholder_187','9002007'),
(9,'Angie','Duque','aduque@utp.edu.co','$2b$10$hashed_placeholder_188','9002008'),
(10,'Cristian','Parra','cparra@udistrital.edu.co','$2b$10$hashed_placeholder_189','101002007'),
(10,'Yuliana','Mendoza','ymendoza@udistrital.edu.co','$2b$10$hashed_placeholder_190','101002008'),
(1,'Brayan','Soacha','bsoacha@unal.edu.co','$2b$10$hashed_placeholder_191','1000223009'),
(1,'Leidy','Barón','lbaron@unal.edu.co','$2b$10$hashed_placeholder_192','1000223010'),
(2,'César','Montaño','cmontano@uniandes.edu.co','$2b$10$hashed_placeholder_193','202020009'),
(2,'Ximena','Páez','xpaez@uniandes.edu.co','$2b$10$hashed_placeholder_194','202020010'),
(3,'Harold','Forero','hforero@urosario.edu.co','$2b$10$hashed_placeholder_195','3002009'),
(3,'Karen','Vásquez','kvasquez@urosario.edu.co','$2b$10$hashed_placeholder_196','3002010'),
(4,'Yesid','Gutiérrez','ygutierrez@javeriana.edu.co','$2b$10$hashed_placeholder_197','4002009'),
(4,'Nury','Rodríguez','nrodriguez@javeriana.edu.co','$2b$10$hashed_placeholder_198','4002010'),
(5,'Edwin','Sepúlveda','esepulveda@eafit.edu.co','$2b$10$hashed_placeholder_199','5002009'),
(5,'Stefany','Naranjo','snaranjo@eafit.edu.co','$2b$10$hashed_placeholder_200','5002010');

-- ============================================================
-- 7. SEMESTRES
-- ============================================================

INSERT INTO semestre (semestre_usuario_id, semestre_numero, semestre_year, semestre_periodo) VALUES
-- Usuario 1 (Sergio Chaves) - 7 semestres
(1,1,2023,1),(1,2,2023,2),(1,3,2024,1),(1,4,2024,2),(1,5,2025,1),(1,6,2025,2),(1,7,2026,1),
-- Usuario 2
(2,1,2023,1),(2,2,2023,2),(2,3,2024,1),(2,4,2024,2),(2,5,2025,1),
-- Usuario 3
(3,1,2022,2),(3,2,2023,1),(3,3,2023,2),(3,4,2024,1),(3,5,2024,2),(3,6,2025,1),
-- Usuario 4
(4,1,2023,2),(4,2,2024,1),(4,3,2024,2),(4,4,2025,1),(4,5,2025,2),
-- Usuario 5
(5,1,2023,1),(5,2,2023,2),(5,3,2024,1),(5,4,2024,2),(5,5,2025,1),(5,6,2025,2),
-- Usuario 6
(6,1,2022,1),(6,2,2022,2),(6,3,2023,1),(6,4,2023,2),(6,5,2024,1),(6,6,2024,2),(6,7,2025,1),
-- Usuario 7
(7,1,2024,1),(7,2,2024,2),(7,3,2025,1),
-- Usuario 8
(8,1,2023,1),(8,2,2023,2),(8,3,2024,1),(8,4,2024,2),
-- Usuario 9
(9,1,2022,2),(9,2,2023,1),(9,3,2023,2),(9,4,2024,1),(9,5,2024,2),(9,6,2025,1),(9,7,2025,2),
-- Usuario 10
(10,1,2024,2),(10,2,2025,1),(10,3,2025,2),
-- Usuario 11
(11,1,2023,1),(11,2,2023,2),(11,3,2024,1),(11,4,2024,2),(11,5,2025,1),
-- Usuario 12
(12,1,2022,1),(12,2,2022,2),(12,3,2023,1),(12,4,2023,2),(12,5,2024,1),(12,6,2024,2),
-- Usuario 13
(13,1,2024,1),(13,2,2024,2),(13,3,2025,1),(13,4,2025,2),
-- Usuario 14
(14,1,2023,2),(14,2,2024,1),(14,3,2024,2),(14,4,2025,1),(14,5,2025,2),
-- Usuario 15
(15,1,2023,1),(15,2,2023,2),(15,3,2024,1),(15,4,2024,2),(15,5,2025,1),(15,6,2025,2),(15,7,2026,1),
-- Usuario 16
(16,1,2024,1),(16,2,2024,2),(16,3,2025,1),
-- Usuario 17
(17,1,2022,2),(17,2,2023,1),(17,3,2023,2),(17,4,2024,1),(17,5,2024,2),(17,6,2025,1),
-- Usuario 18
(18,1,2023,1),(18,2,2023,2),(18,3,2024,1),(18,4,2024,2),
-- Usuario 19
(19,1,2024,2),(19,2,2025,1),(19,3,2025,2),(19,4,2026,1),
-- Usuario 20
(20,1,2023,1),(20,2,2023,2),(20,3,2024,1),(20,4,2024,2),(20,5,2025,1);

INSERT INTO semestre (semestre_usuario_id, semestre_numero, semestre_year, semestre_periodo) VALUES
-- Usuarios 21-40 (UNIANDES)
(21,1,2023,1),(21,2,2023,2),(21,3,2024,1),(21,4,2024,2),(21,5,2025,1),
(22,1,2024,1),(22,2,2024,2),(22,3,2025,1),(22,4,2025,2),
(23,1,2022,2),(23,2,2023,1),(23,3,2023,2),(23,4,2024,1),(23,5,2024,2),(23,6,2025,1),(23,7,2025,2),
(24,1,2023,2),(24,2,2024,1),(24,3,2024,2),(24,4,2025,1),
(25,1,2024,1),(25,2,2024,2),(25,3,2025,1),(25,4,2025,2),(25,5,2026,1),
(26,1,2023,1),(26,2,2023,2),(26,3,2024,1),(26,4,2024,2),(26,5,2025,1),(26,6,2025,2),
(27,1,2022,1),(27,2,2022,2),(27,3,2023,1),(27,4,2023,2),(27,5,2024,1),(27,6,2024,2),(27,7,2025,1),
(28,1,2024,2),(28,2,2025,1),(28,3,2025,2),
(29,1,2023,1),(29,2,2023,2),(29,3,2024,1),(29,4,2024,2),
(30,1,2024,1),(30,2,2024,2),(30,3,2025,1),(30,4,2025,2),(30,5,2026,1),
-- Usuarios 31-40 (Rosario)
(31,1,2023,2),(31,2,2024,1),(31,3,2024,2),(31,4,2025,1),(31,5,2025,2),
(32,1,2024,1),(32,2,2024,2),(32,3,2025,1),
(33,1,2022,2),(33,2,2023,1),(33,3,2023,2),(33,4,2024,1),(33,5,2024,2),(33,6,2025,1),
(34,1,2023,1),(34,2,2023,2),(34,3,2024,1),(34,4,2024,2),(34,5,2025,1),(34,6,2025,2),(34,7,2026,1),
(35,1,2024,2),(35,2,2025,1),(35,3,2025,2),(35,4,2026,1),
(36,1,2023,1),(36,2,2023,2),(36,3,2024,1),(36,4,2024,2),
(37,1,2022,1),(37,2,2022,2),(37,3,2023,1),(37,4,2023,2),(37,5,2024,1),(37,6,2024,2),
(38,1,2024,1),(38,2,2024,2),(38,3,2025,1),(38,4,2025,2),
(39,1,2023,2),(39,2,2024,1),(39,3,2024,2),(39,4,2025,1),(39,5,2025,2),
(40,1,2024,1),(40,2,2024,2),(40,3,2025,1);

INSERT INTO semestre (semestre_usuario_id, semestre_numero, semestre_year, semestre_periodo) VALUES
-- Usuarios 41-60 (Javeriana + EAFIT)
(41,1,2023,1),(41,2,2023,2),(41,3,2024,1),(41,4,2024,2),(41,5,2025,1),(41,6,2025,2),
(42,1,2024,1),(42,2,2024,2),(42,3,2025,1),(42,4,2025,2),(42,5,2026,1),
(43,1,2022,2),(43,2,2023,1),(43,3,2023,2),(43,4,2024,1),(43,5,2024,2),
(44,1,2023,2),(44,2,2024,1),(44,3,2024,2),(44,4,2025,1),
(45,1,2024,1),(45,2,2024,2),(45,3,2025,1),(45,4,2025,2),
(46,1,2023,1),(46,2,2023,2),(46,3,2024,1),(46,4,2024,2),(46,5,2025,1),(46,6,2025,2),(46,7,2026,1),
(47,1,2022,1),(47,2,2022,2),(47,3,2023,1),(47,4,2023,2),(47,5,2024,1),
(48,1,2024,2),(48,2,2025,1),(48,3,2025,2),
(49,1,2023,1),(49,2,2023,2),(49,3,2024,1),(49,4,2024,2),(49,5,2025,1),
(50,1,2024,1),(50,2,2024,2),(50,3,2025,1),(50,4,2025,2),
(51,1,2023,2),(51,2,2024,1),(51,3,2024,2),(51,4,2025,1),(51,5,2025,2),
(52,1,2024,1),(52,2,2024,2),(52,3,2025,1),
(53,1,2022,2),(53,2,2023,1),(53,3,2023,2),(53,4,2024,1),(53,5,2024,2),(53,6,2025,1),(53,7,2025,2),
(54,1,2023,1),(54,2,2023,2),(54,3,2024,1),(54,4,2024,2),
(55,1,2024,1),(55,2,2024,2),(55,3,2025,1),(55,4,2025,2),(55,5,2026,1),
(56,1,2023,1),(56,2,2023,2),(56,3,2024,1),(56,4,2024,2),(56,5,2025,1),
(57,1,2022,1),(57,2,2022,2),(57,3,2023,1),(57,4,2023,2),(57,5,2024,1),(57,6,2024,2),
(58,1,2024,2),(58,2,2025,1),(58,3,2025,2),(58,4,2026,1),
(59,1,2023,1),(59,2,2023,2),(59,3,2024,1),(59,4,2024,2),(59,5,2025,1),(59,6,2025,2),
(60,1,2024,1),(60,2,2024,2),(60,3,2025,1);

INSERT INTO semestre (semestre_usuario_id, semestre_numero, semestre_year, semestre_periodo) VALUES
-- Usuarios 61-80 (UDEA + UNIVALLE)
(61,1,2023,1),(61,2,2023,2),(61,3,2024,1),(61,4,2024,2),(61,5,2025,1),
(62,1,2024,1),(62,2,2024,2),(62,3,2025,1),(62,4,2025,2),
(63,1,2022,2),(63,2,2023,1),(63,3,2023,2),(63,4,2024,1),(63,5,2024,2),(63,6,2025,1),
(64,1,2023,2),(64,2,2024,1),(64,3,2024,2),(64,4,2025,1),(64,5,2025,2),
(65,1,2024,1),(65,2,2024,2),(65,3,2025,1),
(66,1,2023,1),(66,2,2023,2),(66,3,2024,1),(66,4,2024,2),(66,5,2025,1),(66,6,2025,2),(66,7,2026,1),
(67,1,2022,1),(67,2,2022,2),(67,3,2023,1),(67,4,2023,2),(67,5,2024,1),
(68,1,2024,2),(68,2,2025,1),(68,3,2025,2),
(69,1,2023,1),(69,2,2023,2),(69,3,2024,1),(69,4,2024,2),(69,5,2025,1),
(70,1,2024,1),(70,2,2024,2),(70,3,2025,1),(70,4,2025,2),(70,5,2026,1),
(71,1,2023,2),(71,2,2024,1),(71,3,2024,2),(71,4,2025,1),(71,5,2025,2),
(72,1,2024,1),(72,2,2024,2),(72,3,2025,1),
(73,1,2022,2),(73,2,2023,1),(73,3,2023,2),(73,4,2024,1),(73,5,2024,2),(73,6,2025,1),(73,7,2025,2),
(74,1,2023,1),(74,2,2023,2),(74,3,2024,1),(74,4,2024,2),
(75,1,2024,1),(75,2,2024,2),(75,3,2025,1),(75,4,2025,2),
(76,1,2023,1),(76,2,2023,2),(76,3,2024,1),(76,4,2024,2),(76,5,2025,1),(76,6,2025,2),
(77,1,2022,1),(77,2,2022,2),(77,3,2023,1),(77,4,2023,2),(77,5,2024,1),(77,6,2024,2),
(78,1,2024,2),(78,2,2025,1),(78,3,2025,2),(78,4,2026,1),
(79,1,2023,1),(79,2,2023,2),(79,3,2024,1),(79,4,2024,2),(79,5,2025,1),
(80,1,2024,1),(80,2,2024,2),(80,3,2025,1);

-- ============================================================
-- 8. TRANSACCIONAL: INSCRIPCIONES, COMPONENTES Y NOTAS
-- Genera materia_usuario, componente y nota a partir de los
-- semestres ya insertados. Se usa un procedimiento temporal
-- (se crea, se ejecuta con CALL y se elimina) porque MySQL no
-- permite bloques anonimos con cursores fuera de una rutina.
--
-- Volumetria esperada: ~390 semestres x 4-6 materias
-- => ~1900 materia_usuario, ~5700 componente, +8000 nota.
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_poblar_transaccional()
BEGIN
    DECLARE v_done            TINYINT DEFAULT FALSE;
    DECLARE v_semestre_id     INT UNSIGNED;
    DECLARE v_usuario_id      INT UNSIGNED;
    DECLARE v_programa_id     INT UNSIGNED;
    DECLARE v_semestre_numero TINYINT UNSIGNED;
    DECLARE v_year            YEAR;
    DECLARE v_periodo         TINYINT;
    DECLARE v_max_numero      TINYINT UNSIGNED;
    DECLARE v_es_actual       TINYINT;
    DECLARE v_num_materias    INT;
    DECLARE v_fecha_inicio    DATE;

    DECLARE cur_sem CURSOR FOR
        SELECT s.semestre_id, s.semestre_usuario_id, u.usuario_programa_id,
               s.semestre_numero, s.semestre_year, s.semestre_periodo
        FROM   semestre AS s
        INNER JOIN usuario AS u ON u.usuario_id = s.semestre_usuario_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    OPEN cur_sem;

    loop_sem: LOOP
        FETCH cur_sem INTO v_semestre_id, v_usuario_id, v_programa_id,
                           v_semestre_numero, v_year, v_periodo;
        IF v_done THEN
            LEAVE loop_sem;
        END IF;

        SELECT MAX(semestre_numero) INTO v_max_numero
        FROM   semestre WHERE semestre_usuario_id = v_usuario_id;

        SET v_es_actual    = IF(v_semestre_numero = v_max_numero, 1, 0);
        SET v_num_materias = 4 + FLOOR(RAND() * 3);
        SET v_fecha_inicio = IF(v_periodo = 1,
                                 CONCAT(v_year, '-02-01'),
                                 CONCAT(v_year, '-08-01'));

        -- Inscribir materias del programa del estudiante que aun no ha cursado
        INSERT INTO materia_usuario
            (materia_usuario_materia_id, materia_usuario_semestre_id, materia_usuario_estado)
        SELECT m.materia_id, v_semestre_id, 'en_curso'
        FROM   materia AS m
        INNER JOIN tipologia AS t ON t.tipologia_id = m.materia_tipologia_id
        WHERE  t.tipologia_programa_id = v_programa_id
          AND  NOT EXISTS (
                   SELECT 1
                   FROM   materia_usuario AS mu2
                   INNER JOIN semestre AS s2
                       ON s2.semestre_id = mu2.materia_usuario_semestre_id
                   WHERE  s2.semestre_usuario_id = v_usuario_id
                     AND  mu2.materia_usuario_materia_id = m.materia_id
               )
        ORDER BY RAND()
        LIMIT 20;
        -- Nota: LIMIT fijo amplio; el numero real de filas insertadas
        -- puede ser menor si el programa no tiene tantas materias libres.

        -- Recorrer las materia_usuario recien creadas de este semestre
        BEGIN
            DECLARE v_done2       TINYINT DEFAULT FALSE;
            DECLARE v_mu_id       INT UNSIGNED;
            DECLARE v_nota_minima DECIMAL(3,1);
            DECLARE v_target      DECIMAL(4,2);
            DECLARE v_estado_fin  VARCHAR(20);

            DECLARE cur_mu CURSOR FOR
                SELECT mu.materia_usuario_id, m.materia_nota_minima_aprobacion
                FROM   materia_usuario AS mu
                INNER JOIN materia AS m ON m.materia_id = mu.materia_usuario_materia_id
                WHERE  mu.materia_usuario_semestre_id = v_semestre_id;

            DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done2 = TRUE;

            OPEN cur_mu;

            loop_mu: LOOP
                FETCH cur_mu INTO v_mu_id, v_nota_minima;
                IF v_done2 THEN
                    LEAVE loop_mu;
                END IF;

                IF v_es_actual THEN
                    SET v_estado_fin = 'en_curso';
                    SET v_target     = NULL;
                ELSEIF RAND() < 0.82 THEN
                    SET v_estado_fin = 'aprobada';
                    SET v_target     = LEAST(5.0, v_nota_minima + RAND() * (5.0 - v_nota_minima));
                ELSE
                    SET v_estado_fin = 'reprobada';
                    SET v_target     = GREATEST(0.5, RAND() * GREATEST(v_nota_minima - 0.2, 0.5));
                END IF;

                -- 3 componentes fijos que suman 100
                INSERT INTO componente
                    (componente_materia_usuario_id, componente_nombre,
                     componente_porcentaje, componente_nota_minima, componente_orden)
                VALUES
                    (v_mu_id, 'Parcial 1',      30.00, NULL, 1),
                    (v_mu_id, 'Parcial 2',      30.00, NULL, 2),
                    (v_mu_id, 'Proyecto Final', 40.00, NULL, 3);

                IF NOT v_es_actual THEN
                    -- Materia cerrada: una nota por componente alrededor del target
                    INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro)
                    SELECT c.componente_id, 'Calificacion final',
                           ROUND(LEAST(5.0, GREATEST(0.0, v_target + (RAND() - 0.5) * 0.8)), 1),
                           DATE_ADD(v_fecha_inicio, INTERVAL FLOOR(RAND() * 110) DAY)
                    FROM   componente AS c
                    WHERE  c.componente_materia_usuario_id = v_mu_id;

                    -- ~30% de los componentes reciben una segunda entrega
                    -- (demuestra la relacion 1:N componente -> nota)
                    INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro)
                    SELECT c.componente_id, 'Entrega adicional',
                           ROUND(LEAST(5.0, GREATEST(0.0, v_target + (RAND() - 0.5) * 0.8)), 1),
                           DATE_ADD(v_fecha_inicio, INTERVAL FLOOR(RAND() * 110) DAY)
                    FROM   componente AS c
                    WHERE  c.componente_materia_usuario_id = v_mu_id
                      AND  RAND() < 0.3;

                    UPDATE materia_usuario
                    SET    materia_usuario_estado = v_estado_fin
                    WHERE  materia_usuario_id = v_mu_id;
                ELSE
                    -- Semestre en curso: solo el primer componente tiene
                    -- una nota parcial (evaluacion incompleta, caso realista)
                    INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro)
                    SELECT c.componente_id, 'Parcial 1 - corte',
                           ROUND(2.5 + RAND() * 2.5, 1),
                           CURRENT_DATE()
                    FROM   componente AS c
                    WHERE  c.componente_materia_usuario_id = v_mu_id
                      AND  c.componente_orden = 1;
                END IF;

            END LOOP loop_mu;

            CLOSE cur_mu;
        END;

    END LOOP loop_sem;

    CLOSE cur_sem;
END$$

DELIMITER ;

CALL sp_poblar_transaccional();
DROP PROCEDURE sp_poblar_transaccional;

-- ============================================================
-- CASOS LIMITE EXPLICITOS (para la sustentacion / demo de triggers)
-- Se insertan sobre el usuario 1 usando su primer semestre.
-- ============================================================

-- Nota: los 3 componentes (30/30/40) generados arriba ya cubren el caso
-- limite de "porcentaje acumulado = 100 exacto" en TODAS las materias.
-- Aqui agregamos explicitamente los limites de escala de nota (0.0 y 5.0)
-- sobre el usuario 1, para poder mostrarlos en la sustentacion.

-- Caso limite: nota en el limite inferior de la escala (0.0)
INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro)
SELECT c.componente_id, 'Caso limite - nota minima', 0.0, '2024-03-15'
FROM   componente AS c
INNER JOIN materia_usuario AS mu ON mu.materia_usuario_id = c.componente_materia_usuario_id
INNER JOIN semestre AS s ON s.semestre_id = mu.materia_usuario_semestre_id
WHERE  s.semestre_usuario_id = 1
ORDER BY c.componente_id
LIMIT 1;

-- Caso limite: nota en el limite superior de la escala (5.0)
INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro)
SELECT c.componente_id, 'Caso limite - nota maxima', 5.0, '2024-05-30'
FROM   componente AS c
INNER JOIN materia_usuario AS mu ON mu.materia_usuario_id = c.componente_materia_usuario_id
INNER JOIN semestre AS s ON s.semestre_id = mu.materia_usuario_semestre_id
WHERE  s.semestre_usuario_id = 1
ORDER BY c.componente_id DESC
LIMIT 1;