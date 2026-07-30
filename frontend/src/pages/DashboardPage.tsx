import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { Plus, BookOpen, Award, Calendar, ChevronRight, ArrowUpRight } from 'lucide-react'
import { motion, animate } from 'framer-motion'
import { useAuthContext } from '@/context/AuthContext'
import { useSemestres, useCreateSemestre } from '@/hooks/useSemestres'
import { usePromedioGlobal, useAvanceTipologia } from '@/hooks/useProgreso'
import { Card, CardContent } from '@/components/ui/Card'
import Button from '@/components/ui/Button'
import Modal from '@/components/ui/Modal'
import Input from '@/components/ui/Input'
import SelectUI from '@/components/ui/Select'
import { SkeletonCard } from '@/components/ui/Skeleton'

/* ─────────────────────────────────────────────────────────────
   Utilidad: count-up animado para números (PAPA, créditos, etc.)
───────────────────────────────────────────────────────────── */
function useCountUp(target: number, decimals = 0, duration = 1.1) {
  const [value, setValue] = useState(0)
  useEffect(() => {
    const safeTarget = Number(target) || 0
    const controls = animate(0, safeTarget, {
      duration,
      ease: [0.16, 1, 0.3, 1],
      onUpdate: (v) => setValue(Number(v) || 0),
    })
    return () => controls.stop()
  }, [target, duration]) // eslint-disable-line react-hooks/exhaustive-deps
  return (Number(value) || 0).toFixed(decimals)
}

