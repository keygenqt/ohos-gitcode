import { Pages } from "../../base/constants";
import { RepoModel } from "../../base/models";

@Component
export struct PageRepo {
  @Consume('navStack') navStack: NavPathStack;
  @Prop model: RepoModel
  menus: Array<NavigationMenuItem> = [{
    value: "", icon: $r('app.media.icon_edit'), action: () => {
      this.navStack.pushPath({ name: Pages.repo_update, param: JSON.stringify({edit: this.model}) });
    }
  }]

  build() {
    NavDestination() {
      Text("Coming soon...").width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
    }.title(this.model.name)
    .menus(this.menus)
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }
}
