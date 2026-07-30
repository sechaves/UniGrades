import { useState } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { ArrowLeft, Plus, BookMarked, ChevronRight } from 'lucide-react'
import { motion } from 'framer-motion'
import { Select, ListBox, Label, Separator, Header } from '@heroui/react'
import { useAuthContext } from '@/context/AuthContext'
import { useMateriasBySemestre, useInscribirMateria, useMateriasPrograma } from '@/hooks/useMaterias'
import { useSemestres } from '@/hooks/useSemestres'
import Button from '@/components/ui/Button'
import Modal from '@/components/ui/Modal'
import { EstadoBadge } from '@/components/ui/Badge'
import { Skeleton } from '@/components/ui/Skeleton'
import type { MateriaEstado } from '@/types'

/* ── Nota display ── */
function NotaDisplay({ estado, nota_final, nota_acumulada, porcentaje_evaluado }: {
  estado: MateriaEstado
  nota_final: number | null
  nota_acumulada: number | null
  porcentaje_evaluado: number | null
}) {
  if (nota_final !== null) {
    const color =
      estado === 'aprobada' ? 'text-brand-600' :
      estado === 'reprobada' ? 'text-red-600' : 'text-gray-700'
    return <span className={`font-bold tabular-nums ${color}`}>{Number(nota_final).toFixed(2)}</span>
  }
  if (nota_acumulada !== null) {
    return (
      <span className="text-sm text-gray-500 tabular-nums">
        <span className="font-semibold text-gray-700">{Number(nota_acumulada).toFixed(2)}</span>
        <span className="text-xs ml-1 text-gray-400">({porcentaje_evaluado}%)</span>
      </span>
    )
  }
  return <span className="text-xs text-gray-300">—</span>
}

