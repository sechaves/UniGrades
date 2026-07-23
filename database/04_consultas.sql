-- ============================================================
-- UNIGRADES - SESIÓN 3
-- Archivo: 04_consultas.sql
-- Batería de 15 consultas de complejidad creciente
-- SGBD objetivo: MySQL 8
--
-- Nota N6:
-- El archivo 01_ddl.sql ya contiene seis CREATE VIEW:
-- v_promedio_componente, v_nota_materia, v_promedio_semestre,
-- v_promedio_global, v_materias_aprobadas_usuario y
-- v_avance_tipologia. Las consultas N6 demuestran su reutilización.
-- ============================================================

USE unigrades;
SET NAMES utf8mb4;

-- ============================================================
-- N1-01: ¿Qué materias de 3 créditos, sugeridas entre los semestres
-- 2 y 5, contienen "Datos", "Software" o "Computación" en el nombre?
-- Incluye BETWEEN, LIKE, IN y condición compuesta.
-- ============================================================
SELECT
    materia_id,
    materia_codigo,
    materia_nombre,
    materia_creditos,
    materia_semestre_sugerido
FROM materia
WHERE materia_creditos IN (3, 4)
  AND materia_semestre_sugerido BETWEEN 2 AND 5
  AND (
      materia_nombre LIKE '%Datos%'
      OR materia_nombre LIKE '%Software%'
      OR materia_nombre LIKE '%Computación%'
  )
ORDER BY materia_semestre_sugerido, materia_nombre;

-- ============================================================
-- N1-02: ¿Qué notas aprobatorias fueron registradas entre marzo de
-- 2025 y julio de 2026 en evaluaciones parciales o proyectos?
-- Incluye filtro de fechas, rango, IN y LIKE.
-- ============================================================
SELECT
    nota_id,
    nota_nombre,
    nota_valor,
    nota_fecha_registro
FROM nota
WHERE nota_fecha_registro BETWEEN '2025-03-01' AND '2026-07-31'
  AND nota_valor BETWEEN 3.0 AND 5.0
  AND (
      nota_nombre LIKE '%parcial%'
      OR nota_nombre LIKE '%proyecto%'
  )
ORDER BY nota_fecha_registro DESC, nota_valor DESC;

-- ============================================================
-- N2-01: ¿Qué materias cursa cada estudiante y a qué programa,
-- universidad y período académico pertenecen?
-- INNER JOIN de seis tablas.
-- ============================================================
SELECT
    u.usuario_id,
    CONCAT(u.usuario_nombre, ' ', u.usuario_apellido) AS estudiante,
    un.universidad_sigla AS universidad,
    p.programa_nombre AS programa,
    s.semestre_year AS anio,
    s.semestre_periodo AS periodo,
    m.materia_codigo,
    m.materia_nombre,
    mu.materia_usuario_estado AS estado
FROM materia_usuario AS mu
INNER JOIN semestre AS s
    ON s.semestre_id = mu.materia_usuario_semestre_id
INNER JOIN usuario AS u
    ON u.usuario_id = s.semestre_usuario_id
INNER JOIN programa AS p
    ON p.programa_id = u.usuario_programa_id
INNER JOIN universidad AS un
    ON un.universidad_id = p.programa_universidad_id
INNER JOIN materia AS m
    ON m.materia_id = mu.materia_usuario_materia_id
ORDER BY u.usuario_id, s.semestre_year, s.semestre_periodo, m.materia_nombre;

-- ============================================================
-- N2-02: ¿Qué materias del catálogo nunca han sido cursadas?
-- LEFT JOIN es significativo porque conserva materias sin relación;
-- con INNER JOIN esas materias desaparecerían.
-- ============================================================
SELECT
    p.programa_nombre AS programa,
    m.materia_codigo,
    m.materia_nombre,
    COUNT(mu.materia_usuario_id) AS cantidad_intentos
FROM materia AS m
INNER JOIN tipologia AS t
    ON t.tipologia_id = m.materia_tipologia_id
INNER JOIN programa AS p
    ON p.programa_id = t.tipologia_programa_id
