#!/bin/bash
mysql -u root -p$MYSQLPASSWORD unigrades << 'SQLEOF'
DROP TRIGGER IF EXISTS trg_actualizar_estado_materia_update;
DROP TRIGGER IF EXISTS trg_actualizar_estado_materia_delete;
CREATE TRIGGER trg_actualizar_estado_materia_update
AFTER UPDATE ON nota FOR EACH ROW
BEGIN
  DECLARE v INT UNSIGNED;
  SELECT componente_materia_usuario_id INTO v
  FROM componente WHERE componente_id = NEW.nota_componente_id;
  CALL sp_recalcular_estado_materia(v);
END;
CREATE TRIGGER trg_actualizar_estado_materia_delete
AFTER DELETE ON nota FOR EACH ROW
BEGIN
  DECLARE v INT UNSIGNED;
  SELECT componente_materia_usuario_id INTO v
  FROM componente WHERE componente_id = OLD.nota_componente_id;
  CALL sp_recalcular_estado_materia(v);
END;
SHOW TRIGGERS FROM unigrades LIKE 'trg_actualizar%';
SQLEOF
