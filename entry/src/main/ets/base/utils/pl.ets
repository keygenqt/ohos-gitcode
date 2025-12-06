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
 * @param name [string]
 * @returns [Resource]
 */
export function programmingLanguageIcon(lang: ProgrammingLanguage): Resource {
  return $r('app.media.icon_lan_' + lang.valueOf())
}