import { useState, useEffect, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { ArrowRight } from 'lucide-react'
import { useAuthContext } from '@/context/AuthContext'
import { api } from '@/lib/api'
import type { Universidad, Programa } from '@/types'
import Input from '@/components/ui/Input'
import Select from '@/components/ui/Select'
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
  const [loadingProgramas, setLoadingProgramas] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    api.get<Universidad[]>('/universidades').then(setUniversidades).catch(() => {})
  }, [])

  useEffect(() => {
    if (!form.universidad_id) {
      setProgramas([])
      return
    }
    setLoadingProgramas(true)
    setForm(f => ({ ...f, programa_id: '' }))
    api
      .get<Programa[]>(`/universidades/${form.universidad_id}/programas`)
      .then(setProgramas)
      .catch(() => setProgramas([]))
      .finally(() => setLoadingProgramas(false))
  }, [form.universidad_id])

  function set(field: string) {
    return (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) =>
      setForm(f => ({ ...f, [field]: e.target.value }))
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError('')
    if (!form.programa_id) {
      setError('Selecciona un programa académico.')
      return
    }
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
    <div>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900">Crea tu cuenta</h1>
        <p className="text-gray-500 mt-1 text-sm">Empieza a llevar tu seguimiento académico</p>
      </div>

      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <div className="grid grid-cols-2 gap-3">
          <Input
            label="Nombre"
            value={form.nombre}
            onChange={set('nombre')}
            placeholder="Juan"
            required
          />
          <Input
            label="Apellido"
            value={form.apellido}
            onChange={set('apellido')}
            placeholder="García"
            required
          />
        </div>

        <Input
          label="Correo electrónico"
          type="email"
          value={form.email}
          onChange={set('email')}
          autoComplete="email"
          placeholder="tu@correo.edu.co"
          required
        />

        <Input
          label="Contraseña"
          type="password"
          value={form.password}
          onChange={set('password')}
          autoComplete="new-password"
          placeholder="Mínimo 8 caracteres"
          required
        />

        <Input
          label="Código estudiantil (opcional)"
          value={form.codigo_estudiantil}
          onChange={set('codigo_estudiantil')}
          placeholder="20241234567"
        />

        <Select
          label="Universidad"
          value={form.universidad_id}
          onChange={set('universidad_id')}
          required
          error={universidades.length === 0 ? undefined : undefined}
        >
          <option value="">
            {universidades.length === 0 ? 'Cargando universidades…' : 'Selecciona tu universidad'}
          </option>
          {universidades.map(u => (
            <option key={u.universidad_id} value={u.universidad_id}>
              {u.universidad_nombre}
            </option>
          ))}
        </Select>

        <Select
          label="Programa académico"
          value={form.programa_id}
          onChange={set('programa_id')}
          disabled={!form.universidad_id || loadingProgramas}
          required
        >
          <option value="">
            {!form.universidad_id
              ? 'Primero selecciona una universidad'
              : loadingProgramas
              ? 'Cargando programas…'
              : programas.length === 0
              ? 'No hay programas disponibles'
              : 'Selecciona tu programa'}
          </option>
          {programas.map(p => (
            <option key={p.programa_id} value={p.programa_id}>
              {p.programa_nombre}
            </option>
          ))}
        </Select>

        {error && (
          <div
            role="alert"
            className="rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600 flex items-center gap-2"
          >
            <span className="w-1.5 h-1.5 rounded-full bg-red-500 shrink-0" />
            {error}
          </div>
        )}

        <Button type="submit" loading={loading} size="lg" className="mt-1 w-full">
          Crear cuenta
          {!loading && <ArrowRight size={16} />}
        </Button>
      </form>

      <p className="mt-6 text-center text-sm text-gray-500">
        ¿Ya tienes cuenta?{' '}
        <Link to="/login" className="font-medium text-brand-600 hover:text-brand-700">
          Inicia sesión
        </Link>
      </p>
    </div>
  )
}
