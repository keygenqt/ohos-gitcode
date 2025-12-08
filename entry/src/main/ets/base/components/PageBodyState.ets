import lottie from '@ohos/lottie';
import { PageState } from "../enums"

@Component
export struct PageBodyState {
  @Require
  @Prop
  state: PageState | object;

  @Require
  @BuilderParam content: () => void

  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings);

  build() {
    if (this.state === PageState.Loading) {
      this.bodyLoading()
    }
    else if (this.state === PageState.ErrorNetwork) {
      this.bodyErrorNetwork()
    } else {
      this.content()
    }
  }

  aboutToDisappear(): void {
    lottie.destroy();
  }

  @Builder
  bodyLoading() {
    Column({space: 20}) {
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

      Text($r('app.string.body_loading')).width('100%').fontSize(18).textAlign(TextAlign.Center)
    }
    .margin({top: -40})
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  bodyErrorNetwork() {
    Column({space: 20}) {
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

      Text($r('app.string.body_internet_error')).width('100%').fontSize(18).textAlign(TextAlign.Center)
    }
    .margin({top: -40})
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