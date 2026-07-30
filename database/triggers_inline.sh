#!/bin/bash
mysql -u root -p$MYSQLPASSWORD unigrades -e "DROP TRIGGER IF EXISTS trg_actualizar_estado_materia_update"
mysql -u root -p$MYSQLPASSWORD unigrades -e "DROP TRIGGER IF EXISTS trg_actualizar_estado_materia_delete"
mysql -u root -p$MYSQLPASSWORD unigrades -e "CREATE TRIGGER trg_actualizar_estado_materia_update AFTER UPDATE ON nota FOR EACH ROW CALL sp_recalcular_estado_materia((SELECT componente_materia_usuario_id FROM componente WHERE componente_id=NEW.nota_componente_id))"
mysql -u root -p$MYSQLPASSWORD unigrades -e "CREATE TRIGGER trg_actualizar_estado_materia_delete AFTER DELETE ON nota FOR EACH ROW CALL sp_recalcular_estado_materia((SELECT componente_materia_usuario_id FROM componente WHERE componente_id=OLD.nota_componente_id))"
mysql -u root -p$MYSQLPASSWORD unigrades -e "SHOW TRIGGERS FROM unigrades LIKE 'trg_actualizar%'"
