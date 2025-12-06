import { Pages } from '../../base/constants/Pages';
import { customTabBar } from './elements/customTabBar';
import { navDestination } from './elements/navDestination';
import { tabRepos } from './elements/tabRepos';
import { tabSettings } from './elements/tabSettings';

@Entry
@Component
struct PageHome {
  @Provide('navStack') navStack: NavPathStack = new NavPathStack()
  @State tab: number = 0;
  menus: Array<NavigationMenuItem> = [{
    value: "", icon: $r('app.media.icon_user'), action: () => {
      this.navStack.pushPath({ name: Pages.user });
    }
  }]

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        Navigation(this.navStack) {
          tabRepos({ navStack: this.navStack })
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
