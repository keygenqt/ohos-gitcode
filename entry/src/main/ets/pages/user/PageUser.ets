@Component
export struct PageUser {
  @Consume('navStack') navStack: NavPathStack;

  build() {
    NavDestination() {
      Text("Coming soon...").width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
    }.title("User info")
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }
}
