import { useState, useEffect, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuthContext } from '@/context/AuthContext'
import { api } from '@/lib/api'
import type { Universidad, Programa } from '@/types'
import Input from '@/components/ui/Input'
import SelectUI from '@/components/ui/Select'
import Button from '@/components/ui/Button'

export default function RegisterPage() {
  const { register } = useAuthContext()
  const navigate = useNavigate()

  const [form, setForm] = useState({
    nombre: '',
    apellido: '',
    email: '',
    password: '',
    codigo_estudiantil: '',
    universidad_id: '',
    programa_id: '',
  })
  const [universidades, setUniversidades] = useState<Universidad[]>([])
  const [programas, setProgramas] = useState<Programa[]>([])
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    api.get<Universidad[]>('/universidades').then(setUniversidades).catch(() => {})
  }, [])

  useEffect(() => {
    if (!form.universidad_id) { setProgramas([]); return }
    setProgramas([])
    api.get<Programa[]>(`/universidades/${form.universidad_id}/programas`).then(setProgramas).catch(() => {})
  }, [form.universidad_id])

  function set(field: string) {
    return (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) =>
      setForm(f => ({ ...f, [field]: e.target.value }))
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError('')
    if (!form.programa_id) { setError('Selecciona un programa académico.'); return }
    setLoading(true)
    try {
      await register({
        nombre: form.nombre,
        apellido: form.apellido,
        email: form.email,
        password: form.password,
        programa_id: Number(form.programa_id),
        codigo_estudiantil: form.codigo_estudiantil || undefined,
      })
      navigate('/dashboard')
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al registrarse')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="w-full rounded-2xl bg-white shadow-[var(--shadow-elevated)] p-8">
      <h1 className="text-2xl font-semibold text-pine-900 mb-1">Crear cuenta</h1>
      <p className="text-sm text-gray-400 mb-6">Completa tus datos para empezar</p>

      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <div className="grid grid-cols-2 gap-3">
          <Input label="Nombre" value={form.nombre} onChange={set('nombre')} placeholder="Sergio" required />
          <Input label="Apellido" value={form.apellido} onChange={set('apellido')} placeholder="Chaves" required />
        </div>

        <Input
          label="Correo electrónico"
          type="email"
          value={form.email}
          onChange={set('email')}
          placeholder="usuario@unal.edu.co"
          autoComplete="email"
          required
        />

        <Input
          label="Contraseña"
          type="password"
          value={form.password}
          onChange={set('password')}
          placeholder="••••••••"
          autoComplete="new-password"
          required
        />

        <Input
          label="Código estudiantil (opcional)"
          value={form.codigo_estudiantil}
          onChange={set('codigo_estudiantil')}
          placeholder="1014990992"
        />

        <SelectUI
          label="Universidad"
          value={form.universidad_id}
          onChange={set('universidad_id')}
          required
        >
          <option value="">Selecciona una universidad</option>
          {universidades.map(u => (
            <option key={u.universidad_id} value={u.universidad_id}>
              {u.universidad_nombre}
            </option>
          ))}
        </SelectUI>

        <SelectUI
          label="Programa académico"
          value={form.programa_id}
          onChange={set('programa_id')}
          disabled={!form.universidad_id || programas.length === 0}
          required
        >
          <option value="">
            {!form.universidad_id
              ? 'Primero selecciona una universidad'
              : programas.length === 0
              ? 'Cargando programas…'
              : 'Selecciona un programa'}
          </option>
          {programas.map(p => (
            <option key={p.programa_id} value={p.programa_id}>
              {p.programa_nombre}
            </option>
          ))}
        </SelectUI>

        {error && (
          <div className="rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600">
            {error}
          </div>
        )}

        <Button type="submit" loading={loading} size="lg" className="mt-1 w-full">
          Crear cuenta
        </Button>
      </form>

      <p className="mt-5 text-center text-sm text-gray-400">
        ¿Ya tienes cuenta?{' '}
        <Link to="/login" className="text-brand-600 font-medium hover:underline">
          Inicia sesión
        </Link>
      </p>
    </div>
  )
}
