import { ChatMessage, MessageRole, RouterParams } from '../models/TravelModel';
import { TravelService } from '../services/TravelService';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @StorageLink('appLanguage') appLanguage: string = 'en';

  @State messages: ChatMessage[] = [
    new ChatMessage(MessageRole.ASSISTANT, "Hello! I am your AI Travel Assistant. Where are you planning to go?")
  ];

  @State inputText: string = '';
  @State isLoading: boolean = false;

  private scroller: Scroller = new Scroller();
  private travelService: TravelService = new TravelService();

  aboutToAppear(): void {
    const params = router.getParams() as RouterParams;
    if (params && params.prompt) {
      let promptStr = params.prompt;
      setTimeout(() => {
        this.sendMessage(promptStr);
      }, 500);
    }
  }

  async sendMessage(textToSend?: string): Promise<void> {
    const text = textToSend ? textToSend : this.inputText.trim();
    if (text === '' || this.isLoading) return;

    this.messages.push(new ChatMessage(MessageRole.USER, text));
    this.inputText = '';
    this.isLoading = true;
    this.scrollToBottom();

    try {
      // AI руу хэлний мэдээллийг дамжуулж байна
      const aiReply = await this.travelService.generateResponse(text, this.messages, this.appLanguage);
      this.messages.push(aiReply);
      this.scrollToBottom();
    } catch (error) {
      console.error('AI error: ' + JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  scrollToBottom(): void {
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);
  }

  @Builder
  promptChip(label: string, action: () => void) {
    Text(label)
      .padding({ left: 15, right: 15, top: 8, bottom: 8 })
      .backgroundColor('#E6F0FF')
      .fontColor('#007DFF')
      .fontSize(14)
      .borderRadius(20)
      .onClick(action)
  }

  build() {
    Column() {
      Row() {
        Text('⬅️')
          .fontSize(24)
          .margin({ right: 15 })
          .onClick(() => { router.back(); })

        Text(this.appLanguage === 'en' ? '✈️ AI Travel Assistant' : '✈️ AI 旅行助手')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width('100%')
      .height(60)
      .backgroundColor('#007DFF')
      .justifyContent(FlexAlign.Start)
      .padding({ left: 20, top: 20 })

      List({ space: 15, scroller: this.scroller }) {
        ForEach(this.messages, (msg: ChatMessage) => {
          ListItem() {
            Row() {
              if (msg.role === MessageRole.ASSISTANT) {
                Text('🤖').fontSize(24).margin({ right: 10 })
              }

              Column() {
                Text(msg.content)
                  .padding(12)
                  .fontSize(16)
                  .fontColor(msg.role === MessageRole.USER ? Color.White : Color.Black)
                  .backgroundColor(msg.role === MessageRole.USER ? '#007DFF' : '#F1F3F5')
                  .borderRadius(15)
                  .constraintSize({ maxWidth: '75%' })
                  .textAlign(TextAlign.Start)

                Text(new Date(msg.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }))
                  .fontSize(10)
                  .fontColor('#999999')
                  .margin({ top: 5 })
              }
              .alignItems(msg.role === MessageRole.USER ? HorizontalAlign.End : HorizontalAlign.Start)

              if (msg.role === MessageRole.USER) {
                Text('👤').fontSize(24).margin({ left: 10 })
              }
            }
            .width('100%')
            .justifyContent(msg.role === MessageRole.USER ? FlexAlign.End : FlexAlign.Start)
          }
        }, (msg: ChatMessage) => msg.timestamp.toString())

        if (this.isLoading) {
          ListItem() {
            Row() {
              Text('🤖').fontSize(24).margin({ right: 10 })
              Text(this.appLanguage === 'en' ? 'Thinking...' : '思考中...')
                .padding(12)
                .fontSize(16)
                .fontColor('#888888')
                .backgroundColor('#F1F3F5')
                .borderRadius(15)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
          }
        }
      }
      .layoutWeight(1)
      .padding(15)
      .width('100%')

      if (this.messages.length < 3) {
        Scroll() {
          Row({ space: 10 }) {
            this.promptChip(this.appLanguage === 'en' ? 'Tokyo 5 days' : '东京 5天', () => {
              this.sendMessage(this.appLanguage === 'en' ? 'Plan a 5-day trip to Tokyo' : '规划一个5天的东京之旅')
            })
            this.promptChip(this.appLanguage === 'en' ? 'Cheap travel' : '便宜的旅行', () => {
              this.sendMessage(this.appLanguage === 'en' ? 'Give me 5 tips for cheap travel' : '给我5个便宜旅行的建议')
            })
            this.promptChip(this.appLanguage === 'en' ? 'Calculate budget' : '计算预算', () => {
              this.sendMessage(this.appLanguage === 'en' ? 'How to calculate travel budget?' : '如何计算旅行预算？')
            })
          }
          .padding({ left: 15, right: 15, bottom: 10 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
      }

      Row() {
        TextInput({ placeholder: this.appLanguage === 'en' ? 'Ask about travel...' : '询问关于旅行...', text: this.inputText })
          .layoutWeight(1)
          .height(45)
          .backgroundColor('#F1F3F5')
          .borderRadius(20)
          .padding({ left: 15, right: 15 })
          .enabled(!this.isLoading)
          .onChange((value: string) => { this.inputText = value; })
          .onSubmit(() => { this.sendMessage(); })

        Button(this.isLoading ? '...' : (this.appLanguage === 'en' ? 'Send' : '发送'))
          .height(45)
          .margin({ left: 10 })
          .backgroundColor(this.isLoading ? '#A0CFFF' : '#007DFF')
          .fontColor(Color.White)
          .borderRadius(20)
          .enabled(!this.isLoading)
          .onClick(() => { this.sendMessage(); })
      }
      .width('100%')
      .padding(10)
      .backgroundColor(Color.White)
      .border({ width: { top: 1 }, color: '#E5E5E5' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}