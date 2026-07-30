import { type ReactNode } from 'react'
import { cn } from '@/lib/utils'

interface PulsatingButtonProps {
  children: ReactNode
  className?: string
  style?: React.CSSProperties
  pulseColor?: string
  duration?: string
  onClick?: () => void
}

/**
 * Botón con anillos de pulso animados — inspirado en Magic UI Pulsating Button.
 * Los anillos se generan con pseudo-elementos via inline styles + keyframe CSS.
 */
export default function PulsatingButton({
  children,
  className,
  style,
  pulseColor = 'rgba(102, 197, 83, 0.5)',
  duration = '1.5s',
  onClick,
}: PulsatingButtonProps) {
  return (
    <button
      onClick={onClick}
      style={
        {
          '--pulse-color': pulseColor,
          '--duration': duration,
          ...style,
        } as React.CSSProperties
      }
      className={cn(
        'pulsating-btn',
        'relative inline-flex items-center justify-center gap-2',
        'px-7 py-3.5 text-base font-semibold text-white',
        'brand-gradient rounded-2xl shadow-md',
        'hover:opacity-90 transition-opacity',
        className
      )}
    >
      {/* Pulse rings */}
      <span
        aria-hidden="true"
        className="pointer-events-none absolute inset-0 rounded-2xl"
        style={{
          boxShadow: `0 0 0 0 var(--pulse-color)`,
          animation: `pulsating-btn-ring var(--duration) ease-out infinite`,
        }}
      />
      <span className="relative z-10 flex items-center gap-2">{children}</span>
    </button>
  )
}
