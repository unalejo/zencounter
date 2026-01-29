import { Github, Instagram } from 'lucide-react'

const SOCIAL_LINKS = {
  github: 'https://github.com/unalejo',
  instagram: 'https://instagram.com/unalejo',
  x: 'https://x.com/unalejo',
}

export function Credits() {
  return (
    <div className="flex items-center justify-center gap-4 pt-4">
      <span className="text-dark-muted text-xs">Made by</span>
      <span className="text-dark-mutedLight text-xs font-semibold">@unalejo</span>
      <span className="text-dark-muted text-xs">•</span>
      <div className="flex items-center gap-3">
        <a
          href={SOCIAL_LINKS.github}
          target="_blank"
          rel="noopener noreferrer"
          className="text-dark-muted hover:text-dark-mutedLight transition-colors"
          aria-label="GitHub"
        >
          <Github size={14} />
        </a>
        <a
          href={SOCIAL_LINKS.instagram}
          target="_blank"
          rel="noopener noreferrer"
          className="text-dark-muted hover:text-dark-mutedLight transition-colors"
          aria-label="Instagram"
        >
          <Instagram size={14} />
        </a>
        <a
          href={SOCIAL_LINKS.x}
          target="_blank"
          rel="noopener noreferrer"
          className="text-dark-muted hover:text-dark-mutedLight transition-colors font-bold text-sm"
          aria-label="X"
        >
          𝕏
        </a>
      </div>
    </div>
  )
}
