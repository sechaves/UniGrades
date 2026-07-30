import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { PromedioGlobal, AvanceTipologia } from '@/types'

export function usePromedioGlobal(usuarioId: number) {
  const id = Number(usuarioId)
  return useQuery<PromedioGlobal | null>({
    queryKey: ['promedio-global', id],
    queryFn: () => api.get<PromedioGlobal | null>(`/usuarios/${id}/promedio-global`),
    enabled: !!id && !isNaN(id),
  })
}

export function useAvanceTipologia(usuarioId: number) {
  const id = Number(usuarioId)
  return useQuery<AvanceTipologia[]>({
    queryKey: ['avance-tipologia', id],
    queryFn: () => api.get<AvanceTipologia[]>(`/usuarios/${id}/avance-tipologia`),
    enabled: !!id && !isNaN(id),
  })
}
