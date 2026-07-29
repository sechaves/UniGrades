import { Component, type ReactNode } from 'react'

interface Props { children: ReactNode }
interface State { error: Error | null }

export class ErrorBoundary extends Component<Props, State> {
  state: State = { error: null }

  static getDerivedStateFromError(error: Error): State {
    return { error }
  }

  render() {
    if (this.state.error) {
      return (
        <div className="min-h-screen flex items-center justify-center p-6">
          <div className="max-w-md w-full rounded-xl border border-red-200 bg-red-50 p-6">
            <h2 className="text-lg font-semibold text-red-700 mb-2">Algo salió mal</h2>
            <p className="text-sm text-red-600 mb-4">{this.state.error.message}</p>
            <button
              onClick={() => { this.setState({ error: null }); window.history.back() }}
              className="rounded-lg bg-red-600 px-4 py-2 text-sm text-white hover:bg-red-700"
            >
              Volver
            </button>
          </div>
        </div>
      )
    }
    return this.props.children
  }
}
