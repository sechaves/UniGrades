# UniGrades — Documentación Técnica Completa

> Aplicación web para el seguimiento académico de estudiantes universitarios.

**URL producción:** https://unigrades-project.vercel.app  
**API:** https://unigrades-production.up.railway.app/api  
**Repositorio:** https://github.com/sechaves/UniGrades

---

## ¿Qué es?

UniGrades permite registrar semestres, inscribir materias, configurar componentes evaluativos (parciales, proyectos, etc.), registrar notas y calcular promedios automáticamente. El sistema determina si una materia está aprobada o reprobada según la nota mínima definida por el programa.

---

## Arquitectura general

```
┌─────────────────────┐     HTTPS      ┌─────────────────────┐
│   Frontend (Vercel) │ ────────────▶  │  Backend (Railway)  │
│   React + Vite      │     REST API   │  Node.js + Express  │
└─────────────────────┘                └──────────┬──────────┘
                                                  │ mysql2
                                       ┌──────────▼──────────┐
                                       │  MySQL (Railway)     │
                                       │  base: unigrades     │
                                       └─────────────────────┘
```

---

## Stack tecnológico

### Backend

| Tecnología | Versión | Uso |
|---|---|---|
| Node.js | 22 | Runtime |
| Express | 4.18 | Framework HTTP |
| mysql2/promise | 3.9 | Driver MySQL con Promises |
| jsonwebtoken | 9.0 | Autenticación JWT |
| bcryptjs | 2.4 | Hash de contraseñas |
| dotenv | 16 | Variables de entorno |
| cors | 2.8 | Control de orígenes |

### Frontend

| Tecnología | Versión | Uso |
|---|---|---|
| React | 19 | UI |
| TypeScript | 6.0 | Tipado estático |
| Vite | 8 | Bundler |
| Tailwind CSS | 4 | Estilos |
| React Router | 7 | Navegación SPA |
| TanStack Query | 5 | Cache y estado del servidor |
| framer-motion | — | Animaciones |
| lucide-react | — | Iconos |

### Infraestructura

| Servicio | Uso |
|---|---|
| **Railway** | Backend Node.js + MySQL 9.4 |
| **Vercel** | Frontend estático |
| **GitHub** | Control de versiones (`sechaves/UniGrades`) |

---

## Base de datos — Modelo relacional

### Relaciones principales

```
universidad ──< programa ──< tipologia ──< materia
                                              │
usuario ──< semestre ──< materia_usuario ──< componente ──< nota
```

### Tablas

| Tabla | Descripción |
|---|---|
| `universidad` | Instituciones educativas |
| `programa` | Programas académicos por universidad |
| `tipologia` | Categorías de materias (ej: Disciplinar Obligatoria) |
| `materia` | Catálogo de materias del plan de estudios |
| `materia_prerrequisito` | Relación prerrequisito entre materias |
| `usuario` | Estudiantes registrados |
| `semestre` | Períodos académicos por usuario |
| `materia_usuario` | Materia inscrita en un semestre |
| `componente` | Evaluaciones de una materia (parcial, proyecto...) |
| `nota` | Calificaciones individuales dentro de un componente |

### Vistas

| Vista | Descripción |
|---|---|
| `v_promedio_componente` | Promedio de notas por componente |
| `v_nota_materia` | Nota acumulada y final por materia inscrita |
| `v_promedio_semestre` | Promedio ponderado por créditos por semestre |
| `v_promedio_global` | Promedio global acumulado del estudiante |
| `v_avance_tipologia` | Créditos aprobados vs requeridos por tipología |
| `v_materias_aprobadas_usuario` | Materias aprobadas sin duplicados |

### Funciones almacenadas

| Función | Descripción |
|---|---|
| `fn_promedio_semestre(usuario_id, semestre_id)` | Promedio ponderado de un semestre |
| `fn_creditos_aprobados_tipologia(usuario_id, tipologia_id)` | Créditos aprobados en una tipología |

### Procedimientos almacenados

| Procedimiento | Descripción |
|---|---|
| `sp_inscribir_materia(usuario_id, materia_id, semestre_id, OUT mensaje)` | Inscribe una materia validando prerrequisitos, programa del usuario y duplicados |
| `sp_resumen_academico_usuario(usuario_id)` | Resumen completo con cursor: promedio global + detalle por semestre |

