{*******************************************************************************
  AI Service - Base classes for AI integration
  Provides HTTP client and base classes for AI providers
*******************************************************************************}
unit AIService;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.IniFiles, System.Generics.Collections, System.Math, System.StrUtils, WinInetHTTPClient, Win.Registry, Winapi.Windows;

type
  // AI Provider types
  TAIProviderType = (aptOpenAI, aptAnthropic, aptLocal);

  // AI Service configuration
  TAIServiceConfig = record
    Provider: TAIProviderType;
    ProviderName: string;       // Display name: "OpenAI", "Claude", "Ollama"
    APIKey: string;
    Endpoint: string;
    Model: string;
    Timeout: Integer;           // milliseconds
    MaxTokens: Integer;
    Temperature: Double;
    UseSSL: Boolean;
    ProxyHost: string;
    ProxyPort: Integer;
    Enabled: Boolean;
  end;

  // AI Response
  TAIResponse = record
    Success: Boolean;
    Content: string;
    ErrorMessage: string;
    RawResponse: string;        // For debugging
    Usage: record
      PromptTokens: Integer;
      CompletionTokens: Integer;
      TotalTokens: Integer;
    end;
  end;

  // Forward declaration
  TCustomAIProvider = class;

  // Base AI Service class
  TAIService = class
  private
    FConfig: TAIServiceConfig;
    FHTTPClient: TWinInetHTTPClient;
    FCurrentProvider: TCustomAIProvider;
    FOnLog: TNotifyEvent;
    procedure Log(const AMessage: string);
  protected
    function CreateProvider: TCustomAIProvider;
    property CurrentProvider: TCustomAIProvider read FCurrentProvider;
  public
    constructor Create(const AConfig: TAIServiceConfig);
    destructor Destroy; override;

    // Main API methods
    function ChatComplete(const AMessages: TStringList): TAIResponse;
    function FormatSQL(const ASQL: string): TAIResponse;
    function ExplainError(const ASQL: string; AError: string): TAIResponse;
    function ExplainQuery(const ASQL: string): TAIResponse;
    function GenerateQuery(const ADescription: string): TAIResponse;
    function OptimizeSQL(const ASQL: string): TAIResponse;
    function SearchQueries(const ADescription: string; AHistory: TStringList): TAIResponse;
    
    // Public method to build request body (for debugging)
    function BuildRequestBodyForTest(const AMessages: TStringList): string;

    // Configuration
    procedure LoadFromRegistry(const ARoot: THandle; const AKey: string);
    procedure SaveToRegistry(const ARoot: THandle; const AKey: string);
    function IsConfigured: Boolean;

    property Config: TAIServiceConfig read FConfig write FConfig;
    property OnLog: TNotifyEvent read FOnLog write FOnLog;
  end;

  // Base provider class
  TCustomAIProvider = class
  protected
    FConfig: TAIServiceConfig;
    FHTTPClient: TWinInetHTTPClient;
    function BuildRequestBody(const AMessages: TStringList): string; virtual; abstract;
    function ParseResponse(const AResponse: string): TAIResponse; virtual; abstract;
    function GetDefaultHeaders: TStrings; virtual;
  public
    constructor Create(const AConfig: TAIServiceConfig; AHTTPClient: TWinInetHTTPClient);
    function ChatComplete(const AMessages: TStringList): TAIResponse; virtual;
    property Config: TAIServiceConfig read FConfig;
  end;

  // Predefined service configurations
  TAIServicePreset = record
    Name: string;
    Provider: TAIProviderType;
    Endpoint: string;
    Model: string;
    DefaultModel: string;
    Website: string;
    Description: string;
    RequiresAPIKey: Boolean;
  end;

  // Service presets registry
  TAIServicePresets = class
  public
    class function GetPresets: TArray<TAIServicePreset>; static;
    class function GetPresetByName(const AName: string): TAIServicePreset; static;
    class function GetProviderTypes: TArray<string>; static;
    class function ProviderTypeToStr(AType: TAIProviderType): string; static;
    class function StrToProviderType(const AStr: string): TAIProviderType; static;
  end;

implementation

uses
  IdURI, AIProviders;

{ TAIServicePresets }

