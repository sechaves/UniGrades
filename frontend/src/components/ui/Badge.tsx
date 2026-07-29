import { cn } from '@/lib/utils'
import type { MateriaEstado } from '@/types'

const estadoClasses: Record<MateriaEstado, string> = {
  en_curso: 'bg-blue-100 text-blue-800 dark:bg-blue-900/40 dark:text-blue-300',
  aprobada: 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300',
  reprobada: 'bg-red-100 text-red-800 dark:bg-red-900/40 dark:text-red-300',
  retirada: 'bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400',
}

const estadoLabels: Record<MateriaEstado, string> = {
  en_curso: 'En curso',
  aprobada: 'Aprobada',
  reprobada: 'Reprobada',
  retirada: 'Retirada',
}

export function EstadoBadge({ estado }: { estado: MateriaEstado }) {
  return (
    <span className={cn('inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium', estadoClasses[estado])}>
      {estadoLabels[estado]}
    </span>
  )
}

interface BadgeProps {
  children: React.ReactNode
  className?: string
}

export function Badge({ children, className }: BadgeProps) {
  return (
    <span className={cn('inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-indigo-100 text-indigo-800', className)}>
      {children}
    </span>
  )
}
