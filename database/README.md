# UniGrades — Base de Datos

## Orden de ejecución

Ejecutar los scripts **en este orden exacto** para tener la base de datos funcional con datos de prueba:

```bash
mysql -u root -p < database/unigrades.sql              # 1. Estructura (DDL)
mysql -u root -p unigrades < database/02_dml.sql       # 2. Universidades, usuarios, semestres
mysql -u root -p unigrades < database/02b_dml_programa.sql  # 3. Programa, materias, prereqs
mysql -u root -p unigrades < database/03_plsql.sql     # 4. Triggers, funciones, procedimientos
```

> Las consultas de `04_consultas.sql` se ejecutan por separado para pruebas y demostración.

## Archivos

| Archivo | Contenido |
|---------|-----------|
| `unigrades.sql` | DDL completo: tablas, índices, vistas y pruebas de integridad comentadas |
| `02_dml.sql` | 10 universidades, 200 usuarios, +1000 semestres |
| `02b_dml_programa.sql` | Programa Ciencias de la Computación (UNAL): tipologías, materias, prerrequisitos y correquisitos |
| `03_plsql.sql` | 2 triggers, 2 funciones, 2 procedimientos almacenados (incluye validación de prerrequisitos) |
| `04_consultas.sql` | 15 consultas N1–N6 para demostración |
| `seed.sql` | Datos de prueba detallados (componentes y notas) para usuario 1 |

## Notas importantes

- El script `unigrades.sql` incluye `DROP TABLE IF EXISTS` al inicio — **borra y recrea todo**. No ejecutar sobre una BD con datos que quieran conservar.
- `03_plsql.sql` usa `DELIMITER $$`. Desde **MySQL Workbench** ejecutar con `Ctrl+Shift+Enter` (Run Script), no con `Ctrl+Enter`.
- Los usuarios en `02_dml.sql` tienen `usuario_programa_id` entre 1 y 10. El archivo `02b_dml_programa.sql` crea el programa con `programa_id = 1`. Los compañeros que agreguen más programas deben coordinar los IDs con el equipo.
- El procedimiento `sp_inscribir_materia` valida automáticamente que los prerrequisitos estén aprobados antes de inscribir una materia.