class function TAIServicePresets.GetPresets: TArray<TAIServicePreset>;
begin
  SetLength(Result, 15);

  // OpenAI
  Result[0].Name := 'OpenAI';
  Result[0].Provider := aptOpenAI;
  Result[0].Endpoint := 'https://api.openai.com/v1/chat/completions';
  Result[0].Model := 'gpt-4o-mini';
  Result[0].DefaultModel := 'gpt-4o-mini';
  Result[0].Website := 'https://platform.openai.com/api-keys';
  Result[0].Description := 'Official OpenAI API (GPT-4, GPT-3.5)';
  Result[0].RequiresAPIKey := True;

  // OpenRouter - ��������� �������
  Result[1].Name := 'OpenRouter';
  Result[1].Provider := aptOpenAI;
  Result[1].Endpoint := 'https://openrouter.ai/api/v1/chat/completions';
  Result[1].Model := 'openai/gpt-4o-mini';
  Result[1].DefaultModel := 'openai/gpt-4o-mini';
  Result[1].Website := 'https://openrouter.ai/keys';
  Result[1].Description := '������ � 100+ ������� (OpenAI, Anthropic, Meta, Google)';
  Result[1].RequiresAPIKey := True;

  // Groq - ������� �������� ������
  Result[2].Name := 'Groq';
  Result[2].Provider := aptOpenAI;
  Result[2].Endpoint := 'https://api.groq.com/openai/v1/chat/completions';
  Result[2].Model := 'llama-3.3-70b-versatile';
  Result[2].DefaultModel := 'llama-3.3-70b-versatile';
  Result[2].Website := 'https://console.groq.com/keys';
  Result[2].Description := '����� ������� �������� ������ (Llama, Mixtral)';
  Result[2].RequiresAPIKey := True;

  // DeepSeek
  Result[3].Name := 'DeepSeek';
  Result[3].Provider := aptOpenAI;
  Result[3].Endpoint := 'https://api.deepseek.com/chat/completions';
  Result[3].Model := 'deepseek-chat';
  Result[3].DefaultModel := 'deepseek-chat';
  Result[3].Website := 'https://platform.deepseek.com/api_keys';
  Result[3].Description := '��������� ������, ������ ��� ����';
  Result[3].RequiresAPIKey := True;

  // Together AI
  Result[4].Name := 'Together AI';
  Result[4].Provider := aptOpenAI;
  Result[4].Endpoint := 'https://api.together.xyz/v1/chat/completions';
  Result[4].Model := 'meta-llama/Llama-3.3-70B-Instruct-Turbo';
  Result[4].DefaultModel := 'meta-llama/Llama-3.3-70B-Instruct-Turbo';
  Result[4].Website := 'https://api.together.xyz/settings/api-keys';
  Result[4].Description := '�������� ������ � ����������';
  Result[4].RequiresAPIKey := True;

  // Perplexity
  Result[5].Name := 'Perplexity';
  Result[5].Provider := aptOpenAI;
  Result[5].Endpoint := 'https://api.perplexity.ai/chat/completions';
  Result[5].Model := 'llama-3.1-sonar-small-128k-online';
  Result[5].DefaultModel := 'llama-3.1-sonar-small-128k-online';
  Result[5].Website := 'https://www.perplexity.ai/settings/api';
  Result[5].Description := '��������� LLM � �������� � ��������';
  Result[5].RequiresAPIKey := True;

  // Fireworks AI
  Result[6].Name := 'Fireworks AI';
  Result[6].Provider := aptOpenAI;
  Result[6].Endpoint := 'https://api.fireworks.ai/inference/v1/chat/completions';
  Result[6].Model := 'accounts/fireworks/models/llama-v3p1-70b-instruct';
  Result[6].DefaultModel := 'accounts/fireworks/models/llama-v3p1-70b-instruct';
  Result[6].Website := 'https://fireworks.ai/api-keys';
  Result[6].Description := '������� �������� ������';
  Result[6].RequiresAPIKey := True;

  // Cerebras
  Result[7].Name := 'Cerebras';
  Result[7].Provider := aptOpenAI;
  Result[7].Endpoint := 'https://api.cerebras.ai/v1/chat/completions';
  Result[7].Model := 'llama3.1-8b';
  Result[7].DefaultModel := 'llama3.1-8b';
  Result[7].Website := 'https://cloud.cerebras.ai/';
  Result[7].Description := '������������ ��������-����';
  Result[7].RequiresAPIKey := True;

  // Anthropic Claude
  Result[8].Name := 'Anthropic (Claude)';
  Result[8].Provider := aptAnthropic;
  Result[8].Endpoint := 'https://api.anthropic.com/v1/messages';
  Result[8].Model := 'claude-3-haiku-20240307';
  Result[8].DefaultModel := 'claude-3-haiku-20240307';
  Result[8].Website := 'https://console.anthropic.com/settings/keys';
  Result[8].Description := 'Claude 3 Haiku/Sonnet/Opus';
  Result[8].RequiresAPIKey := True;

  // Ollama (��������)
  Result[9].Name := 'Ollama (Local)';
  Result[9].Provider := aptLocal;
  Result[9].Endpoint := 'http://localhost:11434/v1/chat/completions';
  Result[9].Model := 'llama3.2';
  Result[9].DefaultModel := 'llama3.2';
  Result[9].Website := 'https://ollama.ai';
  Result[9].Description := '��������� ������ (Llama, Codellama, SQLCoder)';
  Result[9].RequiresAPIKey := False;

  // LM Studio (��������)
  Result[10].Name := 'LM Studio (Local)';
  Result[10].Provider := aptLocal;
  Result[10].Endpoint := 'http://localhost:1234/v1/chat/completions';
  Result[10].Model := 'local-model';
  Result[10].DefaultModel := 'local-model';
  Result[10].Website := 'https://lmstudio.ai';
  Result[10].Description := '��������� ������ ��� GGUF �������';
  Result[10].RequiresAPIKey := False;

  // Jan (��������)
  Result[11].Name := 'Jan (Local)';
  Result[11].Provider := aptLocal;
  Result[11].Endpoint := 'http://localhost:1337/v1/chat/completions';
  Result[11].Model := 'local-model';
  Result[11].DefaultModel := 'local-model';
  Result[11].Website := 'https://jan.ai';
  Result[11].Description := '��������� AI-������';
  Result[11].RequiresAPIKey := False;

  // vLLM (��������)
  Result[12].Name := 'vLLM (Local)';
  Result[12].Provider := aptLocal;
  Result[12].Endpoint := 'http://localhost:8000/v1/chat/completions';
  Result[12].Model := 'facebook/opt-125m';
  Result[12].DefaultModel := 'facebook/opt-125m';
  Result[12].Website := 'https://vllm.ai';
  Result[12].Description := '���������������������� ��������� ������';
  Result[12].RequiresAPIKey := False;

  // Hugging Face Inference API
  Result[13].Name := 'Hugging Face';
  Result[13].Provider := aptOpenAI;
  Result[13].Endpoint := 'https://api-inference.huggingface.co/models/meta-llama/Meta-Llama-3-70B-Instruct';
  Result[13].Model := 'meta-llama/Meta-Llama-3-70B-Instruct';
  Result[13].DefaultModel := 'meta-llama/Meta-Llama-3-70B-Instruct';
  Result[13].Website := 'https://huggingface.co/settings/tokens';
  Result[13].Description := 'Hugging Face Inference API';
  Result[13].RequiresAPIKey := True;

  // Google AI Studio (Gemini)
  Result[14].Name := 'Google AI Studio';
  Result[14].Provider := aptOpenAI;
  Result[14].Endpoint := 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
  Result[14].Model := 'gemini-1.5-flash';
  Result[14].DefaultModel := 'gemini-1.5-flash';
  Result[14].Website := 'https://aistudio.google.com/apikey';
  Result[14].Description := 'Google Gemini (OpenAI-����������� API)';
  Result[14].RequiresAPIKey := True;
