import axios, { AxiosError, AxiosResponse } from "@ohos/axios";
import { common } from '@kit.AbilityKit';
import { PageBodyState } from "../../base/components";
import { Links, Storage } from "../../base/constants";
import { PageState } from "../../base/enums";
import { UserModel } from "../../base/models";

@Component
export struct PageUser {
  @Consume('navStack') navStack: NavPathStack;

  @StorageLink(Storage.userData) userData: UserModel | null = null;

  @State pageState: PageState = PageState.Loading;

  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext

  build() {
    NavDestination() {
      PageBodyState({state: this.pageState, stateLoading: () => {
        this.queryModel()
      }}) {
        this.bodyModel()
      }
    }
    .title($r('app.string.PageUser_title'))
    .onBackPressed(() => this.navStack.pop() !== undefined)
  }

  queryModel() {
    axios.get<UserModel, AxiosResponse<UserModel>, null>(Links.user())
      .then((response: AxiosResponse<UserModel>) => {
        this.userData = response.data
        this.pageState = PageState.Ready
      })
      .catch((_: AxiosError) => this.pageState = PageState.Error);
  }

  @Builder
  bodyModel() {
    Refresh({ refreshing: this.pageState == PageState.Refresh }) {
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
              Image(this.userData?.avatar_url)
                .width(130)
                .height(130)
                .borderRadius(130)
                .objectFit(ImageFit.Cover)
            }
            Blank().height(20)
            Text(this.userData?.name).fontSize(30).fontWeight(FontWeight.Bold)
            Blank().height(8)
            Text(this.userData?.company).fontSize(14).fontColor($r('app.color.primary'))
          }
          .width("100%")
          .padding(24)
          .borderRadius($r('app.float.card_radius'))
          .backgroundColor($r('app.color.primary_light'))
          .border({ width: 0.5, color: $r('app.color.primary') })
          .alignItems(HorizontalAlign.Center)

          if (this.userData?.bio.length != 0) {
            Text(this.userData?.bio)
              .fontSize(18)
              .width('100%')
              .padding({left: 20, right: 20})
              .textAlign(TextAlign.Center)
          }

          Column() {
            Row() {
              Column({space: 8}) {
                Button({ type: ButtonType.Circle }) {
                  Image($r('app.media.icon_email'))
                    .fillColor($r('app.color.btn_round_icon_fill'))
                    .width(24)
                    .height(24)
                }
                .width(40)
                .height(40)
                .backgroundColor($r('app.color.btn_round_background'))
                .onClick(() => {
                  this.context?.startAbility({
                    action: 'ohos.want.action.sendToData',
                    abilityName: 'MainAbility',
                    uri: `mailto:${this.userData?.email}?subject=Hello ${this.userData?.name}!`,
                  })
                })
                Text($r('app.string.PageUser_btn_email')).fontSize(14)
              }

              if (this.userData?.blog) {
                Divider()
                  .vertical(true)
                  .height(40)
                  .color($r('app.color.secondary'))
                  .margin({ left: 8, right: 8 })

                Column({space: 8}) {
                  Button({ type: ButtonType.Circle }) {
                    Image($r('app.media.icon_blog'))
                      .fillColor($r('app.color.btn_round_icon_fill'))
                      .width(24)
                      .height(24)
                  }
                  .width(40)
                  .height(40)
                  .backgroundColor($r('app.color.btn_round_background'))
                  .onClick(() => {
                    this.context?.startAbility({
                      action: 'ohos.want.action.viewData',
                      entities: ['entity.system.browsable'],
                      abilityName: 'MainAbility',
                      uri: this.userData?.blog,
                    })
                  })
                  Text($r('app.string.PageUser_btn_blog')).fontSize(14)
                }
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
                  this.context?.startAbility({
                    action: 'ohos.want.action.viewData',
                    entities: ['entity.system.browsable'],
                    abilityName: 'MainAbility',
                    uri: this.userData?.html_url,
                  })
                })
                Text($r('app.string.PageUser_btn_gitcode')).fontSize(14)
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
        .alignItems(HorizontalAlign.Center)
      }
    }
    .onStateChange((refreshStatus: RefreshStatus) => {
      if (refreshStatus == RefreshStatus.Refresh) {
        this.pageState = PageState.Refresh
        this.queryModel()
      }
    })
    .refreshOffset(64)
    .pullToRefresh(true)
  }
}