/* ─────────────────────────────────────────────────────────────
   Sello de Progreso — anillo doble tipo sello académico
   con stroke-draw animado.
───────────────────────────────────────────────────────────── */
function ProgressSeal({ value, max = 5 }: { value: number; max?: number }) {
  const size = 168
  const stroke = 9
  const r = (size - stroke) / 2
  const circumference = 2 * Math.PI * r
  const pct = Math.max(0, Math.min(1, value / max))
  const displayed = useCountUp(value, 2, 1.3)
  return (
    <div className="relative shrink-0" style={{ width: size, height: size }}>
      <svg width={size} height={size} className="-rotate-90">
        {/* anillo exterior decorativo */}
        <circle
          cx={size / 2} cy={size / 2} r={r + stroke / 2 + 5}
          fill="none" stroke="currentColor" strokeWidth={1}
          strokeDasharray="2 6" className="text-brand-200"
        />
        {/* pista */}
        <circle
          cx={size / 2} cy={size / 2} r={r}
          fill="none" stroke="currentColor" strokeWidth={stroke}
          className="text-mist-100"
        />
        {/* progreso */}
        <motion.circle
          cx={size / 2} cy={size / 2} r={r}
          fill="none" stroke="currentColor" strokeWidth={stroke}
          strokeLinecap="round" className="text-brand-500"
          strokeDasharray={circumference}
          initial={{ strokeDashoffset: circumference }}
          animate={{ strokeDashoffset: circumference * (1 - pct) }}
          transition={{ duration: 1.3, ease: [0.16, 1, 0.3, 1], delay: 0.15 }}
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="font-display text-4xl font-semibold text-pine-900 tabular-nums leading-none">
          {displayed}
        </span>
        <span className="mt-1.5 text-[11px] font-mono uppercase tracking-[0.14em] text-gray-400">
          PAPA · /{Number(max).toFixed(0)}
        </span>
      </div>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────────
   Fila de ledger — tipología con línea punteada de líder
───────────────────────────────────────────────────────────── */
function LedgerRow({
  label, aprobados, requeridos, delay,
}: {
  label: string; aprobados: number; requeridos: number; delay: number
}) {
  const pct = requeridos > 0 ? Math.min(100, Math.round((aprobados / requeridos) * 100)) : 0
  const complete = pct >= 100
  return (
    <motion.div
      initial={{ opacity: 0, x: -8 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay, duration: 0.4, ease: 'easeOut' }}
      className="group"
    >
      <div className="flex items-baseline gap-3">
        <span className="text-sm font-medium text-gray-700 whitespace-nowrap">{label}</span>
        <span className="flex-1 border-b border-dotted border-gray-300 translate-y-[-3px]" aria-hidden />
        <span className="font-mono text-sm tabular-nums text-gray-400 whitespace-nowrap">
          {aprobados}<span className="text-gray-300"> / </span>{requeridos}<span className="text-gray-300"> cr</span>
        </span>
      </div>
      <div className="relative h-1.5 mt-2 bg-mist-100 rounded-full overflow-hidden">
        <motion.div
          initial={{ width: 0 }}
          animate={{ width: `${pct}%` }}
          transition={{ delay: delay + 0.1, duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          className={`absolute inset-y-0 left-0 rounded-full ${complete ? 'bg-amber-400' : 'brand-gradient'}`}
        />
      </div>
    </motion.div>
  )
}

/* ─────────────────────────────────────────────────────────────
   Nodo de semestre en el timeline conectado
───────────────────────────────────────────────────────────── */
function SemesterNode({
  semestre, onClick, delay,
}: {
  semestre: { semestre_id: number; semestre_numero: number; semestre_year: number; semestre_periodo: 1 | 2; promedio_semestre: number | null }
  onClick: () => void
  delay: number
}) {
  return (
    <motion.button
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ delay, duration: 0.35, ease: 'easeOut' }}
      whileHover={{ y: -3 }}
      onClick={onClick}
      className="group relative shrink-0 text-left w-[168px] rounded-2xl border border-gray-100 bg-white p-4 shadow-[var(--shadow-card)] hover:shadow-[var(--shadow-card-hover)] hover:border-brand-200 transition-shadow duration-200"
    >
      <div className="flex items-center justify-between mb-3">
        <div className="w-9 h-9 rounded-full bg-pine-900 flex items-center justify-center font-display text-white text-sm">
          {semestre.semestre_numero}
        </div>
        <ChevronRight size={15} className="text-gray-300 group-hover:text-brand-500 group-hover:translate-x-0.5 transition-all" />
      </div>
      <p className="text-xs text-gray-400 font-mono">{semestre.semestre_year}-{semestre.semestre_periodo}</p>
      {semestre.promedio_semestre != null ? (
        <p className="mt-2 font-display text-xl font-semibold text-brand-600 tabular-nums">
          {Number(semestre.promedio_semestre).toFixed(2)}
        </p>
      ) : (
        <p className="mt-2 text-sm text-gray-300">Sin notas</p>
      )}
    </motion.button>
  )
}

/* ─────────────────────────────────────────────────────────────
   Página
───────────────────────────────────────────────────────────── */
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
      setForm((f) => ({ ...f, [field]: e.target.value }))
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

  const creditosCursados = useCountUp(promedio?.total_creditos_cursados ?? 0)
  const creditosAprobados = useCountUp(promedio?.total_creditos_aprobados ?? 0)

  return (
    <div className="space-y-10">
      {/* ── Hero: saludo + Sello de Progreso ─────────────────────── */}
      <motion.div
        initial={{ opacity: 0, y: -8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <Card className="p-0 overflow-hidden border-none bg-parchment-50">
          <div className="relative flex flex-col md:flex-row items-center md:items-stretch gap-8 p-6 md:p-8">
            {/* textura sutil de fondo */}
            <div
              className="pointer-events-none absolute inset-0 opacity-[0.04]"
              style={{ backgroundImage: 'radial-gradient(circle at 1px 1px, currentColor 1px, transparent 0)', backgroundSize: '16px 16px' }}
              aria-hidden
            />
            <div className="relative flex-1 flex flex-col justify-center min-w-0">
              <span className="font-mono text-xs uppercase tracking-[0.16em] text-brand-600 mb-2">Resumen académico</span>
              <h1 className="font-display text-3xl md:text-[2.25rem] leading-tight font-semibold text-pine-900">
                Hola, {user?.usuario_nombre}
              </h1>
              <p className="text-gray-500 mt-2 max-w-md">Tu progreso hacia el título, en un solo lugar.</p>
              <div className="flex gap-6 mt-6">
                <div className="flex items-center gap-2.5">
                  <div className="w-9 h-9 rounded-xl bg-blue-50 flex items-center justify-center">
                    <BookOpen size={16} className="text-blue-600" />
                  </div>
                  <div>
                    <p className="font-mono text-lg font-semibold text-gray-900 tabular-nums leading-none">{creditosCursados}</p>
                    <p className="text-xs text-gray-400 mt-0.5">Cursados</p>
                  </div>
                </div>
                <div className="flex items-center gap-2.5">
                  <div className="w-9 h-9 rounded-xl bg-amber-50 flex items-center justify-center">
                    <Award size={16} className="text-amber-600" />
                  </div>
                  <div>
                    <p className="font-mono text-lg font-semibold text-gray-900 tabular-nums leading-none">{creditosAprobados}</p>
                    <p className="text-xs text-gray-400 mt-0.5">Aprobados</p>
                  </div>
                </div>
              </div>
            </div>
            {!loadingPromedio && (
              <div className="relative flex items-center justify-center md:pl-8 md:border-l border-brand-100/60">
                <ProgressSeal value={Number(promedio?.promedio_global ?? 0)} />
              </div>
            )}
          </div>
        </Card>
      </motion.div>

      {/* ── Ledger: avance por tipología ──────────────────────────── */}
      {avance.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15, duration: 0.4 }}
        >
          <Card>
            <CardContent className="pt-5 space-y-5">
              <h2 className="font-display text-lg font-semibold text-pine-900 mb-1">Avance por tipología</h2>
              {avance.map((t, i) => (
                <LedgerRow
                  key={t.tipologia_id}
                  label={t.tipologia}
                  aprobados={t.creditos_aprobados}
                  requeridos={t.creditos_requeridos}
                  delay={0.2 + i * 0.06}
                />
              ))}
            </CardContent>
          </Card>
        </motion.div>
      )}

      {/* ── Timeline de semestres ──────────────────────────────────── */}
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3, duration: 0.4 }}
      >
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-display text-lg font-semibold text-pine-900">Semestres</h2>
          <Button size="sm" onClick={() => setModalOpen(true)}>
            <Plus size={15} />
            Nuevo semestre
          </Button>
        </div>

        {loadingSemestres ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {[0, 1, 2].map((i) => <SkeletonCard key={i} />)}
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
          <div className="relative">
            {/* línea conectora */}
            <div
              className="absolute left-0 right-0 top-[38px] h-px bg-gradient-to-r from-transparent via-brand-200 to-transparent hidden sm:block"
              aria-hidden
            />
            <div className="flex gap-4 overflow-x-auto pb-2 -mx-1 px-1 snap-x">
              {semestres.map((s, i) => (
                <div key={s.semestre_id} className="snap-start">
                  <SemesterNode
                    semestre={s}
                    onClick={() => navigate(`/semestres/${s.semestre_id}`)}
                    delay={i * 0.06}
                  />
                </div>
              ))}
              <motion.button
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: semestres.length * 0.06, duration: 0.35 }}
                onClick={() => setModalOpen(true)}
                className="group shrink-0 w-[168px] rounded-2xl border border-dashed border-gray-200 flex flex-col items-center justify-center gap-2 text-gray-400 hover:text-brand-600 hover:border-brand-300 transition-colors"
              >
                <Plus size={20} />
                <span className="text-xs font-medium">Añadir</span>
              </motion.button>
            </div>
          </div>
        )}
      </motion.div>

      {/* ── Modal nuevo semestre ───────────────────────────────────── */}
      <Modal open={modalOpen} onClose={() => { setModalOpen(false); setFormError('') }} title="Nuevo semestre">
        <form onSubmit={handleCrearSemestre} className="flex flex-col gap-4">
          <Input
            label="Número de semestre"
            type="number" min={1} max={20} placeholder="Ej: 3"
            value={form.semestre_numero}
            onChange={setField('semestre_numero')}
            required
          />
          <Input
            label="Año"
            type="number" min={2000} max={2099}
            placeholder={new Date().getFullYear().toString()}
            value={form.semestre_year}
            onChange={setField('semestre_year')}
            required
          />
          <SelectUI label="Período" value={form.semestre_periodo} onChange={setField('semestre_periodo')} required>
            <option value="1">1S (primer semestre)</option>
            <option value="2">2S (segundo semestre)</option>
          </SelectUI>
          {formError && (
            <div className="rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600 flex items-center gap-2">
              <ArrowUpRight size={14} className="rotate-45 shrink-0" />
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
