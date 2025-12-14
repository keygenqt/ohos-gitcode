export interface RepoModel {
  id: number,
  full_name: string,
  human_name: string,
  namespace: RepoNamespaceModel
  path: string
  name: string
  description: string
  status: string
  ssh_url_to_repo: string
  http_url_to_repo: string
  web_url: string
  homepage: string
  members: [string]
  assignee: [RepoAssigneeModel]
  forks_count: number
  stargazers_count: number
  project_labels: [string]
  relation: string
  permission: RepoPermissionModel
  internal: boolean
  open_issues_count: number
  has_issue: boolean
  watched: boolean
  watchers_count: number
  assignees_number: number
  enterprise: RepoEnterpriseModel
  default_branch: string
  fork: boolean
  owner: RepoOwnerModel
  assigner: RepoAssignerModel
  issue_template_source: string
  private: boolean
  public: boolean
  gitee: RepoGiteeModel,
  language: string,
}

export interface RepoNamespaceModel {
  id: string,
  login: string,
  name: string,
  avatar_url: string,
  html_url: string,
  type: string,
}

export interface RepoAssigneeModel {
  id: number,
  type: string,
  name: string,
  path: string,
  html_url: string,
}

export interface RepoPermissionModel {
  pull: boolean,
  push: boolean,
  admin: boolean,
}

export interface RepoEnterpriseModel {
  id: number,
  path: string,
  html_url: string,
  type: string,
}

export interface RepoOwnerModel {
  id: string,
  login: string,
  name: string,
  avatar_url: string,
  html_url: string,
  type: string,
  url: string,
}

export interface RepoAssignerModel {
  id: string,
  login: string,
  name: string,
  avatar_url: string,
  html_url: string,
  type: string,
  url: string,
}

export interface RepoGiteeModel {
  star: number,
  fork: number,
  watch: number,
}

