{*******************************************************************************
  AI Providers - Implementations for different AI API providers
  Supports OpenAI, Anthropic, and Local (Ollama, LM Studio) providers
*******************************************************************************}
unit AIProviders;

interface

uses
  System.Classes, System.SysUtils, System.JSON, AIService, WinInetHTTPClient, System.Generics.Collections;

type
  // OpenAI-compatible provider (OpenAI, Groq, DeepSeek, OpenRouter, etc.)
  TOpenAIProvider = class(TCustomAIProvider)
  protected
    function BuildRequestBody(const AMessages: TStringList): string; override;
    function ParseResponse(const AResponse: string): TAIResponse; override;
    function GetDefaultHeaders: TStrings; override;
  public
    constructor Create(const AConfig: TAIServiceConfig; AWinHTTP: TWinInetHTTPClient);
  end;

  // Anthropic Claude provider
  TAnthropicProvider = class(TCustomAIProvider)
  private
    function ConvertMessagesToAnthropic(const AMessages: TStringList;
      out ASystem: string; out AUserMessages: TStringList): Boolean;
  protected
    function BuildRequestBody(const AMessages: TStringList): string; override;
    function ParseResponse(const AResponse: string): TAIResponse; override;
    function GetDefaultHeaders: TStrings; override;
  public
    constructor Create(const AConfig: TAIServiceConfig; AWinHTTP: TWinInetHTTPClient);
  end;

// Factory functions for creating providers (used by AIService)
function CreateOpenAIProvider(const AConfig: TAIServiceConfig; AWinHTTP: TWinInetHTTPClient): TCustomAIProvider;
function CreateAnthropicProvider(const AConfig: TAIServiceConfig; AWinHTTP: TWinInetHTTPClient): TCustomAIProvider;

implementation

{ TOpenAIProvider }

constructor TOpenAIProvider.Create(const AConfig: TAIServiceConfig; AWinHTTP: TWinInetHTTPClient);
begin
  inherited Create(AConfig, AWinHTTP);
end;

function TOpenAIProvider.GetDefaultHeaders: TStrings;
begin
  Result := TStringList.Create;
  Result.Add('Content-Type=application/json');

  // Add API key header if provided
  if FConfig.APIKey <> '' then
    Result.Add('Authorization=Bearer ' + FConfig.APIKey);

  // Some providers need additional headers
  if Pos('groq.com', FConfig.Endpoint) > 0 then
    ; // Groq uses standard Authorization header

  if Pos('deepseek.com', FConfig.Endpoint) > 0 then
    ; // DeepSeek uses standard Authorization header

  if Pos('openrouter.ai', FConfig.Endpoint) > 0 then
  begin
    // OpenRouter supports optional headers for ranking
    // Result.Add('HTTP-Referer=sqlite-manager');
    // Result.Add('X-Title=SQLite Manager');
  end;
end;

function TOpenAIProvider.BuildRequestBody(const AMessages: TStringList): string;
var
  JSON: TJSONObject;
  MessagesArray: TJSONArray;
  I: Integer;
  MessageObj: TJSONObject;
  Role, Content: string;
  SeparatorPos: Integer;
begin
  Result := '';

  if not Assigned(AMessages) or (AMessages.Count = 0) then
    Exit;

  JSON := TJSONObject.Create;
  try
    // Add model
    JSON.AddPair('model', FConfig.Model);

    // Add messages
    MessagesArray := TJSONArray.Create;
    try
      for I := 0 to AMessages.Count - 1 do
      begin
        // Parse message format: "role:content"
        SeparatorPos := Pos(':', AMessages[I]);
        if SeparatorPos > 0 then
        begin
          Role := Trim(Copy(AMessages[I], 1, SeparatorPos - 1));
          Content := Trim(Copy(AMessages[I], SeparatorPos + 1, MaxInt));
        end
        else
        begin
          Role := 'user';
          Content := AMessages[I];
        end;

        MessageObj := TJSONObject.Create;
        MessageObj.AddPair('role', Role);
        MessageObj.AddPair('content', Content);
        MessagesArray.AddElement(MessageObj);
      end;
      JSON.AddPair('messages', MessagesArray);
    except
      MessagesArray.Free;
      raise;
    end;

    // Add max_tokens
    //JSON.AddPair('max_tokens', TJSONNumber.Create(FConfig.MaxTokens));

    // Add temperature
    //JSON.AddPair('temperature', TJSONNumber.Create(FConfig.Temperature));

    // Add stream=false (we want synchronous response)
    //JSON.AddPair('stream', TJSONNumber.Create(0));

    Result := JSON.ToJSON;
  finally
    JSON.Free;
  end;
end;

function TOpenAIProvider.ParseResponse(const AResponse: string): TAIResponse;
var
  JSON: TJSONObject;
  Choices: TJSONArray;
  FirstChoice: TJSONObject;
  MessageObj: TJSONObject;
  UsageObj: TJSONObject;
  ErrorPair: TJSONPair;
  MsgPair: TJSONPair;