LEFT JOIN materia_usuario AS mu
    ON mu.materia_usuario_materia_id = m.materia_id
GROUP BY
    p.programa_id,
    p.programa_nombre,
    m.materia_id,
    m.materia_codigo,
    m.materia_nombre
HAVING COUNT(mu.materia_usuario_id) = 0
ORDER BY p.programa_nombre, m.materia_nombre;

-- ============================================================
-- N2-03: ¿Cuál es el detalle completo de cada calificación,
-- incluyendo estudiante, materia, componente y período?
-- INNER JOIN de siete tablas.
-- ============================================================
SELECT
    n.nota_id,
    CONCAT(u.usuario_nombre, ' ', u.usuario_apellido) AS estudiante,
    s.semestre_year AS anio,
    s.semestre_periodo AS periodo,
    m.materia_nombre AS materia,
    c.componente_nombre AS componente,
    n.nota_nombre AS evaluacion,
    n.nota_valor,
    n.nota_fecha_registro
FROM nota AS n
INNER JOIN componente AS c
    ON c.componente_id = n.nota_componente_id
INNER JOIN materia_usuario AS mu
    ON mu.materia_usuario_id = c.componente_materia_usuario_id
INNER JOIN semestre AS s
    ON s.semestre_id = mu.materia_usuario_semestre_id
INNER JOIN usuario AS u
    ON u.usuario_id = s.semestre_usuario_id
INNER JOIN materia AS m
    ON m.materia_id = mu.materia_usuario_materia_id
INNER JOIN tipologia AS t
    ON t.tipologia_id = m.materia_tipologia_id
ORDER BY n.nota_fecha_registro DESC, estudiante, materia;

-- ============================================================
-- N3-01: ¿Cuál es el promedio, la nota mínima, la máxima y el número
-- de materias evaluadas por programa, año y período?
-- Agrupación sobre múltiples columnas y HAVING.
-- ============================================================
SELECT
    p.programa_nombre AS programa,
    s.semestre_year AS anio,
    s.semestre_periodo AS periodo,
    COUNT(vm.materia_usuario_id) AS materias_evaluadas,
    ROUND(AVG(vm.nota_final), 2) AS promedio_notas,
    MIN(vm.nota_final) AS nota_minima,
    MAX(vm.nota_final) AS nota_maxima
FROM v_nota_materia AS vm
INNER JOIN semestre AS s
    ON s.semestre_id = vm.semestre_id
INNER JOIN usuario AS u
    ON u.usuario_id = vm.usuario_id
INNER JOIN programa AS p
    ON p.programa_id = u.usuario_programa_id
WHERE vm.nota_final IS NOT NULL
GROUP BY
    p.programa_id,
    p.programa_nombre,
    s.semestre_year,
    s.semestre_periodo
HAVING COUNT(vm.materia_usuario_id) >= 5
ORDER BY anio, periodo, promedio_notas DESC;

-- ============================================================
-- N3-02: ¿Qué materias presentan al menos cinco intentos y cuál es
-- su tasa de aprobación?
-- Usa COUNT, SUM, AVG y HAVING.
-- ============================================================
SELECT
    m.materia_codigo,
    m.materia_nombre,
    COUNT(mu.materia_usuario_id) AS intentos,
    SUM(mu.materia_usuario_estado = 'aprobada') AS aprobados,
    SUM(mu.materia_usuario_estado = 'reprobada') AS reprobados,
    ROUND(
        100 * SUM(mu.materia_usuario_estado = 'aprobada')
        / NULLIF(
            SUM(mu.materia_usuario_estado IN ('aprobada', 'reprobada')),
            0
        ),
        2
    ) AS tasa_aprobacion_porcentaje
FROM materia AS m
INNER JOIN materia_usuario AS mu
    ON mu.materia_usuario_materia_id = m.materia_id
GROUP BY
    m.materia_id,
    m.materia_codigo,
    m.materia_nombre
HAVING COUNT(mu.materia_usuario_id) >= 5
ORDER BY tasa_aprobacion_porcentaje ASC, intentos DESC;

