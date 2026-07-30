import { cn } from '@/lib/utils'

interface BorderBeamProps {
  className?: string
  size?: number
  duration?: number
  delay?: number
  colorFrom?: string
  colorTo?: string
  borderWidth?: number
  reverse?: boolean
}

/**
 * Border Beam — rayo de luz animado que recorre el borde del contenedor.
 * Inspirado en Magic UI BorderBeam. Implementado con conic-gradient + CSS animation.
 *
 * El contenedor padre DEBE tener: position: relative, overflow: hidden
 * y un border-radius definido.
 */
export default function BorderBeam({
  className,
  size = 120,
  duration = 4,
  delay = 0,
  colorFrom = '#66c553',   // brand-500
  colorTo   = '#a3df97',   // brand-300
  borderWidth = 1.5,
  reverse = false,
}: BorderBeamProps) {
  return (
    <div
      className={cn('pointer-events-none absolute inset-0 rounded-[inherit]', className)}
      style={
        {
          '--size':      `${size}px`,
          '--duration':  `${duration}s`,
          '--delay':     `${delay}s`,
          '--color-from': colorFrom,
          '--color-to':   colorTo,
          '--border-width': `${borderWidth}px`,
          '--direction':  reverse ? 'reverse' : 'normal',
        } as React.CSSProperties
      }
    >
      {/* Outer mask: shows only a thin border strip */}
      <div
        aria-hidden
        className="border-beam-inner absolute inset-0 rounded-[inherit]"
      />
    </div>
  )
}
