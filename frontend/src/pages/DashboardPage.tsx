import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Plus, TrendingUp, BookOpen, Award, Calendar, ChevronRight } from 'lucide-react'
import { motion } from 'framer-motion'
import { useAuthContext } from '@/context/AuthContext'
import { useSemestres, useCreateSemestre } from '@/hooks/useSemestres'
import { usePromedioGlobal, useAvanceTipologia } from '@/hooks/useProgreso'
import { Card, CardHeader, CardContent, CardTitle } from '@/components/ui/Card'
import Button from '@/components/ui/Button'
import Modal from '@/components/ui/Modal'
import Input from '@/components/ui/Input'
import Select from '@/components/ui/Select'
import { SkeletonCard } from '@/components/ui/Skeleton'

/* ──────────────────────────── Stat card ──────────────────────────── */
interface StatCardProps {
  label: string
  value: string | number
  icon: React.ReactNode
  color: string
  delay?: number
}

function StatCard({ label, value, icon, color, delay = 0 }: StatCardProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay, duration: 0.4, ease: 'easeOut' }}
    >
      <Card className="p-0 overflow-hidden">
        <div className="flex items-center gap-4 p-5">
          <div className={`w-12 h-12 rounded-2xl flex items-center justify-center shrink-0 ${color}`}>
            {icon}
          </div>
          <div className="min-w-0">
            <p className="text-sm text-gray-500 mb-0.5">{label}</p>
            <p className="text-2xl font-bold text-gray-900 tabular-nums">{value}</p>
          </div>
        </div>
      </Card>
    </motion.div>
  )
}

/* ──────────────────────────── Semester card ──────────────────────────── */
function SemesterCard({
  semestre,
  onClick,
  delay,
}: {
  semestre: { semestre_id: number; semestre_numero: number; semestre_year: number; semestre_periodo: 1 | 2; promedio_semestre: number | null }
  onClick: () => void
  delay: number
}) {
  return (
    <motion.button
      initial={{ opacity: 0, scale: 0.96 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ delay, duration: 0.3 }}
      onClick={onClick}
      className="group text-left w-full rounded-2xl border border-gray-100 bg-white p-5 shadow-[var(--shadow-card)] hover:shadow-[var(--shadow-card-hover)] hover:border-brand-200 transition-all duration-200"
    >
      <div className="flex items-start justify-between mb-3">
        <div className="w-10 h-10 rounded-xl bg-brand-50 flex items-center justify-center">
          <Calendar size={18} className="text-brand-600" />
        </div>
        <ChevronRight size={16} className="text-gray-300 group-hover:text-brand-500 transition-colors mt-1" />
      </div>
      <p className="font-semibold text-gray-900 group-hover:text-brand-700 transition-colors">
        Semestre {semestre.semestre_numero}
      </p>
      <p className="text-xs text-gray-400 mt-0.5">
        {semestre.semestre_year} · Período {semestre.semestre_periodo}S
      </p>
      {semestre.promedio_semestre != null && (
        <p className="mt-3 text-xl font-bold text-brand-600 tabular-nums">
          {Number(semestre.promedio_semestre).toFixed(2)}
        </p>
      )}
    </motion.button>
  )
}

