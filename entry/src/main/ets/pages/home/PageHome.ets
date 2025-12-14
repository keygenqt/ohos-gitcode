import { Pages } from '../../base/constants/Pages';
import { customTabBar } from './elements/customTabBar';
import { navDestination } from './elements/navDestination';
import { tabRepos } from './elements/tabRepos';
import { tabSettings } from './elements/tabSettings';
import { PageState } from '../../base/enums';
import { RepoModel } from '../../base/models';
import { PageBodyState } from '../../base/components';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';
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
  @State page: number = 1;
  @State pageData: [RepoModel] | null = null;
  @State pageState: PageState = PageState.Loading;

  build() {
    Column() {
      PageBodyState({state: this.pageState, stateLoading: () => {
        this.queryModel()
      }}) {
        this.bodyModel()
      }
    }
    .height('100%')
    .width('100%')
  }

  queryModel() {
    axios.get<[RepoModel], AxiosResponse<[RepoModel]>, null>(Links.user_repos(this.page))
      .then((response: AxiosResponse<[RepoModel]>) => {
        if (this.page != 1 && this.pageData instanceof Array) {
          if (response.data.length) {
            response.data.forEach((item) => {
              (this.pageData as [RepoModel]).push(item)
            })
          } else {
            this.page = -1;
          }
        } else {
          this.pageData = response.data;
        }
        this.pageState = PageState.Ready
      })
      .catch((_: AxiosError) => this.pageState = PageState.Error);
  }

  @Builder
  bodyModel() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        Navigation(this.navStack) {
          tabRepos({
            navStack: this.navStack,
            page: this.page,
            data: this.pageData as [RepoModel],
            state: this.pageState,
            onLoading: (page, state) => {
              this.page = page
              this.pageState = state
              this.queryModel()
            },
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