end;

class function TAIServicePresets.GetPresetByName(const AName: string): TAIServicePreset;
var
  Presets: TArray<TAIServicePreset>;
  I: Integer;
begin
  Presets := GetPresets;
  for I := 0 to High(Presets) do
  begin
    if SameText(Presets[I].Name, AName) then
      Exit(Presets[I]);
  end;
  // Return default (OpenAI) if not found
  Result := Presets[0];
end;

class function TAIServicePresets.GetProviderTypes: TArray<string>;
begin
  SetLength(Result, 3);
  Result[0] := 'OpenAI';
  Result[1] := 'Anthropic';
  Result[2] := 'Local';
end;

class function TAIServicePresets.ProviderTypeToStr(AType: TAIProviderType): string;
begin
  case AType of
    aptOpenAI: Result := 'OpenAI';
    aptAnthropic: Result := 'Anthropic';
    aptLocal: Result := 'Local';
  else
    Result := 'Unknown';
  end;
end;

class function TAIServicePresets.StrToProviderType(const AStr: string): TAIProviderType;
begin
  if SameText(AStr, 'OpenAI') then
    Result := aptOpenAI
  else if SameText(AStr, 'Anthropic') then
    Result := aptAnthropic
  else if SameText(AStr, 'Local') then
    Result := aptLocal
  else
    Result := aptOpenAI; // Default
