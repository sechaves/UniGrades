# UniGrades — Contrato de API

> Este documento es el contrato entre frontend y backend.
> Cualquier cambio en endpoints, parámetros o estructura de respuesta
> debe actualizarse aquí **antes** de implementarse.

Base URL de desarrollo: `http://localhost:3001/api`

---

## Autenticación

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/auth/register` | Registrar nuevo usuario |
| POST | `/auth/login` | Login, devuelve JWT |

### POST /auth/register
```json
// Body
{ "nombre": "Sergio", "apellido": "Chaves", "email": "s@unal.edu.co",
  "password": "1234", "programa_id": 1, "codigo_estudiantil": "1000123" }

// Response 201
{ "token": "jwt...", "usuario": { "usuario_id": 1, "usuario_nombre": "Sergio" } }
```

### POST /auth/login
```json
// Body
{ "email": "s@unal.edu.co", "password": "1234" }

// Response 200
{ "token": "jwt...", "usuario": { "usuario_id": 1, "usuario_nombre": "Sergio" } }
```

---

## Universidades y Programas

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/universidades` | Lista todas las universidades |
| GET | `/universidades/:id/programas` | Programas de una universidad |

---

## Semestres

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/semestres` | Semestres del usuario autenticado |
| POST | `/semestres` | Crear nuevo semestre |
| GET | `/semestres/:id/promedio` | Promedio ponderado de un semestre |

### GET /semestres
```json
// Response 200
[
  {
    "semestre_id": 1,
    "semestre_numero": 1,
    "semestre_year": 2025,
    "semestre_periodo": 2,
    "promedio_semestre": 4.35,
    "creditos_cursados": 17
  }
]
```

### POST /semestres
```json
// Body
{ "semestre_numero": 2, "semestre_year": 2026, "semestre_periodo": 1 }

// Response 201
{ "semestre_id": 2 }
```

---

## Materias

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/materias` | Todas las materias del programa del usuario (roadmap) |
| GET | `/semestres/:id/materias` | Materias inscritas en un semestre |
| POST | `/semestres/:id/materias` | Inscribir materia en un semestre |
| PATCH | `/materias-usuario/:id/estado` | Cambiar estado de una materia |

### GET /semestres/:id/materias
```json
// Response 200
[
  {
    "materia_usuario_id": 1,
    "materia_nombre": "Introducción a la Ingeniería de Sistemas",
    "materia_codigo": "2025975",
    "materia_creditos": 3,
    "materia_usuario_estado": "aprobada",
    "nota_final": 4.72,
    "tipologia_nombre": "DISCIPLINAR OBLIGATORIA",
    "tipologia_cuenta_promedio": 1
  }
]
```

### POST /semestres/:id/materias
```json
// Body
{ "materia_id": 6 }

// Response 201
{ "materia_usuario_id": 5 }
```

---

## Componentes

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/materias-usuario/:id/componentes` | Componentes de una materia inscrita |
| POST | `/materias-usuario/:id/componentes` | Crear componente |
| DELETE | `/componentes/:id` | Eliminar componente |

### GET /materias-usuario/:id/componentes
```json
// Response 200
[
  {
    "componente_id": 1,
    "componente_nombre": "Talleres",
    "componente_porcentaje": 20.00,
    "componente_nota_minima": null,
    "componente_orden": 1,
    "promedio_componente": 4.57,
    "cantidad_notas": 4
  }
]
```

### POST /materias-usuario/:id/componentes
```json
// Body
{ "componente_nombre": "Talleres", "componente_porcentaje": 20, "componente_orden": 1 }

// Response 201
{ "componente_id": 4 }
```

---

## Notas

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/componentes/:id/notas` | Notas de un componente |
| POST | `/componentes/:id/notas` | Agregar nota a un componente |
| DELETE | `/notas/:id` | Eliminar nota |

### POST /componentes/:id/notas
```json
// Body
{ "nota_nombre": "Taller 5", "nota_valor": 4.8, "nota_fecha_registro": "2025-11-10" }

// Response 201
{ "nota_id": 22 }
```

---

## Progreso global

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/progreso` | Promedio global + créditos del usuario |
| GET | `/progreso/tipologias` | Avance por tipología |
| GET | `/progreso/roadmap` | Materias del programa ordenadas por semestre sugerido |

### GET /progreso
```json
// Response 200
{
  "promedio_global": 4.35,
  "total_creditos_cursados": 17,
  "total_creditos_aprobados": 17
}
```

### GET /progreso/tipologias
```json
// Response 200
[
  {
    "tipologia_nombre": "DISCIPLINAR OBLIGATORIA",
    "creditos_requeridos": 39,
    "creditos_aprobados": 9,
    "porcentaje_avance": 23.1
  }
]
```

---

## Códigos de error estándar

| Código | Significado |
|--------|-------------|
| 400 | Bad Request — datos inválidos o faltantes |
| 401 | Unauthorized — token ausente o inválido |
| 404 | Not Found — recurso no existe |
| 409 | Conflict — duplicado (materia ya inscrita en ese semestre) |
| 500 | Internal Server Error |

```json
// Formato de error estándar
{ "error": "Descripción del problema" }
```
