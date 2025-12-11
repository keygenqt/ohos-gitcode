import BuildProfile from 'BuildProfile'
import { getAuthModel, getUserModel } from '../models'

export class Links {
  static auth_redirect(): string {
    return `https://gitcode.com/oauth/authorize?client_id=${BuildProfile.clientId}&redirect_uri=https://ohos-gitcode.keygenqt.com/&response_type=code`
  }

  static auth_token(code: string | null) {
    return `https://gitcode.com/oauth/token?grant_type=authorization_code&code=${code}&client_id=${BuildProfile.clientId}&client_secret=${BuildProfile.clientSecret}`
  }

  static user(): string {
    return `https://api.gitcode.com/api/v5/user?access_token=${getAuthModel()?.access_token}`
  }

  /**
   * TODO Paging?
   */
  static user_repos() {
    console.log(`>> https://api.gitcode.com/api/v5/users/${getUserModel()?.login}/repos?access_token=${getAuthModel()?.access_token}&type=all&sort=full_name&page=1&pre_page=100`)
    return `https://api.gitcode.com/api/v5/users/${getUserModel()?.login}/repos?access_token=${getAuthModel()?.access_token}&type=all&sort=full_name&page=1&pre_page=100`
  }
}