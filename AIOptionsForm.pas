{*******************************************************************************
  AI Options Form - Configuration dialog for AI integration
*******************************************************************************}
unit AIOptionsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, AIService, ShellAPI, ActiveX;

type
  TfrmAIOptions = class(TForm)
    pnlHeader: TPanel;
    lblSubtitle: TLabel;
    cbEnableAI: TCheckBox;
    lblPreset: TLabel;
    cbPreset: TComboBox;
    lblAPIKey: TLabel;
    edtAPIKey: TEdit;
    lblEndpoint: TLabel;
    edtEndpoint: TEdit;
    lblModel: TLabel;
    edtModel: TEdit;
    btnGetAPIKey: TButton;
    lblProvider: TLabel;
    cbProvider: TComboBox;
    lblTimeout: TLabel;
    edtTimeout: TEdit;
    lblMaxTokens: TLabel;
    edtMaxTokens: TEdit;
    lblTemperature: TLabel;
    edtTemperature: TEdit;
    btnTestConnection: TButton;
    pnlFooter: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    memLog: TMemo;
    udTemperature: TUpDown;
    lblPresetInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbPresetChange(Sender: TObject);
    procedure cbProviderChange(Sender: TObject);
    procedure btnGetAPIKeyClick(Sender: TObject);
    procedure btnTestConnectionClick(Sender: TObject);
    procedure memLogKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FPresets: TArray<TAIServicePreset>;
    procedure LoadPresets;
    procedure ApplyPreset(const APreset: TAIServicePreset);
    procedure Log(const AMessage: string);
  public
    function GetConfig: TAIServiceConfig;
    procedure SetConfig(const AConfig: TAIServiceConfig);
  end;

var
  frmAIOptions: TfrmAIOptions;

implementation

{$R *.dfm}

uses
  System.Threading;

procedure TfrmAIOptions.FormCreate(Sender: TObject);
begin
  LoadPresets;
  
  // Initialize provider combo
  cbProvider.Items.Assign(TStringList.Create);
  cbProvider.Items.AddStrings(TStringList.Create);
  cbProvider.Items.Add('OpenAI');
  cbProvider.Items.Add('Anthropic');
  cbProvider.Items.Add('Local');
  cbProvider.ItemIndex := 0;
  
  // Initialize temperature up-down
  udTemperature.Min := 0;
  udTemperature.Max := 20;
  
  memLog.Clear;
end;

procedure TfrmAIOptions.FormDestroy(Sender: TObject);
begin
  // Cleanup if needed
end;

procedure TfrmAIOptions.LoadPresets;
var
  I: Integer;
begin
  FPresets := TAIServicePresets.GetPresets;
  cbPreset.Items.Clear;
  
  for I := 0 to High(FPresets) do
  begin
    cbPreset.Items.AddObject(FPresets[I].Name, TObject(Integer(I)));
  end;
  
  if Length(FPresets) > 0 then
    cbPreset.ItemIndex := 0;
end;

procedure TfrmAIOptions.ApplyPreset(const APreset: TAIServicePreset);
begin
  cbProvider.ItemIndex := Ord(APreset.Provider);
  edtEndpoint.Text := APreset.Endpoint;
  edtModel.Text := APreset.DefaultModel;
  lblPresetInfo.Caption := APreset.Description;
  
  // Enable/disable API key field
  edtAPIKey.Enabled := APreset.RequiresAPIKey;
  lblAPIKey.Enabled := APreset.RequiresAPIKey;
  btnGetAPIKey.Visible := APreset.RequiresAPIKey;
  
  Log('Preset loaded: ' + APreset.Name);
end;

procedure TfrmAIOptions.cbPresetChange(Sender: TObject);
var
  Index: Integer;
begin
  if cbPreset.ItemIndex < 0 then
    Exit;
    
  Index := Integer(cbPreset.Items.Objects[cbPreset.ItemIndex]);
  if (Index >= 0) and (Index <= High(FPresets)) then
    ApplyPreset(FPresets[Index]);
end;

procedure TfrmAIOptions.cbProviderChange(Sender: TObject);
begin
  // Update preset selection based on provider
  // This helps user find local providers when they select "Local"
  case cbProvider.ItemIndex of
    0: // OpenAI
      begin
        // Could filter to OpenAI-compatible presets
      end;
    1: // Anthropic
      begin
        // Select Anthropic preset
      end;
    2: // Local
      begin
        // Select Ollama preset
        cbPreset.ItemIndex := 9; // Ollama
        cbPresetChange(Sender);
      end;
  end;
end;

procedure TfrmAIOptions.btnGetAPIKeyClick(Sender: TObject);
var
  Index: Integer;
  URL: string;
begin
  if cbPreset.ItemIndex < 0 then
    Exit;
    
  Index := Integer(cbPreset.Items.Objects[cbPreset.ItemIndex]);
  if (Index >= 0) and (Index <= High(FPresets)) then
  begin
    URL := FPresets[Index].Website;
    if URL <> '' then
      ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TfrmAIOptions.btnTestConnectionClick(Sender: TObject);
var
  Config: TAIServiceConfig;
  Service: TAIService;
  Messages: TStringList;
  JSONBody: string;
