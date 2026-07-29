import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { PromedioGlobal, AvanceTipologia } from '@/types'

export function usePromedioGlobal(usuarioId: number) {
  return useQuery<PromedioGlobal | null>({
    queryKey: ['promedio-global', usuarioId],
    queryFn: () => api.get<PromedioGlobal | null>(`/usuarios/${usuarioId}/promedio-global`),
    enabled: !!usuarioId,
  })
}

export function useAvanceTipologia(usuarioId: number) {
  return useQuery<AvanceTipologia[]>({
    queryKey: ['avance-tipologia', usuarioId],
    queryFn: () => api.get<AvanceTipologia[]>(`/usuarios/${usuarioId}/avance-tipologia`),
    enabled: !!usuarioId,
  })
}
