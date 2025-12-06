@Component
export struct PageError404 {
  @Consume('navStack') navStack: NavPathStack;

  build() {
    NavDestination() {
      Text("Page not found").width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
    }.title("Error")
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }
}