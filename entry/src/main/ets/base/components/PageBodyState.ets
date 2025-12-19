import lottie from '@ohos/lottie';
import { PageState } from "../enums"
import { common } from '@kit.AbilityKit';
import { Links, Storage } from '../constants';
import { UserModel } from '../models';

@Component
export struct PageBodyState {
  @Require
  @Prop
  state: PageState | object | null;

  @Require
  @BuilderParam content: () => void

  @StorageLink(Storage.authCode) authCode: boolean = false;
  @StorageLink(Storage.userData) userData: UserModel | null = null;

  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings);
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext

  stateAuth: () => void = () => {}
  stateAuthLoading: () => void = () => {}
  stateLoading: () => void = () => {}
  stateError: () => void = () => {}

  build() {
    if (!this.authCode && this.userData === null) {
      Column() {
        this.bodyAuth()
      }
      .width('100%')
      .height('100%')
      .onAttach(() => {
        this.state = PageState.Loading
        this.stateAuth()
      })
    }
    else if (this.authCode && this.userData === null) {
      Column() {
        this.bodyLoading()
      }
      .width('100%')
      .height('100%')
      .onAttach(this.stateAuthLoading)
    }
    else if (this.state === PageState.Loading) {
      Column() {
        this.bodyLoading()
      }
      .width('100%')
      .height('100%')
      .onAttach(this.stateLoading)
    }
    else if (this.state === PageState.Error) {
      Column() {
        this.bodyError()
      }
      .width('100%')
      .height('100%')
      .onAttach(this.stateError)
    } else {
      Column() {
        this.content()
      }
      .width('100%')
      .height('100%')
    }
  }

  aboutToDisappear(): void {
    lottie.destroy();
  }

  @Builder
  bodyAuth() {
    Column({space: 20}) {
      Column() {
        Image($r('app.media.icon_foreground'))
          .width(160)
          .height(160)
          .fillColor($r('sys.color.font'))
      }
      .width(200)
      .height(200)
      .borderRadius(200)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.primary_light'))

      Blank().height(8)

      Text($r('app.string.PageBodyState_login_title'))
        .width('100%')
        .fontSize(36)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)

      Text($r('app.string.PageBodyState_login_text'))
        .width('100%')
        .fontSize(18)
        .padding({left: 30, right: 30})
        .textAlign(TextAlign.Center)

      Blank().height(3)

      Button($r('app.string.PageBodyState_login_btn'), { type: ButtonType.Capsule, stateEffect: true })
        .onClick(() => {
          this.context?.startAbility({
            action: 'ohos.want.action.viewData',
            entities: ['entity.system.browsable'],
            abilityName: 'MainAbility',
            uri: Links.auth_redirect(),
          })
        })
    }
    .padding(16)
    .margin({top: -20})
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  bodyLoading() {
    Column({space: 40}) {
      Column() {
        Canvas(this.canvasRenderingContext)
          .width(180)
          .height(180)
          .margin({left: -20})
          .onReady(() => {
            this.canvasRenderingContext.imageSmoothingEnabled = true;
            this.canvasRenderingContext.imageSmoothingQuality = 'medium';
            this.loadAnimation('lottie_loading.json', 2.3);
          })
      }
      .width(200)
      .height(200)
      .borderRadius(200)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.primary_light'))

      Text($r('app.string.PageBodyState_loading_text')).width('100%').fontSize(18).textAlign(TextAlign.Center)
    }
    .margin({top: -20})
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  bodyError() {
    Column({space: 40}) {
      Column() {
        Canvas(this.canvasRenderingContext)
          .width(160)
          .height(160)
          .onReady(() => {
              this.canvasRenderingContext.imageSmoothingEnabled = true;
              this.canvasRenderingContext.imageSmoothingQuality = 'medium';
              this.loadAnimation('lottie_error.json', 1);
          })
      }
      .width(200)
      .height(200)
      .borderRadius(200)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.primary_light'))

      Text($r('app.string.PageBodyState_error_text')).width('100%').fontSize(18).textAlign(TextAlign.Center)

      Blank().height(3)

      Button($r('app.string.PageBodyState_error_btn'), { type: ButtonType.Capsule, stateEffect: true })
        .onClick(() => {
          this.authCode = false;
          this.userData = null;
        })
    }
    .margin({top: -20})
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  loadAnimation(name: string, speed: number) {
    lottie.loadAnimation({
      container: this.canvasRenderingContext,
      renderer: 'canvas',
      loop: true,
      autoplay: true,
      contentMode: 'Contain',
      path: 'rawfile/' + name,
    }).setSpeed(speed)
  }
}