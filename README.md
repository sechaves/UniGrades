| universidad | universidad_ciudad | VARCHAR(80) | â€” | Ciudad sede. |
| universidad | universidad_logo_url | VARCHAR(255) | â€” | URL del logo institucional. |
| universidad | universidad_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro en el sistema. |

### 5.2 Programa

| Entidad | Atributo | Tipo | RestricciÃ³n | DescripciÃ³n |
|---|---|---|---|---|
| programa | programa_id | INT UNSIGNED | PK, AUTO_INCREMENT | Identificador Ãºnico del programa. |
| programa | programa_universidad_id | INT UNSIGNED | FK â†’ universidad, NOT NULL | Universidad a la que pertenece el programa. |
| programa | programa_nombre | VARCHAR(150) | NOT NULL | Nombre del programa acadÃ©mico. |
| programa | programa_facultad | VARCHAR(150) | â€” | Facultad a la que adscribe el programa. |
| programa | programa_total_creditos | SMALLINT UNSIGNED | NOT NULL, DEFAULT 0 | CrÃ©ditos totales exigidos por el pÃ©nsum. |
| programa | programa_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro. |

### 5.3 TipologÃ­a

| Entidad | Atributo | Tipo | RestricciÃ³n | DescripciÃ³n |
|---|---|---|---|---|
| tipologia | tipologia_id | INT UNSIGNED | PK, AUTO_INCREMENT | Identificador Ãºnico de la tipologÃ­a. |
| tipologia | tipologia_programa_id | INT UNSIGNED | FK â†’ programa, NOT NULL | Programa al que pertenece la tipologÃ­a. |
| tipologia | tipologia_nombre | VARCHAR(100) | NOT NULL | Nombre de la tipologÃ­a (ej. Disciplinar Obligatoria). |
| tipologia | tipologia_creditos_requeridos | SMALLINT UNSIGNED | NOT NULL, DEFAULT 0 | CrÃ©ditos mÃ­nimos exigidos en esta tipologÃ­a. |
| tipologia | tipologia_cuenta_promedio | TINYINT(1) | NOT NULL, DEFAULT 1 | Indica si esta tipologÃ­a se incluye en el cÃ¡lculo del promedio. |
| tipologia | tipologia_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro. |

### 5.4 Materia

| Entidad | Atributo | Tipo | RestricciÃ³n | DescripciÃ³n |
|---|---|---|---|---|
| materia | materia_id | INT UNSIGNED | PK, AUTO_INCREMENT | Identificador Ãºnico de la materia. |
| materia | materia_programa_id | INT UNSIGNED | FK â†’ programa, NOT NULL | Programa al que pertenece la materia. |
| materia | materia_tipologia_id | INT UNSIGNED | FK â†’ tipologia, NOT NULL | TipologÃ­a de la materia. |
| materia | materia_codigo | VARCHAR(30) | UNIQUE (con programa) | CÃ³digo institucional de la materia. |
| materia | materia_nombre | VARCHAR(150) | NOT NULL | Nombre de la materia. |
| materia | materia_creditos | TINYINT UNSIGNED | NOT NULL, DEFAULT 3 | NÃºmero de crÃ©ditos de la materia. |
| materia | materia_nota_minima_aprobacion | DECIMAL(3,1) | NOT NULL, DEFAULT 3.0 | Nota mÃ­nima para aprobar la materia. |
| materia | materia_semestre_sugerido | TINYINT UNSIGNED | â€” | Semestre sugerido en el pÃ©nsum. |
| materia | materia_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro. |

### 5.5 Usuario

| Entidad | Atributo | Tipo | RestricciÃ³n | DescripciÃ³n |
|---|---|---|---|---|
| usuario | usuario_id | INT UNSIGNED | PK, AUTO_INCREMENT | Identificador Ãºnico del estudiante. |
| usuario | usuario_programa_id | INT UNSIGNED | FK â†’ programa, NOT NULL | Programa en el que estÃ¡ inscrito. |
| usuario | usuario_nombre | VARCHAR(100) | NOT NULL | Nombre del estudiante. |
| usuario | usuario_apellido | VARCHAR(100) | NOT NULL | Apellido del estudiante. |
| usuario | usuario_email | VARCHAR(150) | NOT NULL, UNIQUE | Correo electrÃ³nico de acceso. |
| usuario | usuario_password_hash | VARCHAR(255) | NOT NULL | ContraseÃ±a cifrada. |
| usuario | usuario_codigo_estudiantil | VARCHAR(20) | â€” | CÃ³digo institucional del estudiante. |
| usuario | usuario_avatar_url | VARCHAR(255) | â€” | URL de la foto de perfil. |
| usuario | usuario_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro. |

### 5.6 Semestre

