import { Pages } from '../../base/constants/Pages';
import { customTabBar } from './elements/customTabBar';
import { navDestination } from './elements/navDestination';
import { tabRepos } from './elements/tabRepos';
import { tabAbout } from './elements/tabAbout';
import { PageState } from '../../base/enums';
import { RepoModel, UserModel } from '../../base/models';
import { PageBodyState } from '../../base/components';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';
import { common } from '@kit.AbilityKit';
import { Links, Storage } from '../../base/constants';

// PersistentStorage
PersistentStorage.persistProp(Storage.authData, null);
PersistentStorage.persistProp(Storage.userData, null);

@Entry
@Component
struct PageHome {
  @Provide('navStack') navStack: NavPathStack = new NavPathStack()

  menus: Array<NavigationMenuItem> = [{
    value: "", icon: $r('app.media.icon_user'), action: () => {
      this.navStack.pushPath({ name: Pages.user });
    }
  }]

  @StorageLink(Storage.authCode) authCode: boolean = false;
  @StorageLink(Storage.userData) userData: UserModel | null = null;
  @StorageLink(Storage.repoData) repoData: RepoModel | null = null;
  @StorageLink(Storage.reposData) reposData: [RepoModel] | null = null;

  @State tab: number = 0;
  @State page: number = 1;
  @State pageState: PageState = PageState.Loading;

  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext

  build() {
    Column() {
      PageBodyState({
        state: this.pageState,
        stateLoading: () => { this.queryModel() },
      }) {
        this.bodyModel()
      }
    }
    .height('100%')
    .width('100%')
  }

  queryModel() {
    if (this.page == 1) {
      this.pageState = PageState.Loading
    }
    axios.get<[RepoModel], AxiosResponse<[RepoModel]>, null>(Links.user_repos(this.page))
      .then((response: AxiosResponse<[RepoModel]>) => {
        if (this.page != 1 && this.reposData instanceof Array) {
          if (response.data.length) {
            response.data.forEach((item) => {
              (this.reposData as [RepoModel]).push(item)
            })
          } else {
            this.page = -1;
          }
        } else {
          this.reposData = response.data;
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
            page: this.page,
            data: this.reposData as [RepoModel],
            state: this.pageState,
            onLoading: (page, state) => {
              this.page = page
              this.pageState = state
              this.queryModel()
            },
            onOpenRepo: (data: RepoModel) => {
              this.repoData = data
              this.navStack?.pushPath({ name: Pages.repo });
            }
          })
        }.title($r('app.string.app_name')).mode(NavigationMode.Stack).navDestination(navDestination).menus(this.menus)
      }.tabBar(customTabBar({ icon: $r('app.media.icon_home'), active: this.tab === 0 }))

      TabContent() {
        tabAbout({
          context: this.context,
          onLogout: () => {
            this.authCode = false;
            this.userData = null;
          }
        })
      }.tabBar(customTabBar({ icon: $r('app.media.icon_page_info'), active: this.tab === 1 }))
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
