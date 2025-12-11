export enum ProgrammingLanguage {
  arkts = 'arkts',
  bash = 'bash',
  clang = 'c',
  cplusplus = 'cpp',
  dart = 'dart',
  elixir = 'elixir',
  groovy = 'groovy',
  haskell = 'haskell',
  java = 'java',
  javascript = 'javascript',
  kotlin = 'kotlin',
  php = 'php',
  python = 'python',
  ruby = 'ruby',
  rust = 'rust',
  scala = 'scala',
  swift = 'swift',
  unknown = 'unknown',
}

/**
 * Get icon programming language by name
 */
export function programmingLanguageIconEnum(lang: ProgrammingLanguage): Resource {
  return $r('app.media.icon_lan_' + lang.valueOf())
}

/**
 * Get icon programming language by name
 */
export function programmingLanguageIcon(lang: string | null): Resource {
  if (!lang) {
    return $r('app.media.icon_lan_unknown')
  }
  return $r('app.media.icon_lan_' + lang.toLowerCase())
}