end;

{ TAIService }

constructor TAIService.Create(const AConfig: TAIServiceConfig);
begin
  inherited Create;
  FConfig := AConfig;
  FCurrentProvider := nil;
  FHTTPClient := TWinInetHTTPClient.Create;
end;

destructor TAIService.Destroy;
begin
  if Assigned(FCurrentProvider) then
    FCurrentProvider.Free;
  FHTTPClient.Free;
  inherited Destroy;
end;

procedure TAIService.Log(const AMessage: string);
begin
  if Assigned(FOnLog) then
    FOnLog(Self);
  // Could write to file for debugging
  // TFile.AppendAllText('ai_service.log', AMessage + sLineBreak);
end;

function TAIService.CreateProvider: TCustomAIProvider;
begin
  // Defensive check
  if not Assigned(FHTTPClient) then
    raise Exception.Create('FWinHTTP is nil in TAIService');
    
  // Providers are created in AIProviders unit
  case FConfig.Provider of
    aptOpenAI, aptLocal:
      Result := CreateOpenAIProvider(FConfig, FHTTPClient);
    aptAnthropic:
      Result := CreateAnthropicProvider(FConfig, FHTTPClient);
  else
    Result := CreateOpenAIProvider(FConfig, FHTTPClient);
  end;
end;

function TAIService.IsConfigured: Boolean;
begin
  Result := FConfig.Enabled and 
            (FConfig.APIKey <> '') or 
            (FConfig.Provider = aptLocal);
end;

function TAIService.ChatComplete(const AMessages: TStringList): TAIResponse;
begin
  Result.Success := False;
  Result.Content := '';
  Result.ErrorMessage := 'AI service not configured';

  if not IsConfigured then
    Exit;

  try
    if not Assigned(FCurrentProvider) or 
       (FCurrentProvider.Config.Provider <> FConfig.Provider) then
    begin
      if Assigned(FCurrentProvider) then
        FCurrentProvider.Free;
      FCurrentProvider := CreateProvider;
    end;

    Result := FCurrentProvider.ChatComplete(AMessages);
    Log('AI Response: ' + Result.Content);
  except
    on E: Exception do
    begin
      Result.Success := False;
      Result.ErrorMessage := E.Message;
      Log('AI Error: ' + E.Message);
    end;
  end;
end;

function TAIService.BuildRequestBodyForTest(const AMessages: TStringList): string;
var
  Provider: TCustomAIProvider;
begin
  Provider := CreateProvider;
  try
    Result := Provider.BuildRequestBody(AMessages);
  finally
    Provider.Free;
  end;
end;

function TAIService.FormatSQL(const ASQL: string): TAIResponse;
var
  Messages: TStringList;
  SystemPrompt, UserPrompt: string;
begin
  Messages := TStringList.Create;
  try
    SystemPrompt := 'You are a SQL formatting assistant. Format SQL queries according to best practices. ' +
                    'Use consistent indentation, uppercase keywords, and proper spacing. ' +
                    'Return ONLY the formatted SQL, no explanations.';
    UserPrompt := 'Format this SQL query:' + sLineBreak + sLineBreak + ASQL;

    Messages.Add('system:' + SystemPrompt);
    Messages.Add('user:' + UserPrompt);

    Result := ChatComplete(Messages);
  finally
    Messages.Free;
  end;
