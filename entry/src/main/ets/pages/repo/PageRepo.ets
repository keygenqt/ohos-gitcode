import axios, { AxiosError, AxiosResponse } from "@ohos/axios";
import { common } from '@kit.AbilityKit';
import { PageBodyState } from "../../base/components";
import { Links, Pages, Storage } from "../../base/constants";
import { PageState } from "../../base/enums";
import { RepoModel } from "../../base/models";
import { programmingLanguageIcon } from "../../base/utils/pl";

@Component
export struct PageRepo {

  @Consume('navStack') navStack: NavPathStack;

  menus: Array<NavigationMenuItem> = [{
    value: "", icon: $r('app.media.icon_edit'), action: () => {
      this.navStack.pushPath({ name: Pages.repo_update });
    }
  }]

  @StorageLink(Storage.repoData) repoData: RepoModel | null = null;
  @StorageLink(Storage.reposData) reposData: [RepoModel] | null = null;

  @State pageState: PageState = PageState.Ready;

  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext

  build() {
    NavDestination() {
      PageBodyState({state: this.pageState, stateLoading: () => {
        this.queryModel()
      }}) {
        this.bodyModel()
      }
    }
    .title($r('app.string.PageRepo_title'))
    .menus(this.pageState == PageState.Ready ? this.menus : [])
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }

  queryModel() {
    axios.get<RepoModel, AxiosResponse<RepoModel>, null>(Links.repo(this.repoData?.path ?? ''))
      .then((response: AxiosResponse<RepoModel>) => {
        this.repoData = response.data
        this.pageState = PageState.Ready
        // Update state list
        if (this.reposData != null) {
          const index = this.reposData?.findIndex((e: RepoModel) => e.id == this.repoData?.id) ?? -1;
          if (index >= 0) {
            this.reposData[index] = this.repoData;
          }
        }
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

              Column() {
                Image(programmingLanguageIcon(this.repoData?.language))
                  .fillColor($r('sys.color.font'))
                  .width(70)
                  .height(70)
              }
              .width(130)
              .height(130)
              .borderRadius(130)
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor($r('sys.color.background_primary'))
            }
            Blank().height(20)
            Text(this.repoData?.name).fontSize(30).fontWeight(FontWeight.Bold)
            Blank().height(8)
            Text(this.repoData?.project_labels.map((e) => `#${e}`).join(', ')).fontSize(14).fontColor($r('app.color.primary'))

            Blank().height(24)
            Divider().color($r('app.color.primary'))
            Blank().height(24)

            Row({space: 16}) {
              Row({space: 4}) {
                Image($r('app.media.icon_star'))
                  .fillColor($r('sys.color.icon'))
                  .width(24)
                  .height(24)
                Text(this.repoData?.stargazers_count.toString()).fontSize(18)
              }
              Row({space: 4}) {
                Image($r('app.media.icon_graph'))
                  .fillColor($r('sys.color.icon'))
                  .width(24)
                  .height(24)
                Text(this.repoData?.forks_count.toString()).fontSize(18)
              }
              Row({space: 6}) {
                Image($r('app.media.icon_visibility'))
                  .fillColor($r('sys.color.icon'))
                  .width(24)
                  .height(24)
                Text(this.repoData?.watchers_count.toString()).fontSize(18)
              }
            }
          }
          .width("100%")
          .padding(24)
          .borderRadius($r('app.float.card_radius'))
          .backgroundColor($r('app.color.primary_light'))
          .border({ width: 0.5, color: $r('app.color.primary') })
          .alignItems(HorizontalAlign.Center)

          if (this.repoData?.description.length != 0) {
            Text(this.repoData?.description)
              .fontSize(18)
              .width('100%')
              .padding({left: 20, right: 20})
              .textAlign(TextAlign.Center)
          }

          Column() {
            Row() {
              Column({space: 8}) {
                Button({ type: ButtonType.Circle }) {
                  Image($r('app.media.icon_home'))
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
                    uri: this.repoData?.homepage,
                  })
                })
                Text($r('app.string.PageRepo_btn_homepage')).fontSize(14)
              }

              Divider()
                .vertical(true)
                .height(40)
                .color($r('app.color.secondary'))
                .margin({ left: 8, right: 8 })

              Column({space: 8}) {
                Button({ type: ButtonType.Circle }) {
                  Image($r('app.media.icon_user'))
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
                    uri: this.repoData?.owner.html_url,
                  })
                })
                Text($r('app.string.PageRepo_btn_user_page')).fontSize(14)
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
                    uri: this.repoData?.web_url,
                  })
                })
                Text($r('app.string.PageRepo_btn_gitcode')).fontSize(14)
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
    .height('100%')
    .refreshOffset(64)
    .pullToRefresh(true)
  }
}
