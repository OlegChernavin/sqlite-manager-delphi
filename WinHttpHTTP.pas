{*******************************************************************************
  HTTP Client using WinHttp WinHttpRequest
  Built into Windows, better HTTPS support than MSXML
*******************************************************************************}
unit WinHttpHTTP;

interface

uses
  System.Classes, System.SysUtils, Variants, ActiveX, ComObj;

type
  TWinHttpHTTP = class
  private
    FWinHttp: Variant;
    FUserAgent: string;
    FTimeout: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function Post(const AURL, AHeaders, ABody: string; out AResponse: string): Boolean;
    
    property UserAgent: string read FUserAgent write FUserAgent;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

implementation

constructor TWinHttpHTTP.Create;
begin
  inherited Create;
  CoInitialize(nil);
  try
    // WinHttp.WinHttpRequest is available on Windows XP and later
    FWinHttp := CreateOleObject('WinHttp.WinHttpRequest.5.1');
  except
    FWinHttp := CreateOleObject('WinHttp.WinHttpRequest');
  end;
  FUserAgent := 'SQLiteManager-AI/1.0';
  FTimeout := 30000;
end;

destructor TWinHttpHTTP.Destroy;
begin
  FWinHttp := Unassigned;
  CoUninitialize;
  inherited Destroy;
end;

function TWinHttpHTTP.Post(const AURL, AHeaders, ABody: string; out AResponse: string): Boolean;
var
  HeadersList: TStringList;
  I: Integer;
  HeaderName, HeaderValue: string;
  PosIdx: Integer;
  StatusCode: Integer;
begin
  Result := False;
  AResponse := '';

  try
    // Open connection (POST, URL, async=false)
    FWinHttp.Open('POST', AURL, False);
    
    // Enable TLS 1.2 (WINHTTP_OPTION_SECURE_PROTOCOLS = 4, TLS1.2 = 0x00002000)
    try
      FWinHttp.Option(4, $00002000);
    except
      // Ignore if option not supported
    end;
    
    // Set timeouts (resolve, connect, send, receive) in milliseconds
    FWinHttp.SetTimeouts(FTimeout div 1000, FTimeout div 1000, FTimeout div 1000, FTimeout);
    
    // Set User-Agent
    FWinHttp.SetRequestHeader('User-Agent', FUserAgent);
    
    // Parse and set headers
    HeadersList := TStringList.Create;
    try
      HeadersList.Text := StringReplace(AHeaders, #13#10, sLineBreak, [rfReplaceAll]);
      for I := 0 to HeadersList.Count - 1 do
      begin
        if HeadersList[I] <> '' then
        begin
          PosIdx := Pos(':', HeadersList[I]);
          if PosIdx > 0 then
          begin
            HeaderName := Trim(Copy(HeadersList[I], 1, PosIdx - 1));
            HeaderValue := Trim(Copy(HeadersList[I], PosIdx + 1, MaxInt));
            FWinHttp.SetRequestHeader(HeaderName, HeaderValue);
          end;
        end;
      end;
    finally
      HeadersList.Free;
    end;

    // Send POST request
    FWinHttp.Send(ABody);
    
    // Get status code
    StatusCode := FWinHttp.Status;
    
    // Get response
    AResponse := FWinHttp.ResponseText;
    
    // Add status code to response for debugging
    if StatusCode = 0 then
      AResponse := 'HTTP Status: 0 (Connection failed or SSL error)' + sLineBreak + sLineBreak + AResponse
    else if (StatusCode < 200) or (StatusCode >= 300) then
      AResponse := 'HTTP ' + IntToStr(StatusCode) + ' ' + FWinHttp.StatusText + sLineBreak + sLineBreak + AResponse;
    
    Result := (StatusCode >= 200) and (StatusCode < 300);
  except
    on E: Exception do
    begin
      AResponse := 'Exception: ' + E.Message;
      Result := False;
    end;
  end;
end;

end.
