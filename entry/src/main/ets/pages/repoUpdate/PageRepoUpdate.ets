import { rcp } from '@kit.RemoteCommunicationKit';
import { Links, Storage } from '../../base/constants';
import { RepoModel } from '../../base/models';

@Component
export struct PageRepoUpdate {
  @Consume('navStack') navStack: NavPathStack;

  @StorageLink(Storage.reposData) reposData: [RepoModel] | null = null;
  @StorageLink(Storage.repoData) repoData: RepoModel | null = null;

  @State isSuccess: boolean | null = null;
  @State isSubmit: boolean = false;
  @State timeout: number | null = null;

  @State isPublic: boolean = !this.repoData?.private ?? false;
  @State homepage: string = this.repoData?.homepage ?? '';
  @State description: string = this.repoData?.description ?? '';

  build() {
    NavDestination() {
      this.bodyModel()
    }.title($r('app.string.PageRepoUpdate_title')).onBackPressed(() => {
      this.navStack.pop();
      return true;
    })
  }

  updateRepoSettings() {
    this.isSubmit = true;
    this.isSuccess = null;
    clearTimeout(this.timeout);
    // @todo axios {"code":401,"message":"Parameter error"} https://gitcode.com/openharmony-sig/ohos_axios/issues/361
    rcp.createSession()
      .fetch(new rcp.Request(
        Links.repo_update(this.repoData?.path),
        'PATCH',
        { "Content-Type": "application/json" },
        {
          name: this.repoData?.name,
          description: this.description,
          homepage: this.homepage,
          private: !this.isPublic,
        }
      ))
      .then((response: rcp.Response) => {
        if (response.statusCode == 200) {
          this.isSubmit = false;
          this.isSuccess = true;
          this.timeout = setTimeout(() => this.isSuccess = null, 2000);
          if (this.repoData != null) {
            // Update state repo
            this.repoData.description = this.description;
            this.repoData.homepage = this.homepage;
            this.repoData.private = !this.isPublic;
            // Update state list
            if (this.reposData != null) {
              this.reposData.reverse(); // @todo data not reload without
              const index = this.reposData?.findIndex((e: RepoModel) => e.id == this.repoData?.id) ?? -1;
              if (index >= 0) {
                this.reposData[index] = this.repoData;
              }
              this.reposData.reverse();
            }
          }
        } else {
          this.isSubmit = false;
          this.isSuccess = false;
          this.timeout = setTimeout(() => this.isSuccess = null, 2000);
        }
      })
      .catch((_: Error) => {
          this.isSubmit = false;
          this.isSuccess = false;
          this.timeout = setTimeout(() => this.isSuccess = null, 2000);
      });
  }

  formIsValid(): boolean {
    return this.homepage.length != 0
  }

  @Builder
  bodyModel() {
    Scroll() {
      Column({ space: 24 }) {
        if (this.isSuccess != null) {
          if (this.isSuccess) {
            Text($r('app.string.PageRepoUpdate_success'))
              .width('100%')
              .padding(16)
              .fontSize(16)
              .borderWidth(1)
              .borderRadius($r('app.float.card_radius'))
              .fontColor($r('app.color.form_success_main'))
              .borderColor($r('app.color.form_success_main'))
              .backgroundColor($r('app.color.form_success_background'))
              .textAlign(TextAlign.Start)
          } else {
            Text($r('app.string.PageRepoUpdate_error'))
              .width('100%')
              .padding(16)
              .fontSize(16)
              .borderWidth(1)
              .borderRadius($r('app.float.card_radius'))
              .fontColor($r('app.color.form_error_main'))
              .borderColor($r('app.color.form_error_main'))
              .backgroundColor($r('app.color.form_error_background'))
              .textAlign(TextAlign.Start)
          }
        }

        Column({ space: 10 }) {
          Text($r('app.string.PageRepoUpdate_homepage_label')).fontSize(16).margin({left: 10})
          TextInput({
            text: this.homepage,
            placeholder: $r('app.string.PageRepoUpdate_homepage_placeholder')
          })
            .width('100%')
            .enabled(!this.isSubmit)
            .onChange((value: string) => this.homepage = value)
            .showError(this.homepage.length == 0 ? $r('app.string.form_input_error_required') : null)
        }
        .alignItems(HorizontalAlign.Start)

        Column({ space: 10 }) {
          Text($r('app.string.PageRepoUpdate_description_label')).fontSize(16).margin({left: 10})
          TextArea({
            text: this.description,
            placeholder: $r('app.string.PageRepoUpdate_description_placeholder')
          })
            .width('100%')
            .enabled(!this.isSubmit)
            .onChange((value: string) => this.description = value)
        }
        .alignItems(HorizontalAlign.Start)

        Row() {
          Text($r('app.string.PageRepoUpdate_state_public')).fontSize(16).margin({left: 10})
          Toggle({ type: ToggleType.Switch, isOn: this.isPublic })
            .enabled(!this.isSubmit)
            .onChange((isOn: boolean) => this.isPublic = isOn)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Row({space: 8}) {
            LoadingProgress()
              .width(24)
              .height(24)
              .color(Color.White)
              .visibility(this.isSubmit ? Visibility.Visible : Visibility.None)
            Text($r('app.string.PageRepoUpdate_btn_submit'))
              .fontSize(18)
              .fontColor(Color.White)
          }.alignItems(VerticalAlign.Center)
        }
        .enabled(!this.isSubmit && this.formIsValid())
        .width('100%')
        .padding(8)
        .borderRadius($r('app.float.card_radius'))
        .onClick(() => {
          this.updateRepoSettings()
        })
      }
      .padding(16)
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
  }
}
