import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { Nota } from '@/types'

export function useNotas(componenteId: number) {
  return useQuery<Nota[]>({
    queryKey: ['notas', componenteId],
    queryFn: () => api.get<Nota[]>(`/componentes/${componenteId}/notas`),
    enabled: !!componenteId,
  })
}

export function useCreateNota(componenteId: number, muId: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (data: { nombre: string; valor: number; fecha_registro?: string }) =>
      api.post(`/componentes/${componenteId}/notas`, data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['notas', componenteId] })
      qc.invalidateQueries({ queryKey: ['componentes', muId] })
    },
  })
}

export function useDeleteNota(componenteId: number, muId: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (id: number) => api.delete(`/notas/${id}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['notas', componenteId] })
      qc.invalidateQueries({ queryKey: ['componentes', muId] })
    },
  })
}
