import { useState } from 'react'
import { useMateriasPrograma } from '@/hooks/useMaterias'
import { Card, CardHeader, CardContent, CardTitle } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import type { Materia } from '@/types'

function groupBySemestre(materias: Materia[]): Record<number, Materia[]> {
  return materias.reduce<Record<number, Materia[]>>((acc, m) => {
    const key = m.materia_semestre_sugerido ?? 0
    if (!acc[key]) acc[key] = []
    acc[key].push(m)
    return acc
  }, {})
}

export default function MateriasPage() {
  const { data: materias = [], isLoading } = useMateriasPrograma()
  const [search, setSearch] = useState('')

  const filtered = materias.filter(m =>
    m.materia_nombre.toLowerCase().includes(search.toLowerCase()) ||
    m.materia_codigo?.toLowerCase().includes(search.toLowerCase()) ||
    m.tipologia_nombre.toLowerCase().includes(search.toLowerCase())
  )

  const grouped = groupBySemestre(filtered)
  const semestres = Object.keys(grouped)
    .map(Number)
    .sort((a, b) => a - b)

  return (
    <div className="max-w-5xl mx-auto">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-gray-100">Plan de estudios</h1>
        <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
          Todas las materias de tu programa académico
        </p>
      </div>

      {/* Search */}
      <input
        type="search"
        placeholder="Buscar materia, código o tipología…"
        value={search}
        onChange={e => setSearch(e.target.value)}
        className="w-full mb-6 rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 dark:border-gray-600 dark:bg-gray-800 dark:text-gray-100"
        aria-label="Buscar materia"
      />

      {isLoading ? (
        <p className="text-gray-500">Cargando…</p>
      ) : semestres.length === 0 ? (
        <p className="text-gray-500 dark:text-gray-400">No se encontraron materias.</p>
      ) : (
        <div className="flex flex-col gap-6">
          {semestres.map(sem => (
            <Card key={sem}>
              <CardHeader>
                <CardTitle>
                  {sem === 0 ? 'Sin semestre sugerido' : `Semestre ${sem}`}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  {grouped[sem].map(m => (
                    <div
                      key={m.materia_id}
                      className="rounded-lg border border-gray-200 dark:border-gray-700 p-3"
                    >
                      <div className="flex items-start justify-between gap-2">
                        <div>
                          <p className="font-medium text-gray-900 dark:text-gray-100 text-sm">
                            {m.materia_nombre}
                          </p>
                          {m.materia_codigo && (
                            <p className="text-xs text-gray-500 dark:text-gray-400">{m.materia_codigo}</p>
                          )}
                        </div>
                        <span className="text-xs font-semibold text-indigo-600 dark:text-indigo-400 whitespace-nowrap">
                          {m.materia_creditos} cr.
                        </span>
                      </div>
                      <div className="mt-2">
                        <Badge className="text-xs bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400">
                          {m.tipologia_nombre}
                        </Badge>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  )
}