begin
  Result.Success := False;
  Result.Content := '';
  Result.ErrorMessage := '';
  Result.RawResponse := AResponse;

  try
    JSON := TJSONObject.ParseJSONValue(AResponse) as TJSONObject;
    try
      if not Assigned(JSON) then
      begin
        Result.ErrorMessage := 'Invalid JSON response';
        Exit;
      end;

      // Check for error
      ErrorPair := JSON.Get('error');
      if Assigned(ErrorPair) and (ErrorPair.JsonValue is TJSONObject) then
      begin
        MsgPair := TJSONObject(ErrorPair.JsonValue).Get('message');
        if Assigned(MsgPair) then
          Result.ErrorMessage := MsgPair.JsonString.Value
        else
          Result.ErrorMessage := 'API Error';
        Exit;
      end;

      // Get choices
      var ChoicesPair := JSON.Get('choices');
      if not Assigned(ChoicesPair) or not Assigned(ChoicesPair.JsonValue) then
      begin
        Result.ErrorMessage := 'No choices in response';
        Exit;
      end;
      Choices := ChoicesPair.JsonValue as TJSONArray;
      if not Assigned(Choices) or (Choices.Count = 0) then
      begin
        Result.ErrorMessage := 'No choices in response';
        Exit;
      end;

      // Get first choice
      FirstChoice := Choices.Items[0] as TJSONObject;
      if not Assigned(FirstChoice) then
      begin
        Result.ErrorMessage := 'Invalid choice format';
        Exit;
      end;

      // Get message content
      var MessagePair := FirstChoice.Get('message');
      if not Assigned(MessagePair) or not Assigned(MessagePair.JsonValue) then
      begin
        Result.ErrorMessage := 'No message in response';
        Exit;
      end;
      MessageObj := MessagePair.JsonValue as TJSONObject;
      if Assigned(MessageObj) then
      begin
        var ContentPair := MessageObj.Get('content');
        if Assigned(ContentPair) and Assigned(ContentPair.JsonValue) then
        begin
          Result.Content := ContentPair.JsonValue.Value;
          Result.Success := True;
        end
        else
        begin
          Result.ErrorMessage := 'No content in message';
        end;
      end
      else
      begin
        Result.ErrorMessage := 'No message in response';
        Exit;
      end;

      // Get usage statistics
      UsageObj := JSON.Get('usage').JsonValue as TJSONObject;
      if Assigned(UsageObj) then
      begin
        Result.Usage.PromptTokens := (UsageObj.Get('prompt_tokens').JsonValue as TJSONNumber).AsInt;
        Result.Usage.CompletionTokens := (UsageObj.Get('completion_tokens').JsonValue as TJSONNumber).AsInt;
        Result.Usage.TotalTokens := (UsageObj.Get('total_tokens').JsonValue as TJSONNumber).AsInt;
      end;

    finally
      JSON.Free;
    end;
  except
    on E: Exception do
    begin
      Result.Success := False;
      Result.ErrorMessage := 'Parse error: ' + E.Message;
    end;
  end;
end;

{ TAnthropicProvider }

constructor TAnthropicProvider.Create(const AConfig: TAIServiceConfig; AWinHTTP: TWinInetHTTPClient);
begin
  inherited Create(AConfig, AWinHTTP);
end;

function TAnthropicProvider.GetDefaultHeaders: TStrings;
begin
  Result := TStringList.Create;
  Result.Add('Content-Type=application/json');

  // Anthropic requires API key in header
  if FConfig.APIKey <> '' then
  begin
    Result.Add('x-api-key=' + FConfig.APIKey);
    Result.Add('anthropic-version=2023-06-01');
  end;
end;

function TAnthropicProvider.ConvertMessagesToAnthropic(const AMessages: TStringList;
  out ASystem: string; out AUserMessages: TStringList): Boolean;
var
  I: Integer;
  Role, Content: string;
  SeparatorPos: Integer;
begin
  ASystem := '';
  AUserMessages := TStringList.Create;

  for I := 0 to AMessages.Count - 1 do
  begin
    // Parse message format: "role:content"
    SeparatorPos := Pos(':', AMessages[I]);
    if SeparatorPos > 0 then
    begin
      Role := Trim(Copy(AMessages[I], 1, SeparatorPos - 1));
      Content := Trim(Copy(AMessages[I], SeparatorPos + 1, MaxInt));
    end
    else
    begin
      Role := 'user';
      Content := AMessages[I];
    end;

    if SameText(Role, 'system') then
    begin
      if ASystem = '' then
        ASystem := Content
      else
        ASystem := ASystem + sLineBreak + Content;
    end
    else if SameText(Role, 'user') then
    begin
      AUserMessages.Add(Content);
    end
    else if SameText(Role, 'assistant') then
    begin
      // Anthropic doesn't support assistant messages in simple API
      // We'll skip them or could add to user messages with prefix
      AUserMessages.Add('Assistant previously said: ' + Content);
    end;
  end;

  Result := True;
