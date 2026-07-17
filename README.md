# UniGrades 🎓

Gestor de progreso académico universitario. Permite a estudiantes registrar materias, configurar componentes de evaluación y hacer seguimiento de sus notas, promedios y avance por tipología de créditos.

## Estructura del repositorio

```
UniGrades/
├── frontend/        # React + Vite — interfaz web (Sergio)
├── backend/         # Node + Express — API REST
├── database/        # Esquema SQL, migraciones y datos de prueba
│   ├── unigrades.sql    # Esquema completo + datos iniciales
│   └── seed.sql         # Datos de prueba para desarrollo
└── docs/            # Documentación del proyecto
    ├── API.md               # Contrato de endpoints
    ├── entrega_sesion1.tex  # Entregable Sesión 1 (LaTeX)
    └── Diagrama E-R.drawio  # Diagrama entidad-relación
```

## Stack

| Capa | Tecnología |
|------|-----------|
| Frontend | React 19 + Vite + Tailwind CSS |
| Backend | Node.js + Express |
| Base de datos | MySQL 8 |

## Levantar el proyecto en desarrollo

### 1. Base de datos
```bash
mysql -u root -p < database/unigrades.sql
mysql -u root -p unigrades < database/seed.sql
```

### 2. Backend
```bash
cd backend
npm install
cp .env.example .env   # configurar credenciales de MySQL
npm run dev
```

### 3. Frontend
```bash
cd frontend
npm install
npm run dev
```

## Equipo

| Rol | Responsable |
|-----|-------------|
| Frontend + integración | Sergio Chaves |
| Backend / API REST | — |
| Base de datos + modelo | — |
| Consultas + seed data | — |
| Documentación + pruebas | — |

## Contrato de API

Ver [`docs/API.md`](docs/API.md) para la especificación completa de endpoints.
