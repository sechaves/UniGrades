-- ============================================================
-- UNIGRADES - 13_fix_nombres.sql
-- Corrige nombres de materias con tildes corruptas
-- y reinsertar prerrequisitos de ISIS
-- EJECUTAR: mysql --default-character-set=utf8mb4 -u root -p$MYSQLPASSWORD unigrades < script
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
USE unigrades;

-- ============================================================
-- PASO 1: Corregir nombres de materias (ISIS - programa_id=16)
-- ============================================================
UPDATE materia SET materia_nombre = 'Introducción a la Ingeniería de Sistemas y Computación' WHERE materia_codigo = '2025975';
UPDATE materia SET materia_nombre = 'Programación de Computadores'               WHERE materia_codigo = '2015734';
UPDATE materia SET materia_nombre = 'Pensamiento Sistémico'                       WHERE materia_codigo = '2016703';
UPDATE materia SET materia_nombre = 'Programación Orientada a Objetos'            WHERE materia_codigo = '2016375';
UPDATE materia SET materia_nombre = 'Álgebra Lineal'                              WHERE materia_codigo = '1000003-B';
UPDATE materia SET materia_nombre = 'Cálculo Diferencial'                         WHERE materia_codigo = '1000004-B';
UPDATE materia SET materia_nombre = 'Cálculo Integral'                            WHERE materia_codigo = '1000005-B';
UPDATE materia SET materia_nombre = 'Cálculo en Varias Variables'                 WHERE materia_codigo = '1000006-B';
UPDATE materia SET materia_nombre = 'Estructuras de Datos'                        WHERE materia_codigo = '2016699';
UPDATE materia SET materia_nombre = 'Algoritmos'                                  WHERE materia_codigo = '2016696';
UPDATE materia SET materia_nombre = 'Introducción a la Teoría de la Computación'  WHERE materia_codigo = '2015174';
UPDATE materia SET materia_nombre = 'Matemáticas Discretas I'                     WHERE materia_codigo = '2025963';
UPDATE materia SET materia_nombre = 'Matemáticas Discretas II'                    WHERE materia_codigo = '2025964';
UPDATE materia SET materia_nombre = 'Probabilidad y Estadística Fundamental'      WHERE materia_codigo = '1000013-B';
UPDATE materia SET materia_nombre = 'Ingeniería Económica'                        WHERE materia_codigo = '2015703';
UPDATE materia SET materia_nombre = 'Gerencia y Gestión de Proyectos'             WHERE materia_codigo = '2015702';
UPDATE materia SET materia_nombre = 'Sistemas Operativos'                         WHERE materia_codigo = '2016707';
UPDATE materia SET materia_nombre = 'Arquitectura de Computadores'                WHERE materia_codigo = '2016697';
UPDATE materia SET materia_nombre = 'Redes de Computadores'                       WHERE materia_codigo = '2025967';
UPDATE materia SET materia_nombre = 'Ingeniería de Software I'                    WHERE materia_codigo = '2016701';
UPDATE materia SET materia_nombre = 'Ingeniería de Software II'                   WHERE materia_codigo = '2016702';
UPDATE materia SET materia_nombre = 'Lenguajes de Programación'                   WHERE materia_codigo = '2025966';
UPDATE materia SET materia_nombre = 'Introducción a los Sistemas Inteligentes'    WHERE materia_codigo = '2025995';
UPDATE materia SET materia_nombre = 'Sistemas de Información'                     WHERE materia_codigo = '2025982';
UPDATE materia SET materia_nombre = 'Métodos Numéricos'                           WHERE materia_codigo = '2015970';
UPDATE materia SET materia_nombre = 'Optimización'                                WHERE materia_codigo = '2025971';
UPDATE materia SET materia_nombre = 'Arquitectura de Infraestructura y Gobierno de TICs' WHERE materia_codigo = '2025983';
UPDATE materia SET materia_nombre = 'Teoría de la Información y Sistemas de Comunicación' WHERE materia_codigo = '2025994';
UPDATE materia SET materia_nombre = 'Modelos Estocásticos y Simulación en Cómputo y Comun.' WHERE materia_codigo = '2025969';
UPDATE materia SET materia_nombre = 'Arquitectura de Software'                    WHERE materia_codigo = '2016716';
UPDATE materia SET materia_nombre = 'Computación Paralela y Distribuida'          WHERE materia_codigo = '2016722';
UPDATE materia SET materia_nombre = 'Introducción a la Criptografía y Seguridad'  WHERE materia_codigo = '2025972';
UPDATE materia SET materia_nombre = 'Computación Visual'                          WHERE materia_codigo = '2025960';
UPDATE materia SET materia_nombre = 'Taller de Proyectos Interdisciplinarios'     WHERE materia_codigo = '2024045';
UPDATE materia SET materia_nombre = 'Fundamentación Obligatoria'                  WHERE materia_codigo = '1000019-B';
UPDATE materia SET materia_nombre = 'Fundamentos de Electricidad y Magnetismo'    WHERE materia_codigo = '1000017-B';

