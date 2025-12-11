import { CryptoJS } from '@ohos/crypto-js'
import BuildProfile from 'BuildProfile';

export function encryptData(data: string) {
  return CryptoJS.AES.encrypt(data, BuildProfile.cryptoSecret).toString();
}

export function decryptData(encryptedData: string) {
  return CryptoJS.AES.decrypt(encryptedData, BuildProfile.cryptoSecret).toString(CryptoJS.enc.Utf8);
}