end;

function TAnthropicProvider.BuildRequestBody(const AMessages: TStringList): string;
var
  JSON: TJSONObject;
  MessagesArray: TJSONArray;
  MessageObj: TJSONObject;
  SystemPrompt: string;
  UserMessages: TStringList;
  I: Integer;
begin
  JSON := TJSONObject.Create;
  UserMessages := TStringList.Create;
  try
    // Convert messages to Anthropic format
    ConvertMessagesToAnthropic(AMessages, SystemPrompt, UserMessages);

    // Add model
    JSON.AddPair('model', FConfig.Model);

    // Add system prompt if present
    if SystemPrompt <> '' then
      JSON.AddPair('system', SystemPrompt);

    // Add messages (user messages only for simple API)
    MessagesArray := TJSONArray.Create;
    for I := 0 to UserMessages.Count - 1 do
    begin
      MessageObj := TJSONObject.Create;
      MessageObj.AddPair('role', 'user');

      // Content as array of content blocks
      var ContentArray := TJSONArray.Create;
      var ContentBlock := TJSONObject.Create;
      ContentBlock.AddPair('type', 'text');
      ContentBlock.AddPair('text', UserMessages[I]);
      ContentArray.AddElement(ContentBlock);

      MessageObj.AddPair('content', ContentArray);
      MessagesArray.AddElement(MessageObj);
    end;
    JSON.AddPair('messages', MessagesArray);

    // Add max_tokens (required for Anthropic)
    JSON.AddPair('max_tokens', TJSONNumber.Create(FConfig.MaxTokens));

    // Add temperature
    JSON.AddPair('temperature', TJSONNumber.Create(FConfig.Temperature));

    Result := JSON.ToJSON;
  finally
    JSON.Free;
    UserMessages.Free;
  end;
end;

function TAnthropicProvider.ParseResponse(const AResponse: string): TAIResponse;
var
  JSON: TJSONObject;
  ContentArray: TJSONArray;
  I: Integer;
  ContentBlock: TJSONObject;
  ErrorPair2: TJSONPair;
  UsageObj: TJSONObject;
begin
  Result.Success := False;
  Result.Content := '';
  Result.ErrorMessage := '';
  Result.RawResponse := AResponse;

  try
    JSON := TJSONObject.ParseJSONValue(AResponse) as TJSONObject;
    try
      if not Assigned(JSON) then
      begin
        Result.ErrorMessage := 'Invalid JSON response';
        Exit;
      end;

      // Check for error
      ErrorPair2 := JSON.Get('error');
      if Assigned(ErrorPair2) and (ErrorPair2.JsonValue is TJSONObject) then
      begin
        Result.ErrorMessage := TJSONObject(ErrorPair2.JsonValue).Get('message').JsonValue.Value;
        Exit;
      end;

      // Get content array
      ContentArray := JSON.Get('content').JsonValue as TJSONArray;
      if Assigned(ContentArray) then
      begin
        for I := 0 to ContentArray.Count - 1 do
        begin
          ContentBlock := ContentArray.Items[I] as TJSONObject;
          if Assigned(ContentBlock) and (ContentBlock.Get('type').JsonValue.Value = 'text') then
          begin
            Result.Content := Result.Content + ContentBlock.Get('text').JsonValue.Value;
          end;
        end;
        Result.Success := Result.Content <> '';
      end;

      if not Result.Success then
      begin
        Result.ErrorMessage := 'No content in response';
        Exit;
      end;

      // Get usage statistics
      UsageObj := JSON.Get('usage').JsonValue as TJSONObject;
      if Assigned(UsageObj) then
      begin
        Result.Usage.PromptTokens := (UsageObj.Get('input_tokens').JsonValue as TJSONNumber).AsInt;
        Result.Usage.CompletionTokens := (UsageObj.Get('output_tokens').JsonValue as TJSONNumber).AsInt;
        Result.Usage.TotalTokens := Result.Usage.PromptTokens + Result.Usage.CompletionTokens;
      end;

    finally
      JSON.Free;
    end;
  except
    on E: Exception do
    begin
      Result.Success := False;
      Result.ErrorMessage := 'Parse error: ' + E.Message;
    end;
  end;
end;

{ Factory functions }

function CreateOpenAIProvider(const AConfig: TAIServiceConfig; AWinHTTP: TWinInetHTTPClient): TCustomAIProvider;
begin
  Result := TOpenAIProvider.Create(AConfig, AWinHTTP);
end;

function CreateAnthropicProvider(const AConfig: TAIServiceConfig; AWinHTTP: TWinInetHTTPClient): TCustomAIProvider;
begin
  Result := TAnthropicProvider.Create(AConfig, AWinHTTP);
end;

end.
