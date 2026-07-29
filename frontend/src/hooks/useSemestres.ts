import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { Semestre } from '@/types'

export function useSemestres(usuarioId: number) {
  return useQuery<Semestre[]>({
    queryKey: ['semestres', usuarioId],
    queryFn: () => api.get<Semestre[]>(`/usuarios/${usuarioId}/semestres`),
    enabled: !!usuarioId,
  })
}

export function useCreateSemestre(usuarioId: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (data: { semestre_numero: number; semestre_year: number; semestre_periodo: 1 | 2 }) =>
      api.post<Semestre>(`/usuarios/${usuarioId}/semestres`, data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['semestres', usuarioId] })
    },
  })
}
