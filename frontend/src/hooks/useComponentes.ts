import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { Componente } from '@/types'

export function useComponentes(muId: number) {
  return useQuery<Componente[]>({
    queryKey: ['componentes', muId],
    queryFn: () => api.get<Componente[]>(`/materia-usuario/${muId}/componentes`),
    enabled: !!muId,
  })
}

export function useCreateComponente(muId: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (data: {
      nombre: string
      porcentaje: number
      nota_minima?: number
      orden: number
    }) => api.post<Componente>(`/materia-usuario/${muId}/componentes`, data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['componentes', muId] })
    },
  })
}

export function useDeleteComponente(muId: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (id: number) => api.delete(`/componentes/${id}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['componentes', muId] })
    },
  })
}
