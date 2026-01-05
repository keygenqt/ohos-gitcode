import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { url } from '@kit.ArkTS';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';
import { AuthModel, saveAuthModel, saveUserModel, UserModel } from '../base/models';
import { Links, Storage } from '../base/constants';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    let uri = want?.uri;
    if (uri && uri.includes("ohos-gitcode.keygenqt.com")) {
      let urlObject = url.URL.parseURL(want?.uri);
      let code = urlObject.params.get('code');
      // Set code
      AppStorage.setOrCreate(Storage.authCode, code);
      // Get auth data
      axios.post<AuthModel, AxiosResponse<AuthModel>, null>(Links.auth_token(code))
        .then((response: AxiosResponse<AuthModel>) => {
          // Save auth data
          saveAuthModel(response.data);
          // Get user data
          axios.get<UserModel, AxiosResponse<UserModel>, null>(Links.user())
            .then((response: AxiosResponse<UserModel>) => {
              // Save user data
              saveUserModel(response.data);
            })
            .catch((_: AxiosError) => AppStorage.delete(Storage.userData))
        })
        .catch((_: AxiosError) => AppStorage.delete(Storage.authCode))
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    // Load main page
    windowStage.loadContent('pages/home/PageHome', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}