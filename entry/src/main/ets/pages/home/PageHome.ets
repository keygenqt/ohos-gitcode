import { Pages } from '../../base/constants/Pages';
import { customTabBar } from './elements/customTabBar';
import { navDestination } from './elements/navDestination';
import { tabRepos } from './elements/tabRepos';
import { tabSettings } from './elements/tabSettings';
import { PageState } from '../../base/enums';
import { RepoModel } from '../../base/models';
import { PageBodyState } from '../../base/components';
import axios, { AxiosResponse } from '@ohos/axios';
import { Links, Storage } from '../../base/constants';

// PersistentStorage
PersistentStorage.persistProp(Storage.authData, null);
PersistentStorage.persistProp(Storage.userData, null);

@Entry
@Component
struct PageHome {
  menus: Array<NavigationMenuItem> = [{
    value: "", icon: $r('app.media.icon_user'), action: () => {
      this.navStack.pushPath({ name: Pages.user });
    }
  }]
  @Provide('navStack') navStack: NavPathStack = new NavPathStack()
  @State tab: number = 0;
  @State state: [RepoModel] | PageState = PageState.Loading;
  @State pageLoading: boolean = false;
  @State page: number = 1;

  build() {
    Column() {
      PageBodyState({state: this.state, stateLoading: () => {
        this.queryModel()
      }}) {
        this.bodyModel(this.state as [RepoModel])
      }
    }
    .height('100%')
    .width('100%')
  }

  queryModel() {
    axios.get<[RepoModel], AxiosResponse<[RepoModel]>, null>(Links.user_repos(this.page))
      .then((response: AxiosResponse<[RepoModel]>) => {
        if (this.state instanceof Array) {
          // @todo ??
          this.state.concat(response.data)
        } else {
          this.state = response.data
        }
        this.pageLoading = false
      })
      .catch((_: [RepoModel]) => this.state = PageState.ErrorNetwork);
  }

  @Builder
  bodyModel(models: [RepoModel]) {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        Navigation(this.navStack) {
          tabRepos({
            navStack: this.navStack,
            models: models,
            pageLoading: this.pageLoading,
            page: this.page,
            onLoading: (page) => {
              this.page = page
              this.pageLoading = true
              this.queryModel()
            }
          })
        }.title($r('app.string.app_name')).mode(NavigationMode.Stack).navDestination(navDestination).menus(this.menus)
      }.tabBar(customTabBar({ icon: $r('app.media.icon_home'), active: this.tab === 0 }))

      TabContent() {
        tabSettings({})
      }.tabBar(customTabBar({ icon: $r('app.media.icon_settings'), active: this.tab === 1 }))
    }
    .onSelected((index: number) => {
      this.tab = index;
    })
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.background_primary'))
    .barHeight(this.navStack.size() === 0 ? null : 0.01)
    .barBackgroundColor(Color.Transparent)
    .barOverlap(true)
    .scrollable(false)
    .animation({
      duration: 200,
      iterations: 1,
      curve: Curve.Linear,
      playMode: PlayMode.Normal
    })
  }
}
