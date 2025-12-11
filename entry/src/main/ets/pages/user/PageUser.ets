import axios, { AxiosError, AxiosResponse } from "@ohos/axios";
import { PageBodyState } from "../../base/components";
import { Links } from "../../base/constants";
import { PageState } from "../../base/enums";
import { UserModel } from "../../base/models";

@Component
export struct PageUser {
  @Consume('navStack') navStack: NavPathStack;

  @State state: UserModel | PageState = PageState.Loading;

  build() {
    NavDestination() {
      PageBodyState({state: this.state, stateLoading: () => {
        this.queryModel()
      }}) {
        this.bodyModel(this.state as UserModel)
      }
    }.title("User info")
    .onBackPressed(() => this.navStack.pop() !== undefined)
  }

  queryModel() {
    axios.get<UserModel, AxiosResponse<UserModel>, null>(Links.user())
      .then((response: AxiosResponse<UserModel>) => setTimeout(() => this.state = response.data, 1000))
      .catch((_: AxiosError) => setTimeout(() => this.state = PageState.ErrorNetwork, 1000));
  }

  @Builder
  bodyModel(model: UserModel) {
    Text(model.name).width('100%').height('100%').fontSize(24).textAlign(TextAlign.Center)
  }
}
