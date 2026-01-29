interface ToggleProps {
  checked: boolean
  onChange: (checked: boolean) => void
  label?: string
}

export function Toggle({ checked, onChange, label }: ToggleProps) {
  return (
    <button
      role="switch"
      aria-checked={checked}
      aria-label={label}
      onClick={() => onChange(!checked)}
      className={`relative w-12 h-7 rounded-full transition-colors ${
        checked ? 'bg-white' : 'bg-dark-control'
      }`}
    >
      <span
        className={`absolute top-0.5 w-6 h-6 rounded-full transition-all ${
          checked ? 'left-[22px] bg-dark-bg' : 'left-0.5 bg-white'
        }`}
      />
    </button>
  )
}