begin
  btnTestConnection.Enabled := False;
  memLog.Clear;

  Config := GetConfig;

  if not Config.Enabled then
  begin
    Log('⚠ AI is not enabled. Enable it first.');
    btnTestConnection.Enabled := True;
    Exit;
  end;

  if (Config.Provider <> TAIServicePresets.StrToProviderType('Local')) and
     (Config.APIKey = '') then
  begin
    Log('⚠ API Key is empty. Some providers require it.');
  end;

  Log('Testing connection to ' + Config.ProviderName + '...');
  Log('Endpoint: ' + Config.Endpoint);
  Log('Model: ' + Config.Model);
  
  // Test HTTP first (for debugging)
  if Pos('https://', Config.Endpoint) > 0 then
  begin
    Log('Note: HTTPS may require TLS 1.2 support. Make sure Windows is updated.');
  end;

  Service := TAIService.Create(Config);
  Messages := TStringList.Create;
  try
    Messages.Add('system:You are a test assistant. Reply with "OK" if you receive this.');
    Messages.Add('user:Test connection from SQLite Manager');

    Log('Sending test request...');
    
    // Log JSON that will be sent
    try
      JSONBody := Service.BuildRequestBodyForTest(Messages);
      Log('JSON Request:');
      Log(JSONBody);
    except
      on E: Exception do
        Log('Error building request: ' + E.Message);
    end;

    // Run in background thread - Service will be freed in thread
    TThread.CreateAnonymousThread(
      procedure
      var
        LocalResponse: TAIResponse;
      begin
        // Initialize COM in this thread
        CoInitialize(nil);
        try
          try
            LocalResponse := Service.ChatComplete(Messages);

            TThread.Synchronize(nil, procedure
            begin
              if LocalResponse.Success then
              begin
                Log('✓ Connection successful!');
                Log('Response: ' + Copy(LocalResponse.Content, 1, 100));
                if LocalResponse.Usage.TotalTokens > 0 then
                  Log('Tokens used: ' + IntToStr(LocalResponse.Usage.TotalTokens));
              end
              else
              begin
                Log('✗ Connection failed: ' + LocalResponse.ErrorMessage);
                Log('Full Raw response:');
                Log('---');
                Log(LocalResponse.RawResponse);
                Log('---');
              end;
              btnTestConnection.Enabled := True;
              Service.Free; // Free service after use
            end);
          except
            on E: Exception do
            begin
              TThread.Synchronize(nil, procedure
              begin
                Log('✗ Error: ' + E.Message);
                btnTestConnection.Enabled := True;
                Service.Free;
              end);
            end;
          end;
        finally
          CoUninitialize;
          Messages.Free;
        end;
      end).Start;
    
  except
    on E: Exception do
    begin
      Log('✗ Setup error: ' + E.Message);
      btnTestConnection.Enabled := True;
      Service.Free;
      Messages.Free;
    end;
  end;
end;

procedure TfrmAIOptions.Log(const AMessage: string);
begin
  memLog.Lines.Add(AMessage);
end;

procedure TfrmAIOptions.memLogKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Ord('A')) and (ssCtrl in Shift) then
    memLog.SelectAll;
end;

function TfrmAIOptions.GetConfig: TAIServiceConfig;
begin
  Result.Enabled := cbEnableAI.Checked;
  Result.Provider := TAIServicePresets.StrToProviderType(cbProvider.Text);
  Result.ProviderName := cbProvider.Text;
  Result.APIKey := edtAPIKey.Text;
  Result.Endpoint := edtEndpoint.Text;
  Result.Model := edtModel.Text;
  Result.Timeout := StrToIntDef(edtTimeout.Text, 30000);
  Result.MaxTokens := StrToIntDef(edtMaxTokens.Text, 1024);
  Result.Temperature := StrToFloatDef(edtTemperature.Text, 0.3) / 10;
  Result.UseSSL := Pos('https://', Result.Endpoint) > 0;
  Result.ProxyHost := '';
  Result.ProxyPort := 0;
end;

procedure TfrmAIOptions.SetConfig(const AConfig: TAIServiceConfig);
var
  I: Integer;
  PresetFound: Boolean;
begin
  cbEnableAI.Checked := AConfig.Enabled;
  cbProvider.Text := TAIServicePresets.ProviderTypeToStr(AConfig.Provider);
  edtAPIKey.Text := AConfig.APIKey;
  edtEndpoint.Text := AConfig.Endpoint;
  edtTimeout.Text := IntToStr(AConfig.Timeout);
  edtMaxTokens.Text := IntToStr(AConfig.MaxTokens);
  edtTemperature.Text := FloatToStr(AConfig.Temperature * 10);

  // Find matching preset
  PresetFound := False;
  FPresets := TAIServicePresets.GetPresets;
  for I := 0 to High(FPresets) do
  begin
    if SameText(FPresets[I].Endpoint, AConfig.Endpoint) then
    begin
      cbPreset.ItemIndex := I;
      ApplyPreset(FPresets[I]);
      PresetFound := True;
      Break;
    end;
  end;

  if not PresetFound then
  begin
    // Custom configuration
    cbPreset.ItemIndex := -1;
    lblPresetInfo.Caption := 'Custom configuration';
  end;
  edtModel.Text := AConfig.Model;
end;

end.
