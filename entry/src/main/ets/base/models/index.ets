import { Storage } from '../constants';
import { decryptData, encryptData } from '../utils/crypto';
import { AuthModel } from './AuthModel';
import { RepoModel } from './RepoModel';
import { UserModel } from './UserModel';

export * from './AuthModel';
export * from './RepoModel';
export * from './UserModel';

export function saveAuthModel(model: AuthModel) {
  AppStorage.setOrCreate(Storage.authData, encryptData(JSON.stringify(model)));
}

export function getAuthModel(): AuthModel | undefined {
  const data = AppStorage.get<string>(Storage.authData);
  if (!data) return undefined;
  return JSON.parse(decryptData(data));
}

export function saveUserModel(model: UserModel) {
  AppStorage.setOrCreate(Storage.userData, model);
}

export function getUserModel(): UserModel | undefined {
  return AppStorage.get<UserModel>(Storage.userData);
}

