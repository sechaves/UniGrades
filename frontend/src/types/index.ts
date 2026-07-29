export interface Universidad {
  universidad_id: number
  universidad_nombre: string
  universidad_sigla: string | null
  universidad_pais: string
  universidad_ciudad: string | null
}

export interface Programa {
  programa_id: number
  programa_nombre: string
  programa_facultad: string | null
  programa_total_creditos: number
}

export interface User {
  usuario_id: number
  usuario_nombre: string
  usuario_apellido: string
  usuario_email: string
  usuario_programa_id: number
  usuario_avatar_url: string | null
  programa_nombre?: string
  universidad_nombre?: string
}

export interface AuthResponse {
  token: string
  user: User
}

export interface Semestre {
  semestre_id: number
  semestre_usuario_id: number
  semestre_numero: number
  semestre_year: number
  semestre_periodo: 1 | 2
  promedio_semestre: number | null
}

export type MateriaEstado = 'en_curso' | 'aprobada' | 'reprobada' | 'retirada'

export interface MateriaUsuario {
  materia_usuario_id: number
  materia_id: number
  semestre_id: number
  usuario_id: number
  materia: string
  materia_codigo: string
  creditos: number
  tipologia_id: number
  cuenta_promedio: boolean
  estado: MateriaEstado
  nota_acumulada: number | null
  porcentaje_evaluado: number | null
  nota_final: number | null
}

export interface Materia {
  materia_id: number
  materia_codigo: string
  materia_nombre: string
  materia_creditos: number
  materia_nota_minima_aprobacion: number
  materia_semestre_sugerido: number | null
  tipologia_id: number
  tipologia_nombre: string
  tipologia_cuenta_promedio: boolean
  programa_id: number
  programa_nombre: string
}

export interface Componente {
  componente_id: number
  componente_materia_usuario_id: number
  componente_nombre: string
  componente_porcentaje: number
  componente_nota_minima: number | null
  componente_orden: number
  promedio_componente: number | null
  cantidad_notas: number
}

export interface Nota {
  nota_id: number
  nota_nombre: string
  nota_valor: number
  nota_fecha_registro: string | null
  nota_componente_id: number
}

export interface PromedioGlobal {
  usuario_id: number
  promedio_global: number | null
  total_creditos_cursados: number
  total_creditos_aprobados: number
}

export interface AvanceTipologia {
  usuario_id: number
  tipologia_id: number
  tipologia: string
  creditos_requeridos: number
  cuenta_promedio: boolean
  creditos_aprobados: number
  creditos_pendientes: number
}
