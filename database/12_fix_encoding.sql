-- ============================================================
-- UNIGRADES - 12_fix_encoding.sql
-- Corrige los nombres de materias y tipologías que quedaron
-- con encoding incorrecto (latin1 leído como utf8mb4).
-- El patrón: las letras acentuadas quedaron como secuencias
-- tipo CÃ¡lculo → Cálculo
-- EJECUTAR EN RAILWAY
-- ============================================================

USE unigrades;

SET NAMES utf8mb4;
SET character_set_connection = utf8mb4;

-- Actualizar nombres de materias con tildes corruptas
-- Técnica: convert(convert(materia_nombre using latin1) using utf8mb4)
UPDATE materia 
SET materia_nombre = CONVERT(CONVERT(materia_nombre USING latin1) USING utf8mb4)
WHERE materia_nombre REGEXP '[Ã]|[Â]';

-- Actualizar nombres de tipologías
UPDATE tipologia 
SET tipologia_nombre = CONVERT(CONVERT(tipologia_nombre USING latin1) USING utf8mb4)
WHERE tipologia_nombre REGEXP '[Ã]|[Â]';

-- Verificar resultado
SELECT materia_nombre FROM materia 
WHERE materia_nombre LIKE '%lculo%' 
   OR materia_nombre LIKE '%temas%'
   OR materia_nombre LIKE '%rogramaci%'
LIMIT 10;