end;

function TAIService.ExplainError(const ASQL: string; AError: string): TAIResponse;
var
  Messages: TStringList;
  SystemPrompt, UserPrompt: string;
begin
  Messages := TStringList.Create;
  try
    SystemPrompt := 'You are a SQL error explanation assistant. Explain SQL errors clearly and concisely. ' +
                    'Provide the cause of the error and suggest how to fix it. ' +
                    'Use simple language suitable for developers.';
    UserPrompt := Format('SQL Query:%s%s%s%sError: %s%s%sExplain this error and suggest a fix.',
                         [sLineBreak, ASQL, sLineBreak, sLineBreak, AError, sLineBreak]);

    Messages.Add('system:' + SystemPrompt);
    Messages.Add('user:' + UserPrompt);

    Result := ChatComplete(Messages);
  finally
    Messages.Free;
  end;
end;

function TAIService.ExplainQuery(const ASQL: string): TAIResponse;
var
  Messages: TStringList;
  SystemPrompt, UserPrompt: string;
begin
  Messages := TStringList.Create;
  try
    SystemPrompt := 'You are a SQL explanation assistant. Explain what SQL queries do in clear, simple language. ' +
                    'Break down complex queries into understandable parts. ' +
                    'Explain joins, subqueries, and functions used.';
    UserPrompt := 'Explain what this SQL query does:' + sLineBreak + sLineBreak + ASQL;

    Messages.Add('system:' + SystemPrompt);
    Messages.Add('user:' + UserPrompt);

    Result := ChatComplete(Messages);
  finally
    Messages.Free;
  end;
end;

function TAIService.GenerateQuery(const ADescription: string): TAIResponse;
var
  Messages: TStringList;
  SystemPrompt, UserPrompt: string;
begin
  Messages := TStringList.Create;
  try
    SystemPrompt := 'You are a SQL generation assistant. Create SQL queries based on natural language descriptions. ' +
                    'Use SQLite syntax. Return ONLY the SQL query, no explanations. ' +
                    'Use proper formatting and best practices.';
    UserPrompt := 'Generate a SQL query for: ' + ADescription;

    Messages.Add('system:' + SystemPrompt);
    Messages.Add('user:' + UserPrompt);

    Result := ChatComplete(Messages);
  finally
    Messages.Free;
  end;
end;

function TAIService.OptimizeSQL(const ASQL: string): TAIResponse;
var
  Messages: TStringList;
  SystemPrompt, UserPrompt: string;
begin
  Messages := TStringList.Create;
  try
    SystemPrompt := 'You are a SQL optimization assistant. Optimize SQL queries for performance. ' +
                    'Suggest indexes, query rewrites, and performance improvements. ' +
                    'Explain the optimizations you make.';
    UserPrompt := 'Optimize this SQL query for better performance:' + sLineBreak + sLineBreak + ASQL;

    Messages.Add('system:' + SystemPrompt);
    Messages.Add('user:' + UserPrompt);

    Result := ChatComplete(Messages);
  finally
    Messages.Free;
  end;
end;

function TAIService.SearchQueries(const ADescription: string; AHistory: TStringList): TAIResponse;
var
  Messages: TStringList;
  SystemPrompt, UserPrompt: string;
  I: Integer;
  HistoryText: string;
begin
  Messages := TStringList.Create;
  try
    // Build history context
    HistoryText := '';
    for I := 0 to Min(AHistory.Count - 1, 20) do
      HistoryText := HistoryText + Format('%d. %s%s', [I + 1, AHistory[I], sLineBreak]);

    SystemPrompt := 'You are a SQL search assistant. Find relevant queries from history based on description. ' +
                    'Return matching queries with brief explanations.';
    UserPrompt := Format('Find SQL queries related to: %s%s%sQuery History:%s%s',
                         [ADescription, sLineBreak, sLineBreak, HistoryText, sLineBreak]);

    Messages.Add('system:' + SystemPrompt);
    Messages.Add('user:' + UserPrompt);

    Result := ChatComplete(Messages);
  finally
    Messages.Free;
  end;
end;

