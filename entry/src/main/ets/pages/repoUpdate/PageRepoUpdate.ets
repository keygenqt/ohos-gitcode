@Component
export struct PageRepoUpdate {
  @Consume('navStack') navStack: NavPathStack;
  @Prop edit: string

  build() {
    NavDestination() {
      Text("Coming soon...").width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
    }.title("Edit: " + this.edit)
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }
}
