export interface Settings {
  /** Number of decks (1-8) */
  numberOfDecks: number
  /** Card display speed in seconds (0.5 - 3.0) */
  cardSpeed: number
  /** Show card value helper (+1, 0, -1) */
  showCardValue: boolean
  /** Show running count helper */
  showRunningCount: boolean
}

export const DEFAULT_SETTINGS: Settings = {
  numberOfDecks: 2,
  cardSpeed: 1.5,
  showCardValue: true,
  showRunningCount: true,
}

export const MIN_DECKS = 1
export const MAX_DECKS = 8
export const MIN_SPEED = 0.5
export const MAX_SPEED = 3.0
export const SPEED_STEP = 0.5