procedure TAIService.LoadFromRegistry(const ARoot: THandle; const AKey: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := ARoot;
    if Reg.OpenKey(AKey, False) then
    begin
      try
        FConfig.Provider := TAIServicePresets.StrToProviderType(
          Reg.ReadString('Provider'));
        FConfig.ProviderName := Reg.ReadString('ProviderName');
        FConfig.APIKey := Reg.ReadString('APIKey');
        FConfig.Endpoint := Reg.ReadString('Endpoint');
        FConfig.Model := Reg.ReadString('Model');
        FConfig.Timeout := Reg.ReadInteger('Timeout');
        FConfig.MaxTokens := Reg.ReadInteger('MaxTokens');
        FConfig.Temperature := Reg.ReadFloat('Temperature');
        FConfig.UseSSL := Reg.ReadBool('UseSSL');
        FConfig.ProxyHost := Reg.ReadString('ProxyHost');
        FConfig.ProxyPort := Reg.ReadInteger('ProxyPort');
        FConfig.Enabled := Reg.ReadBool('Enabled');
      except
        // Use defaults if registry values not found
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TAIService.SaveToRegistry(const ARoot: THandle; const AKey: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := ARoot;
    if Reg.OpenKey(AKey, True) then
    begin
      Reg.WriteString('Provider',
        TAIServicePresets.ProviderTypeToStr(FConfig.Provider));
      Reg.WriteString('ProviderName', FConfig.ProviderName);
      Reg.WriteString('APIKey', FConfig.APIKey);
      Reg.WriteString('Endpoint', FConfig.Endpoint);
      Reg.WriteString('Model', FConfig.Model);
      Reg.WriteInteger('Timeout', FConfig.Timeout);
      Reg.WriteInteger('MaxTokens', FConfig.MaxTokens);
      Reg.WriteFloat('Temperature', FConfig.Temperature);
      Reg.WriteBool('UseSSL', FConfig.UseSSL);
      Reg.WriteString('ProxyHost', FConfig.ProxyHost);
      Reg.WriteInteger('ProxyPort', FConfig.ProxyPort);
      Reg.WriteBool('Enabled', FConfig.Enabled);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

{ TCustomAIProvider }

constructor TCustomAIProvider.Create(const AConfig: TAIServiceConfig; AHTTPClient: TWinInetHTTPClient);
begin
  inherited Create;
  FConfig := AConfig;
  FHTTPClient := AHTTPClient;
end;

function TCustomAIProvider.GetDefaultHeaders: TStrings;
begin
  Result := TStringList.Create;
end;

function TCustomAIProvider.ChatComplete(const AMessages: TStringList): TAIResponse;
var
  RequestBody, ResponseText: string;
  Headers: TStrings;
  I: Integer;
  HeadersStr: string;
begin
  Result.Success := False;
  Result.Content := '';
  Result.ErrorMessage := '';

  // Defensive checks
  if not Assigned(Self) then
  begin
    Result.ErrorMessage := 'Provider is nil';
    Exit;
  end;

  if not Assigned(AMessages) then
  begin
    Result.ErrorMessage := 'Messages is nil';
    Exit;
  end;

  try
    // Set headers
    Headers := GetDefaultHeaders;
    try
      HeadersStr := '';
      for I := 0 to Headers.Count - 1 do
      begin
        if Pos('=', Headers[I]) > 0 then
          HeadersStr := HeadersStr + Copy(Headers[I], 1, Pos('=', Headers[I]) - 1) + ': ' +
                       Copy(Headers[I], Pos('=', Headers[I]) + 1, MaxInt) + #13#10;
      end;
    finally
      Headers.Free;
    end;

    // Build and send request
    RequestBody := BuildRequestBody(AMessages);

    // Use HTTP client for request
    Result.RawResponse := '';
    if FHTTPClient.Post(FConfig.Endpoint, HeadersStr, RequestBody, ResponseText) then
    begin
      Result.RawResponse := ResponseText;
      Result := ParseResponse(ResponseText);
    end
    else
    begin
      Result.ErrorMessage := 'HTTP request failed: ' + ResponseText;
    end;
  except
    on E: Exception do
    begin
      Result.Success := False;
      Result.ErrorMessage := E.Message;
    end;
  end;
end;

end.
