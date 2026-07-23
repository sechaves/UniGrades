# UniGrades — Base de Datos

## Orden de ejecución

Ejecutar los scripts **en este orden exacto** para tener la base de datos funcional con datos de prueba:

```bash
mysql -u root -p < database/unigrades.sql     # 1. Estructura (DDL)
mysql -u root -p unigrades < database/02_dml.sql    # 2. Datos base
mysql -u root -p unigrades < database/03_plsql.sql  # 3. Triggers, funciones y procedimientos
```

> Las consultas de `04_consultas.sql` se ejecutan por separado para pruebas y demostración.

## Archivos

| Archivo | Contenido |
|---------|-----------|
| `unigrades.sql` | DDL completo: tablas, índices, vistas y pruebas de integridad comentadas |
| `02_dml.sql` | 10 universidades, 200 usuarios, +1000 semestres |
| `03_plsql.sql` | 2 triggers, 2 funciones, 2 procedimientos almacenados |
| `04_consultas.sql` | 15 consultas N1–N6 para demostración |
| `seed.sql` | Datos de prueba detallados (componentes y notas) para usuario 1 |

## Notas importantes

- El script `unigrades.sql` incluye `DROP TABLE IF EXISTS` al inicio — **borra y recrea todo**. No ejecutar sobre una BD con datos que quieran conservar.
- `03_plsql.sql` usa `DELIMITER $$`. Desde **MySQL Workbench** ejecutar con `Ctrl+Shift+Enter` (Run Script), no con `Ctrl+Enter`.
- Los datos de `02_dml.sql` solo cubren `universidad`, `usuario` y `semestre`. Los compañeros encargados de la malla curricular deben agregar `programa`, `tipologia`, `materia`, `materia_usuario`, `componente` y `nota`.
- El `usuario_programa_id` en `02_dml.sql` asume que los programas tendrán `programa_id` del 1 al 10 (uno por universidad). Coordinar con el compañero que inserte los programas.