-- ============================================================
-- PASO 2: Corregir nombres de materias (CC - programa_id=1)
-- ============================================================
UPDATE materia SET materia_nombre = 'Fundamentos de Matemáticas'                  WHERE materia_codigo = '2015168';
UPDATE materia SET materia_nombre = 'Sistemas Numéricos'                          WHERE materia_codigo = '2015181';
UPDATE materia SET materia_nombre = 'Introducción a la Teoría de Conjuntos'       WHERE materia_codigo = '2025819';
UPDATE materia SET materia_nombre = 'Álgebra Lineal Básica'                       WHERE materia_codigo = '2015555';
UPDATE materia SET materia_nombre = 'Cálculo Diferencial en una Variable'         WHERE materia_codigo = '2016377';
UPDATE materia SET materia_nombre = 'Cálculo Integral en una Variable'            WHERE materia_codigo = '2015556';
UPDATE materia SET materia_nombre = 'Cálculo Vectorial'                           WHERE materia_codigo = '2015162';
UPDATE materia SET materia_nombre = 'Cálculo de Ecuaciones Diferenciales Ordinarias' WHERE materia_codigo = '2016342';
UPDATE materia SET materia_nombre = 'Introducción al Análisis Real'               WHERE materia_codigo = '2015155';
UPDATE materia SET materia_nombre = 'Introducción a las CC y a la Programación'   WHERE materia_codigo = '2026573';
UPDATE materia SET materia_nombre = 'Álgebra Abstracta y Computacional'           WHERE materia_codigo = '2026555';
UPDATE materia SET materia_nombre = 'Introducción al Análisis Combinatorio'       WHERE materia_codigo = '2027312';
UPDATE materia SET materia_nombre = 'Análisis Numérico I'                         WHERE materia_codigo = '2019072';
UPDATE materia SET materia_nombre = 'Introducción a la Optimización'              WHERE materia_codigo = '2015173';
UPDATE materia SET materia_nombre = 'Introducción a la Biología Computacional'    WHERE materia_codigo = '2025196';
UPDATE materia SET materia_nombre = 'Introducción a la Inteligencia Artificial'   WHERE materia_codigo = '2027631';
UPDATE materia SET materia_nombre = 'Teoría de Codificación'                      WHERE materia_codigo = '2027313';
UPDATE materia SET materia_nombre = 'Introducción a la Criptografía y Teoría de Información' WHERE materia_codigo = '2027311';
UPDATE materia SET materia_nombre = 'Teoría de Lenguajes Formales'                WHERE materia_codigo = '2027628';
UPDATE materia SET materia_nombre = 'Lógica Computacional'                        WHERE materia_codigo = '2027629';
UPDATE materia SET materia_nombre = 'Matemáticas del Aprendizaje de Máquinas'     WHERE materia_codigo = '2028837';
UPDATE materia SET materia_nombre = 'Redes Neuronales, Arquitecturas y Aplicaciones' WHERE materia_codigo = '2029090';
UPDATE materia SET materia_nombre = 'Fundamentos de Analítica de Datos y Aplicaciones' WHERE materia_codigo = '2028839';
UPDATE materia SET materia_nombre = 'Álgebra Lineal Numérica'                     WHERE materia_codigo = '2028836';
UPDATE materia SET materia_nombre = 'Ecuaciones en Diferencias Finitas y Sistemas Dinámicos' WHERE materia_codigo = '2026519';
UPDATE materia SET materia_nombre = 'Mecánica Newtoniana'                         WHERE materia_codigo = '2015176';
UPDATE materia SET materia_nombre = 'Grupos y Anillos'                            WHERE materia_codigo = '2015152';
UPDATE materia SET materia_nombre = 'Teoría de Grafos'                            WHERE materia_codigo = '2015184';

