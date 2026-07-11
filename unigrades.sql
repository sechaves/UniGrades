-- ============================================================
--  UNIGRADES - Base de datos para gestor de progreso académico
-- ============================================================

CREATE DATABASE IF NOT EXISTS unigrades
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE unigrades;

-- ------------------------------------------------------------
-- UNIVERSIDAD
-- ------------------------------------------------------------
CREATE TABLE universidad (
    universidad_id          INT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    universidad_nombre      VARCHAR(150)    NOT NULL,
    universidad_sigla       VARCHAR(20),
    universidad_pais        VARCHAR(80)     NOT NULL DEFAULT 'Colombia',
    universidad_ciudad      VARCHAR(80),
    universidad_logo_url    VARCHAR(255),
    universidad_created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- PROGRAMA
-- ------------------------------------------------------------
CREATE TABLE programa (
    programa_id                 INT UNSIGNED      AUTO_INCREMENT PRIMARY KEY,
    programa_universidad_id     INT UNSIGNED      NOT NULL,
    programa_nombre             VARCHAR(150)      NOT NULL,
    programa_facultad           VARCHAR(150),
    programa_total_creditos     SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    programa_created_at         TIMESTAMP         DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_programa_universidad
        FOREIGN KEY (programa_universidad_id) REFERENCES universidad(universidad_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- TIPOLOGIA
-- Tipos de materia que maneja cada programa.
-- cuenta_promedio = 0 → no afecta el promedio (Ej: NIVELACIÓN en UNAL)
-- ------------------------------------------------------------
CREATE TABLE tipologia (
    tipologia_id                    INT UNSIGNED      AUTO_INCREMENT PRIMARY KEY,
    tipologia_programa_id           INT UNSIGNED      NOT NULL,
    tipologia_nombre                VARCHAR(100)      NOT NULL,
    tipologia_creditos_requeridos   SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    tipologia_cuenta_promedio       TINYINT(1)        NOT NULL DEFAULT 1,
    tipologia_created_at            TIMESTAMP         DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tipologia_programa
        FOREIGN KEY (tipologia_programa_id) REFERENCES programa(programa_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- MATERIA
-- materia_codigo: código libre según la universidad (opcional).
-- Ej UNAL: '1000003-B' | Ej otra universidad: 'CS-101'
-- ------------------------------------------------------------
CREATE TABLE materia (
    materia_id                      INT UNSIGNED      AUTO_INCREMENT PRIMARY KEY,
    materia_programa_id             INT UNSIGNED      NOT NULL,
    materia_tipologia_id            INT UNSIGNED      NOT NULL,
    materia_codigo                  VARCHAR(30)       DEFAULT NULL,
    materia_nombre                  VARCHAR(150)      NOT NULL,
    materia_creditos                TINYINT UNSIGNED  NOT NULL DEFAULT 3,
    materia_nota_minima_aprobacion  DECIMAL(3,1)      NOT NULL DEFAULT 3.0,
    materia_semestre_sugerido       TINYINT UNSIGNED,
    materia_created_at              TIMESTAMP         DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_materia_codigo_programa (materia_programa_id, materia_codigo),

    CONSTRAINT fk_materia_programa
        FOREIGN KEY (materia_programa_id) REFERENCES programa(programa_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_materia_tipologia
        FOREIGN KEY (materia_tipologia_id) REFERENCES tipologia(tipologia_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- USUARIO
-- ------------------------------------------------------------
CREATE TABLE usuario (
    usuario_id                  INT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
    usuario_programa_id         INT UNSIGNED  NOT NULL,
    usuario_nombre              VARCHAR(100)  NOT NULL,
    usuario_apellido            VARCHAR(100)  NOT NULL,
    usuario_email               VARCHAR(150)  NOT NULL UNIQUE,
    usuario_password_hash       VARCHAR(255)  NOT NULL,
    usuario_codigo_estudiantil  VARCHAR(20),
    usuario_avatar_url          VARCHAR(255),
    usuario_created_at          TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_programa
        FOREIGN KEY (usuario_programa_id) REFERENCES programa(programa_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- SEMESTRE
-- Período académico real del estudiante.
-- Formato UNAL: year=2025, periodo=2 → "2025-2S"
-- ------------------------------------------------------------
CREATE TABLE semestre (
    semestre_id             INT UNSIGNED      AUTO_INCREMENT PRIMARY KEY,
    semestre_usuario_id     INT UNSIGNED      NOT NULL,
    semestre_numero         TINYINT UNSIGNED  NOT NULL,   -- semestre 1, 2, 3... del estudiante
    semestre_year           YEAR              NOT NULL,
    semestre_periodo        TINYINT UNSIGNED  NOT NULL,   -- 1 o 2
    semestre_created_at     TIMESTAMP         DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_semestre_usuario (semestre_usuario_id, semestre_year, semestre_periodo),

    CONSTRAINT fk_semestre_usuario
        FOREIGN KEY (semestre_usuario_id) REFERENCES usuario(usuario_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- MATERIA_USUARIO
-- Instancia de una materia cursada por el estudiante en un
-- período real. Permite repetir una materia en otro semestre.
-- ------------------------------------------------------------
CREATE TABLE materia_usuario (
    materia_usuario_id          INT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
    materia_usuario_usuario_id  INT UNSIGNED  NOT NULL,
    materia_usuario_materia_id  INT UNSIGNED  NOT NULL,
    materia_usuario_semestre_id INT UNSIGNED  NOT NULL,
    materia_usuario_estado      ENUM('en_curso','aprobada','reprobada','retirada')
                                    NOT NULL DEFAULT 'en_curso',
    materia_usuario_created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_materia_usuario_semestre (materia_usuario_usuario_id, materia_usuario_materia_id, materia_usuario_semestre_id),

    CONSTRAINT fk_mu_usuario
        FOREIGN KEY (materia_usuario_usuario_id) REFERENCES usuario(usuario_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_mu_materia
        FOREIGN KEY (materia_usuario_materia_id) REFERENCES materia(materia_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_mu_semestre
        FOREIGN KEY (materia_usuario_semestre_id) REFERENCES semestre(semestre_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- COMPONENTE
-- Evaluaciones configuradas por el estudiante por materia.
-- Ej: PARCIAL 01 - 25%, Taller - 25%, PARCIAL 03 - 25%
-- Los porcentajes deben sumar 100 (validar en la app).
-- componente_nota_minima: calificación mínima para superar la evaluación.
-- ------------------------------------------------------------
CREATE TABLE componente (
    componente_id                   INT UNSIGNED      AUTO_INCREMENT PRIMARY KEY,
    componente_materia_usuario_id   INT UNSIGNED      NOT NULL,
    componente_nombre               VARCHAR(100)      NOT NULL,
    componente_porcentaje           DECIMAL(5,2)      NOT NULL,       -- 0.00 a 100.00
    componente_nota_minima          DECIMAL(3,1)      DEFAULT NULL,
    componente_orden                TINYINT UNSIGNED  NOT NULL DEFAULT 1,
    componente_created_at           TIMESTAMP         DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_componente_materia_usuario
        FOREIGN KEY (componente_materia_usuario_id) REFERENCES materia_usuario(materia_usuario_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- NOTA
-- Permite múltiples notas por componente.
-- Ej: Componente "Talleres - 20%" puede tener:
--     - Taller 1: 4.5
--     - Taller 2: 3.8
--     - Taller 3: 5.0
-- La nota final del componente es el promedio de todas sus notas.
-- ------------------------------------------------------------
CREATE TABLE nota (
    nota_id             INT UNSIGNED      AUTO_INCREMENT PRIMARY KEY,
    nota_componente_id  INT UNSIGNED      NOT NULL,           -- muchas notas por componente
    nota_nombre         VARCHAR(100)      NOT NULL,           -- "Taller 1", "Quiz 2", etc.
    nota_valor          DECIMAL(3,1)      NOT NULL,           -- 0.0 a 5.0
    nota_fecha_registro DATE,
    nota_observacion    VARCHAR(255),
    nota_created_at     TIMESTAMP         DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_nota_rango
        CHECK (nota_valor >= 0.0 AND nota_valor <= 5.0),

    CONSTRAINT fk_nota_componente
        FOREIGN KEY (nota_componente_id) REFERENCES componente(componente_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
--  VISTAS ÚTILES
-- ============================================================

-- Vista auxiliar: promedio de notas por componente
-- Un componente puede tener múltiples notas (talleres, quizzes, etc.)
-- Esta vista calcula el promedio de cada componente.
CREATE VIEW v_promedio_componente AS
    SELECT
        c.componente_id,
        c.componente_materia_usuario_id,
        c.componente_nombre,
        c.componente_porcentaje,
        AVG(n.nota_valor)                           AS promedio_componente,
        COUNT(n.nota_id)                            AS cantidad_notas
    FROM componente c
    LEFT JOIN nota n ON n.nota_componente_id = c.componente_id
    GROUP BY c.componente_id, c.componente_materia_usuario_id,
             c.componente_nombre, c.componente_porcentaje;


-- Vista: nota final por materia (promedio ponderado por porcentaje)
-- Usa el promedio de cada componente y lo pondera por su porcentaje
CREATE VIEW v_nota_materia AS
    SELECT
        mu.materia_usuario_id,
        mu.materia_usuario_usuario_id               AS usuario_id,
        mu.materia_usuario_semestre_id              AS semestre_id,
        m.materia_nombre                            AS materia,
        m.materia_codigo,
        m.materia_creditos                          AS creditos,
        t.tipologia_cuenta_promedio                 AS cuenta_promedio,
        mu.materia_usuario_estado                   AS estado,
        ROUND(
            SUM(pc.promedio_componente * pc.componente_porcentaje / 100), 2
        )                                           AS nota_final
    FROM materia_usuario mu
    JOIN materia    m  ON m.materia_id      = mu.materia_usuario_materia_id
    JOIN tipologia  t  ON t.tipologia_id    = m.materia_tipologia_id
    JOIN v_promedio_componente pc
         ON pc.componente_materia_usuario_id = mu.materia_usuario_id
    WHERE pc.promedio_componente IS NOT NULL
    GROUP BY
        mu.materia_usuario_id,
        mu.materia_usuario_usuario_id,
        mu.materia_usuario_semestre_id,
        m.materia_nombre,
        m.materia_codigo,
        m.materia_creditos,
        t.tipologia_cuenta_promedio,
        mu.materia_usuario_estado;


-- Vista: promedio ponderado por créditos de cada semestre
-- Solo incluye materias cuya tipología cuenta para el promedio
CREATE VIEW v_promedio_semestre AS
    SELECT
        vm.usuario_id,
        vm.semestre_id,
        s.semestre_year                             AS year,
        s.semestre_periodo                          AS periodo,
        s.semestre_numero                           AS numero_semestre,
        ROUND(
            SUM(vm.nota_final * vm.creditos)
            / NULLIF(SUM(vm.creditos), 0)
        , 2)                                        AS promedio_semestre,
        SUM(vm.creditos)                            AS creditos_cursados
    FROM v_nota_materia vm
    JOIN semestre s ON s.semestre_id = vm.semestre_id
    WHERE vm.nota_final   IS NOT NULL
      AND vm.cuenta_promedio = 1
    GROUP BY vm.usuario_id, vm.semestre_id,
             s.semestre_year, s.semestre_periodo, s.semestre_numero;


-- Vista: promedio global acumulado (equivalente al PAPA en UNAL)
-- Solo cuenta materias aprobadas/reprobadas, excluye tipologías sin promedio
CREATE VIEW v_promedio_global AS
    SELECT
        vm.usuario_id,
        ROUND(
            SUM(vm.nota_final * vm.creditos)
            / NULLIF(SUM(vm.creditos), 0)
        , 2)                                        AS promedio_global,
        SUM(vm.creditos)                            AS total_creditos_cursados,
        SUM(CASE WHEN vm.estado = 'aprobada' THEN vm.creditos ELSE 0 END)
                                                    AS total_creditos_aprobados
    FROM v_nota_materia vm
    WHERE vm.estado         IN ('aprobada', 'reprobada')
      AND vm.cuenta_promedio = 1
    GROUP BY vm.usuario_id;


-- Vista: avance por tipología (créditos aprobados vs requeridos)
CREATE VIEW v_avance_tipologia AS
    SELECT
        u.usuario_id,
        t.tipologia_id,
        t.tipologia_nombre                          AS tipologia,
        t.tipologia_creditos_requeridos             AS creditos_requeridos,
        t.tipologia_cuenta_promedio                 AS cuenta_promedio,
        COALESCE(SUM(
            CASE WHEN mu.materia_usuario_estado = 'aprobada'
                 THEN m.materia_creditos ELSE 0 END
        ), 0)                                       AS creditos_aprobados
    FROM usuario u
    JOIN programa  p  ON p.programa_id          = u.usuario_programa_id
    JOIN tipologia t  ON t.tipologia_programa_id = p.programa_id
    LEFT JOIN materia m
           ON m.materia_tipologia_id = t.tipologia_id
    LEFT JOIN materia_usuario mu
           ON mu.materia_usuario_materia_id = m.materia_id
          AND mu.materia_usuario_usuario_id = u.usuario_id
    GROUP BY u.usuario_id, t.tipologia_id,
             t.tipologia_nombre, t.tipologia_creditos_requeridos,
             t.tipologia_cuenta_promedio;


-- ============================================================
--  DATOS DE PRUEBA - UNAL Bogotá / Ingeniería de Sistemas
-- ============================================================

INSERT INTO universidad (universidad_nombre, universidad_sigla, universidad_pais, universidad_ciudad) VALUES
    ('Universidad Nacional de Colombia', 'UNAL', 'Colombia', 'Bogotá');

INSERT INTO programa (programa_universidad_id, programa_nombre, programa_facultad, programa_total_creditos) VALUES
    (1, 'Ingeniería de Sistemas y Computación', 'Facultad de Ingeniería', 165);

-- tipologia_cuenta_promedio = 0 → NIVELACIÓN no afecta el promedio
INSERT INTO tipologia (tipologia_programa_id, tipologia_nombre, tipologia_creditos_requeridos, tipologia_cuenta_promedio) VALUES
    (1, 'FUND. OBLIGATORIA',        15, 1),
    (1, 'FUND. OPTATIVA',           36, 1),
    (1, 'DISCIPLINAR OBLIGATORIA',  39, 1),
    (1, 'DISCIPLINAR OPTATIVA',     36, 1),
    (1, 'LIBRE ELECCIÓN',           33, 1),
    (1, 'TRABAJO DE GRADO',          6, 1),
    (1, 'NIVELACIÓN',               12, 0);

INSERT INTO materia (materia_programa_id, materia_tipologia_id, materia_codigo, materia_nombre, materia_creditos, materia_nota_minima_aprobacion, materia_semestre_sugerido) VALUES
    -- FUND. OBLIGATORIA (tipologia_id = 1)
    (1, 1, '1000001-B', 'Matemáticas Fundamentales',                 4, 3.0, 1),
    (1, 1, '1000004-B', 'Cálculo Diferencial',                       4, 3.0, 1),
    (1, 1, '1000002-B', 'Cálculo Integral',                          4, 3.0, 2),
    -- FUND. OPTATIVA (tipologia_id = 2)
    (1, 2, '1000003-B', 'Álgebra Lineal',                            4, 3.0, 3),
    (1, 2, '1000005-B', 'Ecuaciones Diferenciales',                  4, 3.0, 4),
    -- DISCIPLINAR OBLIGATORIA (tipologia_id = 3)
    (1, 3, '2025975',   'Introducción a la Ingeniería de Sistemas',  3, 3.0, 1),
    (1, 3, '2016703',   'Pensamiento Sistémico',                     3, 3.0, 1),
    (1, 3, '2015734',   'Programación de Computadores',              3, 3.0, 2),
    (1, 3, '2016375',   'Programación Orientada a Objetos',          3, 3.0, 2),
    (1, 3, '2015456',   'Estructuras de Datos',                      3, 3.0, 3),
    (1, 3, '2015689',   'Bases de Datos',                            3, 3.0, 4),
    (1, 3, '2015701',   'Ingeniería de Software',                    3, 3.0, 5),
    -- NIVELACIÓN (tipologia_id = 7)
    (1, 7, '1000044-B', 'Inglés I - Semestral',                      3, 3.0, NULL),
    (1, 7, '1000045-B', 'Inglés II - Semestral',                     3, 3.0, NULL),
    (1, 7, '1000046-B', 'Inglés III - Semestral',                    3, 3.0, NULL),
    (1, 7, '1000047-B', 'Inglés IV - Semestral',                     3, 3.0, NULL);
