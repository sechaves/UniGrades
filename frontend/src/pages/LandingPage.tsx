import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import { TrendingUp, BookOpen, Award, CheckCircle2, ArrowRight, GraduationCap, BarChart3, Layers } from 'lucide-react'
import PulsatingButton from '@/components/ui/PulsatingButton'
import BorderBeam from '@/components/ui/BorderBeam'

function Feature({ icon: Icon, title, desc, delay }: { icon: React.ElementType; title: string; desc: string; delay: number }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ delay: delay * 0.08, duration: 0.45 }}
      className="group flex flex-col gap-4 rounded-2xl border border-gray-100 bg-white p-6 shadow-[var(--shadow-card)] hover:shadow-[var(--shadow-card-hover)] hover:border-brand-200 transition-all duration-200"
    >
      <div className="w-11 h-11 rounded-xl brand-gradient flex items-center justify-center shadow-sm">
        <Icon size={20} className="text-white" />
      </div>
      <div>
        <h3 className="font-semibold text-gray-900 mb-1.5">{title}</h3>
        <p className="text-sm text-gray-500 leading-relaxed">{desc}</p>
      </div>
    </motion.div>
  )
}

const features = [
  {
    icon: TrendingUp,
    title: 'Promedio en tiempo real',
    desc: 'Tu promedio ponderado se actualiza automáticamente con cada nota que registres, semestre a semestre.',
  },
  {
    icon: BookOpen,
    title: 'Componentes y notas',
    desc: 'Configura los porcentajes de cada parcial, taller o examen y agrega tus notas individualmente.',
  },
  {
    icon: Award,
    title: 'Avance de graduación',
    desc: 'Visualiza créditos aprobados por tipología y conoce exactamente cuánto te falta.',
  },
  {
    icon: BarChart3,
    title: 'Historial por semestre',
    desc: 'Navega por cada semestre inscrito, revisa materias y compara tu rendimiento a lo largo del tiempo.',
  },
  {
    icon: Layers,
    title: 'Plan de estudios',
    desc: 'Consulta todas las materias de tu programa, agrupadas por semestre sugerido.',
  },
  {
    icon: GraduationCap,
    title: 'Pensado para universitarios',
    desc: 'Diseñado para el sistema académico colombiano con tipologías, créditos y períodos 1S/2S.',
  },
]

