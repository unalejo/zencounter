import type { ReactNode } from 'react'

interface CardProps {
  children: ReactNode
  className?: string
}

export function Card({ children, className = '' }: CardProps) {
  return <div className={`bg-dark-surface rounded-2xl p-5 ${className}`}>{children}</div>
}

interface CardTitleProps {
  children: ReactNode
}

export function CardTitle({ children }: CardTitleProps) {
  return <h2 className="font-display font-bold text-lg text-white mb-5">{children}</h2>
}
