import type { Card, Deck, Rank } from '@/types'
import { SUITS, RANKS } from '@/types'

/**
 * Calculate Hi-Lo value for a card rank
 * Low cards (2-6): +1
 * Neutral cards (7-9): 0
 * High cards (10-A): -1
 */
export function getHiLoValue(rank: Rank): -1 | 0 | 1 {
  if (['2', '3', '4', '5', '6'].includes(rank)) return 1
  if (['7', '8', '9'].includes(rank)) return 0
  return -1 // 10, J, Q, K, A
}

/**
 * Create a single 52-card deck
 */
function createSingleDeck(): Deck {
  const deck: Deck = []
  for (const suit of SUITS) {
    for (const rank of RANKS) {
      deck.push({
        suit,
        rank,
        hiLoValue: getHiLoValue(rank),
      })
    }
  }
  return deck
}

/**
 * Fisher-Yates shuffle algorithm
 */
function shuffleDeck(deck: Deck): Deck {
  const shuffled = [...deck]
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[shuffled[i], shuffled[j]] = [shuffled[j]!, shuffled[i]!]
  }
  return shuffled
}

/**
 * Create and shuffle multiple decks
 */
export function createShuffledDeck(numberOfDecks: number): Deck {
  let deck: Deck = []
  for (let i = 0; i < numberOfDecks; i++) {
    deck = deck.concat(createSingleDeck())
  }
  return shuffleDeck(deck)
}

/**
 * Get total number of cards for given deck count
 */
export function getTotalCards(numberOfDecks: number): number {
  return numberOfDecks * 52
}

/**
 * Calculate the running count for a sequence of cards
 */
export function calculateRunningCount(cards: Card[]): number {
  return cards.reduce((count, card) => count + card.hiLoValue, 0)
}
