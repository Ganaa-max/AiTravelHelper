import { router } from '@kit.ArkUI';
import { RouterParams } from '../models/TravelModel';

@Entry
@Component
struct ExplorePage {
  @StorageLink('appLanguage') appLanguage: string = 'en';
  private destinations: string[] = ['Tokyo, Japan 🇯🇵', 'Paris, France 🇫🇷', 'Bali, Indonesia 🇮🇩', 'Switzerland 🇨🇭', 'Seoul, South Korea 🇰🇷'];

  build() {
    Column() {
      Row() {
        Text('⬅️').fontSize(24).onClick(() => { router.back(); })
        Text(this.appLanguage === 'en' ? 'Choose Destination' : '选择目的地')
          .fontSize(20).fontWeight(FontWeight.Bold).margin({ left: 15 })
      }
      .width('100%')
      .height(60)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#E5E5E5' })

      List({ space: 15 }) {
        ForEach(this.destinations, (item: string) => {
          ListItem() {
            Row() {
              Text(item).fontSize(18).fontWeight(FontWeight.Medium)
              Blank()
              Text('➔').fontSize(18).fontColor('#007DFF')
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#F8F9FA')
            .borderRadius(15)
            .onClick(() => {
              let params = new RouterParams();
              let city = item.split(',')[0];
              params.prompt = this.appLanguage === 'zh'
                ? `我想去${city}旅行。请给我一个5天的行程计划。`
                : `I want to travel to ${city}. Please give me a 5-day itinerary.`;

              router.pushUrl({
                url: 'pages/Index',
                params: params
              });
            })
          }
        }, (item: string) => item)
      }
      .padding(20)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}