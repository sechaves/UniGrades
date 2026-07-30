import { Outlet, Link } from 'react-router-dom'
import { motion } from 'framer-motion'

export default function AuthLayout() {
  return (
    <div className="min-h-screen flex bg-gradient-to-br from-brand-50 via-white to-green-50">
      {/* Left panel — decorative (hidden on mobile) */}
      <div className="hidden lg:flex lg:w-[44%] brand-gradient relative overflow-hidden flex-col justify-between p-12">
        {/* Subtle dot grid */}
        <div className="absolute inset-0 dot-grid opacity-20" />

        {/* Floating blobs */}
        <div className="absolute top-1/4 right-0 w-72 h-72 rounded-full bg-white/10 blur-3xl translate-x-1/2" />
        <div className="absolute bottom-1/3 left-0 w-56 h-56 rounded-full bg-black/10 blur-3xl -translate-x-1/2" />

        <div className="relative z-10">
          <Link to="/">
            <img src="/logo.png" alt="UniGrades" className="h-10 w-auto brightness-200 invert" />
          </Link>
        </div>

        <div className="relative z-10">
          <blockquote className="text-white">
            <p className="text-2xl font-semibold leading-snug mb-4">
              "El primer paso para graduarte es<br />saber exactamente dónde estás."
            </p>
            <p className="text-white/70 text-sm">UniGrades — Seguimiento académico inteligente</p>
          </blockquote>
        </div>

        {/* Stats row */}
        <div className="relative z-10 flex gap-8">
          {[['Promedio', 'en tiempo real'], ['Créditos', 'aprobados'], ['Semestres', 'visualizados']].map(
            ([n, d]) => (
              <div key={n}>
                <p className="text-white font-bold text-lg">{n}</p>
                <p className="text-white/60 text-xs">{d}</p>
              </div>
            )
          )}
        </div>
      </div>

      {/* Right panel */}
      <div className="flex-1 flex items-center justify-center px-6 py-12">
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, ease: 'easeOut' }}
          className="w-full max-w-[420px]"
        >
          {/* Logo for mobile */}
          <div className="lg:hidden flex flex-col items-center mb-8">
            <Link to="/">
              <img src="/logo.png" alt="UniGrades" className="h-10 w-auto mb-2 mix-blend-multiply" />
            </Link>
            <p className="text-sm text-gray-500">Seguimiento académico inteligente</p>
          </div>

          <Outlet />
        </motion.div>
      </div>
    </div>
  )
}
