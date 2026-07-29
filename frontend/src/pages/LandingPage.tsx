import { Link } from 'react-router-dom'
import { GraduationCap, TrendingUp, BookOpen, Award } from 'lucide-react'

function Feature({ icon, title, desc }: { icon: React.ReactNode; title: string; desc: string }) {
  return (
    <div className="flex flex-col items-start gap-3 rounded-xl border border-gray-200 dark:border-gray-800 p-6">
      <div className="p-3 rounded-lg bg-indigo-50 dark:bg-indigo-900/30">{icon}</div>
      <h3 className="font-semibold text-gray-900 dark:text-gray-100">{title}</h3>
      <p className="text-sm text-gray-500 dark:text-gray-400">{desc}</p>
    </div>
  )
}

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-white dark:bg-gray-950">
      {/* Nav */}
      <nav className="flex items-center justify-between px-6 py-4 border-b border-gray-100 dark:border-gray-900 max-w-6xl mx-auto">
        <div className="flex items-center gap-2">
          <GraduationCap className="text-indigo-600" size={28} />
          <span className="text-xl font-bold text-gray-900 dark:text-gray-100">UniGrades</span>
        </div>
        <div className="flex items-center gap-3">
          <Link
            to="/login"
            className="text-sm font-medium text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-100 transition-colors"
          >
            Iniciar sesión
          </Link>
          <Link
            to="/register"
            className="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700 transition-colors"
          >
            Crear cuenta
          </Link>
        </div>
      </nav>

      {/* Hero */}
      <section className="max-w-4xl mx-auto px-6 py-24 text-center">
        <h1 className="text-5xl font-extrabold text-gray-900 dark:text-gray-100 leading-tight mb-6">
          Tu progreso académico,<br />
          <span className="text-indigo-600">organizado.</span>
        </h1>
        <p className="text-lg text-gray-500 dark:text-gray-400 mb-10 max-w-xl mx-auto">
          Registra tus materias, componentes y notas semestre a semestre.
          Monitorea tu promedio en tiempo real y visualiza tu avance hacia la graduación.
        </p>
        <div className="flex justify-center gap-4">
          <Link
            to="/register"
            className="rounded-xl bg-indigo-600 px-6 py-3 text-base font-semibold text-white hover:bg-indigo-700 transition-colors"
          >
            Empezar gratis
          </Link>
          <Link
            to="/login"
            className="rounded-xl border border-gray-300 px-6 py-3 text-base font-semibold text-gray-700 hover:bg-gray-50 dark:border-gray-700 dark:text-gray-300 dark:hover:bg-gray-900 transition-colors"
          >
            Iniciar sesión
          </Link>
        </div>
      </section>

      {/* Features */}
      <section className="max-w-5xl mx-auto px-6 pb-24">
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-5">
          <Feature
            icon={<TrendingUp size={22} className="text-indigo-600" />}
            title="Promedio en tiempo real"
            desc="Calcula automáticamente tu promedio ponderado por semestre y global."
          />
          <Feature
            icon={<BookOpen size={22} className="text-indigo-600" />}
            title="Componentes y notas"
            desc="Configura los porcentajes de cada componente y agrega tus notas individualmente."
          />
          <Feature
            icon={<Award size={22} className="text-indigo-600" />}
            title="Avance de graduación"
            desc="Visualiza cuántos créditos has aprobado por tipología y cuántos te faltan."
          />
        </div>
      </section>
    </div>
  )
}
