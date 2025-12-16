import { common } from '@kit.AbilityKit';
import { Links } from '../../../base/constants';

class TabSettingsParams {
  context: common.UIAbilityContext | null = null
  onLogout: () => void = () => {}
}

@Builder
export function tabAbout(params: TabSettingsParams) {
  Column() {
    Column() {
      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.icon_logout'))
          .fillColor($r('app.color.btn_round_icon_fill'))
          .width(24)
          .height(24)
      }
      .width(40)
      .height(40)
      .backgroundColor($r('app.color.btn_round_background'))
      .onClick(() => params.onLogout())
    }
    .width('100%')
    .alignItems(HorizontalAlign.End)
    .padding({right: 16, top: 8, left: 16, bottom: 8})
    .backgroundColor($r('sys.color.background_primary'))

    Scroll() {
      Column({ space: 36 }) {
        Column() {
          Stack() {
            Column()
              .width(130)
              .height(130)
              .borderRadius(130)
              .border({ width: 2, color: $r('app.color.secondary') })
              .offset({x: -2})
            Column()
              .width(130)
              .height(130)
              .borderRadius(130)
              .border({ width: 2, color: $r('app.color.primary') })
              .offset({x: 2})

            Column() {
              Image($r('app.media.icon_foreground'))
                .width(120)
                .height(120)
                .fillColor($r('sys.color.font'))
            }
            .width(130)
            .height(130)
            .borderRadius(130)
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('sys.color.background_primary'))
          }
          Blank().height(20)
          Text($r('app.string.app_name')).fontSize(30).fontWeight(FontWeight.Bold)
          Blank().height(8)
          Text('v0.0.1').fontSize(14).fontColor($r('app.color.primary'))
        }
        .width("100%")
        .padding(24)
        .borderRadius($r('app.float.card_radius'))
        .backgroundColor($r('app.color.primary_light'))
        .border({ width: 0.5, color: $r('app.color.primary') })
        .alignItems(HorizontalAlign.Center)

        Text($r('app.string.PageHomeTabAbout_description'))
          .fontSize(18)
          .width('100%')
          .padding({left: 20, right: 20})
          .textAlign(TextAlign.Center)

        Column() {
          Row() {
            Column({space: 8}) {
              Button({ type: ButtonType.Circle }) {
                Image($r('app.media.icon_app_gallery'))
                  .fillColor($r('app.color.btn_round_icon_fill'))
                  .width(24)
                  .height(24)
                  .borderRadius(24)
              }
              .width(40)
              .height(40)
              .backgroundColor($r('app.color.btn_round_background'))
              .onClick(() => {
                params.context?.startAbility({
                  action: 'action.system.home',
                  uri: Links.app_market(),
                })
              })
              Text($r('app.string.PageHomeTabAbout_btn_app_gallery')).fontSize(14)
            }

            Divider()
              .vertical(true)
              .height(40)
              .color($r('app.color.secondary'))
              .margin({ left: 8, right: 8 })

            Column({space: 8}) {
              Button({ type: ButtonType.Circle }) {
                Image($r('app.media.icon_dev_account'))
                  .fillColor($r('app.color.btn_round_icon_fill'))
                  .width(26)
                  .height(26)
              }
              .width(40)
              .height(40)
              .backgroundColor($r('app.color.btn_round_background'))
              .onClick(() => {
                params.context?.startAbility({
                  action: 'ohos.want.action.viewData',
                  entities: ['entity.system.browsable'],
                  abilityName: 'MainAbility',
                  uri: Links.app_developer(),
                })
              })
              Text($r('app.string.PageHomeTabAbout_btn_app_dev')).fontSize(14)
            }

            Divider()
              .vertical(true)
              .height(40)
              .color($r('app.color.secondary'))
              .margin({ left: 8, right: 8 })

            Column({space: 8}) {
              Button({ type: ButtonType.Circle }) {
                Image($r('app.media.icon_gitcode'))
                  .fillColor($r('app.color.btn_round_icon_fill'))
                  .width(24)
                  .height(24)
              }
              .width(40)
              .height(40)
              .backgroundColor($r('app.color.btn_round_background'))
              .onClick(() => {
                params.context?.startAbility({
                  action: 'ohos.want.action.viewData',
                  entities: ['entity.system.browsable'],
                  abilityName: 'MainAbility',
                  uri: Links.app_repo(),
                })
              })
              Text($r('app.string.PageHomeTabAbout_btn_app_repo')).fontSize(14)
            }
          }
          .width("100%")
          .justifyContent(FlexAlign.SpaceAround)
        }
        .width("100%")
        .padding(16)
        .borderRadius($r('app.float.card_radius'))
        .backgroundColor($r('app.color.secondary_light'))
        .border({ width: 0.5, color: $r('app.color.secondary') })
        .alignItems(HorizontalAlign.Center)
      }
      .padding(16)
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .align(Alignment.Top)
    .padding({ bottom: 60 /* bottom bar */ + 50 /* top bar */ })
  }
  .height('100%')
  .width('100%')
}