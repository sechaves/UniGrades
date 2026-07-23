-- ============================================================
-- UNIGRADES - 04_consultas.sql
-- 15 consultas en 6 niveles de complejidad
-- Sesión 3
-- ============================================================

USE unigrades;

-- ============================================================
-- NIVEL 1 — FILTROS SIMPLES (WHERE, ORDER BY, LIMIT)
-- ============================================================

-- N1-1: Todos los usuarios de un programa específico
--       ordenados por apellido
SELECT usuario_id,
       usuario_nombre,
       usuario_apellido,
       usuario_email,
       usuario_codigo_estudiantil
FROM   usuario
WHERE  usuario_programa_id = 1
ORDER  BY usuario_apellido, usuario_nombre;

-- N1-2: Materias con nota mínima de aprobación mayor a 3.0
--       (materias más exigentes)
SELECT materia_id,
       materia_nombre,
       materia_codigo,
       materia_creditos,
       materia_nota_minima_aprobacion,
       materia_semestre_sugerido
FROM   materia
WHERE  materia_nota_minima_aprobacion > 3.0
ORDER  BY materia_nota_minima_aprobacion DESC, materia_semestre_sugerido;

-- N1-3: Semestres cursados entre 2024 y 2025
--       ordenados por año y período
SELECT s.semestre_id,
       u.usuario_nombre,
       u.usuario_apellido,
       s.semestre_numero,
       s.semestre_year,
       s.semestre_periodo
FROM   semestre AS s
INNER JOIN usuario AS u
    ON u.usuario_id = s.semestre_usuario_id
WHERE  s.semestre_year BETWEEN 2024 AND 2025
ORDER  BY s.semestre_year, s.semestre_periodo, u.usuario_apellido;

-- ============================================================
-- NIVEL 2 — JOINS ENTRE VARIAS TABLAS
-- ============================================================

-- N2-1: Materias inscritas por un usuario con su estado,
--       nombre de tipología y semestre en que las cursó
SELECT u.usuario_nombre,
       u.usuario_apellido,
       m.materia_nombre,
       m.materia_codigo,
       m.materia_creditos,
       t.tipologia_nombre,
       CONCAT(s.semestre_year, '-', s.semestre_periodo, 'S') AS periodo,
       mu.materia_usuario_estado
FROM   materia_usuario AS mu
INNER JOIN semestre    AS s
    ON  s.semestre_id = mu.materia_usuario_semestre_id
INNER JOIN usuario     AS u
    ON  u.usuario_id  = s.semestre_usuario_id
INNER JOIN materia     AS m
    ON  m.materia_id  = mu.materia_usuario_materia_id
INNER JOIN tipologia   AS t
    ON  t.tipologia_id = m.materia_tipologia_id
WHERE  u.usuario_id = 1
ORDER  BY s.semestre_year, s.semestre_periodo, t.tipologia_nombre;

-- N2-2: Componentes y sus notas para una materia cursada,
--       incluyendo el promedio calculado por componente
SELECT m.materia_nombre,
       c.componente_nombre,
       c.componente_porcentaje,
       n.nota_nombre,
       n.nota_valor,
       n.nota_fecha_registro
FROM   componente AS c
INNER JOIN materia_usuario AS mu
    ON  mu.materia_usuario_id = c.componente_materia_usuario_id
INNER JOIN semestre        AS s
    ON  s.semestre_id = mu.materia_usuario_semestre_id
INNER JOIN materia         AS m
    ON  m.materia_id  = mu.materia_usuario_materia_id
LEFT  JOIN nota            AS n
    ON  n.nota_componente_id = c.componente_id
WHERE  s.semestre_usuario_id = 1
ORDER  BY m.materia_nombre, c.componente_orden, n.nota_fecha_registro;

-- N2-3: Universidades con sus programas y total de créditos
SELECT uni.universidad_nombre,
       uni.universidad_ciudad,
       p.programa_nombre,
       p.programa_facultad,
       p.programa_total_creditos
FROM   universidad AS uni
INNER JOIN programa AS p
    ON  p.programa_universidad_id = uni.universidad_id
ORDER  BY uni.universidad_nombre, p.programa_nombre;

-- ============================================================
-- NIVEL 3 — AGREGACIÓN (GROUP BY, HAVING, funciones de grupo)
-- ============================================================

-- N3-1: Cantidad de estudiantes por programa y universidad,
--       solo programas con más de 5 estudiantes
SELECT uni.universidad_nombre,
       p.programa_nombre,
       COUNT(u.usuario_id) AS total_estudiantes
