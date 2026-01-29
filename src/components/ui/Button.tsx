import { forwardRef } from 'react'
import type { ButtonHTMLAttributes, ReactNode } from 'react'

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary'
  icon?: ReactNode
  children: ReactNode
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant = 'primary', icon, children, className = '', ...props }, ref) => {
    const baseStyles =
      'w-full h-14 rounded-2xl flex items-center justify-center gap-3 font-display font-bold text-lg transition-opacity disabled:opacity-50'

    const variantStyles = {
      primary: 'bg-white text-black',
      secondary: 'bg-dark-surface text-white',
    }

    return (
      <button
        ref={ref}
        className={`${baseStyles} ${variantStyles[variant]} ${className}`}
        {...props}
      >
        {icon}
        {children}
      </button>
    )
  }
)

Button.displayName = 'Button'
