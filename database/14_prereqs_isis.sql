-- ============================================================
-- UNIGRADES - 14_prereqs_isis.sql
-- Prerrequisitos reales de Ingeniería de Sistemas y Computación
-- EJECUTAR: mysql --default-character-set=utf8mb4 -u root -p$MYSQLPASSWORD unigrades < script
-- ============================================================

SET NAMES utf8mb4;
USE unigrades;

-- Limpiar prerrequisitos anteriores de ISIS
DELETE FROM materia_prerrequisito
WHERE materia_id IN (
    SELECT m.materia_id FROM materia m
    JOIN tipologia t ON t.tipologia_id = m.materia_tipologia_id
    WHERE t.tipologia_programa_id = 16
);

-- Insertar prerrequisitos correctos usando códigos de materia
INSERT IGNORE INTO materia_prerrequisito (materia_id, prerrequisito_materia_id)
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '1000005-B' AND p.materia_codigo = '1000004-B'  -- Cálculo Integral -> Cálculo Diferencial
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '1000006-B' AND p.materia_codigo = '1000005-B'  -- Cálculo en Varias Variables -> Cálculo Integral
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '1000003-B' AND p.materia_codigo = '1000004-B'  -- Álgebra Lineal -> Cálculo Diferencial
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '1000019-B' AND p.materia_codigo = '1000004-B'  -- Fundamentos de Mecánica -> Cálculo Diferencial
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2016375' AND p.materia_codigo = '2015734'      -- POO -> Programación de Computadores
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2016698' AND p.materia_codigo = '2025975'      -- Elementos de Comp -> Intro ISIS
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2016353' AND p.materia_codigo = '2016375'      -- Bases de Datos -> POO
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2015703' AND p.materia_codigo = '1000005-B'    -- Ingeniería Económica -> Cálculo Integral
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '1000013-B' AND p.materia_codigo = '1000005-B' -- Prob. y Estadística -> Cálculo Integral
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '1000017-B' AND p.materia_codigo = '1000005-B' -- Fundamentos E&M -> Cálculo Integral
UNION ALL
-- Ingeniería de Software I -> Pensamiento Sistémico
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2016701' AND p.materia_codigo = '2016703'
UNION ALL
-- Ingeniería de Software I -> Bases de Datos
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2016701' AND p.materia_codigo = '2016353'
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2025963' AND p.materia_codigo = '1000003-B'   -- Matemáticas Discretas I -> Álgebra Lineal
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2025964' AND p.materia_codigo = '2025963'     -- Matemáticas Discretas II -> Discretas I
UNION ALL
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2016697' AND p.materia_codigo = '2016698'     -- Arq. Computadores -> Elementos de Comp
UNION ALL
-- Redes de Computadores -> Matemáticas Discretas II
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2025967' AND p.materia_codigo = '2025964'
UNION ALL
-- Redes de Computadores -> Fundamentos E&M
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2025967' AND p.materia_codigo = '1000017-B'
UNION ALL
-- Redes de Computadores -> Estructuras de Datos
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2025967' AND p.materia_codigo = '2016699'
UNION ALL
-- Redes de Computadores -> Arquitectura de Computadores
SELECT m.materia_id, p.materia_id FROM materia m JOIN materia p ON 1=1
WHERE m.materia_codigo = '2025967' AND p.materia_codigo = '2016697';

-- ============================================================
-- VERIFICACIÓN
-- ============================================================
SELECT m.materia_nombre AS materia, p.materia_nombre AS prerrequisito
FROM materia_prerrequisito mp
JOIN materia m ON m.materia_id = mp.materia_id
JOIN materia p ON p.materia_id = mp.prerrequisito_materia_id
JOIN tipologia t ON t.tipologia_id = m.materia_tipologia_id
WHERE t.tipologia_programa_id = 16
ORDER BY m.materia_nombre;
