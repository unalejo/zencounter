import type { Deck } from './card'
import type { Settings } from './settings'

export type Screen = 'home' | 'training' | 'results'

export type GameStatus = 'idle' | 'playing' | 'paused' | 'deck_exhausted' | 'finished'

export interface GameState {
  status: GameStatus
  deck: Deck
  currentCardIndex: number
  runningCount: number
  /** User's submitted count for exam mode */
  userCount: number | null
  startTime: number | null
  endTime: number | null
  /** Snapshot of settings when game started */
  settings: Settings
}

export interface SessionResult {
  actualCount: number
  userCount: number
  isCorrect: boolean
  cardsDealt: number
  decksUsed: number
  /** Time elapsed in seconds */
  timeElapsed: number
}
