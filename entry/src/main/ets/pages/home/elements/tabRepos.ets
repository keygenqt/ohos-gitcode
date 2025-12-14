import { Pages } from '../../../base/constants/Pages'
import { PageState } from '../../../base/enums';
import { RepoModel } from '../../../base/models';
import { programmingLanguageIcon } from '../../../base/utils/pl';

class TabReposParams {
  navStack: NavPathStack | null = null;
  page: number = 1;
  data: [RepoModel] | null = null;
  state: PageState = PageState.Loading;
  onLoading: (page: number, state: PageState) => void = () => {}
}

@Builder
export function tabRepos(params: TabReposParams) {
  Refresh({ refreshing: params.state == PageState.Refresh }) {
    if (params.data != null) {
      List({ space: 16 }) {
        ForEach(params.data, (item: RepoModel, index: number) => {
          ListItem() {
            Button({ type: ButtonType.Normal, stateEffect: true }) {
              Column({space: 16}) {
                Row({space: 16}) {
                  Column() {
                    Image(programmingLanguageIcon(item.language))
                      .fillColor(Color.White)
                      .width(24)
                      .height(24)
                  }
                  .height(36)
                  .width(36)
                  .alignItems(HorizontalAlign.Center)
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor($r('app.color.primary'))
                  .borderRadius(36)

                  Text(item.name).fontSize(20).fontWeight(FontWeight.Bold)
                }
                .width('100%')
                Text(item.description).fontSize(16).width('100%')
                Divider().strokeWidth(1).color($r('app.color.primary_light'))
                Row() {
                  Row({space: 8}) {
                    Row({space: 4}) {
                      Image($r('app.media.icon_star'))
                        .fillColor($r('sys.color.icon'))
                        .width(20)
                        .height(20)
                      Text(item.stargazers_count.toString()).fontSize(16)
                    }
                    Row({space: 4}) {
                      Image($r('app.media.icon_graph'))
                        .fillColor($r('sys.color.icon'))
                        .width(20)
                        .height(20)
                      Text(item.forks_count.toString()).fontSize(16)
                    }
                    Row({space: 6}) {
                      Image($r('app.media.icon_visibility'))
                        .fillColor($r('sys.color.icon'))
                        .width(20)
                        .height(20)
                      Text(item.watchers_count.toString()).fontSize(16)
                    }
                  }
                  Row() {
                    Image(item.private ? $r('app.media.icon_lock') : $r('app.media.icon_unlock'))
                      .fillColor($r('sys.color.icon'))
                      .width(20)
                      .height(20)
                  }
                }
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')
              }
              .width('100%')
            }
            .width("100%")
            .padding(24)
            .margin({ top: index ? 0 : 16 })
            .backgroundColor($r('app.color.primary_light'))
            .border({ width: 0.5, color: $r('app.color.primary') })
            .borderRadius($r('app.float.card_radius'))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              params.navStack?.pushPath({ name: Pages.repo, param: JSON.stringify({ repoModel: item }) });
            })
          }
        })
        ListItem() {
          Column() {
            LoadingProgress().width(30).height(30)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .visibility(params.page <= 0 ? Visibility.None : Visibility.Visible)
        }
        .margin({bottom: params.page <= 0 ? 60 : 76 })
      }
      .padding({ right: 16, left: 16 })
      .width("100%")
      .onScrollIndex((start: number, end: number, center: number) => {
        if (params.page > 0 && params.data?.length == end && params.state == PageState.Ready) {
          params.onLoading(params.page + 1, PageState.Paging)
        }
      })
    }
  }
  .onStateChange((refreshStatus: RefreshStatus) => {
    if (refreshStatus == RefreshStatus.Refresh) {
      params.onLoading(1, PageState.Refresh)
    }
  })
  .refreshOffset(64)
  .pullToRefresh(true)
}