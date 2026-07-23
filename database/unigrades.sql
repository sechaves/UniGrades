-- ============================================================
-- UNIGRADES
-- Base de datos para el seguimiento del progreso académico
--
-- Entregable: Sesión 2 - Diseño lógico, normalización y DDL
-- Integrantes:
-- Samuel Sanchez, Edison Quintero, Sergio Chaves, Cristian Hernandez, Santiago Puentes.
--
-- ============================================================

CREATE DATABASE IF NOT EXISTS unigrades
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE unigrades;

SET NAMES utf8mb4;

-- ============================================================
-- LIMPIEZA PARA GARANTIZAR REPRODUCIBILIDAD
-- Primero se eliminan las vistas en orden inverso de dependencia.
-- Después se eliminan las tablas en orden inverso de dependencia.
-- ============================================================

DROP VIEW IF EXISTS v_avance_tipologia;
DROP VIEW IF EXISTS v_materias_aprobadas_usuario;
DROP VIEW IF EXISTS v_promedio_global;
DROP VIEW IF EXISTS v_promedio_semestre;
DROP VIEW IF EXISTS v_nota_materia;
DROP VIEW IF EXISTS v_promedio_componente;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS nota;
DROP TABLE IF EXISTS componente;
DROP TABLE IF EXISTS materia_usuario;
DROP TABLE IF EXISTS semestre;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS materia_correquisito;
DROP TABLE IF EXISTS materia_prerrequisito;
DROP TABLE IF EXISTS materia;
DROP TABLE IF EXISTS tipologia;
DROP TABLE IF EXISTS programa;
DROP TABLE IF EXISTS universidad;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- TABLA: UNIVERSIDAD
-- Almacena las instituciones educativas disponibles.
-- ============================================================

CREATE TABLE universidad (
    universidad_id          INT UNSIGNED AUTO_INCREMENT,
    universidad_nombre      VARCHAR(150) NOT NULL,
    universidad_sigla       VARCHAR(20) DEFAULT NULL,
    universidad_pais        VARCHAR(80) NOT NULL DEFAULT 'Colombia',
    universidad_ciudad      VARCHAR(80) DEFAULT NULL,
    universidad_logo_url    VARCHAR(255) DEFAULT NULL,
    universidad_created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_universidad
        PRIMARY KEY (universidad_id),

    CONSTRAINT uq_universidad_nombre_ciudad
        UNIQUE (universidad_nombre, universidad_ciudad)
) ENGINE = InnoDB
  COMMENT = 'Instituciones educativas registradas en UNIGRADES';

-- ============================================================
-- TABLA: PROGRAMA
-- Cada programa pertenece a una universidad.
-- programa_total_creditos representa el valor oficial del plan.
-- ============================================================

