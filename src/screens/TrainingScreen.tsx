import { useEffect, useRef, useState } from 'react'
import { Pause, Play } from 'lucide-react'
import { IconButton, CountInput, Badge } from '@/components/ui'
import { PlayingCard, CountDisplay } from '@/components/game'
import { useGameStore, useSettingsStore } from '@/stores'

export function TrainingScreen() {
  const game = useGameStore((state) => state.game)
  const dealNextCard = useGameStore((state) => state.dealNextCard)
  const pauseGame = useGameStore((state) => state.pauseGame)
  const resumeGame = useGameStore((state) => state.resumeGame)
  const checkCount = useGameStore((state) => state.checkCount)
  const finishGame = useGameStore((state) => state.finishGame)
  const resetGame = useGameStore((state) => state.resetGame)
  const setScreen = useGameStore((state) => state.setScreen)
  const getCurrentCard = useGameStore((state) => state.getCurrentCard)
  const getCardsRemaining = useGameStore((state) => state.getCardsRemaining)
  const getTotalCards = useGameStore((state) => state.getTotalCards)

  const [showCheckInput, setShowCheckInput] = useState(false)
  const [finalCountValue, setFinalCountValue] = useState(0)
  const [countValue, setCountValue] = useState(0)

  // Settings from store
  const cardSpeed = useSettingsStore((state) => state.cardSpeed)
  const showCardValueSetting = useSettingsStore((state) => state.showCardValue)
  const showRunningCountSetting = useSettingsStore((state) => state.showRunningCount)

  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null)

  const currentCard = getCurrentCard()
  const cardsRemaining = getCardsRemaining()
  const totalCards = getTotalCards()
  const cardsDealt = totalCards - cardsRemaining

  const isPlaying = game?.status === 'playing'
  const isPaused = game?.status === 'paused'
  const isDeckExhausted = game?.status === 'deck_exhausted'
  // Use settings store directly so changes during pause take effect immediately
  const showCardValue = showCardValueSetting
  const showRunningCount = showRunningCountSetting

  // Auto-deal cards
  useEffect(() => {
    if (!game || game.status !== 'playing') {
      if (timerRef.current) {
        clearInterval(timerRef.current)
        timerRef.current = null
      }
      return
    }

    // First card is already dealt by startGame, just set up the interval
    // Use cardSpeed from settingsStore so mid-game speed changes take effect
    timerRef.current = setInterval(() => {
      dealNextCard()
    }, cardSpeed * 1000)

    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current)
        timerRef.current = null
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- Only re-run when status or speed changes, not on every game state update
  }, [game?.status, cardSpeed, dealNextCard])

  const handlePauseResume = () => {
    if (isPlaying) {
      pauseGame()
    } else if (isPaused) {
      resumeGame()
    }
  }

  const handleEndSession = () => {
    resetGame()
    setScreen('home')
  }

  const handleCheckCount = () => {
    setCountValue(0)
    setShowCheckInput(true)
  }

  const handleSubmitCheck = () => {
    checkCount(countValue)
    setShowCheckInput(false)
  }

  const handleCancelCheck = () => {
    setShowCheckInput(false)
  }

  const handleSubmitFinalCount = () => {
    finishGame(finalCountValue)
  }

  // When deck is exhausted and user can see running count, auto-finish
  // (they already know the count, no point asking)
  useEffect(() => {
    if (isDeckExhausted && showRunningCount) {
      finishGame()
    }
  }, [isDeckExhausted, showRunningCount, finishGame])

  // Reset final count input when deck exhausts
  useEffect(() => {
    if (isDeckExhausted && !showRunningCount) {
      setFinalCountValue(0)
    }
  }, [isDeckExhausted, showRunningCount])

  if (!game) return null

  return (
    <div className="min-h-screen bg-dark-bg flex flex-col relative">
      {/* Header */}
      <header className="h-16 px-6 pt-2 flex items-center justify-between">
        <span className="font-display font-extrabold text-xl text-white tracking-tight">
          ZenCounter
        </span>
        <IconButton
          icon={isPaused ? <Play size={20} /> : <Pause size={20} />}
          label={isPaused ? 'Resume' : 'Pause'}
          onClick={handlePauseResume}
        />
      </header>

      {/* Card Area */}
      <main className="flex-1 flex flex-col items-center justify-center gap-8 px-6">
        <PlayingCard card={currentCard} animationKey={game.currentCardIndex} />
        {showCardValue && currentCard && (
          <div className="flex items-center gap-2">
            <span className="text-dark-muted text-sm">Card value:</span>
            <Badge value={currentCard.hiLoValue} animationKey={game.currentCardIndex} />
          </div>
        )}
        {showRunningCount && <CountDisplay count={game.runningCount} />}
      </main>

      {/* Footer */}
      <footer className="h-24 px-6 flex items-center justify-between">
        <div>
          <span className="text-dark-muted text-sm block">Cards remaining</span>
          <span className="font-display font-bold text-xl text-white">
            {cardsDealt} / {totalCards}
          </span>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-dark-muted text-sm">Speed</span>
          <span className="px-3 py-1.5 bg-dark-surface rounded-lg font-display font-semibold text-sm text-white">
            {cardSpeed}s
          </span>
        </div>
      </footer>

      {/* Pause Overlay */}
      {isPaused && !showCheckInput && (
        <div className="absolute inset-0 bg-[rgba(24,24,27,0.95)] flex flex-col items-center justify-center gap-5">
          <span className="font-display font-bold text-[28px] text-white">Paused</span>
          <button
            onClick={handlePauseResume}
            className="px-12 py-3.5 bg-white text-black font-display font-bold rounded-2xl"
          >
            Resume
          </button>
          <button
            onClick={handleCheckCount}
            className="px-8 py-3.5 bg-dark-surface text-white font-display font-semibold rounded-2xl"
          >
            Check Count
          </button>
          <button onClick={handleEndSession} className="text-dark-muted text-sm">
            End Session
          </button>
        </div>
      )}

      {/* Check Count Modal */}
      {isPaused && showCheckInput && (
        <div className="absolute inset-0 bg-[rgba(24,24,27,0.98)] flex items-center justify-center">
          <div className="bg-dark-surface rounded-3xl p-6 w-[327px] flex flex-col items-center gap-6">
            <span className="font-display font-bold text-xl text-white">What's the count?</span>
            <CountInput value={countValue} onChange={setCountValue} />
            <button
              onClick={handleSubmitCheck}
              className="w-full py-3.5 bg-white text-black font-display font-bold rounded-2xl"
            >
              Submit
            </button>
            <button onClick={handleCancelCheck} className="text-dark-muted text-sm">
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Final Count Modal - shown when deck exhausted and running count was hidden */}
      {isDeckExhausted && !showRunningCount && (
        <div className="absolute inset-0 bg-[rgba(24,24,27,0.98)] flex items-center justify-center">
          <div className="bg-dark-surface rounded-3xl p-6 w-[327px] flex flex-col items-center gap-6">
            <span className="font-display font-bold text-xl text-white">Session Complete</span>
            <span className="text-dark-muted text-sm text-center">
              All {totalCards} cards dealt. What's your final count?
            </span>
            <CountInput value={finalCountValue} onChange={setFinalCountValue} />
            <button
              onClick={handleSubmitFinalCount}
              className="w-full py-3.5 bg-white text-black font-display font-bold rounded-2xl"
            >
              Submit
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
