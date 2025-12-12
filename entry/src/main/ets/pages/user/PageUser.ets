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
    Column({ space: 20 }) {
      Text(model.avatar_url).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.followers_url).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.html_url).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.id).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.login).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.name).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.type).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.url).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.bio).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.blog).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.company).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.email).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.followers.toString()).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.following.toString()).width('100%').fontSize(16).textAlign(TextAlign.Center)
      Text(model.top_languages.join(';')).width('100%').fontSize(16).textAlign(TextAlign.Center)
    }
    .padding(16)
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
