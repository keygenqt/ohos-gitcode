import { RepoModel } from "../../base/models";

@Component
export struct PageRepo {
  @Consume('navStack') navStack: NavPathStack;
  @Prop model: RepoModel

  build() {
    NavDestination() {
      Text("Coming soon...").width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
    }.title(this.model.name)
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }
}
