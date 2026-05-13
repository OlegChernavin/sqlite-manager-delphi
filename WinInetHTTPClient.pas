{*******************************************************************************
  HTTP Client using WinInet API (direct, not OleObject)
  Works with OpenRouter and other HTTPS APIs
*******************************************************************************}
unit WinInetHTTPClient;

interface

uses
  System.Classes, System.SysUtils, Winapi.Windows, Winapi.WinInet;

type
  TWinInetHTTPClient = class
  private
    FhInternet: HINTERNET;
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

constructor TWinInetHTTPClient.Create;
begin
  inherited Create;
  FUserAgent := 'SQLiteManager-AI/1.0';
  FTimeout := 30000;
  FhInternet := nil;
end;

destructor TWinInetHTTPClient.Destroy;
begin
  if Assigned(FhInternet) then
    InternetCloseHandle(FhInternet);
  inherited Destroy;
end;

function TWinInetHTTPClient.Post(const AURL, AHeaders, ABody: string; out AResponse: string): Boolean;
var
  hConnect: HINTERNET;
  hRequest: HINTERNET;
  Buffer: array[0..4095] of Byte;
  BytesRead: DWORD;
  ResponseStream: TStringStream;
  Server, Path: string;
  Port: Integer;
  UseSSL: Boolean;
  Flags: DWORD;
  HeadersWide: string;
  BodyPtr: Pointer;
  BodyLen: DWORD;
  StatusCode: DWORD;
  StatusCodeLen: DWORD;
  ARes: DWORD;
begin
  Result := False;
  AResponse := '';
  hConnect := nil;
  hRequest := nil;
  //ResponseStream := nil;

  // Parse URL - handle nil/empty safely
  if AURL = '' then
  begin
    AResponse := 'Empty URL';
    Exit;
  end;
  
  UseSSL := Pos('https://', AURL) > 0;
  Server := Copy(AURL, Pos('://', AURL) + 3, MaxInt);
  if Server = '' then
  begin
    AResponse := 'Invalid URL: no server';
    Exit;
  end;
  
  if Pos('/', Server) > 0 then
  begin
    Path := Copy(Server, Pos('/', Server), MaxInt);
    Server := Copy(Server, 1, Pos('/', Server) - 1);
  end
  else
    Path := '/';

  if Pos(':', Server) > 0 then
  begin
    Port := StrToIntDef(Copy(Server, Pos(':', Server) + 1, MaxInt), 0);
    Server := Copy(Server, 1, Pos(':', Server) - 1);
  end
  else
  begin
    Port := 80;
    if UseSSL then
      Port := 443;
  end;
  
  if Server = '' then
  begin
    AResponse := 'Invalid URL: empty server name';
    Exit;
  end;

  try
    // Open WinInet
    FhInternet := InternetOpen(PChar(FUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if not Assigned(FhInternet) then
    begin
      AResponse := 'Failed to open WinInet. Error: ' + IntToStr(GetLastError);
      Exit;
    end;

    // Set timeouts
    InternetSetOption(FhInternet, INTERNET_OPTION_CONNECT_TIMEOUT, @FTimeout, SizeOf(FTimeout));
    InternetSetOption(FhInternet, INTERNET_OPTION_SEND_TIMEOUT, @FTimeout, SizeOf(FTimeout));
    InternetSetOption(FhInternet, INTERNET_OPTION_RECEIVE_TIMEOUT, @FTimeout, SizeOf(FTimeout));

    // Connect to server
    hConnect := InternetConnect(FhInternet, PChar(Server), Port, '', '', INTERNET_SERVICE_HTTP, 0, 0);
    if not Assigned(hConnect) then
    begin
      AResponse := 'Failed to connect to server. Error: ' + IntToStr(GetLastError);
      Exit;
    end;

    // Open request
    Flags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE or
             INTERNET_FLAG_IGNORE_CERT_DATE_INVALID or INTERNET_FLAG_IGNORE_CERT_CN_INVALID;
    if UseSSL then
      Flags := Flags or INTERNET_FLAG_SECURE;

    hRequest := HttpOpenRequest(hConnect, 'POST', PChar(Path), nil, nil, nil, Flags, 0);
    if not Assigned(hRequest) then
    begin
      AResponse := 'Failed to open request. Error: ' + IntToStr(GetLastError);
      Exit;
    end;

    // Build headers string
    HeadersWide := AHeaders + #13#10;

    // Prepare body
    if ABody <> '' then
    begin
      BodyPtr := Pointer(UTF8Encode(ABody));
      BodyLen := Length(UTF8Encode(ABody));
    end
    else
    begin
      BodyPtr := nil;
      BodyLen := 0;
    end;

    // Send request
    if not HttpSendRequest(hRequest, PChar(HeadersWide), Length(HeadersWide), BodyPtr, BodyLen) then
    begin
      AResponse := 'Failed to send request. Error: ' + IntToStr(GetLastError);
      Exit;
    end;

    // Get status code
    StatusCodeLen := SizeOf(StatusCode);
    FillChar(StatusCode, SizeOf(StatusCode), 0);
    if HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @StatusCode, StatusCodeLen, ARes) then
    begin
      // Check status
      if (StatusCode < 200) or (StatusCode >= 300) then
      begin
        AResponse := 'HTTP ' + string(StatusCode) + sLineBreak + sLineBreak;
      end;
    end;

    // Read response
    ResponseStream := TStringStream.Create('', TEncoding.UTF8);
    try
      repeat
        BytesRead := 0;
        if InternetReadFile(hRequest, @Buffer, SizeOf(Buffer), BytesRead) and (BytesRead > 0) then
          ResponseStream.Write(Buffer, BytesRead)
        else
          Break;
      until False;

      AResponse := AResponse + ResponseStream.DataString;
      Result := (StatusCode >= 200) and (StatusCode < 300);
    finally
      ResponseStream.Free;
    end;

  finally
    if Assigned(hRequest) then
      InternetCloseHandle(hRequest);
    if Assigned(hConnect) then
      InternetCloseHandle(hConnect);
    if Assigned(FhInternet) then
    begin
      InternetCloseHandle(FhInternet);
      FhInternet := nil;
    end;
  end;
end;

end.