-- ============================================================
-- N3-03: ¿Cuántos créditos aprobados acumulan los estudiantes por
-- programa y tipología?
-- Agrupa por programa y tipología; usa SUM y COUNT DISTINCT.
-- ============================================================
SELECT
    p.programa_nombre AS programa,
    vat.tipologia,
    COUNT(DISTINCT vat.usuario_id) AS estudiantes,
    SUM(vat.creditos_aprobados) AS creditos_aprobados_acumulados,
    ROUND(AVG(vat.creditos_aprobados), 2) AS promedio_creditos_por_estudiante,
    MAX(vat.creditos_aprobados) AS maximo_creditos_estudiante
FROM v_avance_tipologia AS vat
INNER JOIN usuario AS u
    ON u.usuario_id = vat.usuario_id
INNER JOIN programa AS p
    ON p.programa_id = u.usuario_programa_id
GROUP BY
    p.programa_id,
    p.programa_nombre,
    vat.tipologia_id,
    vat.tipologia
HAVING SUM(vat.creditos_aprobados) > 0
ORDER BY programa, creditos_aprobados_acumulados DESC;

-- ============================================================
-- N4-01: ¿Qué estudiantes tienen un promedio global superior al
-- promedio global de los estudiantes de su mismo programa?
-- Subconsulta correlacionada.
-- ============================================================
SELECT
    u.usuario_id,
    CONCAT(u.usuario_nombre, ' ', u.usuario_apellido) AS estudiante,
    p.programa_nombre AS programa,
    pg.promedio_global
FROM v_promedio_global AS pg
INNER JOIN usuario AS u
    ON u.usuario_id = pg.usuario_id
INNER JOIN programa AS p
    ON p.programa_id = u.usuario_programa_id
WHERE pg.promedio_global > (
    SELECT AVG(pg2.promedio_global)
    FROM v_promedio_global AS pg2
    INNER JOIN usuario AS u2
        ON u2.usuario_id = pg2.usuario_id
    WHERE u2.usuario_programa_id = u.usuario_programa_id
)
ORDER BY programa, pg.promedio_global DESC;

-- ============================================================
-- N4-02: ¿Qué materias no han sido aprobadas por ningún estudiante?
-- Subconsulta con NOT EXISTS.
-- ============================================================
SELECT
    p.programa_nombre AS programa,
    m.materia_codigo,
    m.materia_nombre
FROM materia AS m
INNER JOIN tipologia AS t
    ON t.tipologia_id = m.materia_tipologia_id
INNER JOIN programa AS p
    ON p.programa_id = t.tipologia_programa_id
WHERE NOT EXISTS (
    SELECT 1
    FROM materia_usuario AS mu
    WHERE mu.materia_usuario_materia_id = m.materia_id
      AND mu.materia_usuario_estado = 'aprobada'
)
ORDER BY p.programa_nombre, m.materia_nombre;

-- ============================================================
-- N4-03: ¿Cuál es el avance total de cada estudiante y cómo se
-- compara con el total oficial de créditos de su programa?
-- CTE en cláusula WITH.
-- ============================================================
WITH avance_estudiante AS (
    SELECT
        u.usuario_id,
        u.usuario_programa_id,
        SUM(vat.creditos_aprobados) AS creditos_aprobados
    FROM usuario AS u
    INNER JOIN v_avance_tipologia AS vat
        ON vat.usuario_id = u.usuario_id
    GROUP BY
        u.usuario_id,
        u.usuario_programa_id
)
SELECT
    ae.usuario_id,
    CONCAT(u.usuario_nombre, ' ', u.usuario_apellido) AS estudiante,
    p.programa_nombre AS programa,
    ae.creditos_aprobados,
    p.programa_total_creditos,
    ROUND(
        ae.creditos_aprobados * 100
        / NULLIF(p.programa_total_creditos, 0),
        2
    ) AS avance_porcentaje
FROM avance_estudiante AS ae
INNER JOIN usuario AS u
    ON u.usuario_id = ae.usuario_id
