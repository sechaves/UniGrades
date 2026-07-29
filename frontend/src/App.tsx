import { Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuthContext } from '@/context/AuthContext'

// Layouts
import AuthLayout from '@/layouts/AuthLayout'
import AppLayout from '@/layouts/AppLayout'

// Pages
import LoginPage from '@/pages/LoginPage'
import RegisterPage from '@/pages/RegisterPage'
import DashboardPage from '@/pages/DashboardPage'
import SemestrePage from '@/pages/SemestrePage'
import MateriaUsuarioPage from '@/pages/MateriaUsuarioPage'
import MateriasPage from '@/pages/MateriasPage'
import LandingPage from '@/pages/LandingPage'

// Auth guard
function PrivateRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated } = useAuthContext()
  return isAuthenticated ? <>{children}</> : <Navigate to="/login" replace />
}

function GuestRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated } = useAuthContext()
  return isAuthenticated ? <Navigate to="/dashboard" replace /> : <>{children}</>
}

function AppRoutes() {
  return (
    <Routes>
      {/* Landing pública */}
      <Route path="/" element={<LandingPage />} />

      {/* Auth */}
      <Route
        element={
          <GuestRoute>
            <AuthLayout />
          </GuestRoute>
        }
      >
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
      </Route>

      {/* App protegida */}
      <Route
        element={
          <PrivateRoute>
            <AppLayout />
          </PrivateRoute>
        }
      >
        <Route path="/dashboard" element={<DashboardPage />} />
        <Route path="/semestres/:id" element={<SemestrePage />} />
        <Route path="/materia-usuario/:id" element={<MateriaUsuarioPage />} />
        <Route path="/materias" element={<MateriasPage />} />
      </Route>

      {/* Fallback */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}

export default function App() {
  return (
    <AuthProvider>
      <AppRoutes />
    </AuthProvider>
  )
}
