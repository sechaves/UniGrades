import { Link, NavLink, Outlet, useNavigate } from 'react-router-dom'
import { GraduationCap, LayoutDashboard, BookOpen, LogOut, User } from 'lucide-react'
import { useAuthContext } from '@/context/AuthContext'

export default function AppLayout() {
  const { user, logout } = useAuthContext()
  const navigate = useNavigate()

  function handleLogout() {
    logout()
    navigate('/login')
  }

  const navLinkClass = ({ isActive }: { isActive: boolean }) =>
    `flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
      isActive
        ? 'bg-indigo-50 text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-300'
        : 'text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800'
    }`

  return (
    <div className="min-h-screen flex bg-gray-50 dark:bg-gray-950">
      {/* Sidebar */}
      <aside className="hidden md:flex md:flex-col w-60 bg-white border-r border-gray-200 dark:bg-gray-900 dark:border-gray-800">
        {/* Logo */}
        <Link
          to="/dashboard"
          className="flex items-center gap-2 px-5 py-5 border-b border-gray-100 dark:border-gray-800"
        >
          <GraduationCap className="text-indigo-600" size={24} />
          <span className="text-xl font-bold text-gray-900 dark:text-gray-100">UniGrades</span>
        </Link>

        {/* Nav */}
        <nav className="flex-1 p-4 flex flex-col gap-1">
          <NavLink to="/dashboard" end className={navLinkClass}>
            <LayoutDashboard size={16} />
            Dashboard
          </NavLink>
          <NavLink to="/materias" className={navLinkClass}>
            <BookOpen size={16} />
            Mis materias
          </NavLink>
        </nav>

        {/* User */}
        <div className="p-4 border-t border-gray-100 dark:border-gray-800">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center dark:bg-indigo-900">
              <User size={16} className="text-indigo-600 dark:text-indigo-300" />
            </div>
            <div className="min-w-0">
              <p className="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">
                {user?.usuario_nombre} {user?.usuario_apellido}
              </p>
              <p className="text-xs text-gray-500 dark:text-gray-400 truncate">{user?.usuario_email}</p>
            </div>
          </div>
          <button
            onClick={handleLogout}
            className="flex w-full items-center gap-2 rounded-lg px-3 py-2 text-sm text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800 transition-colors"
          >
            <LogOut size={16} />
            Cerrar sesión
          </button>
        </div>
      </aside>

      {/* Main */}
      <main className="flex-1 overflow-y-auto">
        {/* Mobile header */}
        <header className="md:hidden flex items-center justify-between px-4 py-3 bg-white border-b border-gray-200 dark:bg-gray-900 dark:border-gray-800">
          <Link to="/dashboard" className="flex items-center gap-2">
            <GraduationCap className="text-indigo-600" size={20} />
            <span className="font-bold text-gray-900 dark:text-gray-100">UniGrades</span>
          </Link>
          <button
            onClick={handleLogout}
            className="p-2 rounded-md text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800"
            aria-label="Cerrar sesión"
          >
            <LogOut size={18} />
          </button>
        </header>
        <div className="p-6">
          <Outlet />
        </div>
      </main>
    </div>
  )
}
