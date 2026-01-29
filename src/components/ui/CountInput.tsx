import { Minus, Plus } from 'lucide-react'

interface CountInputProps {
  value: number
  onChange: (value: number) => void
}

export function CountInput({ value, onChange }: CountInputProps) {
  const formatValue = (n: number) => (n >= 0 ? `+${n}` : String(n))

  return (
    <div className="flex items-center gap-4">
      <button
        onClick={() => onChange(value - 1)}
        className="w-12 h-12 rounded-xl bg-dark-control flex items-center justify-center text-white transition-opacity hover:opacity-80 active:opacity-60"
        aria-label="Decrease count"
      >
        <Minus size={24} />
      </button>
      <div className="w-[100px] h-16 rounded-xl bg-dark-bg flex items-center justify-center">
        <span className="font-display font-black text-4xl text-white tracking-tight">
          {formatValue(value)}
        </span>
      </div>
      <button
        onClick={() => onChange(value + 1)}
        className="w-12 h-12 rounded-xl bg-dark-control flex items-center justify-center text-white transition-opacity hover:opacity-80 active:opacity-60"
        aria-label="Increase count"
      >
        <Plus size={24} />
      </button>
    </div>
  )
}
