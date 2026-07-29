import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Plus, BookOpen, TrendingUp, Award } from 'lucide-react'
import { useAuthContext } from '@/context/AuthContext'
import { useSemestres, useCreateSemestre } from '@/hooks/useSemestres'
import { usePromedioGlobal, useAvanceTipologia } from '@/hooks/useProgreso'
import { Card, CardHeader, CardContent, CardTitle } from '@/components/ui/Card'
import Button from '@/components/ui/Button'
import Modal from '@/components/ui/Modal'
import Input from '@/components/ui/Input'
import Select from '@/components/ui/Select'

function StatCard({ label, value, icon }: { label: string; value: string | number; icon: React.ReactNode }) {
  return (
    <Card>
      <CardContent className="flex items-center gap-4 py-5">
        <div className="p-3 rounded-lg bg-brand-50 dark:bg-brand-100/60">{icon}</div>
        <div>
          <p className="text-sm text-gray-500 dark:text-gray-400">{label}</p>
          <p className="text-2xl font-bold text-gray-900 dark:text-gray-100">{value}</p>
        </div>
      </CardContent>
    </Card>
  )
}

export default function DashboardPage() {
  const { user } = useAuthContext()
  const navigate = useNavigate()
  const usuarioId = user!.usuario_id

  const { data: semestres = [], isLoading } = useSemestres(usuarioId)
  const { data: promedio } = usePromedioGlobal(usuarioId)
  const { data: avance = [] } = useAvanceTipologia(usuarioId)
  const createSemestre = useCreateSemestre(usuarioId)

  const [modalOpen, setModalOpen] = useState(false)
  const [form, setForm] = useState({ semestre_numero: '', semestre_year: new Date().getFullYear().toString(), semestre_periodo: '1' })
  const [formError, setFormError] = useState('')

  function set(field: string) {
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

  return (
    <div className="max-w-5xl mx-auto">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-gray-100">
          Hola, {user?.usuario_nombre} 👋
        </h1>
        <p className="text-gray-500 dark:text-gray-400 mt-1">
          Aquí está tu progreso académico
        </p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
        <StatCard
          label="Promedio global"
          value={promedio?.promedio_global != null ? promedio.promedio_global.toFixed(2) : '—'}
          icon={<TrendingUp size={20} className="text-brand-600" />}
        />
        <StatCard
          label="Créditos cursados"
          value={promedio?.total_creditos_cursados ?? 0}
          icon={<BookOpen size={20} className="text-brand-600" />}
        />
        <StatCard
          label="Créditos aprobados"
          value={promedio?.total_creditos_aprobados ?? 0}
          icon={<Award size={20} className="text-brand-600" />}
        />
      </div>

      {/* Avance por tipología */}
      {avance.length > 0 && (
        <Card className="mb-8">
          <CardHeader>
            <CardTitle>Avance por tipología</CardTitle>
          </CardHeader>
          <CardContent className="flex flex-col gap-4">
            {avance.map(t => {
              const pct = t.creditos_requeridos > 0
                ? Math.min(100, Math.round((t.creditos_aprobados / t.creditos_requeridos) * 100))
                : 0
              return (
                <div key={t.tipologia_id}>
                  <div className="flex justify-between text-sm mb-1">
                    <span className="text-gray-700 dark:text-gray-300">{t.tipologia}</span>
                    <span className="text-gray-500 dark:text-gray-400">
                      {t.creditos_aprobados} / {t.creditos_requeridos} créditos
                    </span>
                  </div>
                  <div className="w-full h-2 bg-gray-100 rounded-full dark:bg-gray-800">
                    <div
                      className="h-2 rounded-full bg-brand-500 transition-all"
                      style={{ width: `${pct}%` }}
                      role="progressbar"
                      aria-valuenow={pct}
                      aria-valuemin={0}
                      aria-valuemax={100}
                    />
                  </div>
                </div>
              )
            })}
          </CardContent>
        </Card>
      )}

      {/* Semestres */}
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle>Semestres</CardTitle>
          <Button size="sm" onClick={() => setModalOpen(true)}>
            <Plus size={14} />
            Nuevo semestre
          </Button>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <p className="text-gray-500 text-sm">Cargando…</p>
          ) : semestres.length === 0 ? (
            <p className="text-gray-500 dark:text-gray-400 text-sm">
              No tienes semestres aún.{' '}
              <button className="text-brand-600 hover:underline" onClick={() => setModalOpen(true)}>
                Crea el primero
              </button>
            </p>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
              {semestres.map(s => (
                <button
                  key={s.semestre_id}
                  onClick={() => navigate(`/semestres/${s.semestre_id}`)}
                  className="text-left rounded-lg border border-gray-200 dark:border-gray-700 p-4 hover:border-brand-500 hover:shadow-sm transition-all group"
                >
                  <p className="font-semibold text-gray-900 dark:text-gray-100 group-hover:text-brand-600">
                    Semestre {s.semestre_numero}
                  </p>
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    {s.semestre_year} · Período {s.semestre_periodo}
                  </p>
                  {s.promedio_semestre != null && (
                    <p className="mt-2 text-lg font-bold text-brand-600 dark:text-brand-500">
                      {Number(s.promedio_semestre).toFixed(2)}
                    </p>
                  )}
                </button>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Modal nuevo semestre */}
      <Modal open={modalOpen} onClose={() => setModalOpen(false)} title="Nuevo semestre">
        <form onSubmit={handleCrearSemestre} className="flex flex-col gap-4">
          <Input
            label="Número de semestre"
            type="number"
            min={1}
            max={20}
            value={form.semestre_numero}
            onChange={set('semestre_numero')}
            required
          />
          <Input
            label="Año"
            type="number"
            min={2000}
            max={2099}
            value={form.semestre_year}
            onChange={set('semestre_year')}
            required
          />
          <Select
            label="Período"
            value={form.semestre_periodo}
            onChange={set('semestre_periodo')}
            required
          >
            <option value="1">1S</option>
            <option value="2">2S</option>
          </Select>
          {formError && <p className="text-sm text-red-600">{formError}</p>}
          <div className="flex gap-2 justify-end mt-2">
            <Button type="button" variant="outline" onClick={() => setModalOpen(false)}>
              Cancelar
            </Button>
            <Button type="submit" loading={createSemestre.isPending}>
              Crear
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