/* ── Page ── */
export default function SemestrePage() {
  const { id } = useParams<{ id: string }>()
  const semestreId = Number(id)
  const navigate = useNavigate()
  const { user } = useAuthContext()

  const { data: semestres = [] } = useSemestres(user!.usuario_id)
  const semestre = semestres.find(s => s.semestre_id === semestreId)

  const { data: materiasInscritas = [], isLoading } = useMateriasBySemestre(semestreId)
  const { data: todasMaterias = [], isLoading: loadingMaterias } = useMateriasPrograma()
  const inscribir = useInscribirMateria(semestreId, user!.usuario_id)

  const [modalOpen, setModalOpen] = useState(false)
  const [materiaId, setMateriaId] = useState('')
  const [errorMsg, setErrorMsg] = useState('')

  const inscritasIds = new Set(materiasInscritas.map(m => m.materia_id))
  const disponibles = todasMaterias
    .filter(m => !inscritasIds.has(m.materia_id))
    .sort((a, b) => (a.materia_semestre_sugerido ?? 99) - (b.materia_semestre_sugerido ?? 99))

  async function handleInscribir(e: React.FormEvent) {
    e.preventDefault()
    setErrorMsg('')
    if (!materiaId) return
    try {
      await inscribir.mutateAsync(Number(materiaId))
      setModalOpen(false)
      setMateriaId('')
    } catch (err) {
      setErrorMsg(err instanceof Error ? err.message : 'Error al inscribir materia')
    }
  }

  function closeModal() {
    setModalOpen(false)
    setMateriaId('')
    setErrorMsg('')
  }

  const titulo = semestre
    ? `Semestre ${semestre.semestre_numero} — ${semestre.semestre_year}-${semestre.semestre_periodo}S`
    : 'Semestre'

  return (
    <div className="space-y-6">
      {/* Back + Header */}
      <div>
        <button
          onClick={() => navigate('/dashboard')}
          className="inline-flex items-center gap-1.5 text-sm text-gray-400 hover:text-gray-700 transition-colors mb-4"
        >
          <ArrowLeft size={15} />
          Dashboard
        </button>

        <div className="flex items-start justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">{titulo}</h1>
            {semestre?.promedio_semestre != null && (
              <p className="text-sm text-gray-500 mt-1">
                Promedio:{' '}
                <span className="font-bold text-brand-600 text-base">
                  {Number(semestre.promedio_semestre).toFixed(2)}
                </span>
              </p>
            )}
          </div>
          <Button size="sm" onClick={() => setModalOpen(true)} className="shrink-0">
            <Plus size={15} />
            Inscribir materia
          </Button>
        </div>
      </div>

      {/* Materias list */}
      {isLoading ? (
        <div className="space-y-3">
          {[0, 1, 2].map(i => (
            <div key={i} className="rounded-2xl border border-gray-100 bg-white p-4">
              <Skeleton className="h-4 w-2/3 mb-2" />
              <Skeleton className="h-3 w-1/3" />
            </div>
          ))}
        </div>
      ) : materiasInscritas.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-gray-200 bg-white p-12 text-center">
          <div className="w-14 h-14 rounded-2xl bg-brand-50 flex items-center justify-center mx-auto mb-4">
            <BookMarked size={24} className="text-brand-500" />
          </div>
          <p className="font-medium text-gray-700 mb-1">Sin materias inscritas</p>
          <p className="text-sm text-gray-400 mb-5">Inscribe tu primera materia para empezar a registrar notas.</p>
          <Button size="sm" onClick={() => setModalOpen(true)}>
            <Plus size={15} />
            Inscribir materia
          </Button>
        </div>
      ) : (
        <div className="space-y-2">
          {materiasInscritas.map((m, i) => (
            <motion.div
              key={m.materia_usuario_id}
              initial={{ opacity: 0, x: -8 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.04, duration: 0.3 }}
            >
              <Link
                to={`/materia-usuario/${m.materia_usuario_id}`}
                className="group flex items-center justify-between rounded-2xl border border-gray-100 bg-white px-5 py-4 shadow-[var(--shadow-card)] hover:shadow-[var(--shadow-card-hover)] hover:border-brand-200 transition-all duration-200"
              >
                <div className="min-w-0 flex-1">
                  <p className="font-medium text-gray-900 group-hover:text-brand-700 transition-colors truncate">
                    {m.materia}
                  </p>
                  <p className="text-xs text-gray-400 mt-0.5">
                    {m.materia_codigo} · {m.creditos} créditos
                  </p>
                </div>
                <div className="flex items-center gap-3 shrink-0 ml-4">
                  <NotaDisplay
                    estado={m.estado}
                    nota_final={m.nota_final}
                    nota_acumulada={m.nota_acumulada}
                    porcentaje_evaluado={m.porcentaje_evaluado}
                  />
                  <EstadoBadge estado={m.estado} />
                  <ChevronRight size={16} className="text-gray-300 group-hover:text-brand-500 transition-colors" />
                </div>
              </Link>
            </motion.div>
          ))}
        </div>
      )}

      {/* Modal inscribir */}
      <Modal open={modalOpen} onClose={closeModal} title="Inscribir materia">
        <form onSubmit={handleInscribir} className="flex flex-col gap-4">
          <Select
            label="Materia"
            value={materiaId}
            onChange={e => setMateriaId(e.target.value)}
            required
            disabled={loadingMaterias}
          >
            <option value="">
              {loadingMaterias
                ? 'Cargando materias…'
                : disponibles.length === 0
                ? 'No hay materias disponibles'
                : 'Selecciona una materia'}
            </option>
            {disponibles.map(m => (
              <option key={m.materia_id} value={m.materia_id}>
                [{m.materia_semestre_sugerido ?? '?'}] {m.materia_nombre} ({m.materia_creditos} cr.)
              </option>
            ))}
          </Select>

          {disponibles.length === 0 && !loadingMaterias && (
            <div className="rounded-xl bg-amber-50 border border-amber-100 px-4 py-3 text-sm text-amber-700">
              Todas las materias de tu programa ya están inscritas en este semestre.
            </div>
          )}

          {errorMsg && (
            <div className="rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600">
              {errorMsg}
            </div>
          )}

          <div className="flex gap-2 justify-end pt-1">
            <Button type="button" variant="outline" onClick={closeModal}>
              Cancelar
            </Button>
            <Button
              type="submit"
              loading={inscribir.isPending}
              disabled={!materiaId || disponibles.length === 0}
            >
              Inscribir
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
