import { motion, AnimatePresence } from 'framer-motion'
import type { Card } from '@/types'
import { SUIT_SYMBOLS, SUIT_COLORS } from '@/types'

interface PlayingCardProps {
  card: Card | null
  /** Key to trigger animation on change */
  animationKey?: string | number
}

export function PlayingCard({ card, animationKey }: PlayingCardProps) {
  if (!card) {
    return (
      <div className="w-[200px] h-[280px] rounded-2xl bg-dark-surface flex items-center justify-center">
        <span className="text-dark-muted font-display text-xl">Ready</span>
      </div>
    )
  }

  const suitSymbol = SUIT_SYMBOLS[card.suit]
  const suitColor = SUIT_COLORS[card.suit]
  const textColor = suitColor === 'red' ? 'text-error' : 'text-black'

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={animationKey ?? `${card.rank}-${card.suit}`}
        initial={{ scale: 0.8, rotateY: 90 }}
        animate={{ scale: 1, rotateY: 0 }}
        exit={{ scale: 0.8, rotateY: -90 }}
        transition={{ duration: 0.15, ease: 'easeOut' }}
        className="w-[200px] h-[280px] rounded-2xl bg-white flex flex-col items-center justify-center"
        style={{ perspective: 1000 }}
      >
        <span
          className={`font-display font-black text-[96px] leading-none tracking-tighter ${textColor}`}
        >
          {card.rank}
        </span>
        <span className={`font-display text-5xl ${textColor}`}>{suitSymbol}</span>
      </motion.div>
    </AnimatePresence>
  )
}
