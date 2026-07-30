import { cn } from '@/lib/utils'
import type { MateriaEstado } from '@/types'

const estadoConfig: Record<MateriaEstado, { label: string; className: string; dot: string }> = {
  en_curso: {
    label: 'En curso',
    className: 'bg-blue-50 text-blue-700 border border-blue-100',
    dot: 'bg-blue-500',
  },
  aprobada: {
    label: 'Aprobada',
    className: 'bg-brand-50 text-brand-700 border border-brand-100',
    dot: 'bg-brand-500',
  },
  reprobada: {
    label: 'Reprobada',
    className: 'bg-red-50 text-red-700 border border-red-100',
    dot: 'bg-red-500',
  },
  retirada: {
    label: 'Retirada',
    className: 'bg-gray-50 text-gray-500 border border-gray-100',
    dot: 'bg-gray-400',
  },
}

export function EstadoBadge({ estado }: { estado: MateriaEstado }) {
  const config = estadoConfig[estado]
  return (
    <span
      className={cn(
        'inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-xs font-medium',
        config.className
      )}
    >
      <span className={cn('h-1.5 w-1.5 rounded-full', config.dot)} />
      {config.label}
    </span>
  )
}

interface BadgeProps {
  children: React.ReactNode
  className?: string
  variant?: 'brand' | 'gray' | 'blue' | 'amber'
}

const badgeVariants = {
  brand: 'bg-brand-50 text-brand-700 border border-brand-100',
  gray: 'bg-gray-50 text-gray-600 border border-gray-100',
  blue: 'bg-blue-50 text-blue-700 border border-blue-100',
  amber: 'bg-amber-50 text-amber-700 border border-amber-100',
}

export function Badge({ children, className, variant = 'brand' }: BadgeProps) {
  return (
    <span
      className={cn(
        'inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium',
        badgeVariants[variant],
        className
      )}
    >
      {children}
    </span>
  )
}
