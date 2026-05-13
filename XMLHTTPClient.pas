{*******************************************************************************
  HTTP Client using MSXML ServerXMLHTTP
  Better HTTPS support than WinHttp
*******************************************************************************}
unit XMLHTTPClient;

interface

uses
  System.Classes, System.SysUtils, Variants, ActiveX, ComObj;

type
  TXMLHTTPClient = class
  private
    FHTTP: Variant;
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

constructor TXMLHTTPClient.Create;
begin
  inherited Create;
  CoInitialize(nil);
  try
    // Try MSXML 6.0 first (best HTTPS support), then 3.0
    try
      FHTTP := CreateOleObject('MSXML2.ServerXMLHTTP.6.0');
    except
      try
        FHTTP := CreateOleObject('MSXML2.ServerXMLHTTP.3.0');
      except
        FHTTP := CreateOleObject('MSXML2.XMLHTTP.3.0');
      end;
    end;
  except
    FHTTP := Unassigned;
  end;
  FUserAgent := 'SQLiteManager-AI/1.0';
  FTimeout := 30000;
end;

destructor TXMLHTTPClient.Destroy;
begin
  if not VarIsEmpty(FHTTP) then
    FHTTP := Unassigned;
  CoUninitialize;
  inherited Destroy;
end;

function TXMLHTTPClient.Post(const AURL, AHeaders, ABody: string; out AResponse: string): Boolean;
var
  HeadersList: TStringList;
  I: Integer;
  HeaderName, HeaderValue: string;
  PosIdx: Integer;
  StatusCode: Integer;
  StatusText: string;
begin
  Result := False;
  AResponse := '';

  if VarIsEmpty(FHTTP) then
  begin
    AResponse := 'MSXML not available. Please install MSXML 6.0 or later.';
    Exit;
  end;

  try
    // Open connection (method, URL, async)
    FHTTP.open('POST', AURL, False);

    // Set timeouts (resolve, connect, send, receive) in milliseconds
    FHTTP.setTimeouts(FTimeout div 1000, FTimeout div 1000, FTimeout div 1000, FTimeout);

    // Set User-Agent
    FHTTP.setRequestHeader('User-Agent', FUserAgent);
    
    // Set request headers
    FHTTP.setRequestHeader('Accept', 'application/json');
    FHTTP.setRequestHeader('Accept-Encoding', 'gzip, deflate');

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
            FHTTP.setRequestHeader(HeaderName, HeaderValue);
          end;
        end;
      end;
    finally
      HeadersList.Free;
    end;

    // Send POST request
    FHTTP.send(ABody);
    
    // Check readyState
    if FHTTP.readyState <> 4 then
    begin
      AResponse := 'Request did not complete. readyState: ' + IntToStr(FHTTP.readyState);
      Result := False;
      Exit;
    end;

    // Get status code and text
    try
      StatusCode := FHTTP.status;
      StatusText := FHTTP.statustext;
    except
      on E: Exception do
      begin
        AResponse := 'Failed to get status: ' + E.Message;
        Result := False;
        Exit;
      end;
    end;

    // Get response
    try
      AResponse := FHTTP.responseText;
    except
      on E: Exception do
      begin
        AResponse := 'Failed to get response text: ' + E.Message;
        Result := False;
        Exit;
      end;
    end;

    // Add status code to response for debugging
    if StatusCode = 0 then
      AResponse := 'HTTP Status: 0 (Connection failed)' + sLineBreak + 
                   'Possible causes: TLS/SSL error, network issue, or firewall blocking.' + sLineBreak +
                   'Try: 1) Check internet connection, 2) Install/update MSXML 6.0, 3) Check firewall settings.' + sLineBreak +
                   sLineBreak + AResponse
    else if (StatusCode < 200) or (StatusCode >= 300) then
      AResponse := 'HTTP ' + IntToStr(StatusCode) + ' ' + StatusText + sLineBreak + sLineBreak + AResponse;

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
