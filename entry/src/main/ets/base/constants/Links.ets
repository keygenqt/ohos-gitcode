import BuildProfile from 'BuildProfile'
import { getAuthModel, getUserModel } from '../models'

export class Links {
  static app_market(): string {
    return `appmarket://details?id=com.keygenqt.gitcode`
  }

  static app_developer(): string {
    return `https://keygenqt.com`
  }

  static app_repo(): string {
    return `https://gitcode.com/keygenqt_vz/ohos-gitcode`
  }

  static auth_redirect(): string {
    const link = `https://gitcode.com/oauth/authorize?client_id=${BuildProfile.clientId}&redirect_uri=https://ohos-gitcode.keygenqt.com/&response_type=code`;
    console.debug(link)
    return link
  }

  static auth_token(code: string | null) {
    const link = `https://gitcode.com/oauth/token?grant_type=authorization_code&code=${code}&client_id=${BuildProfile.clientId}&client_secret=${BuildProfile.clientSecret}`;
    console.debug(link)
    return link
  }

  static user(): string {
    const link = `https://api.gitcode.com/api/v5/user?access_token=${getAuthModel()?.access_token}`;
    console.debug(link)
    return link
  }

  static user_repos(page: number) {
    const link = `https://api.gitcode.com/api/v5/user/repos?access_token=${getAuthModel()?.access_token}&type=all&sort=created_at&page=${page}&per_page=4`;
    console.debug(link)
    return link
  }

  static repo(path: string) {
    const link = `https://api.gitcode.com/api/v5/repos/${getUserModel()?.login}/${path}?access_token=${getAuthModel()?.access_token}`;
    console.debug(link)
    return link
  }

  static repo_update(path: string) {
    const link = `https://api.gitcode.com/api/v5/repos/${getUserModel()?.login}/${path}?access_token=${getAuthModel()?.access_token}`;
    console.debug(link)
    return link
  }
}