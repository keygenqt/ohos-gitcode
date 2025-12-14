import { Storage } from "../../base/constants";
import { UserModel } from "../../base/models";

@Component
export struct PageUserUpdate {
  @Consume('navStack') navStack: NavPathStack;
  @StorageLink(Storage.userData) userData: UserModel | null = null;

  build() {
    NavDestination() {
      Text("Coming soon...").width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
    }
    .title($r('app.string.PageUserUpdate_title'))
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }
}
