import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { Settings } from '@/types'
import { DEFAULT_SETTINGS, MIN_DECKS, MAX_DECKS, MIN_SPEED, MAX_SPEED, SPEED_STEP } from '@/types'

interface SettingsStore extends Settings {
  setNumberOfDecks: (decks: number) => void
  incrementDecks: () => void
  decrementDecks: () => void
  setCardSpeed: (speed: number) => void
  incrementSpeed: () => void
  decrementSpeed: () => void
  toggleShowCardValue: () => void
  toggleShowRunningCount: () => void
  resetSettings: () => void
  getSettings: () => Settings
}

export const useSettingsStore = create<SettingsStore>()(
  persist(
    (set, get) => ({
      ...DEFAULT_SETTINGS,

      setNumberOfDecks: (decks) =>
        set({ numberOfDecks: Math.min(MAX_DECKS, Math.max(MIN_DECKS, decks)) }),

      incrementDecks: () =>
        set((state) => ({
          numberOfDecks: Math.min(MAX_DECKS, state.numberOfDecks + 1),
        })),

      decrementDecks: () =>
        set((state) => ({
          numberOfDecks: Math.max(MIN_DECKS, state.numberOfDecks - 1),
        })),

      setCardSpeed: (speed) => set({ cardSpeed: Math.min(MAX_SPEED, Math.max(MIN_SPEED, speed)) }),

      incrementSpeed: () =>
        set((state) => ({
          cardSpeed: Math.min(MAX_SPEED, state.cardSpeed + SPEED_STEP),
        })),

      decrementSpeed: () =>
        set((state) => ({
          cardSpeed: Math.max(MIN_SPEED, state.cardSpeed - SPEED_STEP),
        })),

      toggleShowCardValue: () => set((state) => ({ showCardValue: !state.showCardValue })),

      toggleShowRunningCount: () => set((state) => ({ showRunningCount: !state.showRunningCount })),

      resetSettings: () => set(DEFAULT_SETTINGS),

      getSettings: () => {
        const { numberOfDecks, cardSpeed, showCardValue, showRunningCount } = get()
        return { numberOfDecks, cardSpeed, showCardValue, showRunningCount }
      },
    }),
    {
      name: 'zencounter-settings',
    }
  )
)
