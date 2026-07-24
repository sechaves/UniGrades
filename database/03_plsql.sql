-- ============================================================
-- UNIGRADES - 03_plsql.sql
-- Triggers, procedimientos almacenados y funciones
-- Sesión 3 - PL/SQL (MySQL)
--
-- NOTA SOBRE COMPATIBILIDAD:
-- Este archivo es 100% compatible con MySQL 8.0+.
-- Para ejecutarlo correctamente desde un cliente de línea de
-- comandos (mysql CLI), el archivo se puede cargar completo:
--     mysql -u root -p unigrades < 03_plsql.sql
-- Desde MySQL Workbench: ejecutar el script completo con
-- Ctrl+Shift+Enter (Run Script), NO con Ctrl+Enter (Run Statement),
-- ya que este archivo contiene múltiples delimitadores.
-- ============================================================

USE unigrades;

-- ============================================================
-- TRIGGERS AUXILIARES: validar que una materia no sea
-- prerrequisito ni correquisito de sí misma.
-- MySQL 3823 impide CHECK en columnas FK, se resuelve con trigger.
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_validar_prerrequisito_diferente
BEFORE INSERT ON materia_prerrequisito
FOR EACH ROW
BEGIN
    IF NEW.materia_id = NEW.prerrequisito_materia_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una materia no puede ser prerrequisito de sí misma.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_validar_correquisito_diferente
BEFORE INSERT ON materia_correquisito
FOR EACH ROW
BEGIN
    IF NEW.materia_id = NEW.correquisito_materia_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una materia no puede ser correquisito de sí misma.';
    END IF;
END$$

DELIMITER ;

-- ============================================================
-- TRIGGER 1: trg_validar_porcentaje_componente
--
-- Propósito: garantizar que la suma de porcentajes de todos los
-- componentes de una misma materia_usuario no supere 100.00.
-- Esta regla no puede expresarse con CHECK porque involucra
-- múltiples filas de la misma tabla.
--
-- Se dispara: BEFORE INSERT y BEFORE UPDATE en componente.
-- Entidades: componente → materia_usuario
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_validar_porcentaje_insert
BEFORE INSERT ON componente
FOR EACH ROW
BEGIN
    DECLARE v_suma_actual DECIMAL(6,2);

    SELECT COALESCE(SUM(componente_porcentaje), 0)
    INTO   v_suma_actual
    FROM   componente
    WHERE  componente_materia_usuario_id = NEW.componente_materia_usuario_id;

    IF (v_suma_actual + NEW.componente_porcentaje) > 100.00 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'La suma de porcentajes de los componentes supera 100. Ajuste el valor antes de insertar.';
    END IF;
END$$

DELIMITER ;

-- ----------------------------------------------------------

DELIMITER $$

CREATE TRIGGER trg_validar_porcentaje_update
BEFORE UPDATE ON componente
FOR EACH ROW
BEGIN
    DECLARE v_suma_sin_actual DECIMAL(6,2);

    -- Suma de los demás componentes (excluye el que se está actualizando)
    SELECT COALESCE(SUM(componente_porcentaje), 0)
    INTO   v_suma_sin_actual
    FROM   componente
    WHERE  componente_materia_usuario_id = NEW.componente_materia_usuario_id
      AND  componente_id <> OLD.componente_id;

    IF (v_suma_sin_actual + NEW.componente_porcentaje) > 100.00 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'La suma de porcentajes de los componentes supera 100. Ajuste el valor antes de actualizar.';
    END IF;
END$$

DELIMITER ;

