import { Outlet } from 'react-router-dom'
import { GraduationCap } from 'lucide-react'

export default function AuthLayout() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-950 px-4">
      <div className="w-full max-w-md">
        {/* Logo */}
        <div className="flex flex-col items-center mb-8">
          <div className="flex items-center gap-2 mb-2">
            <GraduationCap className="text-indigo-600" size={36} />
            <span className="text-3xl font-bold text-gray-900 dark:text-gray-100">UniGrades</span>
          </div>
          <p className="text-sm text-gray-500 dark:text-gray-400">
            Seguimiento académico inteligente
          </p>
        </div>
        <Outlet />
      </div>
    </div>
  )
}
