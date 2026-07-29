-- ============================================================
-- UNIGRADES - 05_seeding.sql
-- Script de Inflado Masivo de Datos (Data Seeding)
-- SGBD Objetivo: MySQL 8.0+
-- ============================================================

USE unigrades;

SET SESSION wait_timeout            = 28800;
SET SESSION interactive_timeout     = 28800;
SET SESSION net_read_timeout        = 3600;
SET SESSION net_write_timeout       = 3600;
SET SESSION cte_max_recursion_depth = 150000;

-- ------------------------------------------------------------
-- LIMPIEZA PREVIA
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE nota;
TRUNCATE TABLE componente;
TRUNCATE TABLE materia_usuario;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- TABLAS TEMPORALES CON IDs REALES INDEXADOS POR POSICION
-- ------------------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS tmp_sem;
CREATE TEMPORARY TABLE tmp_sem (
    pos SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    sid INT UNSIGNED NOT NULL
);
INSERT INTO tmp_sem (sid)
    SELECT semestre_id FROM semestre ORDER BY semestre_id;

DROP TEMPORARY TABLE IF EXISTS tmp_mat;
CREATE TEMPORARY TABLE tmp_mat (
    pos SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    mid INT UNSIGNED NOT NULL
);
INSERT INTO tmp_mat (mid)
    SELECT materia_id FROM materia ORDER BY materia_id;

-- ------------------------------------------------------------
-- Materializar los totales en variables de sesion ANTES del
-- INSERT principal. Esto evita el Error 1137 (Can't reopen
-- table) que ocurre cuando una tabla temporal se referencia
-- mas de una vez en la misma sentencia.
-- ------------------------------------------------------------
SELECT COUNT(*) INTO @total_sem FROM tmp_sem;
SELECT COUNT(*) INTO @total_mat FROM tmp_mat;

-- Validacion
SELECT IF(@total_sem = 0, 'ERROR: semestre vacia', CONCAT('OK: ', @total_sem, ' semestres')) AS check_sem;
SELECT IF(@total_mat = 0, 'ERROR: materia vacia',  CONCAT('OK: ', @total_mat, ' materias'))  AS check_mat;

-- ------------------------------------------------------------
-- 1. MATERIA_USUARIO — 10,000 inscripciones ficticias
--
-- Se usa aritmetica modular con primos para distribuir los IDs
-- de forma uniforme sin RAND() (que causaba NULLs en CTEs).
-- INSERT IGNORE descarta duplicados de la constraint unica
-- (materia_usuario_materia_id, materia_usuario_semestre_id).
-- Los totales vienen de variables @, no de subqueries sobre
-- la tabla temporal, evitando el Error 1137.
-- ------------------------------------------------------------
INSERT IGNORE INTO materia_usuario
    (materia_usuario_semestre_id, materia_usuario_materia_id, materia_usuario_estado)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 10000
)
SELECT
    ts.sid,
    tm.mid,
    ELT(1 + (n MOD 3), 'aprobada', 'reprobada', 'en_curso')
FROM seq
JOIN tmp_sem ts ON ts.pos = 1 + ((n * 1009) MOD @total_sem)
JOIN tmp_mat tm ON tm.pos = 1 + ((n * 1013) MOD @total_mat);

-- ------------------------------------------------------------
-- 2. COMPONENTE — 3 por cada materia_usuario
-- ------------------------------------------------------------
INSERT INTO componente
    (componente_materia_usuario_id, componente_nombre, componente_porcentaje, componente_orden)
SELECT
    mu.materia_usuario_id,
    comp.nombre,
    comp.porcentaje,
    comp.orden
FROM materia_usuario AS mu
CROSS JOIN (
    SELECT 'Parciales'            AS nombre, 35.00 AS porcentaje, 1 AS orden UNION ALL
    SELECT 'Proyectos y Talleres',            35.00,              2          UNION ALL
    SELECT 'Examen Final',                    30.00,              3
) AS comp;

-- ------------------------------------------------------------
-- 3. NOTA — 2 por cada componente
-- Valores deterministas pero distribuidos con aritmetica modular.
-- ------------------------------------------------------------
INSERT INTO nota
    (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro)
SELECT
    c.componente_id,
    ev.nombre,
    -- nota entre 1.0 y 5.0 con 1 decimal, variada por componente_id y evaluacion
    ROUND(1.0 + ((c.componente_id * 7 + ev.num * 13) MOD 40) / 10.0, 1),
    DATE_SUB(CURDATE(), INTERVAL ((c.componente_id * 3 + ev.num * 11) MOD 730) DAY)
FROM componente AS c
CROSS JOIN (
    SELECT 1 AS num, 'Evaluacion 1' AS nombre UNION ALL
    SELECT 2,        'Evaluacion 2'
) AS ev;

-- ------------------------------------------------------------
-- LIMPIEZA
-- ------------------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS tmp_sem;
DROP TEMPORARY TABLE IF EXISTS tmp_mat;

-- ------------------------------------------------------------
-- 4. Refrescar estadisticas del optimizador
-- ------------------------------------------------------------
ANALYZE TABLE materia_usuario;
ANALYZE TABLE componente;
ANALYZE TABLE nota;