### Triggers

| Trigger | Evento | Descripción |
|---|---|---|
| `trg_actualizar_estado_materia` | AFTER INSERT en `nota` | Cambia estado a aprobada/reprobada cuando porcentaje evaluado = 100% |
| `trg_validar_porcentaje_insert` | BEFORE INSERT en `componente` | Valida que la suma de porcentajes no supere 100% |
| `trg_validar_porcentaje_update` | BEFORE UPDATE en `componente` | Idem para actualizaciones |
| `trg_validar_prerrequisito_diferente` | BEFORE INSERT en `materia_prerrequisito` | Evita que una materia sea prerrequisito de sí misma |

---

## API REST

**Base URL producción:** `https://unigrades-production.up.railway.app/api`

**Autenticación:** JWT Bearer Token en header `Authorization: Bearer <token>`

### Endpoints principales

| Método | Endpoint | Auth | Descripción |
|---|---|---|---|
| POST | `/auth/register` | No | Registrar usuario |
| POST | `/auth/login` | No | Login, devuelve JWT |
| GET | `/universidades` | No | Lista universidades |
| GET | `/universidades/:id/programas` | No | Programas de una universidad |
| GET | `/usuarios/:id` | Sí | Perfil del usuario |
| GET | `/usuarios/:id/semestres` | Sí | Semestres del usuario |
| POST | `/usuarios/:id/semestres` | Sí | Crear semestre |
| GET | `/usuarios/:id/promedio-global` | Sí | Promedio global y créditos |
| GET | `/usuarios/:id/avance-tipologia` | Sí | Avance por tipología |
| GET | `/semestres/:id/materias` | Sí | Materias inscritas en un semestre |
| POST | `/semestres/:id/inscribir` | Sí | Inscribir materia (usa SP) |
| GET | `/materias` | Sí | Plan de estudios del programa del usuario |
| GET | `/materia-usuario/:id` | Sí | Detalle de materia inscrita |
| GET | `/materia-usuario/:id/componentes` | Sí | Componentes de una materia |
| POST | `/materia-usuario/:id/componentes` | Sí | Crear componente |
| DELETE | `/componentes/:id` | Sí | Eliminar componente |
| GET | `/componentes/:id/notas` | Sí | Notas de un componente |
| POST | `/componentes/:id/notas` | Sí | Agregar nota |
| PUT | `/notas/:id` | Sí | Actualizar nota |
| DELETE | `/notas/:id` | Sí | Eliminar nota |

### Formato de respuesta estándar

```json
// Éxito
{ "success": true, "data": { ... } }

// Error
{ "success": false, "message": "Descripción del error" }
```

---

## Flujo de datos — Cálculo de promedio

```
nota_valor (0.0–5.0)
    │
    ▼
promedio_componente = AVG(notas del componente)   [vista v_promedio_componente]
    │
    ▼
nota_acumulada = Σ(promedio_componente × porcentaje / 100)
nota_final     = nota_acumulada  (solo cuando porcentaje_evaluado = 100%)
    │
    ▼
promedio_semestre = Σ(nota_final × créditos) / Σ(créditos)   [fn_promedio_semestre]
    │
    ▼
promedio_global = Σ(nota_acumulada × créditos) / Σ(créditos)   [endpoint /promedio-global]
```

---

## Lógica de negocio destacada

### Inscripción de materias

El SP `sp_inscribir_materia` valida:
1. El semestre pertenece al usuario
2. La materia pertenece al programa del usuario
3. La materia no está ya inscrita en ese semestre
4. La materia no fue ya aprobada
5. Todos los prerrequisitos están aprobados

### Cambio de estado automático

El trigger `trg_actualizar_estado_materia` se ejecuta al insertar una nota. Si la suma de porcentajes de los componentes llega a 100%, compara la nota final con la nota mínima de aprobación y cambia el estado a `aprobada` o `reprobada`. Si se modifica o elimina una nota, el backend recalcula el estado mediante la función `recalcularEstadoMateria()`.

### Porcentajes de componentes

Los triggers `trg_validar_porcentaje_insert/update` garantizan que la suma de porcentajes de todos los componentes de una materia nunca supere 100%.

---

## Estructura del repositorio

