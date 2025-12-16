@Component
export struct PageNotFound {
  @Consume('navStack') navStack: NavPathStack;

  build() {
    NavDestination() {
      Text($r('app.string.PageNotFound_text')).width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
    }.title($r('app.string.PageNotFound_title'))
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }
}