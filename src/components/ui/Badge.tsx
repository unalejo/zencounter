import { motion } from 'framer-motion'

interface BadgeProps {
  value: -1 | 0 | 1
  /** Key to trigger animation on change */
  animationKey?: string | number
}

export function Badge({ value, animationKey }: BadgeProps) {
  const colors = {
    1: 'bg-success',
    0: 'bg-dark-muted',
    '-1': 'bg-error',
  }

  const label = value > 0 ? `+${value}` : String(value)

  return (
    <motion.span
      key={animationKey}
      initial={{ scale: 1.3, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ duration: 0.15, ease: 'easeOut' }}
      className={`inline-flex items-center justify-center w-12 h-8 rounded-lg font-display font-bold text-white ${colors[value]}`}
    >
      {label}
    </motion.span>
  )
}
