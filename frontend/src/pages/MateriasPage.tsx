import { useState } from 'react'
import { Search, BookOpen } from 'lucide-react'
import { motion } from 'framer-motion'
import { useMateriasPrograma } from '@/hooks/useMaterias'
import { Badge } from '@/components/ui/Badge'
import { Skeleton } from '@/components/ui/Skeleton'
import type { Materia } from '@/types'

function groupBySemestre(materias: Materia[]): Record<number, Materia[]> {
  return materias.reduce<Record<number, Materia[]>>((acc, m) => {
    const key = m.materia_semestre_sugerido ?? 0
    if (!acc[key]) acc[key] = []
    acc[key].push(m)
    return acc
  }, {})
}

function MateriaCard({ m }: { m: Materia }) {
  return (
    <div className="rounded-xl border border-gray-100 bg-white p-4 shadow-[var(--shadow-card)] hover:shadow-[var(--shadow-card-hover)] hover:border-brand-200 transition-all duration-200">
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <p className="font-medium text-gray-900 text-sm leading-snug">{m.materia_nombre}</p>
          {m.materia_codigo && (
            <p className="text-xs text-gray-400 mt-0.5">{m.materia_codigo}</p>
          )}
        </div>
        <span className="shrink-0 text-sm font-bold text-brand-600 tabular-nums">
          {m.materia_creditos} cr.
        </span>
      </div>
      <div className="mt-3">
        <Badge variant="gray" className="text-xs">{m.tipologia_nombre}</Badge>
      </div>
    </div>
  )
}

export default function MateriasPage() {
  const { data: materias = [], isLoading } = useMateriasPrograma()
  const [search, setSearch] = useState('')

  const filtered = materias.filter(m =>
    m.materia_nombre.toLowerCase().includes(search.toLowerCase()) ||
    (m.materia_codigo?.toLowerCase() ?? '').includes(search.toLowerCase()) ||
    m.tipologia_nombre.toLowerCase().includes(search.toLowerCase())
  )

  const grouped = groupBySemestre(filtered)
  const semestres = Object.keys(grouped).map(Number).sort((a, b) => a - b)

  return (
    <div className="space-y-6">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.35 }}
      >
        <h1 className="text-2xl font-bold text-gray-900">Plan de estudios</h1>
        <p className="text-gray-500 mt-1 text-sm">
          {materias.length > 0
            ? `${materias.length} materias en tu programa`
            : 'Todas las materias de tu programa académico'}
        </p>
      </motion.div>

      {/* Search */}
      <div className="relative">
        <Search
          size={16}
          className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"
        />
        <input
          type="search"
          placeholder="Buscar materia, código o tipología…"
          value={search}
          onChange={e => setSearch(e.target.value)}
          className="w-full rounded-2xl border border-gray-200 bg-white py-2.5 pl-10 pr-4 text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-brand-500/40 focus:border-brand-500 transition-all"
          aria-label="Buscar materia"
        />
      </div>

      {/* Content */}
      {isLoading ? (
        <div className="space-y-6">
          {[0, 1, 2].map(i => (
            <div key={i} className="space-y-3">
              <Skeleton className="h-5 w-32" />
              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                <Skeleton className="h-20" />
                <Skeleton className="h-20" />
              </div>
            </div>
          ))}
        </div>
      ) : semestres.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-gray-200 bg-white p-12 text-center">
          <div className="w-14 h-14 rounded-2xl bg-gray-50 flex items-center justify-center mx-auto mb-4">
            <BookOpen size={24} className="text-gray-400" />
          </div>
          <p className="font-medium text-gray-600 mb-1">
            {search ? 'Sin resultados' : 'Sin materias'}
          </p>
          <p className="text-sm text-gray-400">
            {search
              ? `No hay materias que coincidan con "${search}"`
              : 'No hay materias registradas para tu programa.'}
          </p>
        </div>
      ) : (
        <div className="space-y-8">
          {semestres.map((sem, si) => (
            <motion.section
              key={sem}
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: si * 0.06, duration: 0.35 }}
            >
              <div className="flex items-center gap-3 mb-3">
                <h2 className="text-sm font-semibold text-gray-700">
                  {sem === 0 ? 'Sin semestre sugerido' : `Semestre ${sem}`}
                </h2>
                <span className="h-px flex-1 bg-gray-100" />
                <span className="text-xs text-gray-400">{grouped[sem].length} materia{grouped[sem].length !== 1 ? 's' : ''}</span>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3">
                {grouped[sem].map(m => (
                  <MateriaCard key={m.materia_id} m={m} />
                ))}
              </div>
            </motion.section>
          ))}
        </div>
      )}
    </div>
  )
}
