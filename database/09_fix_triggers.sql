-- ============================================================
-- UNIGRADES - 09_fix_triggers.sql
-- Triggers para recalcular estado en UPDATE y DELETE de nota.
-- EJECUTAR EN RAILWAY — abrir en DBeaver, seleccionar TODO
-- y usar: SQL Editor > Execute Script (Ctrl+Shift+Enter)
-- NO usar Ctrl+Enter (ejecuta statement a statement)
-- ============================================================

USE unigrades;

DROP PROCEDURE IF EXISTS sp_recalcular_estado_materia;

DELIMITER $$

CREATE PROCEDURE sp_recalcular_estado_materia(
    IN p_materia_usuario_id INT UNSIGNED
)
recalc: BEGIN
    DECLARE v_nota_minima         DECIMAL(3,1);
    DECLARE v_porcentaje_evaluado DECIMAL(6,2);
    DECLARE v_nota_final          DECIMAL(4,2);
    DECLARE v_estado_actual       VARCHAR(20);

    SELECT m.materia_nota_minima_aprobacion,
           mu.materia_usuario_estado
    INTO   v_nota_minima,
           v_estado_actual
    FROM   materia_usuario AS mu
    INNER JOIN materia AS m
        ON m.materia_id = mu.materia_usuario_materia_id
    WHERE  mu.materia_usuario_id = p_materia_usuario_id;

    -- No recalcular si fue retirada
    IF v_estado_actual = 'retirada' THEN
        LEAVE recalc;
    END IF;

    -- Calcular porcentaje evaluado y nota final
    SELECT ROUND(SUM(pc.componente_porcentaje), 2),
           ROUND(SUM(pc.promedio_componente * pc.componente_porcentaje / 100), 2)
    INTO   v_porcentaje_evaluado,
           v_nota_final
    FROM   v_promedio_componente AS pc
    WHERE  pc.componente_materia_usuario_id = p_materia_usuario_id
      AND  pc.promedio_componente IS NOT NULL;

    IF v_porcentaje_evaluado = 100.00 THEN
        IF v_nota_final >= v_nota_minima THEN
            UPDATE materia_usuario
            SET    materia_usuario_estado = 'aprobada'
            WHERE  materia_usuario_id = p_materia_usuario_id;
        ELSE
            UPDATE materia_usuario
            SET    materia_usuario_estado = 'reprobada'
            WHERE  materia_usuario_id = p_materia_usuario_id;
        END IF;
    ELSE
        -- Si ya no está al 100%, volver a en_curso
        UPDATE materia_usuario
        SET    materia_usuario_estado = 'en_curso'
        WHERE  materia_usuario_id = p_materia_usuario_id
          AND  materia_usuario_estado != 'retirada';
    END IF;

END recalc$$

DELIMITER ;

-- Trigger AFTER UPDATE en nota
DROP TRIGGER IF EXISTS trg_actualizar_estado_materia_update;

DELIMITER $$

CREATE TRIGGER trg_actualizar_estado_materia_update
AFTER UPDATE ON nota
FOR EACH ROW
BEGIN
    DECLARE v_mu_id INT UNSIGNED;
    SELECT componente_materia_usuario_id INTO v_mu_id
    FROM   componente WHERE componente_id = NEW.nota_componente_id;
    CALL sp_recalcular_estado_materia(v_mu_id);
END$$

DELIMITER ;

-- Trigger AFTER DELETE en nota
DROP TRIGGER IF EXISTS trg_actualizar_estado_materia_delete;

DELIMITER $$

CREATE TRIGGER trg_actualizar_estado_materia_delete
AFTER DELETE ON nota
FOR EACH ROW
BEGIN
    DECLARE v_mu_id INT UNSIGNED;
    SELECT componente_materia_usuario_id INTO v_mu_id
    FROM   componente WHERE componente_id = OLD.nota_componente_id;
    CALL sp_recalcular_estado_materia(v_mu_id);
END$$

DELIMITER ;

-- Verificar
SHOW TRIGGERS FROM unigrades LIKE 'trg_actualizar%';
