import { router } from '@kit.ArkUI';

@Entry
@Component
struct HomePage {
  // AppStorage-оос одоогийн хэлийг уншина
  @StorageLink('appLanguage') appLanguage: string = 'en';

  build() {
    Column() {
      // --- ХЭЛ СОНГОХ ХЭСЭГ (Дээд баруун булан) ---
      Row() {
        Blank() // Зүүн тийш түлхэх
        Row({ space: 10 }) {
          Text('EN')
            .fontSize(16)
            .fontWeight(this.appLanguage === 'en' ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.appLanguage === 'en' ? '#007DFF' : '#999999')
            .onClick(() => { this.appLanguage = 'en'; })

          Text('|').fontColor('#CCCCCC')

          Text('中文')
            .fontSize(16)
            .fontWeight(this.appLanguage === 'zh' ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.appLanguage === 'zh' ? '#007DFF' : '#999999')
            .onClick(() => { this.appLanguage = 'zh'; })
        }
      }
      .width('100%')
      .padding({ top: 50, right: 25, bottom: 20 })

      // --- ТАВТАЙ ХЭСЭГ ---
      Column() {
        Text(this.appLanguage === 'en' ? 'Hello! 👋' : '你好！👋')
          .fontSize(20)
          .fontColor('#666666')
          .width('100%')
          .textAlign(TextAlign.Start)

        Text(this.appLanguage === 'en' ? 'Where do you want to travel?' : '你想去哪里旅行？')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ top: 10, bottom: 30 })
      }
      .padding({ left: 25, right: 25, bottom: 20 })

      // 1-р товч: Чат
      Row() {
        Column() {
          Text('💬').fontSize(40).margin({ bottom: 10 })
          Text(this.appLanguage === 'en' ? 'Start Chat' : '开始聊天').fontSize(20).fontWeight(FontWeight.Bold).fontColor(Color.White)
          Text(this.appLanguage === 'en' ? 'Get AI advice' : '获取 AI 建议').fontSize(14).fontColor('#E6F0FF').margin({ top: 5 })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('90%')
      .height(140)
      .backgroundColor('#007DFF')
      .borderRadius(20)
      .padding(20)
      .onClick(() => {
        router.pushUrl({ url: 'pages/Index' });
      })
      .shadow({ radius: 15, color: '#40007DFF', offsetY: 8 })

      // 2-р товч: Бусад сонголт
      Row() {
        Column() {
          Text('🌍').fontSize(40).margin({ bottom: 10 })
          Text(this.appLanguage === 'en' ? 'Choose Destination' : '选择目的地').fontSize(20).fontWeight(FontWeight.Bold).fontColor('#333333')
          Text(this.appLanguage === 'en' ? 'Popular places list' : '热门地点列表').fontSize(14).fontColor('#666666').margin({ top: 5 })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('90%')
      .height(140)
      .backgroundColor('#F5F7FA')
      .borderRadius(20)
      .padding(20)
      .margin({ top: 20 })
      .onClick(() => {
        router.pushUrl({ url: 'pages/ExplorePage' });
      })
      .shadow({ radius: 15, color: '#20000000', offsetY: 8 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}