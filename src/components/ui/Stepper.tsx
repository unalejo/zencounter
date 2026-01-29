import { Minus, Plus } from 'lucide-react'

interface StepperProps {
  value: string | number
  onIncrement: () => void
  onDecrement: () => void
  disableIncrement?: boolean
  disableDecrement?: boolean
}

export function Stepper({
  value,
  onIncrement,
  onDecrement,
  disableIncrement = false,
  disableDecrement = false,
}: StepperProps) {
  return (
    <div className="flex items-center gap-3">
      <button
        onClick={onDecrement}
        disabled={disableDecrement}
        className="w-8 h-8 rounded-lg bg-dark-control flex items-center justify-center text-white transition-opacity hover:opacity-80 disabled:opacity-40"
        aria-label="Decrease"
      >
        <Minus size={16} />
      </button>
      <span className="font-display font-bold text-lg text-white min-w-[3rem] text-center">
        {value}
      </span>
      <button
        onClick={onIncrement}
        disabled={disableIncrement}
        className="w-8 h-8 rounded-lg bg-dark-control flex items-center justify-center text-white transition-opacity hover:opacity-80 disabled:opacity-40"
        aria-label="Increase"
      >
        <Plus size={16} />
      </button>
    </div>
  )
}
