export enum MessageRole {
  USER = 'user',
  ASSISTANT = 'assistant'
}

export class ChatMessage {
  role: MessageRole;
  content: string;
  timestamp: number;

  constructor(role: MessageRole, content: string) {
    this.role = role;
    this.content = content;
    this.timestamp = Date.now();
  }
}

export class ApiMessage {
  role: string;
  content: string;

  constructor(role: string, content: string) {
    this.role = role;
    this.content = content;
  }
}

export interface ChatRequestBody {
  model: string;
  messages: ApiMessage[];
  temperature: number;
}

export interface AIMessage {
  role: string;
  content: string;
}

export interface AIChoice {
  message: AIMessage;
}

export interface AIResponse {
  choices: AIChoice[];
}

export class RouterParams {
  prompt: string = '';
}