FROM   programa    AS p
INNER JOIN universidad AS uni
    ON  uni.universidad_id = p.programa_universidad_id
INNER JOIN usuario  AS u
    ON  u.usuario_programa_id = p.programa_id
GROUP  BY uni.universidad_nombre, p.programa_nombre
HAVING COUNT(u.usuario_id) > 5
ORDER  BY total_estudiantes DESC;

-- N3-2: Promedio de nota final por tipología en todos los semestres
SELECT t.tipologia_nombre,
       COUNT(vm.materia_usuario_id)         AS materias_evaluadas,
       ROUND(AVG(vm.nota_final), 2)         AS promedio_tipologia,
       ROUND(MIN(vm.nota_final), 2)         AS nota_minima,
       ROUND(MAX(vm.nota_final), 2)         AS nota_maxima
FROM   v_nota_materia AS vm
INNER JOIN tipologia  AS t
    ON  t.tipologia_id = vm.tipologia_id
WHERE  vm.nota_final IS NOT NULL
GROUP  BY t.tipologia_nombre
ORDER  BY promedio_tipologia DESC;

-- N3-3: Estudiantes que han cursado más de 3 semestres
--       con su semestre más reciente
SELECT u.usuario_id,
       u.usuario_nombre,
       u.usuario_apellido,
       COUNT(s.semestre_id)                         AS semestres_cursados,
       MAX(CONCAT(s.semestre_year, s.semestre_periodo)) AS ultimo_periodo
FROM   usuario  AS u
INNER JOIN semestre AS s
    ON  s.semestre_usuario_id = u.usuario_id
GROUP  BY u.usuario_id, u.usuario_nombre, u.usuario_apellido
HAVING COUNT(s.semestre_id) > 3
ORDER  BY semestres_cursados DESC;

-- ============================================================
-- NIVEL 4 — SUBCONSULTAS (correlacionadas y no correlacionadas)
-- ============================================================

-- N4-1: Estudiantes cuyo promedio global supera el promedio
--       global de todos los estudiantes (subconsulta escalar)
SELECT u.usuario_id,
       u.usuario_nombre,
       u.usuario_apellido,
       pg.promedio_global
FROM   v_promedio_global AS pg
INNER JOIN usuario       AS u
    ON  u.usuario_id = pg.usuario_id
WHERE  pg.promedio_global > (
    SELECT AVG(promedio_global)
    FROM   v_promedio_global
)
ORDER  BY pg.promedio_global DESC;

-- N4-2: Materias que ningún estudiante ha aprobado aún
--       (subconsulta con NOT EXISTS)
SELECT m.materia_id,
       m.materia_nombre,
       m.materia_codigo,
       t.tipologia_nombre
FROM   materia   AS m
INNER JOIN tipologia AS t
    ON  t.tipologia_id = m.materia_tipologia_id
WHERE  NOT EXISTS (
    SELECT 1
    FROM   materia_usuario AS mu
    WHERE  mu.materia_usuario_materia_id = m.materia_id
      AND  mu.materia_usuario_estado     = 'aprobada'
)
ORDER  BY t.tipologia_nombre, m.materia_semestre_sugerido;

-- N4-3: Componentes cuyo promedio de notas es inferior a la
--       nota mínima configurada para ese componente
--       (subconsulta correlacionada)
SELECT m.materia_nombre,
       c.componente_nombre,
       c.componente_nota_minima,
       ROUND(AVG(n.nota_valor), 2) AS promedio_actual
FROM   componente AS c
INNER JOIN materia_usuario AS mu
    ON  mu.materia_usuario_id = c.componente_materia_usuario_id
INNER JOIN materia AS m
    ON  m.materia_id = mu.materia_usuario_materia_id
INNER JOIN nota    AS n
    ON  n.nota_componente_id = c.componente_id
WHERE  c.componente_nota_minima IS NOT NULL
GROUP  BY m.materia_nombre, c.componente_id,
          c.componente_nombre, c.componente_nota_minima
HAVING ROUND(AVG(n.nota_valor), 2) < c.componente_nota_minima
ORDER  BY promedio_actual ASC;

-- ============================================================
-- NIVEL 5 — WINDOW FUNCTIONS
-- ============================================================

