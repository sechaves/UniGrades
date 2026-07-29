import { Outlet } from 'react-router-dom'

export default function AuthLayout() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-950 px-4">
      <div className="w-full max-w-md">
        <div className="flex flex-col items-center mb-8">
          <img src="/logo.png" alt="UniGrades" className="h-12 w-auto mb-3" />
          <p className="text-sm text-gray-500 dark:text-gray-400">
            Seguimiento académico inteligente
          </p>
        </div>
        <Outlet />
      </div>
    </div>
  )
}