CREATE TABLE programa (
    programa_id                 INT UNSIGNED AUTO_INCREMENT,
    programa_universidad_id     INT UNSIGNED NOT NULL,
    programa_nombre             VARCHAR(150) NOT NULL,
    programa_facultad           VARCHAR(150) DEFAULT NULL,
    programa_total_creditos     SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    programa_created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_programa
        PRIMARY KEY (programa_id),

    CONSTRAINT uq_programa_universidad_nombre
        UNIQUE (programa_universidad_id, programa_nombre),

    CONSTRAINT chk_programa_total_creditos
        CHECK (programa_total_creditos >= 0),

    CONSTRAINT fk_programa_universidad
        FOREIGN KEY (programa_universidad_id)
        REFERENCES universidad (universidad_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Programas académicos ofrecidos por cada universidad';

-- ============================================================
-- TABLA: TIPOLOGIA
-- Clasifica las materias de un programa.
-- Ejemplos: disciplinar obligatoria, libre elección y nivelación.
-- ============================================================

CREATE TABLE tipologia (
    tipologia_id                    INT UNSIGNED AUTO_INCREMENT,
    tipologia_programa_id           INT UNSIGNED NOT NULL,
    tipologia_nombre                VARCHAR(100) NOT NULL,
    tipologia_creditos_requeridos   SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    tipologia_cuenta_promedio       BOOLEAN NOT NULL DEFAULT TRUE,
    tipologia_created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_tipologia
        PRIMARY KEY (tipologia_id),

    CONSTRAINT uq_tipologia_programa_nombre
        UNIQUE (tipologia_programa_id, tipologia_nombre),

    CONSTRAINT chk_tipologia_creditos_requeridos
        CHECK (tipologia_creditos_requeridos >= 0),

    CONSTRAINT chk_tipologia_cuenta_promedio
        CHECK (tipologia_cuenta_promedio IN (0, 1)),

    CONSTRAINT fk_tipologia_programa
        FOREIGN KEY (tipologia_programa_id)
        REFERENCES programa (programa_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Tipologías de materias definidas para cada programa';

-- ============================================================
-- TABLA: MATERIA
-- Cada materia pertenece a una tipología.
-- El programa se obtiene mediante la relación con TIPOLOGIA.
-- ============================================================

CREATE TABLE materia (
    materia_id                      INT UNSIGNED AUTO_INCREMENT,
    materia_tipologia_id            INT UNSIGNED NOT NULL,
    materia_codigo                  VARCHAR(30) DEFAULT NULL,
    materia_nombre                  VARCHAR(150) NOT NULL,
    materia_creditos                TINYINT UNSIGNED NOT NULL DEFAULT 3,
    materia_nota_minima_aprobacion  DECIMAL(3,1) NOT NULL DEFAULT 3.0,
    materia_semestre_sugerido       TINYINT UNSIGNED DEFAULT NULL,
    materia_created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_materia
        PRIMARY KEY (materia_id),

    CONSTRAINT uq_materia_tipologia_codigo
        UNIQUE (materia_tipologia_id, materia_codigo),

    CONSTRAINT uq_materia_tipologia_nombre
        UNIQUE (materia_tipologia_id, materia_nombre),

    CONSTRAINT chk_materia_creditos
        CHECK (materia_creditos > 0),

    CONSTRAINT chk_materia_nota_minima
        CHECK (
            materia_nota_minima_aprobacion >= 0.0
            AND materia_nota_minima_aprobacion <= 5.0
        ),

    CONSTRAINT chk_materia_semestre_sugerido
        CHECK (
            materia_semestre_sugerido IS NULL
            OR materia_semestre_sugerido BETWEEN 1 AND 20
        ),

    CONSTRAINT fk_materia_tipologia
        FOREIGN KEY (materia_tipologia_id)
        REFERENCES tipologia (tipologia_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Materias que componen las tipologías de cada programa';

-- ============================================================
-- TABLA: MATERIA_PRERREQUISITO
-- Relaciona una materia con sus prerrequisitos.
-- Auto-relación sobre MATERIA. Un prerrequisito debe aprobarse
-- antes de poder inscribir la materia destino.
-- ============================================================

CREATE TABLE materia_prerrequisito (
    materia_id                INT UNSIGNED NOT NULL,
    prerrequisito_materia_id  INT UNSIGNED NOT NULL,
    created_at                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_materia_prerrequisito
        PRIMARY KEY (materia_id, prerrequisito_materia_id),

    CONSTRAINT chk_prerrequisito_diferente
        CHECK (materia_id != prerrequisito_materia_id),

    CONSTRAINT fk_mp_materia
        FOREIGN KEY (materia_id)
        REFERENCES materia (materia_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_mp_prerrequisito
        FOREIGN KEY (prerrequisito_materia_id)
        REFERENCES materia (materia_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Prerrequisitos asociados a cada materia';

-- ============================================================
-- TABLA: MATERIA_CORREQUISITO
-- Relaciona una materia con sus correquisitos.
-- Auto-relación sobre MATERIA. Un correquisito debe cursarse
-- simultáneamente o haberse aprobado previamente.
-- ============================================================

CREATE TABLE materia_correquisito (
    materia_id                INT UNSIGNED NOT NULL,
    correquisito_materia_id   INT UNSIGNED NOT NULL,
    created_at                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_materia_correquisito
        PRIMARY KEY (materia_id, correquisito_materia_id),

    CONSTRAINT chk_correquisito_diferente
        CHECK (materia_id != correquisito_materia_id),

    CONSTRAINT fk_mc_materia
        FOREIGN KEY (materia_id)
        REFERENCES materia (materia_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_mc_correquisito
        FOREIGN KEY (correquisito_materia_id)
        REFERENCES materia (materia_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Correquisitos asociados a cada materia';

-- ============================================================
-- TABLA: USUARIO
-- Cada usuario está asociado con un programa académico.
-- ============================================================

CREATE TABLE usuario (
    usuario_id                  INT UNSIGNED AUTO_INCREMENT,
    usuario_programa_id         INT UNSIGNED NOT NULL,
    usuario_nombre              VARCHAR(100) NOT NULL,
    usuario_apellido            VARCHAR(100) NOT NULL,
    usuario_email               VARCHAR(150) NOT NULL,
    usuario_password_hash       VARCHAR(255) NOT NULL,
    usuario_codigo_estudiantil  VARCHAR(20) DEFAULT NULL,
    usuario_avatar_url          VARCHAR(255) DEFAULT NULL,
    usuario_created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_usuario
        PRIMARY KEY (usuario_id),

    CONSTRAINT uq_usuario_email
        UNIQUE (usuario_email),

    CONSTRAINT uq_usuario_programa_codigo
        UNIQUE (usuario_programa_id, usuario_codigo_estudiantil),

    CONSTRAINT fk_usuario_programa
        FOREIGN KEY (usuario_programa_id)
        REFERENCES programa (programa_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Estudiantes registrados y asociados con un programa';

-- ============================================================
-- TABLA: SEMESTRE
-- Representa un período académico real cursado por un usuario.
-- Ejemplo: año 2026, período 1.
-- ============================================================

CREATE TABLE semestre (
    semestre_id             INT UNSIGNED AUTO_INCREMENT,
    semestre_usuario_id     INT UNSIGNED NOT NULL,
    semestre_numero         TINYINT UNSIGNED NOT NULL,
    semestre_year           YEAR NOT NULL,
    semestre_periodo        TINYINT UNSIGNED NOT NULL,
    semestre_created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_semestre
        PRIMARY KEY (semestre_id),

    CONSTRAINT uq_semestre_usuario_periodo
        UNIQUE (semestre_usuario_id, semestre_year, semestre_periodo),

    CONSTRAINT chk_semestre_numero
        CHECK (semestre_numero BETWEEN 1 AND 20),

    CONSTRAINT chk_semestre_periodo
        CHECK (semestre_periodo IN (1, 2)),

    CONSTRAINT fk_semestre_usuario
        FOREIGN KEY (semestre_usuario_id)
        REFERENCES usuario (usuario_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Períodos académicos registrados por cada estudiante';

-- ============================================================
-- TABLA: MATERIA_USUARIO
-- Registra una materia cursada por un estudiante en un semestre.
-- El usuario se obtiene mediante la relación con SEMESTRE.
-- Una materia puede repetirse en otro semestre.
-- ============================================================

CREATE TABLE materia_usuario (
    materia_usuario_id           INT UNSIGNED AUTO_INCREMENT,
    materia_usuario_materia_id   INT UNSIGNED NOT NULL,
    materia_usuario_semestre_id  INT UNSIGNED NOT NULL,
    materia_usuario_estado       ENUM(
                                    'en_curso',
                                    'aprobada',
                                    'reprobada',
                                    'retirada'
                                  ) NOT NULL DEFAULT 'en_curso',
    materia_usuario_created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_materia_usuario
        PRIMARY KEY (materia_usuario_id),

    CONSTRAINT uq_materia_usuario_semestre
        UNIQUE (
            materia_usuario_materia_id,
            materia_usuario_semestre_id
        ),

    CONSTRAINT fk_materia_usuario_materia
        FOREIGN KEY (materia_usuario_materia_id)
        REFERENCES materia (materia_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_materia_usuario_semestre
        FOREIGN KEY (materia_usuario_semestre_id)
        REFERENCES semestre (semestre_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Materias cursadas por los estudiantes en cada semestre';

-- ============================================================
-- TABLA: COMPONENTE
-- Representa evaluaciones o grupos de evaluaciones de una materia.
-- La suma de porcentajes de los componentes de una materia debe ser
-- exactamente 100. Esta regla depende de varias filas y se validará
-- mediante trigger o procedimiento en la siguiente sesión.
-- ============================================================

CREATE TABLE componente (
    componente_id                   INT UNSIGNED AUTO_INCREMENT,
    componente_materia_usuario_id   INT UNSIGNED NOT NULL,
    componente_nombre               VARCHAR(100) NOT NULL,
    componente_porcentaje           DECIMAL(5,2) NOT NULL,
    componente_nota_minima          DECIMAL(3,1) DEFAULT NULL,
    componente_orden                TINYINT UNSIGNED NOT NULL DEFAULT 1,
    componente_created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_componente
        PRIMARY KEY (componente_id),

    CONSTRAINT uq_componente_materia_nombre
        UNIQUE (
            componente_materia_usuario_id,
            componente_nombre
        ),

    CONSTRAINT uq_componente_materia_orden
        UNIQUE (
            componente_materia_usuario_id,
            componente_orden
        ),

    CONSTRAINT chk_componente_porcentaje
        CHECK (
            componente_porcentaje > 0.00
            AND componente_porcentaje <= 100.00
        ),

    CONSTRAINT chk_componente_nota_minima
        CHECK (
            componente_nota_minima IS NULL
            OR (
                componente_nota_minima >= 0.0
                AND componente_nota_minima <= 5.0
            )
        ),

    CONSTRAINT chk_componente_orden
        CHECK (componente_orden >= 1),

    CONSTRAINT fk_componente_materia_usuario
        FOREIGN KEY (componente_materia_usuario_id)
        REFERENCES materia_usuario (materia_usuario_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Componentes evaluativos configurados para una materia cursada';

-- ============================================================
-- TABLA: NOTA
-- Permite registrar varias calificaciones dentro de un componente.
-- La nota final del componente corresponde al promedio de sus notas.
-- ============================================================

CREATE TABLE nota (
    nota_id              INT UNSIGNED AUTO_INCREMENT,
    nota_componente_id   INT UNSIGNED NOT NULL,
    nota_nombre          VARCHAR(100) NOT NULL,
    nota_valor           DECIMAL(3,1) NOT NULL,
    nota_fecha_registro  DATE DEFAULT NULL,
    nota_observacion     VARCHAR(255) DEFAULT NULL,
    nota_created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_nota
        PRIMARY KEY (nota_id),

    CONSTRAINT uq_nota_componente_nombre
        UNIQUE (nota_componente_id, nota_nombre),

    CONSTRAINT chk_nota_rango
        CHECK (
            nota_valor >= 0.0
            AND nota_valor <= 5.0
        ),

    CONSTRAINT fk_nota_componente
        FOREIGN KEY (nota_componente_id)
        REFERENCES componente (componente_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  COMMENT = 'Calificaciones registradas dentro de cada componente';

-- ============================================================
-- ÍNDICES PARA CONSULTAS FRECUENTES
-- Los índices de PRIMARY KEY, UNIQUE y FOREIGN KEY se crean
-- automáticamente. Los siguientes índices compuestos optimizan
-- patrones adicionales de búsqueda y ordenamiento.
-- ============================================================

-- Índice para listar estudiantes de un programa ordenados o filtrados
-- por apellido y nombre.
CREATE INDEX idx_usuario_programa_apellido
    ON usuario (
        usuario_programa_id,
        usuario_apellido,
        usuario_nombre
    );

-- Índice para consultar materias de una tipología y organizarlas
-- según el semestre sugerido.
CREATE INDEX idx_materia_tipologia_semestre
    ON materia (
        materia_tipologia_id,
        materia_semestre_sugerido
    );

-- Índice para consultar las materias de un semestre filtradas
-- rápidamente por su estado académico.
CREATE INDEX idx_materia_usuario_semestre_estado
    ON materia_usuario (
        materia_usuario_semestre_id,
        materia_usuario_estado
    );

-- Índice para consultar el historial de notas de un componente
-- y ordenarlo por fecha de registro.
CREATE INDEX idx_nota_componente_fecha
    ON nota (
        nota_componente_id,
        nota_fecha_registro
    );

-- Índice para consultar todos los prerrequisitos de una materia.
CREATE INDEX idx_prerrequisito_materia
    ON materia_prerrequisito (prerrequisito_materia_id);

-- Índice para consultar todos los correquisitos de una materia.
CREATE INDEX idx_correquisito_materia
    ON materia_correquisito (correquisito_materia_id);

-- ============================================================
-- VISTAS
-- ============================================================

-- ------------------------------------------------------------
-- VISTA: PROMEDIO DE NOTAS POR COMPONENTE
-- Calcula el promedio de las notas registradas en cada componente.
-- ------------------------------------------------------------

CREATE VIEW v_promedio_componente AS
SELECT
    c.componente_id,
    c.componente_materia_usuario_id,
    c.componente_nombre,
    c.componente_porcentaje,
    AVG(n.nota_valor) AS promedio_componente,
    COUNT(n.nota_id) AS cantidad_notas
FROM componente AS c
LEFT JOIN nota AS n
    ON n.nota_componente_id = c.componente_id
GROUP BY
    c.componente_id,
    c.componente_materia_usuario_id,
    c.componente_nombre,
    c.componente_porcentaje;

-- ------------------------------------------------------------
-- VISTA: NOTA DE CADA MATERIA CURSADA
--
-- nota_acumulada:
--   suma ponderada de los componentes que ya tienen calificaciones.
--
-- porcentaje_evaluado:
--   suma de porcentajes de los componentes con notas registradas.
--
-- nota_final:
--   solo se calcula cuando el porcentaje evaluado es exactamente 100.
-- ------------------------------------------------------------

CREATE VIEW v_nota_materia AS
SELECT
    mu.materia_usuario_id,
    s.semestre_usuario_id AS usuario_id,
    mu.materia_usuario_semestre_id AS semestre_id,
    m.materia_id,
    m.materia_nombre AS materia,
    m.materia_codigo,
    m.materia_creditos AS creditos,
    t.tipologia_id,
    t.tipologia_cuenta_promedio AS cuenta_promedio,
    mu.materia_usuario_estado AS estado,

    ROUND(
        SUM(
            pc.promedio_componente
            * pc.componente_porcentaje
            / 100
        ),
        2
    ) AS nota_acumulada,

    ROUND(
        SUM(pc.componente_porcentaje),
        2
    ) AS porcentaje_evaluado,

    CASE
        WHEN ROUND(SUM(pc.componente_porcentaje), 2) = 100.00
        THEN ROUND(
            SUM(
                pc.promedio_componente
                * pc.componente_porcentaje
                / 100
            ),
            2
        )
        ELSE NULL
    END AS nota_final

FROM materia_usuario AS mu
INNER JOIN semestre AS s
    ON s.semestre_id = mu.materia_usuario_semestre_id
INNER JOIN materia AS m
    ON m.materia_id = mu.materia_usuario_materia_id
INNER JOIN tipologia AS t
    ON t.tipologia_id = m.materia_tipologia_id
INNER JOIN v_promedio_componente AS pc
    ON pc.componente_materia_usuario_id = mu.materia_usuario_id
WHERE pc.promedio_componente IS NOT NULL
GROUP BY
    mu.materia_usuario_id,
    s.semestre_usuario_id,
    mu.materia_usuario_semestre_id,
    m.materia_id,
    m.materia_nombre,
    m.materia_codigo,
    m.materia_creditos,
    t.tipologia_id,
    t.tipologia_cuenta_promedio,
    mu.materia_usuario_estado;

-- ------------------------------------------------------------
-- VISTA: PROMEDIO PONDERADO DE CADA SEMESTRE
-- Solo incluye materias cuya tipología cuenta para el promedio
-- y que ya tienen una nota final calculable.
-- ------------------------------------------------------------

CREATE VIEW v_promedio_semestre AS
SELECT
    vm.usuario_id,
    vm.semestre_id,
    s.semestre_year AS year,
    s.semestre_periodo AS periodo,
    s.semestre_numero AS numero_semestre,

    ROUND(
        SUM(vm.nota_final * vm.creditos)
        / NULLIF(SUM(vm.creditos), 0),
        2
    ) AS promedio_semestre,

    SUM(vm.creditos) AS creditos_cursados

FROM v_nota_materia AS vm
INNER JOIN semestre AS s
    ON s.semestre_id = vm.semestre_id
WHERE vm.nota_final IS NOT NULL
  AND vm.cuenta_promedio = 1
GROUP BY
    vm.usuario_id,
    vm.semestre_id,
    s.semestre_year,
    s.semestre_periodo,
    s.semestre_numero;

-- ------------------------------------------------------------
-- VISTA: PROMEDIO GLOBAL ACUMULADO
-- Considera materias aprobadas y reprobadas que cuentan para promedio.
-- ------------------------------------------------------------

CREATE VIEW v_promedio_global AS
SELECT
    vm.usuario_id,

    ROUND(
        SUM(vm.nota_final * vm.creditos)
        / NULLIF(SUM(vm.creditos), 0),
        2
    ) AS promedio_global,

    SUM(vm.creditos) AS total_creditos_cursados,

    SUM(
        CASE
            WHEN vm.estado = 'aprobada'
            THEN vm.creditos
            ELSE 0
        END
    ) AS total_creditos_aprobados

FROM v_nota_materia AS vm
WHERE vm.estado IN ('aprobada', 'reprobada')
  AND vm.cuenta_promedio = 1
  AND vm.nota_final IS NOT NULL
GROUP BY
    vm.usuario_id;

-- ------------------------------------------------------------
-- VISTA AUXILIAR: MATERIAS APROBADAS POR USUARIO
-- Evita contar dos veces los créditos si una materia aparece
-- aprobada en más de un intento.
-- ------------------------------------------------------------

CREATE VIEW v_materias_aprobadas_usuario AS
SELECT
    s.semestre_usuario_id AS usuario_id,
    mu.materia_usuario_materia_id AS materia_id
FROM materia_usuario AS mu
INNER JOIN semestre AS s
    ON s.semestre_id = mu.materia_usuario_semestre_id
WHERE mu.materia_usuario_estado = 'aprobada'
GROUP BY
    s.semestre_usuario_id,
    mu.materia_usuario_materia_id;

-- ------------------------------------------------------------
-- VISTA: AVANCE DE CRÉDITOS POR TIPOLOGÍA
-- Compara los créditos aprobados con los requeridos.
-- ------------------------------------------------------------

CREATE VIEW v_avance_tipologia AS
SELECT
    u.usuario_id,
    t.tipologia_id,
    t.tipologia_nombre AS tipologia,
    t.tipologia_creditos_requeridos AS creditos_requeridos,
    t.tipologia_cuenta_promedio AS cuenta_promedio,

    COALESCE(
        SUM(
            CASE
                WHEN mau.materia_id IS NOT NULL
                THEN m.materia_creditos
                ELSE 0
            END
        ),
        0
    ) AS creditos_aprobados,

    GREATEST(
        t.tipologia_creditos_requeridos
        - COALESCE(
            SUM(
                CASE
                    WHEN mau.materia_id IS NOT NULL
                    THEN m.materia_creditos
                    ELSE 0
                END
            ),
            0
        ),
        0
    ) AS creditos_pendientes

FROM usuario AS u
INNER JOIN tipologia AS t
    ON t.tipologia_programa_id = u.usuario_programa_id
LEFT JOIN materia AS m
    ON m.materia_tipologia_id = t.tipologia_id
LEFT JOIN v_materias_aprobadas_usuario AS mau
    ON mau.usuario_id = u.usuario_id
   AND mau.materia_id = m.materia_id
GROUP BY
    u.usuario_id,
    t.tipologia_id,
    t.tipologia_nombre,
    t.tipologia_creditos_requeridos,
    t.tipologia_cuenta_promedio;

-- ============================================================
-- PRUEBAS DE INTEGRIDAD OPCIONALES
--
-- Se dejan comentadas para que el script DDL pueda ejecutarse
-- completamente sin errores. Para obtener evidencia, ejecuten cada
-- prueba por separado después de crear la estructura.
-- ============================================================

-- PRUEBA 1: debe fallar por violación de clave foránea.
-- INSERT INTO programa (
--     programa_universidad_id,
--     programa_nombre,
--     programa_total_creditos
-- )
-- VALUES (
--     999999,
--     'Programa inválido',
--     100
-- );

-- PRUEBA 2: debe fallar porque el período solo puede ser 1 o 2.
-- Requiere que exista previamente un usuario con usuario_id = 1.
-- INSERT INTO semestre (
--     semestre_usuario_id,
--     semestre_numero,
--     semestre_year,
--     semestre_periodo
-- )
-- VALUES (
--     1,
--     1,
--     2026,
--     3
-- );

-- PRUEBA 3: debe fallar porque la nota supera el valor máximo de 5.0.
-- Requiere que exista previamente un componente con componente_id = 1.
-- INSERT INTO nota (
--     nota_componente_id,
--     nota_nombre,
--     nota_valor
-- )
-- VALUES (
--     1,
--     'Nota inválida',
--     6.0
-- );

-- ============================================================
-- FIN DEL SCRIPT DDL
-- ============================================================