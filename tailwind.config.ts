import type { Config } from 'tailwindcss'

export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        // Zen-inspired color palette (legacy)
        zen: {
          50: '#f7f7f5',
          100: '#e8e8e3',
          200: '#d3d3c8',
          300: '#b8b8a6',
          400: '#9d9d85',
          500: '#8a8a6d',
          600: '#727259',
          700: '#5c5c49',
          800: '#4d4d3f',
          900: '#434338',
          950: '#24241e',
        },
        // Design system colors
        dark: {
          bg: '#18181B',
          surface: '#27272A',
          control: '#3F3F46',
          muted: '#71717A',
          mutedLight: '#A1A1AA',
        },
        success: '#22C55E',
        error: '#EF4444',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Outfit', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      animation: {
        'card-flip': 'cardFlip 0.6s ease-in-out',
        'fade-in': 'fadeIn 0.3s ease-out',
        'slide-up': 'slideUp 0.4s ease-out',
      },
      keyframes: {
        cardFlip: {
          '0%': { transform: 'rotateY(0deg)' },
          '50%': { transform: 'rotateY(90deg)' },
          '100%': { transform: 'rotateY(0deg)' },
        },
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { opacity: '0', transform: 'translateY(10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
      },
    },
  },
  plugins: [],
} satisfies Config
