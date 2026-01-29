import { Badge } from '@/components/ui'

export function HiLoReference() {
  const rules = [
    { cards: '2, 3, 4, 5, 6', value: 1 as const },
    { cards: '7, 8, 9', value: 0 as const },
    { cards: '10, J, Q, K, A', value: -1 as const },
  ]

  return (
    <div className="flex flex-col gap-3">
      {rules.map((rule) => (
        <div key={rule.value} className="flex items-center justify-between">
          <span className="font-display font-semibold text-white">{rule.cards}</span>
          <Badge value={rule.value} />
        </div>
      ))}
    </div>
  )
}
