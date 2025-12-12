import { RepoModel } from "../../base/models";

@Component
export struct PageRepoUpdate {
  @Consume('navStack') navStack: NavPathStack;
  @Prop edit: RepoModel

  build() {
    NavDestination() {
      Text("Coming soon...").width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
    }.title("Edit: " + this.edit.name)
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }
}
