import axios, { AxiosError, AxiosResponse } from "@ohos/axios";
import { PageBodyState } from "../../base/components";
import { Links, Storage } from "../../base/constants";
import { PageState } from "../../base/enums";
import { RepoModel } from "../../base/models";

@Component
export struct PageRepo {
  @Consume('navStack') navStack: NavPathStack;

  @StorageLink(Storage.reposData) reposData: [RepoModel] | null = null;

  @State pageState: PageState = PageState.Ready;

  @Prop repoModel: RepoModel

  build() {
    NavDestination() {
      PageBodyState({state: this.pageState, stateLoading: () => {
        this.queryModel()
      }}) {
        this.bodyModel(this.repoModel as RepoModel)
      }
    }.title(this.repoModel.name)
    .onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }

  queryModel() {
    axios.get<RepoModel, AxiosResponse<RepoModel>, null>(Links.repo(this.repoModel.path))
      .then((response: AxiosResponse<RepoModel>) => {
        this.repoModel = response.data
        this.pageState = PageState.Ready
        // Update state list
        if (this.reposData != null) {
          const index = this.reposData?.findIndex((e: RepoModel) => e.id == this.repoModel.id) ?? -1;
          if (index >= 0) {
            this.reposData[index] = this.repoModel;
          }
        }
      })
      .catch((_: AxiosError) => this.pageState = PageState.Error);
  }

  @Builder
  bodyModel(model: RepoModel) {
    Refresh({ refreshing: this.pageState == PageState.Refresh }) {
      Column({ space: 36 }) {
        Column() {
          Text(model.name).fontSize(30).fontWeight(FontWeight.Bold)
        }
        .width("100%")
        .padding(24)
        .borderRadius($r('app.float.card_radius'))
        .backgroundColor($r('app.color.primary_light'))
        .border({ width: 0.5, color: $r('app.color.primary') })
        .alignItems(HorizontalAlign.Center)
      }
      .padding(16)
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
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
