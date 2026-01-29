import { Play } from 'lucide-react'
import { Button, Card, CardTitle, Stepper, Toggle, Credits } from '@/components/ui'
import { HiLoReference } from '@/components/game'
import { useSettingsStore, useGameStore } from '@/stores'
import { MIN_DECKS, MAX_DECKS, MIN_SPEED, MAX_SPEED } from '@/types'

export function HomeScreen() {
  const {
    numberOfDecks,
    cardSpeed,
    showCardValue,
    showRunningCount,
    incrementDecks,
    decrementDecks,
    incrementSpeed,
    decrementSpeed,
    toggleShowCardValue,
    toggleShowRunningCount,
    getSettings,
  } = useSettingsStore()

  const startGame = useGameStore((state) => state.startGame)

  const handleStart = () => {
    startGame(getSettings())
  }

  return (
    <div className="min-h-screen bg-dark-bg flex flex-col">
      {/* Header */}
      <header className="px-6 pt-12 pb-6">
        <h1 className="font-display font-extrabold text-4xl text-white tracking-tight">
          ZenCounter
        </h1>
        <p className="text-dark-muted mt-2">Train your mind with Hi-Lo</p>
      </header>

      {/* Content */}
      <main className="flex-1 px-6 space-y-6">
        {/* Settings Card */}
        <Card>
          <CardTitle>Settings</CardTitle>
          <div className="space-y-5">
            {/* Number of Decks */}
            <div className="flex items-center justify-between">
              <span className="text-dark-mutedLight font-medium">Number of decks</span>
              <Stepper
                value={numberOfDecks}
                onIncrement={incrementDecks}
                onDecrement={decrementDecks}
                disableIncrement={numberOfDecks >= MAX_DECKS}
                disableDecrement={numberOfDecks <= MIN_DECKS}
              />
            </div>

            {/* Card Speed */}
            <div className="flex items-center justify-between">
              <span className="text-dark-mutedLight font-medium">Card speed (seconds)</span>
              <Stepper
                value={`${cardSpeed}s`}
                onIncrement={incrementSpeed}
                onDecrement={decrementSpeed}
                disableIncrement={cardSpeed >= MAX_SPEED}
                disableDecrement={cardSpeed <= MIN_SPEED}
              />
            </div>

            <div className="h-px bg-dark-control" />

            {/* Training Helpers */}
            <div className="space-y-4">
              <span className="text-dark-muted text-xs font-semibold tracking-wider uppercase">
                Training helpers
              </span>

              {/* Show Card Value */}
              <div className="flex items-center justify-between">
                <div>
                  <span className="text-dark-mutedLight font-medium block">Show card value</span>
                  <span className="text-dark-muted text-sm">+1, 0, or -1 for each card</span>
                </div>
                <Toggle
                  checked={showCardValue}
                  onChange={toggleShowCardValue}
                  label="Toggle show card value"
                />
              </div>

              {/* Show Running Count */}
              <div className="flex items-center justify-between">
                <div>
                  <span className="text-dark-mutedLight font-medium block">Show running count</span>
                  <span className="text-dark-muted text-sm">Accumulated count total</span>
                </div>
                <Toggle
                  checked={showRunningCount}
                  onChange={toggleShowRunningCount}
                  label="Toggle show running count"
                />
              </div>
            </div>
          </div>
        </Card>

        {/* Hi-Lo Reference Card */}
        <Card>
          <CardTitle>Hi-Lo System</CardTitle>
          <HiLoReference />
        </Card>
      </main>

      {/* Footer */}
      <footer className="px-6 py-6 space-y-4">
        <Button variant="primary" icon={<Play size={24} />} onClick={handleStart}>
          Start Training
        </Button>
        <p className="text-dark-muted text-sm text-center">
          {numberOfDecks} deck{numberOfDecks > 1 ? 's' : ''} &bull; {cardSpeed}s per card
        </p>
        <Credits />
      </footer>
    </div>
  )
}
