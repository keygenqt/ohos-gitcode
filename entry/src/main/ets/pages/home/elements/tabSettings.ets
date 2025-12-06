class TabSettingsParams {}

@Builder
export function tabSettings(params: TabSettingsParams) {
  Text("Settings").width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
}