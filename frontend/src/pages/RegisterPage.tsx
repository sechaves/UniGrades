import { useState, useEffect, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { Select, ListBox, Label } from '@heroui/react'
import { useAuthContext } from '@/context/AuthContext'
import { api } from '@/lib/api'
import type { Universidad, Programa } from '@/types'
import Input from '@/components/ui/Input'
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
  })
  const [universidadId, setUniversidadId] = useState<string>('')
  const [programaId, setProgramaId] = useState<string>('')

  const [universidades, setUniversidades] = useState<Universidad[]>([])
  const [programas, setProgramas] = useState<Programa[]>([])
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    api.get<Universidad[]>('/universidades').then(setUniversidades).catch(() => {})
  }, [])

  useEffect(() => {
    if (!universidadId) { setProgramas([]); return }
    api.get<Programa[]>(`/universidades/${universidadId}/programas`).then(setProgramas).catch(() => {})
  }, [universidadId])

  function set(field: string) {
    return (e: React.ChangeEvent<HTMLInputElement>) =>
      setForm(f => ({ ...f, [field]: e.target.value }))
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError('')
    if (!programaId) { setError('Selecciona un programa académico.'); return }
    setLoading(true)
    try {
      await register({
        nombre: form.nombre,
        apellido: form.apellido,
        email: form.email,
        password: form.password,
        programa_id: Number(programaId),
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
        <h1 className="text-xl font-semibold text-gray-900 mb-6">Crear cuenta</h1>
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

          {/* HeroUI Select — Universidad */}
          <div className="flex flex-col gap-1">
            <Select
              placeholder="Selecciona una universidad"
              selectedKey={universidadId}
              onSelectionChange={key => {
                setUniversidadId(String(key ?? ''))
                setProgramaId('')
              }}
            >
              <Label>Universidad</Label>
              <Select.Trigger>
                <Select.Value />
                <Select.Indicator />
              </Select.Trigger>
              <Select.Popover>
                <ListBox>
                  {universidades.map(u => (
                    <ListBox.Item key={String(u.universidad_id)} id={String(u.universidad_id)} textValue={u.universidad_nombre}>
                      {u.universidad_nombre}
                      <ListBox.ItemIndicator />
                    </ListBox.Item>
                  ))}
                </ListBox>
              </Select.Popover>
            </Select>
          </div>

          {/* HeroUI Select — Programa */}
          <div className="flex flex-col gap-1">
            <Select
              placeholder={!universidadId ? 'Primero selecciona una universidad' : 'Selecciona un programa'}
              isDisabled={!universidadId || programas.length === 0}
              selectedKey={programaId}
              onSelectionChange={key => setProgramaId(String(key ?? ''))}
            >
              <Label>Programa académico</Label>
              <Select.Trigger>
                <Select.Value />
                <Select.Indicator />
              </Select.Trigger>
              <Select.Popover>
                <ListBox>
                  {programas.map(p => (
                    <ListBox.Item key={String(p.programa_id)} id={String(p.programa_id)} textValue={p.programa_nombre}>
                      {p.programa_nombre}
                      <ListBox.ItemIndicator />
                    </ListBox.Item>
                  ))}
                </ListBox>
              </Select.Popover>
            </Select>
          </div>

          {error && <p role="alert" className="text-sm text-red-600">{error}</p>}

          <Button type="submit" loading={loading} size="lg" className="mt-2">
            Crear cuenta
          </Button>
        </form>
        <p className="mt-4 text-center text-sm text-gray-500">
          ¿Ya tienes cuenta?{' '}
          <Link to="/login" className="text-brand-600 hover:underline">
            Inicia sesión
          </Link>
        </p>
      </CardContent>
    </Card>
  )
}