-- ============================================================
-- TRIGGER 2: trg_actualizar_estado_materia
--
-- Propósito: cuando se inserta una nota en un componente y la
-- materia ya tiene nota_final calculable (porcentaje_evaluado = 100),
-- actualizar automáticamente el estado de materia_usuario a
-- 'aprobada' o 'reprobada' según la nota_minima_aprobacion.
--
-- Se dispara: AFTER INSERT en nota.
-- Entidades: nota → componente → materia_usuario → materia
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_actualizar_estado_materia
AFTER INSERT ON nota
FOR EACH ROW
BEGIN
    DECLARE v_materia_usuario_id   INT UNSIGNED;
    DECLARE v_materia_id           INT UNSIGNED;
    DECLARE v_nota_minima          DECIMAL(3,1);
    DECLARE v_porcentaje_evaluado  DECIMAL(6,2);
    DECLARE v_nota_final           DECIMAL(4,2);
    DECLARE v_estado_actual        VARCHAR(20);

    -- Obtener el materia_usuario_id a partir del componente de la nota
    SELECT c.componente_materia_usuario_id
    INTO   v_materia_usuario_id
    FROM   componente AS c
    WHERE  c.componente_id = NEW.nota_componente_id;

    -- Obtener el materia_id y su nota mínima de aprobación
    SELECT mu.materia_usuario_materia_id,
           m.materia_nota_minima_aprobacion,
           mu.materia_usuario_estado
    INTO   v_materia_id,
           v_nota_minima,
           v_estado_actual
    FROM   materia_usuario AS mu
    INNER JOIN materia AS m
        ON m.materia_id = mu.materia_usuario_materia_id
    WHERE  mu.materia_usuario_id = v_materia_usuario_id;

    -- Solo actuar si la materia sigue en_curso (no modificar estados ya cerrados)
    IF v_estado_actual = 'en_curso' THEN

        -- Calcular el porcentaje evaluado y la nota acumulada
        SELECT ROUND(SUM(pc.componente_porcentaje), 2),
               ROUND(SUM(pc.promedio_componente * pc.componente_porcentaje / 100), 2)
        INTO   v_porcentaje_evaluado,
               v_nota_final
        FROM   v_promedio_componente AS pc
        WHERE  pc.componente_materia_usuario_id = v_materia_usuario_id
          AND  pc.promedio_componente IS NOT NULL;

        -- Solo cerrar la materia cuando el 100% ha sido evaluado
        IF v_porcentaje_evaluado = 100.00 THEN
            IF v_nota_final >= v_nota_minima THEN
                UPDATE materia_usuario
                SET    materia_usuario_estado = 'aprobada'
                WHERE  materia_usuario_id = v_materia_usuario_id;
            ELSE
                UPDATE materia_usuario
                SET    materia_usuario_estado = 'reprobada'
                WHERE  materia_usuario_id = v_materia_usuario_id;
            END IF;
        END IF;

    END IF;
END$$

DELIMITER ;

-- ============================================================
-- FUNCIÓN 1: fn_promedio_semestre
--
-- Propósito: calcular el promedio ponderado por créditos de un
-- estudiante en un semestre específico. Solo incluye materias
-- cuya tipología cuenta para el promedio y que tienen nota final.
--
-- Parámetros:
--   p_usuario_id  → id del estudiante
--   p_semestre_id → id del semestre
--
-- Retorna: DECIMAL(4,2) — promedio ponderado, o NULL si no hay datos
-- ============================================================

DELIMITER $$

