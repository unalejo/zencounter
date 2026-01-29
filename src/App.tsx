import { useGameStore } from '@/stores'
import { HomeScreen, TrainingScreen, ResultsScreen } from '@/screens'

function App() {
  const currentScreen = useGameStore((state) => state.currentScreen)

  return (
    <div className="min-h-screen bg-dark-bg">
      {currentScreen === 'home' && <HomeScreen />}
      {currentScreen === 'training' && <TrainingScreen />}
      {currentScreen === 'results' && <ResultsScreen />}
    </div>
  )
}

export default App