-- N5-1: Ranking de estudiantes por promedio global dentro
--       de cada programa (RANK con PARTITION BY)
SELECT u.usuario_nombre,
       u.usuario_apellido,
       p.programa_nombre,
       pg.promedio_global,
       RANK() OVER (
           PARTITION BY u.usuario_programa_id
           ORDER BY pg.promedio_global DESC
       ) AS ranking_programa
FROM   v_promedio_global AS pg
INNER JOIN usuario   AS u
    ON  u.usuario_id = pg.usuario_id
INNER JOIN programa  AS p
    ON  p.programa_id = u.usuario_programa_id
ORDER  BY p.programa_nombre, ranking_programa;

-- N5-2: Evolución del promedio semestral de un estudiante:
--       promedio acumulado histórico con AVG sobre ventana
--       deslizante (desde el primer semestre hasta el actual)
SELECT u.usuario_nombre,
       ps.numero_semestre,
       CONCAT(ps.year, '-', ps.periodo, 'S')  AS periodo,
       ps.promedio_semestre,
       ROUND(
           AVG(ps.promedio_semestre) OVER (
               PARTITION BY ps.usuario_id
               ORDER BY ps.year, ps.periodo
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ), 2
       ) AS promedio_acumulado
FROM   v_promedio_semestre AS ps
INNER JOIN usuario         AS u
    ON  u.usuario_id = ps.usuario_id
WHERE  ps.usuario_id = 1
ORDER  BY ps.year, ps.periodo;

-- ============================================================
-- NIVEL 6 — VISTAS Y CONSULTAS ANALÍTICAS COMPLEJAS
-- ============================================================

-- N6-1: Dashboard completo del estudiante:
--       usa las 4 vistas para consolidar promedio global,
--       avance por tipología y semestre actual
SELECT
    u.usuario_nombre,
    u.usuario_apellido,
    p.programa_nombre,
    uni.universidad_nombre,
    pg.promedio_global,
    pg.total_creditos_cursados,
    pg.total_creditos_aprobados,
    ROUND(
        pg.total_creditos_aprobados * 100.0
        / NULLIF(p.programa_total_creditos, 0),
        1
    )                               AS porcentaje_avance_carrera
FROM   v_promedio_global AS pg
INNER JOIN usuario       AS u
    ON  u.usuario_id = pg.usuario_id
INNER JOIN programa      AS p
    ON  p.programa_id = u.usuario_programa_id
INNER JOIN universidad   AS uni
    ON  uni.universidad_id = p.programa_universidad_id
ORDER  BY pg.promedio_global DESC;

-- N6-2: Reporte de avance curricular por tipología para todos
--       los estudiantes: créditos aprobados, pendientes y
--       porcentaje de completitud — usa v_avance_tipologia
SELECT u.usuario_nombre,
       u.usuario_apellido,
       vat.tipologia,
       vat.creditos_requeridos,
       vat.creditos_aprobados,
       vat.creditos_pendientes,
       ROUND(
           vat.creditos_aprobados * 100.0
           / NULLIF(vat.creditos_requeridos, 0),
           1
       ) AS porcentaje_cumplimiento
FROM   v_avance_tipologia AS vat
INNER JOIN usuario        AS u
    ON  u.usuario_id = vat.usuario_id
WHERE  vat.creditos_requeridos > 0
ORDER  BY u.usuario_apellido, vat.tipologia;

-- N6-3: Top 3 mejores notas finales por materia en toda la
--       historia de la plataforma, usando v_nota_materia
--       y una CTE con ranking
WITH ranked_notas AS (
    SELECT vm.materia,
           vm.materia_codigo,
           u.usuario_nombre,
           u.usuario_apellido,
           vm.nota_final,
           CONCAT(s.semestre_year, '-', s.semestre_periodo, 'S') AS periodo,
           DENSE_RANK() OVER (
               PARTITION BY vm.materia_id
               ORDER BY vm.nota_final DESC
           ) AS posicion
    FROM   v_nota_materia AS vm
    INNER JOIN semestre   AS s
        ON  s.semestre_id = vm.semestre_id
    INNER JOIN usuario    AS u
        ON  u.usuario_id  = vm.usuario_id
    WHERE  vm.nota_final IS NOT NULL
)
SELECT materia,
       materia_codigo,
       posicion,
       usuario_nombre,
       usuario_apellido,
       nota_final,
       periodo
FROM   ranked_notas
WHERE  posicion <= 3
ORDER  BY materia, posicion;

-- ============================================================
-- FIN DEL ARCHIVO 04_consultas.sql
-- ============================================================
