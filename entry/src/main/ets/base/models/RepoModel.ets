export interface RepoModel {
  id: number,
  name: string,
  url: string,
  description: string,
  forks_count: number,
  stargazers_count: number,
  watchers_count: number,
  language: string | null,
  private: boolean,
}