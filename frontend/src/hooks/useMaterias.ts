import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { Materia, MateriaUsuario } from '@/types'

export function useMateriasPrograma() {
  const stored = localStorage.getItem('unigrades_user')
  const parsed = stored ? JSON.parse(stored) : null
  // Asegurar que sea número, no string ni "1:1"
  const programaId: number | undefined = parsed?.usuario_programa_id
    ? Number(parsed.usuario_programa_id)
    : undefined

  return useQuery<Materia[]>({
    queryKey: ['materias', programaId],
    queryFn: () => api.get<Materia[]>(`/materias${programaId ? `?programa_id=${programaId}` : ''}`),
    enabled: !!programaId && !isNaN(programaId),
  })
}

export function useMateriasBySemestre(semestreId: number) {
  return useQuery<MateriaUsuario[]>({
    queryKey: ['materias-semestre', semestreId],
    queryFn: () => api.get<MateriaUsuario[]>(`/semestres/${semestreId}/materias`),
    enabled: !!semestreId,
  })
}

export function useInscribirMateria(semestreId: number, usuarioId: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (materia_id: number) =>
      api.post<{ mensaje: string }>(`/semestres/${semestreId}/inscribir`, {
        usuario_id: usuarioId,
        materia_id,
      }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['materias-semestre', semestreId] })
    },
  })
}

export function useUpdateEstadoMateria(semestreId: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: ({ muId, estado }: { muId: number; estado: string }) =>
      api.put(`/materia-usuario/${muId}/estado`, { estado }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['materias-semestre', semestreId] })
    },
  })
}
