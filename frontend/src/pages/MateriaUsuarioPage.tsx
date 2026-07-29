import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { ArrowLeft, Plus, Trash2 } from 'lucide-react'
import { api } from '@/lib/api'
import { useQuery } from '@tanstack/react-query'
import { useComponentes, useCreateComponente, useDeleteComponente } from '@/hooks/useComponentes'
import { useNotas, useCreateNota, useDeleteNota } from '@/hooks/useNotas'
import type { MateriaUsuario, Componente } from '@/types'
import { Card, CardHeader, CardContent, CardTitle } from '@/components/ui/Card'
import Button from '@/components/ui/Button'
import Modal from '@/components/ui/Modal'
import Input from '@/components/ui/Input'
import { EstadoBadge } from '@/components/ui/Badge'

// Sub-component: nota list inside a componente
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
      setErr(e2 instanceof Error ? e2.message : 'Error')
    }
  }

  return (
    <div className="mt-3 border-t border-gray-100 dark:border-gray-800 pt-3">
      <div className="flex items-center justify-between mb-2">
        <p className="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wide">
          Notas ({componente.cantidad_notas})
        </p>
        <button
          onClick={() => setOpen(true)}
          className="text-xs text-indigo-600 hover:underline dark:text-indigo-400 flex items-center gap-1"
        >
          <Plus size={12} /> Agregar
        </button>
      </div>

      {notas.length > 0 ? (
        <ul className="flex flex-col gap-1.5">
          {notas.map(n => (
            <li
              key={n.nota_id}
              className="flex items-center justify-between text-sm rounded-md bg-gray-50 dark:bg-gray-800/50 px-3 py-1.5"
            >
              <span className="text-gray-700 dark:text-gray-300">{n.nota_nombre}</span>
              <div className="flex items-center gap-3">
                <span className="font-semibold text-gray-900 dark:text-gray-100">
                  {Number(n.nota_valor).toFixed(1)}
                </span>
                <button
                  onClick={() => deleteNota.mutate(n.nota_id)}
                  className="text-gray-400 hover:text-red-500 transition-colors"
                  aria-label="Eliminar nota"
                >
                  <Trash2 size={14} />
                </button>
              </div>
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-xs text-gray-400">Sin notas aún.</p>
      )}

      <Modal open={open} onClose={() => setOpen(false)} title="Agregar nota">
        <form onSubmit={handleAdd} className="flex flex-col gap-4">
          <Input
            label="Nombre"
            value={form.nombre}
            onChange={e => setForm(f => ({ ...f, nombre: e.target.value }))}
            placeholder="Ej: Taller 1"
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
            required
          />
          <Input
            label="Fecha (opcional)"
            type="date"
            value={form.fecha_registro}
            onChange={e => setForm(f => ({ ...f, fecha_registro: e.target.value }))}
          />
          {err && <p className="text-sm text-red-600">{err}</p>}
          <div className="flex gap-2 justify-end">
            <Button type="button" variant="outline" onClick={() => setOpen(false)}>Cancelar</Button>
            <Button type="submit" loading={createNota.isPending}>Guardar</Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}

export default function MateriaUsuarioPage() {
  const { id } = useParams<{ id: string }>()
  const muId = Number(id)
  const navigate = useNavigate()

  // Fetch materia info
  const { data: materia, isLoading: loadingMateria } = useQuery<MateriaUsuario>({
    queryKey: ['materia-usuario', muId],
    queryFn: () => api.get<MateriaUsuario>(`/materia-usuario/${muId}`),
    enabled: !!muId,
  })

  const { data: componentes = [], isLoading: loadingComp } = useComponentes(muId)
  const createComp = useCreateComponente(muId)
  const deleteComp = useDeleteComponente(muId)

  const [modalOpen, setModalOpen] = useState(false)
  const [form, setForm] = useState({ nombre: '', porcentaje: '', nota_minima: '', orden: '' })
  const [formErr, setFormErr] = useState('')

  // Porcentaje restante
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
      setFormErr(err instanceof Error ? err.message : 'Error')
    }
  }

  if (loadingMateria) return <p className="text-gray-500 p-6">Cargando…</p>
  if (!materia) return <p className="text-red-600 p-6">Materia no encontrada.</p>

  return (
    <div className="max-w-3xl mx-auto">
      {/* Back */}
      <button
        onClick={() => navigate(-1)}
        className="flex items-center gap-1 text-sm text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 mb-4 transition-colors"
      >
        <ArrowLeft size={16} />
        Volver
      </button>

      {/* Header */}
      <div className="flex items-start justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-gray-100">{materia.materia}</h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            {materia.materia_codigo} · {materia.creditos} créditos
          </p>
        </div>
        <div className="flex flex-col items-end gap-2">
          <EstadoBadge estado={materia.estado} />
          {materia.nota_final !== null && (
            <span className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
              {Number(materia.nota_final).toFixed(2)}
            </span>
          )}
          {materia.nota_final === null && materia.nota_acumulada !== null && (
            <span className="text-lg font-semibold text-gray-700 dark:text-gray-300">
              {Number(materia.nota_acumulada).toFixed(2)}
              <span className="text-sm font-normal text-gray-400 ml-1">({materia.porcentaje_evaluado}%)</span>
            </span>
          )}
        </div>
      </div>

      {/* Componentes */}
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <div>
            <CardTitle>Componentes evaluativos</CardTitle>
            <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
              {pctUsado.toFixed(0)}% asignado · {pctRestante.toFixed(0)}% restante
            </p>
          </div>
          <Button size="sm" onClick={() => setModalOpen(true)} disabled={pctRestante === 0}>
            <Plus size={14} />
            Agregar
          </Button>
        </CardHeader>
        <CardContent>
          {loadingComp ? (
            <p className="text-gray-500 text-sm">Cargando…</p>
          ) : componentes.length === 0 ? (
            <p className="text-gray-500 dark:text-gray-400 text-sm">
              No hay componentes. Crea el primero para empezar a registrar notas.
            </p>
          ) : (
            <div className="flex flex-col gap-4">
              {componentes.map(c => (
                <div
                  key={c.componente_id}
                  className="rounded-lg border border-gray-200 dark:border-gray-700 p-4"
                >
                  <div className="flex items-center justify-between">
                    <div>
                      <span className="font-medium text-gray-900 dark:text-gray-100">{c.componente_nombre}</span>
                      <span className="ml-2 text-xs text-gray-500 dark:text-gray-400">
                        {Number(c.componente_porcentaje)}%
                      </span>
                    </div>
                    <div className="flex items-center gap-3">
                      {c.promedio_componente !== null && (
                        <span className="text-sm font-semibold text-gray-900 dark:text-gray-100">
                          {Number(c.promedio_componente).toFixed(2)}
                        </span>
                      )}
                      <button
                        onClick={() => deleteComp.mutate(c.componente_id)}
                        className="text-gray-400 hover:text-red-500 transition-colors"
                        aria-label="Eliminar componente"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </div>
                  <NotasList componente={c} muId={muId} />
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Modal nuevo componente */}
      <Modal open={modalOpen} onClose={() => setModalOpen(false)} title="Nuevo componente">
        <form onSubmit={handleCrearComp} className="flex flex-col gap-4">
          <Input
            label="Nombre"
            value={form.nombre}
            onChange={e => setForm(f => ({ ...f, nombre: e.target.value }))}
            placeholder="Ej: Parcial 1"
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
          />
          <Input
            label="Orden"
            type="number"
            min="1"
            value={form.orden}
            onChange={e => setForm(f => ({ ...f, orden: e.target.value }))}
            required
          />
          {formErr && <p className="text-sm text-red-600">{formErr}</p>}
          <div className="flex gap-2 justify-end">
            <Button type="button" variant="outline" onClick={() => setModalOpen(false)}>Cancelar</Button>
            <Button type="submit" loading={createComp.isPending}>Crear</Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