-- ============================================================
-- PASO 3: Corregir nombres de tipologías
-- ============================================================
UPDATE tipologia SET tipologia_nombre = 'Fundamentación Obligatoria'               WHERE tipologia_nombre LIKE '%undamentaci%';
UPDATE tipologia SET tipologia_nombre = 'Disciplinar Obligatoria'                  WHERE tipologia_nombre LIKE '%Disciplinar Oblig%';
UPDATE tipologia SET tipologia_nombre = 'Disciplinar Optativa'                     WHERE tipologia_nombre LIKE '%Disciplinar Optat%';
UPDATE tipologia SET tipologia_nombre = 'Nivelación'                               WHERE tipologia_nombre LIKE '%Nive%';
UPDATE tipologia SET tipologia_nombre = 'Matemáticas y Estructuras Discretas'      WHERE tipologia_nombre LIKE '%tem%ticas y%';
UPDATE tipologia SET tipologia_nombre = 'Programación y Estructuras de Datos'      WHERE tipologia_nombre LIKE '%rogramaci%n y Estruct%';
UPDATE tipologia SET tipologia_nombre = 'Algoritmos y Teoría de la Computación'    WHERE tipologia_nombre LIKE '%lgoritmos y%';
UPDATE tipologia SET tipologia_nombre = 'Seguridad Informática y Codificación'     WHERE tipologia_nombre LIKE '%eguridad%';
UPDATE tipologia SET tipologia_nombre = 'Sistemas Operativos, Cómputo y Compiladores' WHERE tipologia_nombre LIKE '%istemas Operat%';
UPDATE tipologia SET tipologia_nombre = 'Computación Científica'                   WHERE tipologia_nombre LIKE '%omputaci%n Cient%';
UPDATE tipologia SET tipologia_nombre = 'Computación Aplicada'                     WHERE tipologia_nombre LIKE '%omputaci%n Aplic%';
UPDATE tipologia SET tipologia_nombre = 'Ciencias Naturales y Estadística'         WHERE tipologia_nombre LIKE '%Ciencias Nat%';

-- ============================================================
-- PASO 4: Reinsertar prerrequisitos de ISIS (programa_id=16)
-- Usando códigos de materia para encontrar los IDs actuales
-- ============================================================
INSERT IGNORE INTO materia_prerrequisito (materia_id, prerrequisito_materia_id)
SELECT m.materia_id, p.materia_id
FROM materia m, materia p
WHERE (m.materia_codigo = '2016699' AND p.materia_codigo = '2016375')  -- Estructuras de Datos -> POO
   OR (m.materia_codigo = '2016696' AND p.materia_codigo = '2016699')  -- Algoritmos -> Estructuras
   OR (m.materia_codigo = '2015174' AND p.materia_codigo = '2016699')  -- T.Computacion -> Estructuras
   OR (m.materia_codigo = '2025963' AND p.materia_codigo = '2015734')  -- Discretas I -> Programacion
   OR (m.materia_codigo = '2016697' AND p.materia_codigo = '2016698')  -- Arq.Comp -> Elem.Comp
   OR (m.materia_codigo = '2016707' AND p.materia_codigo = '2016697')  -- SO -> Arq.Comp
   OR (m.materia_codigo = '2025967' AND p.materia_codigo = '2016698')  -- Redes -> Elem.Comp
   OR (m.materia_codigo = '2016701' AND p.materia_codigo = '2016699')  -- IS I -> Estructuras
   OR (m.materia_codigo = '2016702' AND p.materia_codigo = '2016701')  -- IS II -> IS I
   OR (m.materia_codigo = '2025966' AND p.materia_codigo = '2015174'); -- Lenguajes -> T.Comp

-- ============================================================
-- VERIFICACIÓN
-- ============================================================
SELECT materia_nombre FROM materia
WHERE materia_nombre LIKE '%lculo%'
   OR materia_nombre LIKE '%stem%'
   OR materia_nombre LIKE '%rogramaci%'
LIMIT 8;

SELECT COUNT(*) as prereqs_validos FROM materia_prerrequisito mp
WHERE EXISTS (SELECT 1 FROM materia m WHERE m.materia_id = mp.materia_id)
  AND EXISTS (SELECT 1 FROM materia m WHERE m.materia_id = mp.prerrequisito_materia_id);
