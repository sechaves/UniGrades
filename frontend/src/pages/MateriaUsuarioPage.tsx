import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { ArrowLeft, Plus, Trash2, ChevronDown, ChevronUp } from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'
import { useComponentes, useCreateComponente, useDeleteComponente } from '@/hooks/useComponentes'
import { useNotas, useCreateNota, useDeleteNota } from '@/hooks/useNotas'
import type { MateriaUsuario, Componente } from '@/types'
import { Card, CardContent } from '@/components/ui/Card'
import Button from '@/components/ui/Button'
import Modal from '@/components/ui/Modal'
import Input from '@/components/ui/Input'
import { EstadoBadge } from '@/components/ui/Badge'
import { Skeleton } from '@/components/ui/Skeleton'

/* ──────────────────────────── Notas list ──────────────────────────── */
function NotasList({ componente, muId }: { componente: Componente; muId: number }) {
  const { data: notas = [] } = useNotas(componente.componente_id)
  const createNota = useCreateNota(componente.componente_id, muId)
  const deleteNota = useDeleteNota(componente.componente_id, muId)

  const [open, setOpen] = useState(false)
  const [form, setForm] = useState({ nombre: '', valor: '', fecha_registro: '' })
  const [err, setErr] = useState('')

  async function handleAdd(e: React.FormEvent) {
    e.preventDefault()
    setErr('')
    try {
      await createNota.mutateAsync({
        nombre: form.nombre,
        valor: Number(form.valor),
        fecha_registro: form.fecha_registro || undefined,
      })
      setOpen(false)
      setForm({ nombre: '', valor: '', fecha_registro: '' })
    } catch (e2) {
      setErr(e2 instanceof Error ? e2.message : 'Error al agregar nota')
    }
  }

  return (
    <div className="mt-3 pt-3 border-t border-gray-50">
      <div className="flex items-center justify-between mb-2.5">
        <p className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
          Notas ({componente.cantidad_notas})
        </p>
        <button
          onClick={() => setOpen(true)}
          className="inline-flex items-center gap-1 text-xs font-medium text-brand-600 hover:text-brand-700 transition-colors"
        >
          <Plus size={12} />
          Agregar nota
        </button>
      </div>

      {notas.length > 0 ? (
        <ul className="space-y-1.5">
          {notas.map(n => (
            <motion.li
              key={n.nota_id}
              initial={{ opacity: 0, x: -6 }}
              animate={{ opacity: 1, x: 0 }}
              className="group flex items-center justify-between text-sm rounded-xl bg-gray-50 px-3.5 py-2"
            >
              <div className="flex items-center gap-2 min-w-0">
                <span className="w-1.5 h-1.5 rounded-full bg-brand-400 shrink-0" />
                <span className="text-gray-700 truncate">{n.nota_nombre}</span>
              </div>
              <div className="flex items-center gap-3 shrink-0 ml-3">
                <span className="font-bold text-gray-900 tabular-nums">
                  {Number(n.nota_valor).toFixed(1)}
                </span>
                <button
                  onClick={() => deleteNota.mutate(n.nota_id)}
                  className="opacity-0 group-hover:opacity-100 text-gray-300 hover:text-red-500 transition-all"
                  aria-label="Eliminar nota"
                >
                  <Trash2 size={14} />
                </button>
              </div>
            </motion.li>
          ))}
        </ul>
      ) : (
        <p className="text-xs text-gray-300 text-center py-2">Sin notas registradas.</p>
      )}

      <Modal open={open} onClose={() => setOpen(false)} title="Agregar nota">
        <form onSubmit={handleAdd} className="flex flex-col gap-4">
          <Input
            label="Nombre de la nota"
            value={form.nombre}
            onChange={e => setForm(f => ({ ...f, nombre: e.target.value }))}
            placeholder="Ej: Taller 1, Parcial 2…"
            required
          />
          <Input
            label="Valor (0.0 – 5.0)"
            type="number"
            step="0.1"
            min="0"
            max="5"
            value={form.valor}
            onChange={e => setForm(f => ({ ...f, valor: e.target.value }))}
            placeholder="3.8"
            required
          />
          <Input
            label="Fecha (opcional)"
            type="date"
            value={form.fecha_registro}
            onChange={e => setForm(f => ({ ...f, fecha_registro: e.target.value }))}
          />
          {err && (
            <div className="rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600">
              {err}
            </div>
          )}
          <div className="flex gap-2 justify-end pt-1">
            <Button type="button" variant="outline" onClick={() => setOpen(false)}>
              Cancelar
            </Button>
            <Button type="submit" loading={createNota.isPending}>
              Guardar nota
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}

/* ──────────────────────────── Componente card ──────────────────────────── */
function ComponenteCard({ c, muId }: { c: Componente; muId: number }) {
  const deleteComp = useDeleteComponente(muId)
  const [expanded, setExpanded] = useState(true)

  const pct = Number(c.componente_porcentaje)
  const promedio = c.promedio_componente !== null ? Number(c.promedio_componente) : null
  const grade = promedio !== null
    ? promedio >= 3.0 ? 'text-brand-600' : 'text-red-600'
    : 'text-gray-400'

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      className="rounded-2xl border border-gray-100 bg-white shadow-[var(--shadow-card)] overflow-hidden"
    >
      <div className="flex items-center justify-between px-5 py-4">
        <div className="flex items-center gap-3 min-w-0">
          {/* Weight pill */}
          <span className="shrink-0 inline-flex items-center justify-center rounded-xl bg-brand-50 text-brand-700 text-xs font-bold px-2.5 py-1 min-w-[52px]">
            {pct}%
          </span>
          <span className="font-medium text-gray-900 truncate">{c.componente_nombre}</span>
        </div>

        <div className="flex items-center gap-3 shrink-0 ml-3">
          {promedio !== null && (
            <span className={`font-bold tabular-nums ${grade}`}>
              {promedio.toFixed(2)}
            </span>
          )}
          <button
            onClick={() => deleteComp.mutate(c.componente_id)}
            className="p-1.5 rounded-lg text-gray-300 hover:text-red-500 hover:bg-red-50 transition-all"
            aria-label="Eliminar componente"
          >
            <Trash2 size={15} />
          </button>
          <button
            onClick={() => setExpanded(v => !v)}
            className="p-1.5 rounded-lg text-gray-400 hover:bg-gray-50 transition-all"
            aria-label={expanded ? 'Colapsar' : 'Expandir'}
          >
            {expanded ? <ChevronUp size={15} /> : <ChevronDown size={15} />}
          </button>
        </div>
      </div>

      <AnimatePresence initial={false}>
        {expanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.2 }}
            className="overflow-hidden"
          >
            <div className="px-5 pb-4">
              <NotasList componente={c} muId={muId} />
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  )
}

