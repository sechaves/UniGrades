import { useState } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { ArrowLeft, Plus } from 'lucide-react'
import { useAuthContext } from '@/context/AuthContext'
import { useMateriasBySemestre, useInscribirMateria, useMateriasPrograma } from '@/hooks/useMaterias'
import { useSemestres } from '@/hooks/useSemestres'
import { Card, CardHeader, CardContent, CardTitle } from '@/components/ui/Card'
import Button from '@/components/ui/Button'
import Modal from '@/components/ui/Modal'
import Select from '@/components/ui/Select'
import { EstadoBadge } from '@/components/ui/Badge'
import type { MateriaEstado } from '@/types'

export default function SemestrePage() {
  const { id } = useParams<{ id: string }>()
  const semestreId = Number(id)
  const navigate = useNavigate()
  const { user } = useAuthContext()

  const { data: semestres = [] } = useSemestres(user!.usuario_id)
  const semestre = semestres.find(s => s.semestre_id === semestreId)

  const { data: materiasInscritas = [], isLoading } = useMateriasBySemestre(semestreId)
  const { data: todasMaterias = [] } = useMateriasPrograma()
  const inscribir = useInscribirMateria(semestreId, user!.usuario_id)

  const [modalOpen, setModalOpen] = useState(false)
  const [materiaId, setMateriaId] = useState('')
  const [errorMsg, setErrorMsg] = useState('')

  // Materias del programa del usuario filtradas por las ya inscritas en este semestre
  const inscritasIds = new Set(materiasInscritas.map(m => m.materia_id))
  const disponibles = todasMaterias.filter(m => !inscritasIds.has(m.materia_id))

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

  function notaColor(estado: MateriaEstado, nota: number | null) {
    if (nota === null) return 'text-gray-500 dark:text-gray-400'
    if (estado === 'aprobada') return 'text-green-600 dark:text-green-400 font-bold'
    if (estado === 'reprobada') return 'text-red-600 dark:text-red-400 font-bold'
    return 'text-indigo-600 dark:text-indigo-400 font-bold'
  }

  const titulo = semestre
    ? `Semestre ${semestre.semestre_numero} · ${semestre.semestre_year}-${semestre.semestre_periodo}S`
    : `Semestre`

  return (
    <div className="max-w-4xl mx-auto">
      {/* Back */}
      <div className="mb-6">
        <button
          onClick={() => navigate('/dashboard')}
          className="flex items-center gap-1 text-sm text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 transition-colors"
        >
          <ArrowLeft size={16} />
          Dashboard
        </button>
        <h1 className="mt-2 text-2xl font-bold text-gray-900 dark:text-gray-100">{titulo}</h1>
        {semestre?.promedio_semestre != null && (
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Promedio:{' '}
            <span className="font-semibold text-indigo-600 dark:text-indigo-400">
              {Number(semestre.promedio_semestre).toFixed(2)}
            </span>
          </p>
        )}
      </div>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <div>
            <CardTitle>Materias inscritas</CardTitle>
            <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
              {materiasInscritas.length} materia{materiasInscritas.length !== 1 ? 's' : ''}
            </p>
          </div>
          <Button size="sm" onClick={() => setModalOpen(true)}>
            <Plus size={14} />
            Inscribir materia
          </Button>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <p className="text-gray-500 text-sm">Cargando…</p>
          ) : materiasInscritas.length === 0 ? (
            <p className="text-gray-500 dark:text-gray-400 text-sm">
              No hay materias inscritas.{' '}
              <button className="text-indigo-600 hover:underline" onClick={() => setModalOpen(true)}>
                Inscribe la primera
              </button>
            </p>
          ) : (
            <div className="flex flex-col gap-2">
              {materiasInscritas.map(m => (
                <Link
                  key={m.materia_usuario_id}
                  to={`/materia-usuario/${m.materia_usuario_id}`}
                  className="flex items-center justify-between rounded-lg border border-gray-200 dark:border-gray-700 px-4 py-3 hover:border-indigo-400 hover:shadow-sm transition-all group"
                >
                  <div className="min-w-0">
                    <p className="font-medium text-gray-900 dark:text-gray-100 group-hover:text-indigo-600 truncate">
                      {m.materia}
                    </p>
                    <p className="text-xs text-gray-500 dark:text-gray-400">
                      {m.materia_codigo} · {m.creditos} créditos
                    </p>
                  </div>
                  <div className="flex items-center gap-3 flex-shrink-0 ml-3">
                    {m.nota_acumulada !== null && (
                      <span className={`text-sm ${notaColor(m.estado, m.nota_final)}`}>
                        {m.nota_final !== null
                          ? m.nota_final.toFixed(2)
                          : `${Number(m.nota_acumulada).toFixed(2)} (${m.porcentaje_evaluado}%)`}
                      </span>
                    )}
                    <EstadoBadge estado={m.estado} />
                  </div>
                </Link>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Modal inscribir */}
      <Modal open={modalOpen} onClose={() => { setModalOpen(false); setMateriaId(''); setErrorMsg('') }} title="Inscribir materia">
        <form onSubmit={handleInscribir} className="flex flex-col gap-4">
          <Select
            label="Materia"
            value={materiaId}
            onChange={e => setMateriaId(e.target.value)}
            required
          >
            <option value="">Selecciona una materia</option>
            {disponibles
              .sort((a, b) => (a.materia_semestre_sugerido ?? 99) - (b.materia_semestre_sugerido ?? 99))
              .map(m => (
                <option key={m.materia_id} value={m.materia_id}>
                  [{m.materia_semestre_sugerido ?? '?'}] {m.materia_nombre} ({m.materia_creditos} cr.)
                </option>
              ))}
          </Select>
          {errorMsg && <p className="text-sm text-red-600">{errorMsg}</p>}
          <div className="flex gap-2 justify-end">
            <Button type="button" variant="outline" onClick={() => { setModalOpen(false); setMateriaId(''); setErrorMsg('') }}>
              Cancelar
            </Button>
            <Button type="submit" loading={inscribir.isPending} disabled={!materiaId}>
              Inscribir
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
