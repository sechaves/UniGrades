import { useState, useCallback } from 'react'
import { api } from '@/lib/api'
import type { User, AuthResponse } from '@/types'

const USER_KEY = 'unigrades_user'
const TOKEN_KEY = 'token'

function loadUser(): User | null {
  try {
    const raw = localStorage.getItem(USER_KEY)
    return raw ? (JSON.parse(raw) as User) : null
  } catch {
    return null
  }
}

export function useAuth() {
  const [user, setUser] = useState<User | null>(loadUser)

  const login = useCallback(
    async (email: string, password: string): Promise<void> => {
      const data = await api.post<AuthResponse>('/auth/login', { email, password })
      localStorage.setItem(TOKEN_KEY, data.token)
      localStorage.setItem(USER_KEY, JSON.stringify(data.user))
      setUser(data.user)
    },
    []
  )

  const register = useCallback(
    async (payload: {
      nombre: string
      apellido: string
      email: string
      password: string
      programa_id: number
      codigo_estudiantil?: string
    }): Promise<void> => {
      const data = await api.post<AuthResponse>('/auth/register', payload)
      localStorage.setItem(TOKEN_KEY, data.token)
      localStorage.setItem(USER_KEY, JSON.stringify(data.user))
      setUser(data.user)
    },
    []
  )

  const logout = useCallback(() => {
    localStorage.removeItem(TOKEN_KEY)
    localStorage.removeItem(USER_KEY)
    setUser(null)
  }, [])

  return { user, login, register, logout, isAuthenticated: !!user }
}