/* ──────────────────────────── Page ──────────────────────────── */
export default function MateriaUsuarioPage() {
  const { id } = useParams<{ id: string }>()
  const muId = Number(id)
  const navigate = useNavigate()

  const { data: materia, isLoading: loadingMateria } = useQuery<MateriaUsuario>({
    queryKey: ['materia-usuario', muId],
    queryFn: () => api.get<MateriaUsuario>(`/materia-usuario/${muId}`),
    enabled: !!muId,
  })

  const { data: componentes = [], isLoading: loadingComp } = useComponentes(muId)
  const createComp = useCreateComponente(muId)

  const [modalOpen, setModalOpen] = useState(false)
  const [form, setForm] = useState({ nombre: '', porcentaje: '', nota_minima: '', orden: '' })
  const [formErr, setFormErr] = useState('')

  const pctUsado = componentes.reduce((acc, c) => acc + Number(c.componente_porcentaje), 0)
  const pctRestante = Math.max(0, 100 - pctUsado)

  async function handleCrearComp(e: React.FormEvent) {
    e.preventDefault()
    setFormErr('')
    try {
      await createComp.mutateAsync({
        nombre: form.nombre,
        porcentaje: Number(form.porcentaje),
        nota_minima: form.nota_minima ? Number(form.nota_minima) : undefined,
        orden: Number(form.orden),
      })
      setModalOpen(false)
      setForm({ nombre: '', porcentaje: '', nota_minima: '', orden: '' })
    } catch (err) {
      setFormErr(err instanceof Error ? err.message : 'Error al crear componente')
    }
  }

  if (loadingMateria) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-48" />
        <Skeleton className="h-24 w-full" />
        <Skeleton className="h-40 w-full" />
      </div>
    )
  }

  if (!materia) {
    return (
      <div className="rounded-2xl border border-red-100 bg-red-50 p-6 text-red-600">
        Materia no encontrada.
      </div>
    )
  }

  const notaFinal = materia.nota_final !== null ? Number(materia.nota_final) : null
  const notaAcum = materia.nota_acumulada !== null ? Number(materia.nota_acumulada) : null
  const notaColor =
    materia.estado === 'aprobada' ? 'text-brand-600' :
    materia.estado === 'reprobada' ? 'text-red-600' : 'text-gray-900'

  return (
    <div className="space-y-6">
      {/* Back */}
      <button
        onClick={() => navigate(-1)}
        className="inline-flex items-center gap-1.5 text-sm text-gray-400 hover:text-gray-700 transition-colors"
      >
        <ArrowLeft size={15} />
        Volver
      </button>

      {/* Header card */}
      <Card className="p-0 overflow-hidden">
        <div className="h-1.5 brand-gradient" />
        <CardContent className="py-5">
          <div className="flex items-start justify-between gap-4">
            <div className="min-w-0">
              <h1 className="text-xl font-bold text-gray-900 leading-tight">{materia.materia}</h1>
              <p className="text-sm text-gray-400 mt-1">
                {materia.materia_codigo} · {materia.creditos} créditos
              </p>
            </div>
            <div className="flex flex-col items-end gap-2 shrink-0">
              <EstadoBadge estado={materia.estado} />
              {notaFinal !== null && (
                <span className={`text-3xl font-extrabold tabular-nums ${notaColor}`}>
                  {notaFinal.toFixed(2)}
                </span>
              )}
              {notaFinal === null && notaAcum !== null && (
                <div className="text-right">
                  <span className="text-2xl font-bold text-gray-800 tabular-nums">
                    {notaAcum.toFixed(2)}
                  </span>
                  <span className="text-xs text-gray-400 ml-1.5">
                    ({materia.porcentaje_evaluado}% eval.)
                  </span>
                </div>
              )}
            </div>
          </div>

          {/* Progress bar of evaluated % */}
          {materia.porcentaje_evaluado !== null && (
            <div className="mt-4">
              <div className="flex justify-between text-xs text-gray-400 mb-1.5">
                <span>Porcentaje evaluado</span>
                <span className="tabular-nums">{materia.porcentaje_evaluado}%</span>
              </div>
              <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                <motion.div
                  initial={{ width: 0 }}
                  animate={{ width: `${materia.porcentaje_evaluado}%` }}
                  transition={{ duration: 0.7, ease: 'easeOut' }}
                  className="h-full brand-gradient rounded-full"
                />
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Componentes */}
      <div>
        <div className="flex items-center justify-between mb-4">
          <div>
            <h2 className="text-base font-semibold text-gray-900">Componentes evaluativos</h2>
            <p className="text-xs text-gray-400 mt-0.5">
              <span className="text-brand-600 font-medium">{pctUsado.toFixed(0)}%</span> asignado
              {' · '}
              <span>{pctRestante.toFixed(0)}% restante</span>
            </p>
          </div>
          <Button
            size="sm"
            onClick={() => setModalOpen(true)}
            disabled={pctRestante <= 0}
          >
            <Plus size={15} />
            Agregar
          </Button>
        </div>

        {loadingComp ? (
          <div className="space-y-3">
            {[0, 1].map(i => <Skeleton key={i} className="h-20 w-full" />)}
          </div>
        ) : componentes.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-gray-200 p-10 text-center">
            <p className="font-medium text-gray-600 mb-1">Sin componentes aún</p>
            <p className="text-sm text-gray-400 mb-4">
              Agrega parciales, talleres o cualquier actividad evaluativa.
            </p>
            <Button size="sm" onClick={() => setModalOpen(true)}>
              <Plus size={15} />
              Agregar componente
            </Button>
          </div>
        ) : (
          <div className="space-y-3">
            {componentes.map(c => (
              <ComponenteCard key={c.componente_id} c={c} muId={muId} />
            ))}
          </div>
        )}
      </div>

      {/* Modal nuevo componente */}
      <Modal
        open={modalOpen}
        onClose={() => { setModalOpen(false); setFormErr('') }}
        title="Nuevo componente evaluativo"
      >
        <form onSubmit={handleCrearComp} className="flex flex-col gap-4">
          <Input
            label="Nombre"
            value={form.nombre}
            onChange={e => setForm(f => ({ ...f, nombre: e.target.value }))}
            placeholder="Ej: Parcial 1, Proyecto final…"
            required
          />
          <Input
            label={`Porcentaje (máx. ${pctRestante}%)`}
            type="number"
            step="0.01"
            min="0.01"
            max={pctRestante}
            value={form.porcentaje}
            onChange={e => setForm(f => ({ ...f, porcentaje: e.target.value }))}
            hint={`Quedan ${pctRestante}% por asignar`}
            required
          />
          <Input
            label="Nota mínima (opcional)"
            type="number"
            step="0.1"
            min="0"
            max="5"
            value={form.nota_minima}
            onChange={e => setForm(f => ({ ...f, nota_minima: e.target.value }))}
            placeholder="Ej: 3.0"
          />
          <Input
            label="Orden"
            type="number"
            min="1"
            value={form.orden}
            onChange={e => setForm(f => ({ ...f, orden: e.target.value }))}
            placeholder={String(componentes.length + 1)}
            required
          />

          {formErr && (
            <div className="rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600">
              {formErr}
            </div>
          )}

          <div className="flex gap-2 justify-end pt-1">
            <Button type="button" variant="outline" onClick={() => { setModalOpen(false); setFormErr('') }}>
              Cancelar
            </Button>
            <Button type="submit" loading={createComp.isPending}>
              Crear componente
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
