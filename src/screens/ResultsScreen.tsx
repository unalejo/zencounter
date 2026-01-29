import { Check, X, RefreshCw, Home, Play } from 'lucide-react'
import { Button, Card, IconButton, Credits } from '@/components/ui'
import { useGameStore, useSettingsStore } from '@/stores'

export function ResultsScreen() {
  const result = useGameStore((state) => state.result)
  const checkingCount = useGameStore((state) => state.checkingCount)
  const setScreen = useGameStore((state) => state.setScreen)
  const resetGame = useGameStore((state) => state.resetGame)
  const startGame = useGameStore((state) => state.startGame)
  const continueFromCheck = useGameStore((state) => state.continueFromCheck)
  const getSettings = useSettingsStore((state) => state.getSettings)

  if (!result) return null

  const isCorrect = result.isCorrect
  const formatCount = (count: number) => (count >= 0 ? `+${count}` : String(count))

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  const handleTryAgain = () => {
    resetGame()
    startGame(getSettings())
  }

  const handleGoHome = () => {
    resetGame()
    setScreen('home')
  }

  return (
    <div className="min-h-screen bg-dark-bg flex flex-col">
      {/* Header */}
      <header className="h-16 px-6 pt-2 flex items-center justify-between">
        <span className="font-display font-extrabold text-xl text-white tracking-tight">
          Results
        </span>
        <IconButton icon={<X size={20} />} label="Close" onClick={handleGoHome} />
      </header>

      {/* Content */}
      <main className="flex-1 flex flex-col items-center px-6 pt-8 gap-8">
        {/* Success/Error Icon */}
        <div
          className={`w-[120px] h-[120px] rounded-full flex items-center justify-center ${
            isCorrect ? 'bg-success' : 'bg-error'
          }`}
        >
          {isCorrect ? (
            <Check size={64} className="text-white" />
          ) : (
            <X size={64} className="text-white" />
          )}
        </div>

        {/* Message */}
        <div className="text-center">
          <h2 className="font-display font-extrabold text-3xl text-white tracking-tight">
            {isCorrect ? 'Perfect!' : 'Not quite'}
          </h2>
          <p className="text-dark-muted mt-2">
            {isCorrect
              ? 'You nailed the count'
              : `The correct count was ${formatCount(result.actualCount)}`}
          </p>
        </div>

        {/* Stats Grid */}
        <div className="w-full flex gap-4">
          <Card className="flex-1 flex flex-col items-center py-5">
            <span className="text-dark-muted text-sm">Your count</span>
            <span
              className={`font-display font-black text-4xl tracking-tight mt-2 ${
                isCorrect ? 'text-success' : 'text-error'
              }`}
            >
              {formatCount(result.userCount)}
            </span>
          </Card>
          <Card className="flex-1 flex flex-col items-center py-5">
            <span className="text-dark-muted text-sm">Actual count</span>
            <span className="font-display font-black text-4xl text-white tracking-tight mt-2">
              {formatCount(result.actualCount)}
            </span>
          </Card>
        </div>

        {/* Session Details */}
        <Card className="w-full">
          <h3 className="font-display font-bold text-white mb-4">Session details</h3>
          <div className="space-y-3">
            <div className="flex justify-between">
              <span className="text-dark-muted">Cards dealt</span>
              <span className="font-display font-semibold text-white">{result.cardsDealt}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-dark-muted">Decks used</span>
              <span className="font-display font-semibold text-white">{result.decksUsed}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-dark-muted">Time elapsed</span>
              <span className="font-display font-semibold text-white">
                {formatTime(result.timeElapsed)}
              </span>
            </div>
          </div>
        </Card>
      </main>

      {/* Actions */}
      <footer className="px-6 py-6 space-y-3">
        {checkingCount ? (
          <Button variant="primary" icon={<Play size={20} />} onClick={continueFromCheck}>
            Continue
          </Button>
        ) : (
          <Button variant="primary" icon={<RefreshCw size={20} />} onClick={handleTryAgain}>
            Try Again
          </Button>
        )}
        <Button variant="secondary" icon={<Home size={20} />} onClick={handleGoHome}>
          Back to Home
        </Button>
        <Credits />
      </footer>
    </div>
  )
}
