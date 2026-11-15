import { router } from '@kit.ArkUI';

@Entry
@Component
struct SplashPage {
  aboutToAppear(): void {
    // Апп анх ачаалагдах үед хэлийг Англиар анхдагчаар тохируулна
    AppStorage.setOrCreate('appLanguage', 'en');

    setTimeout(() => {
      let options: router.RouterOptions = {
        url: 'pages/HomePage'
      };
      router.replaceUrl(options);
    }, 3000);
  }

  build() {
    Column() {
      Text('✈️')
        .fontSize(80)
        .margin({ bottom: 20 })

      Text('AI Travel Assistant')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#007DFF')
        .margin({ bottom: 10 })

      Text('Making your travels easier')
        .fontSize(16)
        .fontColor('#666666')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
  }
}