INNER JOIN programa AS p
    ON p.programa_id = ae.usuario_programa_id
ORDER BY avance_porcentaje DESC, estudiante;

-- ============================================================
-- N5-01: ¿Cuál es el ranking de estudiantes dentro de cada programa
-- según su promedio global?
-- Usa DENSE_RANK y ROW_NUMBER con PARTITION BY.
-- ============================================================
SELECT
    p.programa_nombre AS programa,
    CONCAT(u.usuario_nombre, ' ', u.usuario_apellido) AS estudiante,
    pg.promedio_global,
    DENSE_RANK() OVER (
        PARTITION BY u.usuario_programa_id
        ORDER BY pg.promedio_global DESC
    ) AS posicion_por_promedio,
    ROW_NUMBER() OVER (
        PARTITION BY u.usuario_programa_id
        ORDER BY pg.promedio_global DESC, u.usuario_id
    ) AS orden_unico
FROM v_promedio_global AS pg
INNER JOIN usuario AS u
    ON u.usuario_id = pg.usuario_id
INNER JOIN programa AS p
    ON p.programa_id = u.usuario_programa_id
ORDER BY programa, posicion_por_promedio, orden_unico;

-- ============================================================
-- N5-02: ¿Cómo cambió el promedio de cada estudiante respecto al
-- semestre inmediatamente anterior?
-- Usa LAG para análisis comparativo temporal.
-- ============================================================
WITH historico AS (
    SELECT
        ps.usuario_id,
        ps.semestre_id,
        ps.year,
        ps.periodo,
        ps.numero_semestre,
        ps.promedio_semestre,
        LAG(ps.promedio_semestre) OVER (
            PARTITION BY ps.usuario_id
            ORDER BY ps.year, ps.periodo
        ) AS promedio_anterior
    FROM v_promedio_semestre AS ps
)
SELECT
    h.usuario_id,
    CONCAT(u.usuario_nombre, ' ', u.usuario_apellido) AS estudiante,
    h.year AS anio,
    h.periodo,
    h.promedio_semestre,
    h.promedio_anterior,
    ROUND(h.promedio_semestre - h.promedio_anterior, 2) AS variacion
FROM historico AS h
INNER JOIN usuario AS u
    ON u.usuario_id = h.usuario_id
ORDER BY h.usuario_id, h.year, h.periodo;

-- ============================================================
-- N6-01: ¿Cuántos créditos ha aprobado y cuántos le faltan a cada
-- estudiante por tipología?
-- Reutiliza la vista compleja v_avance_tipologia creada en el DDL.
-- ============================================================
SELECT
    CONCAT(u.usuario_nombre, ' ', u.usuario_apellido) AS estudiante,
    p.programa_nombre AS programa,
    vat.tipologia,
    vat.creditos_requeridos,
    vat.creditos_aprobados,
    vat.creditos_pendientes,
    vat.cuenta_promedio
FROM v_avance_tipologia AS vat
INNER JOIN usuario AS u
    ON u.usuario_id = vat.usuario_id
INNER JOIN programa AS p
    ON p.programa_id = u.usuario_programa_id
ORDER BY estudiante, vat.tipologia_id;

-- ============================================================
-- N6-02: ¿Cuál es el resumen global y semestral de rendimiento de
-- cada estudiante?
-- Reutiliza v_promedio_global y v_promedio_semestre.
-- ============================================================
SELECT
    CONCAT(u.usuario_nombre, ' ', u.usuario_apellido) AS estudiante,
    p.programa_nombre AS programa,
    pg.promedio_global,
    pg.total_creditos_cursados,
    pg.total_creditos_aprobados,
    ps.year AS anio,
    ps.periodo,
    ps.promedio_semestre
FROM usuario AS u
INNER JOIN programa AS p
    ON p.programa_id = u.usuario_programa_id
LEFT JOIN v_promedio_global AS pg
    ON pg.usuario_id = u.usuario_id
LEFT JOIN v_promedio_semestre AS ps
    ON ps.usuario_id = u.usuario_id
ORDER BY estudiante, ps.year, ps.periodo;