CREATE FUNCTION fn_promedio_semestre(
    p_usuario_id  INT UNSIGNED,
    p_semestre_id INT UNSIGNED
)
RETURNS DECIMAL(4,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_promedio DECIMAL(4,2);

    SELECT ROUND(
               SUM(vm.nota_final * vm.creditos)
               / NULLIF(SUM(vm.creditos), 0),
               2
           )
    INTO   v_promedio
    FROM   v_nota_materia AS vm
    WHERE  vm.usuario_id       = p_usuario_id
      AND  vm.semestre_id      = p_semestre_id
      AND  vm.nota_final       IS NOT NULL
      AND  vm.cuenta_promedio  = 1;

    RETURN v_promedio;
END$$

DELIMITER ;

-- ============================================================
-- FUNCIÓN 2: fn_creditos_aprobados_tipologia
--
-- Propósito: retornar el total de créditos aprobados por un
-- estudiante en una tipología determinada. Útil para calcular
-- el avance de graduación por componente curricular.
--
-- Parámetros:
--   p_usuario_id   → id del estudiante
--   p_tipologia_id → id de la tipología
--
-- Retorna: SMALLINT UNSIGNED — suma de créditos aprobados
-- ============================================================

DELIMITER $$

CREATE FUNCTION fn_creditos_aprobados_tipologia(
    p_usuario_id   INT UNSIGNED,
    p_tipologia_id INT UNSIGNED
)
RETURNS SMALLINT UNSIGNED
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_creditos SMALLINT UNSIGNED DEFAULT 0;

    SELECT COALESCE(SUM(m.materia_creditos), 0)
    INTO   v_creditos
    FROM   materia_usuario  AS mu
    INNER JOIN semestre      AS s
        ON s.semestre_id = mu.materia_usuario_semestre_id
    INNER JOIN materia       AS m
        ON m.materia_id  = mu.materia_usuario_materia_id
    WHERE  s.semestre_usuario_id        = p_usuario_id
      AND  m.materia_tipologia_id       = p_tipologia_id
      AND  mu.materia_usuario_estado    = 'aprobada';

    RETURN v_creditos;
END$$

DELIMITER ;

-- ============================================================
-- PROCEDIMIENTO 1: sp_resumen_academico_usuario
--
-- Propósito: generar el resumen académico completo de un
-- estudiante: promedio global, créditos cursados, créditos
-- aprobados y promedio de cada semestre cursado.
--
-- Incluye: cursor sobre los semestres del estudiante +
-- manejo de excepciones (NOT FOUND y errores generales).
--
-- Parámetro:
--   p_usuario_id → id del estudiante
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_resumen_academico_usuario(
    IN p_usuario_id INT UNSIGNED
)
BEGIN
    -- Variables del cursor
    DECLARE v_semestre_id      INT UNSIGNED;
    DECLARE v_semestre_numero  TINYINT UNSIGNED;
    DECLARE v_year             YEAR;
    DECLARE v_periodo          TINYINT UNSIGNED;
    DECLARE v_promedio_sem     DECIMAL(4,2);
    DECLARE v_creditos_sem     SMALLINT UNSIGNED;
    DECLARE v_fin_cursor       BOOLEAN DEFAULT FALSE;

    -- Variables del resumen global
    DECLARE v_promedio_global  DECIMAL(4,2);
    DECLARE v_total_cursados   SMALLINT UNSIGNED;
    DECLARE v_total_aprobados  SMALLINT UNSIGNED;
    DECLARE v_nombre_usuario   VARCHAR(201);

    -- Cursor: recorre los semestres del estudiante
    -- (debe declararse ANTES que los handlers; MySQL exige el orden
    --  variables/condiciones -> cursores -> handlers, si no falla
    --  con error 1338 "Cursor declaration after handler declaration")
    DECLARE cur_semestres CURSOR FOR
        SELECT s.semestre_id,
               s.semestre_numero,
               s.semestre_year,
               s.semestre_periodo
        FROM   semestre AS s
        WHERE  s.semestre_usuario_id = p_usuario_id
        ORDER  BY s.semestre_year, s.semestre_periodo;

    -- Manejo de excepciones
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_fin_cursor = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Validar que el usuario existe
    SELECT CONCAT(usuario_nombre, ' ', usuario_apellido)
    INTO   v_nombre_usuario
    FROM   usuario
    WHERE  usuario_id = p_usuario_id;

    IF v_nombre_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario especificado no existe.';
    END IF;

    -- Obtener datos del promedio global
    SELECT COALESCE(pg.promedio_global, 0),
           COALESCE(pg.total_creditos_cursados, 0),
           COALESCE(pg.total_creditos_aprobados, 0)
    INTO   v_promedio_global,
           v_total_cursados,
           v_total_aprobados
    FROM   v_promedio_global AS pg
    WHERE  pg.usuario_id = p_usuario_id;

    -- Resultado 1: encabezado del estudiante
    SELECT v_nombre_usuario        AS estudiante,
           v_promedio_global       AS promedio_global,
           v_total_cursados        AS creditos_cursados,
           v_total_aprobados       AS creditos_aprobados;

    -- Resultado 2: detalle por semestre usando cursor
    -- Tabla temporal para acumular resultados del cursor
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_semestres_resumen (
        semestre_numero  TINYINT UNSIGNED,
        periodo          VARCHAR(10),
        promedio         DECIMAL(4,2),
        creditos         SMALLINT UNSIGNED
    );

    TRUNCATE TABLE tmp_semestres_resumen;

    OPEN cur_semestres;

    loop_semestres: LOOP
        FETCH cur_semestres
        INTO  v_semestre_id,
              v_semestre_numero,
              v_year,
              v_periodo;

        IF v_fin_cursor THEN
            LEAVE loop_semestres;
        END IF;

        SET v_promedio_sem = fn_promedio_semestre(p_usuario_id, v_semestre_id);

        SELECT COALESCE(SUM(vm.creditos), 0)
        INTO   v_creditos_sem
        FROM   v_nota_materia AS vm
        WHERE  vm.usuario_id  = p_usuario_id
          AND  vm.semestre_id = v_semestre_id
          AND  vm.nota_final  IS NOT NULL;

        INSERT INTO tmp_semestres_resumen
            (semestre_numero, periodo, promedio, creditos)
        VALUES
            (v_semestre_numero,
             CONCAT(v_year, '-', v_periodo, 'S'),
             v_promedio_sem,
             v_creditos_sem);

    END LOOP loop_semestres;

    CLOSE cur_semestres;

    SELECT * FROM tmp_semestres_resumen
    ORDER  BY semestre_numero;

    DROP TEMPORARY TABLE IF EXISTS tmp_semestres_resumen;

END$$

DELIMITER ;

-- ============================================================
-- PROCEDIMIENTO 2: sp_inscribir_materia
--
-- Propósito: inscribir una materia para un estudiante en un
-- semestre, validando reglas de negocio antes de insertar:
--   1. El semestre debe pertenecer al usuario.
--   2. La materia debe pertenecer al mismo programa del usuario.
--   3. La materia no puede estar ya inscrita en ese semestre.
--   4. Todos los prerrequisitos deben estar aprobados.
--   5. Si la materia fue reprobada antes, permite reinscripción
--      en un semestre diferente.
--
-- Parámetros:
--   p_usuario_id  → id del estudiante
--   p_materia_id  → id de la materia a inscribir
--   p_semestre_id → id del semestre destino
--   p_mensaje     → OUT: resultado de la operación
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_inscribir_materia(
    IN  p_usuario_id  INT UNSIGNED,
    IN  p_materia_id  INT UNSIGNED,
    IN  p_semestre_id INT UNSIGNED,
    OUT p_mensaje     VARCHAR(255)
)
sp_inscribir_materia: BEGIN
    DECLARE v_programa_usuario         INT UNSIGNED;
    DECLARE v_programa_materia         INT UNSIGNED;
    DECLARE v_semestre_usuario         INT UNSIGNED;
    DECLARE v_ya_aprobada              TINYINT DEFAULT 0;
    DECLARE v_ya_inscrita_semestre     TINYINT DEFAULT 0;
    DECLARE v_prereqs_pendientes       INT DEFAULT 0;
    DECLARE v_nombre_prereq_pendiente  VARCHAR(150) DEFAULT '';
    DECLARE v_nuevo_id                 INT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mensaje = 'Error interno al inscribir la materia. Operación revertida.';
        RESIGNAL;
    END;

    START TRANSACTION;

    -- 1. Obtener programa del usuario
    SELECT usuario_programa_id
    INTO   v_programa_usuario
    FROM   usuario
    WHERE  usuario_id = p_usuario_id;

    IF v_programa_usuario IS NULL THEN
        SET p_mensaje = 'El usuario no existe.';
        ROLLBACK;
        LEAVE sp_inscribir_materia;
    END IF;

    -- 2. Verificar que el semestre pertenece al usuario
    SELECT semestre_usuario_id
    INTO   v_semestre_usuario
    FROM   semestre
    WHERE  semestre_id = p_semestre_id;

    IF v_semestre_usuario <> p_usuario_id THEN
        SET p_mensaje = 'El semestre no pertenece al usuario indicado.';
        ROLLBACK;
        LEAVE sp_inscribir_materia;
    END IF;

    -- 3. Verificar que la materia pertenece al programa del usuario
    SELECT t.tipologia_programa_id
    INTO   v_programa_materia
    FROM   materia    AS m
    INNER JOIN tipologia AS t
        ON t.tipologia_id = m.materia_tipologia_id
    WHERE  m.materia_id = p_materia_id;

    IF v_programa_materia <> v_programa_usuario THEN
        SET p_mensaje = 'La materia no pertenece al programa del usuario.';
        ROLLBACK;
        LEAVE sp_inscribir_materia;
    END IF;

    -- 4. Verificar si la materia ya fue aprobada
    SELECT COUNT(*)
    INTO   v_ya_aprobada
    FROM   materia_usuario AS mu
    INNER JOIN semestre    AS s
        ON s.semestre_id = mu.materia_usuario_semestre_id
    WHERE  s.semestre_usuario_id           = p_usuario_id
      AND  mu.materia_usuario_materia_id   = p_materia_id
      AND  mu.materia_usuario_estado       = 'aprobada';

    IF v_ya_aprobada > 0 THEN
        SET p_mensaje = 'La materia ya fue aprobada. No es necesario inscribirla nuevamente.';
        ROLLBACK;
        LEAVE sp_inscribir_materia;
    END IF;

    -- 5. Verificar que no esté ya inscrita en este semestre específico
    SELECT COUNT(*)
    INTO   v_ya_inscrita_semestre
    FROM   materia_usuario
    WHERE  materia_usuario_materia_id  = p_materia_id
      AND  materia_usuario_semestre_id = p_semestre_id;

    IF v_ya_inscrita_semestre > 0 THEN
        SET p_mensaje = 'La materia ya está inscrita en este semestre.';
        ROLLBACK;
        LEAVE sp_inscribir_materia;
    END IF;

    -- 6. Validar prerrequisitos: todos deben estar aprobados
    SELECT COUNT(*),
           COALESCE(MIN(m_pre.materia_nombre), '')
    INTO   v_prereqs_pendientes,
           v_nombre_prereq_pendiente
    FROM   materia_prerrequisito AS mp
    INNER JOIN materia AS m_pre
        ON m_pre.materia_id = mp.prerrequisito_materia_id
    WHERE  mp.materia_id = p_materia_id
      AND  NOT EXISTS (
               SELECT 1
               FROM   materia_usuario AS mu_pre
               INNER JOIN semestre    AS s_pre
                   ON s_pre.semestre_id = mu_pre.materia_usuario_semestre_id
               WHERE  s_pre.semestre_usuario_id         = p_usuario_id
                 AND  mu_pre.materia_usuario_materia_id = mp.prerrequisito_materia_id
                 AND  mu_pre.materia_usuario_estado     = 'aprobada'
           );

    IF v_prereqs_pendientes > 0 THEN
        SET p_mensaje = CONCAT(
            'Prerrequisito(s) no aprobado(s). Ejemplo pendiente: "',
            v_nombre_prereq_pendiente, '". Total faltantes: ',
            v_prereqs_pendientes
        );
        ROLLBACK;
        LEAVE sp_inscribir_materia;
    END IF;

    -- 7. Insertar la inscripción
    INSERT INTO materia_usuario
        (materia_usuario_materia_id, materia_usuario_semestre_id, materia_usuario_estado)
    VALUES
        (p_materia_id, p_semestre_id, 'en_curso');

    SET v_nuevo_id = LAST_INSERT_ID();

    COMMIT;

    SET p_mensaje = CONCAT(
        'Materia inscrita correctamente. materia_usuario_id = ',
        v_nuevo_id
    );

END sp_inscribir_materia$$

DELIMITER ;

-- ============================================================
-- VERIFICACIÓN: mostrar los objetos creados
-- ============================================================

SHOW TRIGGERS FROM unigrades;
SHOW PROCEDURE STATUS WHERE Db = 'unigrades';
SHOW FUNCTION  STATUS WHERE Db = 'unigrades';

-- ============================================================
-- EJEMPLOS DE USO (ejecutar por separado después del script)
-- ============================================================

-- Llamar al resumen académico del usuario 1:
-- CALL sp_resumen_academico_usuario(1);

-- Inscribir una materia (requiere que existan materia y semestre):
-- CALL sp_inscribir_materia(1, 6, 1, @msg);
-- SELECT @msg;

-- Usar las funciones directamente en una consulta:
-- SELECT fn_promedio_semestre(1, 1) AS promedio_semestre_1;
-- SELECT fn_creditos_aprobados_tipologia(1, 3) AS creditos_disciplinar_obligatoria;

-- ============================================================
-- FIN DEL ARCHIVO 03_plsql.sql
-- ============================================================