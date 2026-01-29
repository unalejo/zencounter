# ZenCounter

Cognitive training application for mental agility through Hi-Lo card counting exercises.

> **Disclaimer**: This is an educational tool designed to train working memory and divided attention. It is not intended for use in real gambling environments.

## What is Hi-Lo?

Hi-Lo is a card counting system that assigns values to cards:

- **Low cards (2-6)**: +1
- **Neutral cards (7-9)**: 0
- **High cards (10-A)**: -1

Tracking these values exercises working memory, attention, and mental arithmetic.

## Features

- Adjustable card speed for progressive difficulty
- Multiple deck support (1-8 decks)
- Exam mode to verify counting accuracy
- Clean, distraction-free interface
- Works offline (PWA-ready)

## Getting Started

```bash
# Install dependencies
yarn install

# Start development server
yarn dev

# Build for production
yarn build

# Run tests
yarn test
```

## Tech Stack

- **React 18** + **TypeScript** - UI framework with type safety
- **Vite** - Fast build tool
- **Tailwind CSS** - Utility-first styling
- **Zustand** - Lightweight state management
- **Framer Motion** - Smooth animations
- **Vitest** - Fast unit testing

## Deployment

Automatically deploys to GitHub Pages via GitHub Actions on push to `main`.

Live at: `https://unalejo.github.io/zencounter/`

## Project Structure

```
src/
├── components/    # React components
├── hooks/         # Custom React hooks
├── lib/           # Core game logic
├── screens/       # Screen components
├── stores/        # Zustand state stores
└── types/         # TypeScript definitions
```

## License

MIT - See [LICENSE](LICENSE) for details.

## Contributing

Contributions welcome! Please read the [AGENTS.md](AGENTS.md) for development guidelines.
