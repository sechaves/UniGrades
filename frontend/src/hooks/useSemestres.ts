import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { Semestre } from '@/types'

export function useSemestres(usuarioId: number) {
  const id = Number(usuarioId)
  return useQuery<Semestre[]>({
    queryKey: ['semestres', id],
    queryFn: () => api.get<Semestre[]>(`/usuarios/${id}/semestres`),
    enabled: !!id && !isNaN(id),
  })
}

export function useCreateSemestre(usuarioId: number) {
  const id = Number(usuarioId)
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (data: { semestre_numero: number; semestre_year: number; semestre_periodo: 1 | 2 }) =>
      api.post<Semestre>(`/usuarios/${id}/semestres`, data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['semestres', id] })
    },
  })
}