const checks = [
  'Cálculo automático de promedios ponderados',
  'Seguimiento de créditos por tipología',
  'Historial completo semestre a semestre',
  'Múltiples universidades y programas',
]

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-white">
      {/* ── Navbar ── */}
      <nav className="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-gray-100">
        <div className="max-w-6xl mx-auto px-5 py-3.5 flex items-center justify-between">
          <Link to="/" className="flex items-center gap-2">
            <img src="/logo.png" alt="UniGrades" className="h-8 w-auto mix-blend-multiply" />
          </Link>
          <div className="flex items-center gap-2">
            <Link
              to="/login"
              className="px-4 py-2 text-sm font-medium text-gray-600 hover:text-gray-900 rounded-xl hover:bg-gray-50 transition-colors"
            >
              Iniciar sesión
            </Link>
            <Link
              to="/register"
              className="px-4 py-2 text-sm font-semibold text-white brand-gradient rounded-xl hover:opacity-90 transition-opacity shadow-sm"
            >
              Crear cuenta
            </Link>
          </div>
        </div>
      </nav>

      {/* ── Hero ── */}
      <section className="relative overflow-hidden pt-20 pb-32 px-5">
        {/* Background decoration */}
        <div className="absolute inset-0 dot-grid opacity-40 pointer-events-none" />
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[600px] h-[400px] rounded-full bg-brand-100/40 blur-3xl pointer-events-none" />

        <div className="relative max-w-4xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: -8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4 }}
            className="inline-flex items-center gap-2 rounded-full border border-brand-200 bg-brand-50 px-4 py-1.5 text-xs font-medium text-brand-700 mb-6"
          >
            <span className="w-1.5 h-1.5 rounded-full bg-brand-500 animate-pulse" />
            Seguimiento académico universitario
          </motion.div>

          <motion.h1
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.08, duration: 0.45 }}
            className="text-5xl sm:text-6xl font-extrabold text-gray-900 leading-[1.1] tracking-tight mb-6"
          >
            Tu carrera,{' '}
            <span className="text-shimmer">organizada.</span>
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.16, duration: 0.45 }}
            className="text-lg text-gray-500 mb-10 max-w-xl mx-auto leading-relaxed"
          >
            Registra materias, componentes y notas semestre a semestre.
            Monitorea tu promedio en tiempo real y visualiza tu camino hacia la graduación.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.24, duration: 0.45 }}
            className="flex flex-col sm:flex-row justify-center gap-3"
          >
            <Link to="/register">
              <PulsatingButton>
                Empezar gratis
                <ArrowRight size={18} />
              </PulsatingButton>
            </Link>
            <Link
              to="/login"
              className="inline-flex items-center justify-center gap-2 px-7 py-3.5 text-base font-semibold text-gray-700 bg-white border border-gray-200 rounded-2xl hover:bg-gray-50 transition-colors shadow-sm"
            >
              Iniciar sesión
            </Link>
          </motion.div>
        </div>

        {/* ── Mock UI card ── */}
        <motion.div
          initial={{ opacity: 0, y: 32, scale: 0.97 }}
          animate={{ opacity: 1, y: 0, scale: 1 }}
          transition={{ delay: 0.5, duration: 0.6, ease: 'easeOut' }}
          className="relative max-w-2xl mx-auto mt-16"
        >
          <div className="relative rounded-2xl border border-gray-100 bg-white shadow-[var(--shadow-elevated)] overflow-hidden">
            {/* Border Beam */}
            <BorderBeam
              colorFrom="#66c553"
              colorTo="#a3df97"
              duration={3.5}
              size={140}
              borderWidth={2}
            />
            {/* Mock header */}
            <div className="flex items-center gap-1.5 px-4 py-3 border-b border-gray-50">
              <div className="w-2.5 h-2.5 rounded-full bg-red-400" />
              <div className="w-2.5 h-2.5 rounded-full bg-yellow-400" />
              <div className="w-2.5 h-2.5 rounded-full bg-green-400" />
            </div>
            {/* Mock content */}
            <div className="p-6 space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-gray-400 mb-0.5">Promedio global</p>
                  <p className="text-3xl font-bold text-gray-900">4.18</p>
                </div>
                <div className="text-right">
                  <p className="text-xs text-gray-400 mb-0.5">Créditos aprobados</p>
                  <p className="text-3xl font-bold text-brand-600">72</p>
                </div>
              </div>
              <div className="space-y-2.5">
                {[
                  { label: 'Obligatorias', pct: 78 },
                  { label: 'Electivas', pct: 55 },
                  { label: 'Complementarias', pct: 40 },
                ].map(({ label, pct }) => (
                  <div key={label}>
                    <div className="flex justify-between text-xs text-gray-500 mb-1">
                      <span>{label}</span>
                      <span>{pct}%</span>
                    </div>
                    <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                      <motion.div
                        initial={{ width: 0 }}
                        animate={{ width: `${pct}%` }}
                        transition={{ delay: 0.8 + pct * 0.003, duration: 0.8, ease: 'easeOut' }}
                        className="h-full brand-gradient rounded-full"
                      />
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </motion.div>
      </section>

      {/* ── Features ── */}
      <section className="bg-surface-50 py-24 px-5">
        <div className="max-w-5xl mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 16 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.4 }}
            className="text-center mb-14"
          >
            <h2 className="text-3xl font-bold text-gray-900 mb-3">Todo lo que necesitas</h2>
            <p className="text-gray-500 max-w-md mx-auto">
              Una sola herramienta para gestionar toda tu vida académica universitaria.
            </p>
          </motion.div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {features.map((f, i) => (
              <Feature key={f.title} {...f} delay={i} />
            ))}
          </div>
        </div>
      </section>

      {/* ── Benefits strip ── */}
      <section className="py-20 px-5">
        <div className="max-w-5xl mx-auto flex flex-col lg:flex-row items-center gap-12">
          <motion.div
            initial={{ opacity: 0, x: -24 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="flex-1"
          >
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Diseñado para el estudiante universitario colombiano
            </h2>
            <p className="text-gray-500 mb-8 leading-relaxed">
              Soporta múltiples universidades, programas académicos y el sistema de tipologías de créditos.
            </p>
            <ul className="space-y-3">
              {checks.map((c) => (
                <li key={c} className="flex items-center gap-3 text-sm text-gray-700">
                  <CheckCircle2 size={18} className="text-brand-500 shrink-0" />
                  {c}
                </li>
              ))}
            </ul>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: 24 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="flex-1 brand-gradient rounded-3xl p-8 text-white relative overflow-hidden"
          >
            <div className="absolute inset-0 dot-grid opacity-20" />
            <div className="relative z-10 space-y-5">
              <p className="text-white/70 text-sm font-medium uppercase tracking-wider">Empieza hoy</p>
              <p className="text-3xl font-bold leading-snug">
                Gratis. Sin tarjeta. Sin límites de materias.
              </p>
              <Link to="/register">
                <PulsatingButton
                  pulseColor="rgba(255,255,255,0.5)"
                  className="bg-white text-brand-700 font-semibold shadow-sm"
                  style={{ backgroundImage: 'none' }}
                >
                  Crear mi cuenta
                  <ArrowRight size={16} />
                </PulsatingButton>
              </Link>
            </div>
          </motion.div>
        </div>
      </section>

      {/* ── Footer ── */}
      <footer className="border-t border-gray-100 py-8 px-5">
        <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
          <img src="/logo.png" alt="UniGrades" className="h-6 w-auto mix-blend-multiply" />
          <p className="text-sm text-gray-400">© {new Date().getFullYear()} UniGrades. Todos los derechos reservados.</p>
          <div className="flex gap-4 text-sm text-gray-400">
            <Link to="/login" className="hover:text-gray-600">Ingresar</Link>
            <Link to="/register" className="hover:text-gray-600">Registrarse</Link>
          </div>
        </div>
      </footer>
    </div>
  )
}
