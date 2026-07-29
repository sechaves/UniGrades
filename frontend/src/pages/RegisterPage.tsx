import { useState, useEffect, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuthContext } from '@/context/AuthContext'
import { api } from '@/lib/api'
import type { Universidad, Programa } from '@/types'
import Input from '@/components/ui/Input'
import Select from '@/components/ui/Select'
import Button from '@/components/ui/Button'
import { Card, CardContent } from '@/components/ui/Card'

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
    if (!form.universidad_id) return
    setProgramas([])
    api
      .get<Programa[]>(`/universidades/${form.universidad_id}/programas`)
      .then(setProgramas)
      .catch(() => {})
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
    <Card>
      <CardContent className="pt-6">
        <h1 className="text-xl font-semibold text-gray-900 dark:text-gray-100 mb-6">
          Crear cuenta
        </h1>
        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <div className="grid grid-cols-2 gap-3">
            <Input label="Nombre" value={form.nombre} onChange={set('nombre')} required />
            <Input label="Apellido" value={form.apellido} onChange={set('apellido')} required />
          </div>
          <Input
            label="Correo electrónico"
            type="email"
            value={form.email}
            onChange={set('email')}
            autoComplete="email"
            required
          />
          <Input
            label="Contraseña"
            type="password"
            value={form.password}
            onChange={set('password')}
            autoComplete="new-password"
            required
          />
          <Input
            label="Código estudiantil (opcional)"
            value={form.codigo_estudiantil}
            onChange={set('codigo_estudiantil')}
          />
          <Select
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
          </Select>
          <Select
            label="Programa académico"
            value={form.programa_id}
            onChange={set('programa_id')}
            disabled={!form.universidad_id}
            required
          >
            <option value="">Selecciona un programa</option>
            {programas.map(p => (
              <option key={p.programa_id} value={p.programa_id}>
                {p.programa_nombre}
              </option>
            ))}
          </Select>
          {error && (
            <p role="alert" className="text-sm text-red-600 dark:text-red-400">{error}</p>
          )}
          <Button type="submit" loading={loading} size="lg" className="mt-2">
            Crear cuenta
          </Button>
        </form>
        <p className="mt-4 text-center text-sm text-gray-500 dark:text-gray-400">
          ¿Ya tienes cuenta?{' '}
          <Link to="/login" className="text-indigo-600 hover:underline dark:text-indigo-400">
            Inicia sesión
          </Link>
        </p>
      </CardContent>
    </Card>
  )
}
