-- ============================================================
--  UNIGRADES - Datos de prueba para desarrollo
-- ============================================================

USE unigrades;

-- ------------------------------------------------------------
-- USUARIO de prueba
-- password: test1234 (hash bcrypt placeholder)
-- ------------------------------------------------------------
INSERT INTO usuario (usuario_programa_id, usuario_nombre, usuario_apellido, usuario_email, usuario_password_hash, usuario_codigo_estudiantil) VALUES
    (1, 'Sergio', 'Chaves', 'sechaves@unal.edu.co', '$2b$10$placeholderhashaqui', '1000123456');

-- ------------------------------------------------------------
-- SEMESTRES del usuario 1
-- ------------------------------------------------------------
INSERT INTO semestre (semestre_usuario_id, semestre_numero, semestre_year, semestre_periodo) VALUES
    (1, 1, 2025, 2),   -- 2025-2S  (semestre actual)
    (1, 2, 2026, 1);   -- 2026-1S  (próximo)

-- ------------------------------------------------------------
-- MATERIAS inscritas en 2025-2S (semestre_id = 1)
-- materia_id 6 = Introducción a la Ingeniería de Sistemas
-- materia_id 7 = Pensamiento Sistémico
-- materia_id 8 = Programación de Computadores
-- materia_id 2 = Cálculo Diferencial
-- materia_id 13 = Inglés I
-- ------------------------------------------------------------
INSERT INTO materia_usuario (materia_usuario_usuario_id, materia_usuario_materia_id, materia_usuario_semestre_id, materia_usuario_estado) VALUES
    (1, 6,  1, 'aprobada'),   -- Intro Ingeniería  → aprobada
    (1, 7,  1, 'aprobada'),   -- Pensamiento Sist. → aprobada
    (1, 8,  1, 'aprobada'),   -- Prog. Computadores→ aprobada
    (1, 2,  1, 'aprobada'),   -- Cálculo Diferencial → aprobada
    (1, 13, 1, 'aprobada');   -- Inglés I           → aprobada

-- ------------------------------------------------------------
-- COMPONENTES y NOTAS — Introducción a la Ingeniería (mu_id=1)
-- ------------------------------------------------------------
INSERT INTO componente (componente_materia_usuario_id, componente_nombre, componente_porcentaje, componente_nota_minima, componente_orden) VALUES
    (1, 'Parcial 01',  25.00, 3.0, 1),
    (1, 'Parcial 02',  25.00, 3.0, 2),
    (1, 'Proyecto',    30.00, 3.0, 3),
    (1, 'Talleres',    20.00, NULL, 4);

-- Notas componente 1 (Parcial 01 - una sola nota)
INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro) VALUES
    (1, 'Parcial 01', 4.7, '2025-09-20');

-- Notas componente 2 (Parcial 02 - una sola nota)
INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro) VALUES
    (2, 'Parcial 02', 4.5, '2025-11-01');

-- Notas componente 3 (Proyecto - una sola nota)
INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro) VALUES
    (3, 'Proyecto Final', 5.0, '2025-11-20');

-- Notas componente 4 (Talleres - múltiples notas acumuladas)
INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro) VALUES
    (4, 'Taller 1', 4.5, '2025-09-05'),
    (4, 'Taller 2', 5.0, '2025-09-19'),
    (4, 'Taller 3', 4.0, '2025-10-03'),
    (4, 'Taller 4', 4.8, '2025-10-17');

-- ------------------------------------------------------------
-- COMPONENTES y NOTAS — Pensamiento Sistémico (mu_id=2)
-- ------------------------------------------------------------
INSERT INTO componente (componente_materia_usuario_id, componente_nombre, componente_porcentaje, componente_nota_minima, componente_orden) VALUES
    (2, 'Parcial 01',  25.00, 3.0, 1),
    (2, 'Parcial 02',  25.00, 3.0, 2),
    (2, 'Parcial 03',  25.00, 3.0, 3),
    (2, 'Taller',      25.00, NULL, 4);

INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro) VALUES
    (5, 'Parcial 01', 4.5, '2025-09-18'),
    (6, 'Parcial 02', 3.8, '2025-10-30'),
    (7, 'Parcial 03', 4.2, '2025-11-25'),
    (8, 'Taller',     4.0, '2025-11-10');

-- ------------------------------------------------------------
-- COMPONENTES y NOTAS — Programación de Computadores (mu_id=3)
-- ------------------------------------------------------------
INSERT INTO componente (componente_materia_usuario_id, componente_nombre, componente_porcentaje, componente_nota_minima, componente_orden) VALUES
    (3, 'Parcial 01',  25.00, 3.0, 1),
    (3, 'Parcial 02',  25.00, 3.0, 2),
    (3, 'Parcial 03',  25.00, 3.0, 3),
    (3, 'Proyecto',    25.00, NULL, 4);

INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro) VALUES
    (9,  'Parcial 01', 4.4, '2025-09-15'),
    (10, 'Parcial 02', 4.1, '2025-10-27'),
    (11, 'Parcial 03', 4.6, '2025-11-24'),
    (12, 'Proyecto',   4.8, '2025-11-28');

-- ------------------------------------------------------------
-- COMPONENTES y NOTAS — Cálculo Diferencial (mu_id=4)
-- ------------------------------------------------------------
INSERT INTO componente (componente_materia_usuario_id, componente_nombre, componente_porcentaje, componente_nota_minima, componente_orden) VALUES
    (4, 'Parcial 01',  25.00, 3.0, 1),
    (4, 'Parcial 02',  25.00, 3.0, 2),
    (4, 'Parcial 03',  25.00, 3.0, 3),
    (4, 'Quices',      25.00, NULL, 4);

INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro) VALUES
    (13, 'Parcial 01', 3.8, '2025-09-12'),
    (14, 'Parcial 02', 3.5, '2025-10-24'),
    (15, 'Parcial 03', 4.0, '2025-11-21'),
    (16, 'Quiz 1', 4.2, '2025-09-05'),
    (16, 'Quiz 2', 3.8, '2025-10-03'),
    (16, 'Quiz 3', 4.5, '2025-11-07');

-- ------------------------------------------------------------
-- COMPONENTES y NOTAS — Inglés I (mu_id=5, no cuenta promedio)
-- ------------------------------------------------------------
INSERT INTO componente (componente_materia_usuario_id, componente_nombre, componente_porcentaje, componente_nota_minima, componente_orden) VALUES
    (5, 'Validación por Suficiencia', 100.00, 3.0, 1);

INSERT INTO nota (nota_componente_id, nota_nombre, nota_valor, nota_fecha_registro) VALUES
    (17, 'Examen de Suficiencia', 4.0, '2025-08-15');