```
UniGrades/
├── backend/
│   └── src/
│       ├── app.js                    ← Express + CORS + montaje de rutas
│       ├── server.js                 ← Inicia servidor, verifica DB
│       ├── config/db.js              ← Pool mysql2
│       ├── middleware/
│       │   ├── auth.middleware.js    ← Verificación JWT
│       │   └── error.middleware.js   ← Manejo errores MySQL
│       ├── controllers/              ← Lógica de cada recurso
│       └── routes/                   ← Definición de endpoints
├── frontend/
│   └── src/
│       ├── App.tsx                   ← Rutas con PrivateRoute/GuestRoute
│       ├── main.tsx                  ← QueryClient + BrowserRouter + AuthProvider
│       ├── context/AuthContext.tsx   ← Contexto global de autenticación
│       ├── hooks/                    ← useAuth, useSemestres, useMaterias, useNotas...
│       ├── lib/api.ts                ← Fetch wrapper con JWT automático
│       ├── types/index.ts            ← Interfaces TypeScript
│       ├── layouts/                  ← AppLayout (sidebar), AuthLayout
│       ├── components/ui/            ← Button, Input, Select, Card, Badge, Modal
│       └── pages/                    ← LandingPage, LoginPage, RegisterPage,
│                                        DashboardPage, SemestrePage,
│                                        MateriaUsuarioPage, MateriasPage
└── database/
    ├── 01_ddl.sql          ← Tablas, índices y vistas
    ├── 02_dml.sql          ← Datos base: UNAL, programas, materias, usuarios
    ├── 03_plsql.sql        ← Triggers, funciones y procedimientos almacenados
    ├── 04_consultas.sql    ← Consultas de ejemplo
    ├── 05_seeding.sql      ← 10 000 inscripciones ficticias con notas
    ├── 06_optimizacion.sql ← Índices adicionales y ANALYZE
    ├── 07_ing_sistemas.sql ← Materias programa Ingeniería de Sistemas UNAL
    ├── 08_fix_programas.sql← Limpieza y corrección de programas
    └── 09_fix_triggers.sql ← Triggers UPDATE/DELETE en nota
```

---

## Despliegue

### Frontend — Vercel

- **URL:** https://unigrades-project.vercel.app
- **Variable de entorno:** `VITE_API_URL=https://unigrades-production.up.railway.app/api`
- Auto-deploy en cada push a `main`
- `frontend/vercel.json` con rewrites para SPA (evita 404 al refrescar rutas)

### Backend — Railway

- **URL:** https://unigrades-production.up.railway.app
- **Variables:** `DB_HOST`, `DB_NAME=unigrades`, `DB_USER`, `DB_PASSWORD`, `JWT_SECRET`, `CORS_ORIGIN`
- Deploy manual: `railway up` desde la raíz del repo
- Puerto interno: 8080

### Base de datos — Railway MySQL 9.4

- Base de datos: `unigrades`
- Ejecutar scripts en orden: `01_ddl` → `02_dml` → `03_plsql` → `05_seeding` → `07_ing_sistemas` → `08_fix_programas`

---

## Correr en local

```bash
# Clonar
git clone https://github.com/sechaves/UniGrades.git
cd UniGrades

# Backend
cd backend
cp .env.example .env        # Completar con credenciales locales
npm install
npm run dev                 # http://localhost:3001/api

# Frontend (nueva terminal)
cd frontend
echo "VITE_API_URL=http://localhost:3001/api" > .env.local
npm install
npm run dev                 # http://localhost:5173
```

---

## Datos de prueba

- **Universidad:** Universidad Nacional de Colombia (UNAL)
- **Programas:** Ciencias de la Computación (67 materias) · Ingeniería de Sistemas y Computación (39 materias)
- **Seeding:** 10 000 inscripciones ficticias con componentes y notas distribuidas aritméticamente
- **Usuarios del seeding:** 200 usuarios con hashes placeholder (no aptos para login)
- **Para probar:** crear cuenta nueva desde `/register` seleccionando UNAL y el programa deseado

---

## Integrantes

Samuel Sanchez · Edison Quintero · Sergio Chaves · Cristian Hernandez · Santiago Puentes

*Bases de Datos — Semestre 2 · Universidad Nacional de Colombia*