| Entidad | Atributo | Tipo | RestricciÃ³n | DescripciÃ³n |
|---|---|---|---|---|
| semestre | semestre_id | INT UNSIGNED | PK, AUTO_INCREMENT | Identificador Ãºnico del semestre cursado. |
| semestre | semestre_usuario_id | INT UNSIGNED | FK â†’ usuario, NOT NULL | Estudiante dueÃ±o del semestre. |
| semestre | semestre_numero | TINYINT UNSIGNED | NOT NULL | NÃºmero consecutivo del semestre del estudiante. |
| semestre | semestre_year | YEAR | NOT NULL | AÃ±o calendario del periodo. |
| semestre | semestre_periodo | TINYINT UNSIGNED | NOT NULL | Periodo acadÃ©mico (1 o 2). |
| semestre | semestre_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro. |

### 5.7 Materia_usuario (entidad asociativa)

| Entidad | Atributo | Tipo | RestricciÃ³n | DescripciÃ³n |
|---|---|---|---|---|
| materia_usuario | materia_usuario_id | INT UNSIGNED | PK, AUTO_INCREMENT | Identificador Ãºnico de la matrÃ­cula. |
| materia_usuario | materia_usuario_usuario_id | INT UNSIGNED | FK â†’ usuario, NOT NULL | Estudiante que cursa la materia. |
| materia_usuario | materia_usuario_materia_id | INT UNSIGNED | FK â†’ materia, NOT NULL | Materia matriculada. |
| materia_usuario | materia_usuario_semestre_id | INT UNSIGNED | FK â†’ semestre, NOT NULL | Periodo en que se cursa. |
| materia_usuario | materia_usuario_estado | ENUM | NOT NULL, DEFAULT 'en_curso' | Estado: en_curso / aprobada / reprobada / retirada. |
| materia_usuario | materia_usuario_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro. |

### 5.8 Componente

| Entidad | Atributo | Tipo | RestricciÃ³n | DescripciÃ³n |
|---|---|---|---|---|
| componente | componente_id | INT UNSIGNED | PK, AUTO_INCREMENT | Identificador Ãºnico del componente de evaluaciÃ³n. |
| componente | componente_materia_usuario_id | INT UNSIGNED | FK â†’ materia_usuario, NOT NULL | MatrÃ­cula a la que pertenece el componente. |
| componente | componente_nombre | VARCHAR(100) | NOT NULL | Nombre del componente (ej. Parcial 1). |
| componente | componente_porcentaje | DECIMAL(5,2) | NOT NULL | Porcentaje que aporta a la nota final (0â€“100). |
| componente | componente_nota_minima | DECIMAL(3,1) | â€” | Nota mÃ­nima propia del componente. |
| componente | componente_orden | TINYINT UNSIGNED | NOT NULL, DEFAULT 1 | Orden de presentaciÃ³n del componente. |
| componente | componente_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro. |

### 5.9 Nota

| Entidad | Atributo | Tipo | RestricciÃ³n | DescripciÃ³n |
|---|---|---|---|---|
| nota | nota_id | INT UNSIGNED | PK, AUTO_INCREMENT | Identificador Ãºnico de la nota. |
| nota | nota_componente_id | INT UNSIGNED | FK â†’ componente, NOT NULL | Componente al que pertenece la nota. |
| nota | nota_nombre | VARCHAR(100) | NOT NULL | Nombre puntual (ej. Taller 1, Quiz 2). |
| nota | nota_valor | DECIMAL(3,1) | NOT NULL, CHECK (0.0â€“5.0) | Valor numÃ©rico de la nota. |
| nota | nota_fecha_registro | DATE | â€” | Fecha en que se registrÃ³ la calificaciÃ³n. |
| nota | nota_observacion | VARCHAR(255) | â€” | ObservaciÃ³n adicional sobre la nota. |
| nota | nota_created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creaciÃ³n del registro. |

---

## 6. VerificaciÃ³n contra requisitos mÃ­nimos de la SesiÃ³n 1

| Requisito | Umbral | Estado en este modelo |
|---|---|---|
| Entidades base | â‰¥ 8 | âœ… 9 entidades (universidad, programa, tipologia, materia, usuario, semestre, materia_usuario, componente, nota) |
| Relaciones M:N con atributos propios | â‰¥ 2 | âš ï¸ Solo 1 identificada (`materia_usuario`, con atributo `estado`) |
| Auto-relaciÃ³n o jerarquÃ­a | â‰¥ 1 | â Œ No presente en el modelo actual |
| Datos temporales con consultas por rango de fechas | SÃ­ | âœ… `semestre` (year/periodo) y `nota_fecha_registro` |
| Reglas de negocio no triviales | â‰¥ 2 | âœ… 8 reglas documentadas en la secciÃ³n 3 |