/* ──────────────────────────── Page ──────────────────────────── */
export default function DashboardPage() {
  const { user } = useAuthContext()
  const navigate = useNavigate()
  const usuarioId = user!.usuario_id

  const { data: semestres = [], isLoading: loadingSemestres } = useSemestres(usuarioId)
  const { data: promedio, isLoading: loadingPromedio } = usePromedioGlobal(usuarioId)
  const { data: avance = [] } = useAvanceTipologia(usuarioId)
  const createSemestre = useCreateSemestre(usuarioId)

  const [modalOpen, setModalOpen] = useState(false)
  const [form, setForm] = useState({
    semestre_numero: '',
    semestre_year: new Date().getFullYear().toString(),
    semestre_periodo: '1',
  })
  const [formError, setFormError] = useState('')

  function setField(field: string) {
    return (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) =>
      setForm(f => ({ ...f, [field]: e.target.value }))
  }

  async function handleCrearSemestre(e: React.FormEvent) {
    e.preventDefault()
    setFormError('')
    try {
      await createSemestre.mutateAsync({
        semestre_numero: Number(form.semestre_numero),
        semestre_year: Number(form.semestre_year),
        semestre_periodo: Number(form.semestre_periodo) as 1 | 2,
      })
      setModalOpen(false)
      setForm({ semestre_numero: '', semestre_year: new Date().getFullYear().toString(), semestre_periodo: '1' })
    } catch (err) {
      setFormError(err instanceof Error ? err.message : 'Error al crear semestre')
    }
  }

  const stats = [
    {
      label: 'Promedio global',
      value: promedio?.promedio_global != null ? Number(promedio.promedio_global).toFixed(2) : '—',
      icon: <TrendingUp size={20} className="text-brand-600" />,
      color: 'bg-brand-50',
      delay: 0,
    },
    {
      label: 'Créditos cursados',
      value: promedio?.total_creditos_cursados ?? 0,
      icon: <BookOpen size={20} className="text-blue-600" />,
      color: 'bg-blue-50',
      delay: 0.07,
    },
    {
      label: 'Créditos aprobados',
      value: promedio?.total_creditos_aprobados ?? 0,
      icon: <Award size={20} className="text-amber-600" />,
      color: 'bg-amber-50',
      delay: 0.14,
    },
  ]

  return (
    <div className="space-y-8">
      {/* Greeting */}
      <motion.div
        initial={{ opacity: 0, y: -8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4 }}
      >
        <h1 className="text-2xl font-bold text-gray-900">
          Hola, {user?.usuario_nombre} 👋
        </h1>
        <p className="text-gray-500 mt-1">Aquí está tu resumen académico.</p>
      </motion.div>

      {/* Stat cards */}
      {loadingPromedio ? (
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          {[0, 1, 2].map(i => <SkeletonCard key={i} />)}
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          {stats.map(s => (
            <StatCard key={s.label} {...s} />
          ))}
        </div>
      )}

      {/* Avance tipología */}
      {avance.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.25, duration: 0.4 }}
        >
          <Card>
            <CardHeader>
              <CardTitle>Avance por tipología</CardTitle>
            </CardHeader>
            <CardContent className="space-y-5">
              {avance.map((t, i) => {
                const pct =
                  t.creditos_requeridos > 0
                    ? Math.min(100, Math.round((t.creditos_aprobados / t.creditos_requeridos) * 100))
                    : 0
                return (
                  <div key={t.tipologia_id}>
                    <div className="flex justify-between text-sm mb-2">
                      <span className="font-medium text-gray-700">{t.tipologia}</span>
                      <span className="text-gray-400 tabular-nums">
                        {t.creditos_aprobados}
                        <span className="text-gray-300"> / </span>
                        {t.creditos_requeridos} cr.
                      </span>
                    </div>
                    <div className="relative h-2.5 bg-gray-100 rounded-full overflow-hidden">
                      <motion.div
                        initial={{ width: 0 }}
                        animate={{ width: `${pct}%` }}
                        transition={{ delay: 0.3 + i * 0.08, duration: 0.7, ease: 'easeOut' }}
                        className="absolute inset-y-0 left-0 brand-gradient rounded-full"
                        role="progressbar"
                        aria-valuenow={pct}
                        aria-valuemin={0}
                        aria-valuemax={100}
                      />
                    </div>
                    <p className="text-xs text-gray-400 mt-1">{pct}% completado</p>
                  </div>
                )
              })}
            </CardContent>
          </Card>
        </motion.div>
      )}

      {/* Semestres grid */}
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.35, duration: 0.4 }}
      >
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Semestres</h2>
          <Button size="sm" onClick={() => setModalOpen(true)}>
            <Plus size={15} />
            Nuevo semestre
          </Button>
        </div>

        {loadingSemestres ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {[0, 1, 2].map(i => <SkeletonCard key={i} />)}
          </div>
        ) : semestres.length === 0 ? (
          <Card className="p-0">
            <CardContent className="py-12 text-center">
              <div className="w-14 h-14 rounded-2xl bg-brand-50 flex items-center justify-center mx-auto mb-4">
                <Calendar size={24} className="text-brand-500" />
              </div>
              <p className="font-medium text-gray-700 mb-1">Sin semestres aún</p>
              <p className="text-sm text-gray-400 mb-5">Crea tu primer semestre para empezar a registrar notas.</p>
              <Button size="sm" onClick={() => setModalOpen(true)}>
                <Plus size={15} />
                Crear semestre
              </Button>
            </CardContent>
          </Card>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {semestres.map((s, i) => (
              <SemesterCard
                key={s.semestre_id}
                semestre={s}
                onClick={() => navigate(`/semestres/${s.semestre_id}`)}
                delay={i * 0.06}
              />
            ))}
          </div>
        )}
      </motion.div>

      {/* Modal nuevo semestre */}
      <Modal
        open={modalOpen}
        onClose={() => { setModalOpen(false); setFormError('') }}
        title="Nuevo semestre"
      >
        <form onSubmit={handleCrearSemestre} className="flex flex-col gap-4">
          <Input
            label="Número de semestre"
            type="number"
            min={1}
            max={20}
            placeholder="Ej: 3"
            value={form.semestre_numero}
            onChange={setField('semestre_numero')}
            required
          />
          <Input
            label="Año"
            type="number"
            min={2000}
            max={2099}
            placeholder={new Date().getFullYear().toString()}
            value={form.semestre_year}
            onChange={setField('semestre_year')}
            required
          />
          <Select
            label="Período"
            value={form.semestre_periodo}
            onChange={setField('semestre_periodo')}
            required
          >
            <option value="1">1S (primer semestre)</option>
            <option value="2">2S (segundo semestre)</option>
          </Select>

          {formError && (
            <div className="rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600">
              {formError}
            </div>
          )}

          <div className="flex gap-2 justify-end pt-1">
            <Button type="button" variant="outline" onClick={() => { setModalOpen(false); setFormError('') }}>
              Cancelar
            </Button>
            <Button type="submit" loading={createSemestre.isPending}>
              Crear semestre
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
