import { http } from '@kit.NetworkKit';
import { ChatMessage, MessageRole, ApiMessage, ChatRequestBody, AIResponse } from '../models/TravelModel';

export class TravelService {
  // ⚠️ ӨӨРИЙН GEMINI API KEY-Г ЭНД ОРУУЛААРАЙ
  private apiKey: string = "YOUR_GEMINI_API_KEY_HERE";
  private apiUrl: string = "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions";

  async generateResponse(userInput: string, history: ChatMessage[], lang: string): Promise<ChatMessage> {
    // Сонгосон хэлээс хамаарч AI-д заавар өгнө
    let systemPrompt = lang === 'zh'
      ? 'You are a travel assistant. Answer in Chinese. Keep it concise.'
      : 'You are a travel assistant. Answer in English. Keep it concise.';

    let apiMessages: ApiMessage[] = [
      new ApiMessage('system', systemPrompt)
    ];

    for (let i = 0; i < history.length; i++) {
      apiMessages.push(new ApiMessage(
        history[i].role === MessageRole.USER ? 'user' : 'assistant',
        history[i].content
      ));
    }

    apiMessages.push(new ApiMessage('user', userInput));

    let requestBody: ChatRequestBody = {
      model: 'gemini-3.6-flash',
      messages: apiMessages,
      temperature: 0.7
    };

    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.apiKey}`
      } as Record<string, string>,
      extraData: JSON.stringify(requestBody)
    };

    let httpRequest = http.createHttp();
    try {
      let response = await httpRequest.request(this.apiUrl, options);
      if (response.responseCode === 200) {
        let result: AIResponse = JSON.parse(response.result as string);
        return new ChatMessage(MessageRole.ASSISTANT, result.choices[0].message.content);
      } else {
        return new ChatMessage(MessageRole.ASSISTANT, `Error: ${response.responseCode}`);
      }
    } catch (error) {
      return new ChatMessage(MessageRole.ASSISTANT, "Sorry, a network error occurred.");
    } finally {
      httpRequest.destroy();
    }
  }
}