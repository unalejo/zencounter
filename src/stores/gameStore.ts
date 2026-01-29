import { create } from 'zustand'
import type { Screen, GameState, SessionResult } from '@/types'
import type { Settings } from '@/types'
import { createShuffledDeck } from '@/lib'

interface GameStore {
  // Navigation
  currentScreen: Screen
  setScreen: (screen: Screen) => void

  // Game state
  game: GameState | null
  result: SessionResult | null
  checkingCount: boolean

  // Actions
  startGame: (settings: Settings) => void
  dealNextCard: () => void
  pauseGame: () => void
  resumeGame: () => void
  finishGame: (userCount?: number) => void
  checkCount: (userCount: number) => void
  continueFromCheck: () => void
  resetGame: () => void

  // Computed
  getCurrentCard: () => GameState['deck'][number] | null
  getCardsRemaining: () => number
  getTotalCards: () => number
}

const createInitialGameState = (settings: Settings): GameState => {
  const deck = createShuffledDeck(settings.numberOfDecks)
  const firstCard = deck[0]
  const initialCount = firstCard?.hiLoValue ?? 0

  return {
    status: 'playing',
    deck,
    currentCardIndex: 0, // Start with first card already dealt
    runningCount: initialCount,
    userCount: null,
    startTime: Date.now(),
    endTime: null,
    settings,
  }
}

export const useGameStore = create<GameStore>((set, get) => ({
  currentScreen: 'home',
  game: null,
  result: null,
  checkingCount: false,

  setScreen: (screen) => set({ currentScreen: screen }),

  startGame: (settings) => {
    set({
      game: createInitialGameState(settings),
      result: null,
      currentScreen: 'training',
    })
  },

  dealNextCard: () => {
    const { game } = get()
    if (!game || game.status !== 'playing') return

    const nextIndex = game.currentCardIndex + 1

    // Check if deck is exhausted - set status and let UI handle the finish flow
    if (nextIndex >= game.deck.length) {
      set({ game: { ...game, status: 'deck_exhausted' } })
      return
    }

    const nextCard = game.deck[nextIndex]
    const newCount = game.runningCount + (nextCard?.hiLoValue ?? 0)

    set({
      game: {
        ...game,
        currentCardIndex: nextIndex,
        runningCount: newCount,
      },
    })
  },

  pauseGame: () => {
    const { game } = get()
    if (!game) return
    set({ game: { ...game, status: 'paused' } })
  },

  resumeGame: () => {
    const { game } = get()
    if (!game) return
    set({ game: { ...game, status: 'playing' } })
  },

  finishGame: (userCount) => {
    const { game } = get()
    if (!game) return

    const endTime = Date.now()
    const timeElapsed = Math.floor((endTime - (game.startTime ?? endTime)) / 1000)

    // In practice mode, userCount equals actual count
    const finalUserCount = userCount ?? game.runningCount

    const result: SessionResult = {
      actualCount: game.runningCount,
      userCount: finalUserCount,
      isCorrect: finalUserCount === game.runningCount,
      cardsDealt: game.currentCardIndex + 1,
      decksUsed: game.settings.numberOfDecks,
      timeElapsed,
    }

    set({
      game: { ...game, status: 'finished', endTime },
      result,
      checkingCount: false,
      currentScreen: 'results',
    })
  },

  checkCount: (userCount) => {
    const { game } = get()
    if (!game) return

    const endTime = Date.now()
    const timeElapsed = Math.floor((endTime - (game.startTime ?? endTime)) / 1000)

    const result: SessionResult = {
      actualCount: game.runningCount,
      userCount,
      isCorrect: userCount === game.runningCount,
      cardsDealt: game.currentCardIndex + 1,
      decksUsed: game.settings.numberOfDecks,
      timeElapsed,
    }

    set({
      result,
      checkingCount: true,
      currentScreen: 'results',
    })
  },

  continueFromCheck: () => {
    const { game } = get()
    if (!game) return

    set({
      game: { ...game, status: 'paused' },
      result: null,
      checkingCount: false,
      currentScreen: 'training',
    })
  },

  resetGame: () => {
    set({ game: null, result: null, checkingCount: false })
  },

  getCurrentCard: () => {
    const { game } = get()
    if (!game || game.currentCardIndex < 0) return null
    return game.deck[game.currentCardIndex] ?? null
  },

  getCardsRemaining: () => {
    const { game } = get()
    if (!game) return 0
    return game.deck.length - (game.currentCardIndex + 1)
  },

  getTotalCards: () => {
    const { game } = get()
    if (!game) return 0
    return game.deck.length
  },
}))
