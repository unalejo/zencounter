export type Suit = 'hearts' | 'diamonds' | 'clubs' | 'spades'

export type Rank = 'A' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | '10' | 'J' | 'Q' | 'K'

export interface Card {
  suit: Suit
  rank: Rank
  /** Hi-Lo value: +1 for 2-6, 0 for 7-9, -1 for 10-A */
  hiLoValue: -1 | 0 | 1
}

export type Deck = Card[]

export const SUIT_SYMBOLS: Record<Suit, string> = {
  hearts: '\u2665',
  diamonds: '\u2666',
  clubs: '\u2663',
  spades: '\u2660',
}

export const SUIT_COLORS: Record<Suit, 'red' | 'black'> = {
  hearts: 'red',
  diamonds: 'red',
  clubs: 'black',
  spades: 'black',
}

export const SUITS: Suit[] = ['hearts', 'diamonds', 'clubs', 'spades']

export const RANKS: Rank[] = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
