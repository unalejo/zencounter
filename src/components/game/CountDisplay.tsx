interface CountDisplayProps {
  count: number
  hidden?: boolean
}

export function CountDisplay({ count, hidden = false }: CountDisplayProps) {
  const displayValue = hidden ? '?' : count >= 0 ? `+${count}` : String(count)

  return (
    <div className="flex flex-col items-center gap-1">
      <span className="font-display font-semibold text-xs text-dark-muted tracking-widest uppercase">
        Running Count
      </span>
      <span className="font-display font-black text-6xl text-white tracking-tight">
        {displayValue}
      </span>
    </div>
  )
}
