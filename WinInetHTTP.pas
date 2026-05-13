{*******************************************************************************
  HTTP Client using WinInet
  Alternative to Indy HTTP for AI API calls
*******************************************************************************}
unit WinInetHTTP;

interface

uses
  System.Classes, System.SysUtils, Winapi.Windows, Winapi.WinInet, System.StrUtils;

type
  TWinInetHTTP = class
  private
    FhInternet: HINTERNET;
    FhConnect: HINTERNET;
    FUserAgent: string;
    FTimeout: Integer;
    function GetConnected: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function Connect(const AServer: string; APort: Integer; AUseSSL: Boolean): Boolean;
    function SendRequest(const AMethod, APath, AHeaders, ABody: string; AUseSSL: Boolean; out AResponse: string): Boolean;
    function Post(const AURL, AHeaders, ABody: string; out AResponse: string): Boolean;

    property UserAgent: string read FUserAgent write FUserAgent;
    property Timeout: Integer read FTimeout write FTimeout;
    property Connected: Boolean read GetConnected;
  end;

implementation

constructor TWinInetHTTP.Create;
begin
  inherited Create;
  FhInternet := nil;
  FhConnect := nil;
  FUserAgent := 'SQLiteManager-AI/1.0';
  FTimeout := 30000;
end;

destructor TWinInetHTTP.Destroy;
begin
  if Assigned(FhConnect) then
    InternetCloseHandle(FhConnect);
  if Assigned(FhInternet) then
    InternetCloseHandle(FhInternet);
  inherited Destroy;
end;

function TWinInetHTTP.GetConnected: Boolean;
begin
  Result := Assigned(FhConnect);
end;

function TWinInetHTTP.Connect(const AServer: string; APort: Integer; AUseSSL: Boolean): Boolean;
var
  AccessType: Integer;
begin
  Result := False;

  // Close existing handles
  if Assigned(FhConnect) then
  begin
    InternetCloseHandle(FhConnect);
    FhConnect := nil;
  end;
  if Assigned(FhInternet) then
  begin
    InternetCloseHandle(FhInternet);
    FhInternet := nil;
  end;
  
  // Open WinInet
  FhInternet := InternetOpen(PChar(FUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if not Assigned(FhInternet) then
    Exit;
  
  // Set timeouts
  InternetSetOption(FhInternet, INTERNET_OPTION_CONNECT_TIMEOUT, @FTimeout, SizeOf(FTimeout));
  InternetSetOption(FhInternet, INTERNET_OPTION_SEND_TIMEOUT, @FTimeout, SizeOf(FTimeout));
  InternetSetOption(FhInternet, INTERNET_OPTION_RECEIVE_TIMEOUT, @FTimeout, SizeOf(FTimeout));
  
  // Connect to server
  AccessType := INTERNET_OPEN_TYPE_PRECONFIG;
  FhConnect := InternetConnect(FhInternet, PChar(AServer), APort, '', '', AccessType, 0, 0);
  Result := Assigned(FhConnect);
end;

function TWinInetHTTP.SendRequest(const AMethod, APath, AHeaders, ABody: string; AUseSSL: Boolean; out AResponse: string): Boolean;
var
  hRequest: HINTERNET;
  HeadersWide: PWideChar;
  BodyPtr: Pointer;
  BodyLen: DWORD;
  Buffer: array[0..4095] of Byte;
  BytesRead: DWORD;
  ResponseStream: TStringStream;
  ErrorCode: DWORD;
  Flags: DWORD;
  StatusCode: DWORD;
  StatusCodeLen: DWORD;
  ARes: DWORD;
begin
  Result := False;
  AResponse := '';
  hRequest := nil;

  if not Assigned(FhConnect) then
    Exit;

  try
    // Open request with SSL support
    Flags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE or
                 INTERNET_FLAG_IGNORE_CERT_DATE_INVALID or INTERNET_FLAG_IGNORE_CERT_CN_INVALID;
    
    // Add SSL flag for HTTPS
    Flags := Flags or INTERNET_FLAG_SECURE;
    
    hRequest := HttpOpenRequest(FhConnect, PChar(AMethod), PChar(APath), nil, nil, nil, Flags, 0);

    if not Assigned(hRequest) then
    begin
      ErrorCode := GetLastError;
      Exit;
    end;

    // Set timeouts
    InternetSetOption(hRequest, INTERNET_OPTION_CONNECT_TIMEOUT, @FTimeout, SizeOf(FTimeout));
    InternetSetOption(hRequest, INTERNET_OPTION_SEND_TIMEOUT, @FTimeout, SizeOf(FTimeout));
    InternetSetOption(hRequest, INTERNET_OPTION_RECEIVE_TIMEOUT, @FTimeout, SizeOf(FTimeout));

    // Prepare headers
    if AHeaders <> '' then
      HeadersWide := PChar(AHeaders)
    else
      HeadersWide := nil;

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
    if HttpSendRequest(hRequest, HeadersWide, 0, BodyPtr, BodyLen) then
    begin
      // Get HTTP status code
      StatusCodeLen := SizeOf(StatusCode);
      if HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @StatusCode, StatusCodeLen, ARes) then
      begin
        // Check if status is 2xx
        if (StatusCode < 200) or (StatusCode >= 300) then
        begin
          Result := False;
          Exit;
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

        AResponse := ResponseStream.DataString;
        Result := True;
      finally
        ResponseStream.Free;
      end;
    end
    else
    begin
      ErrorCode := GetLastError;
    end;

  finally
    if Assigned(hRequest) then
      InternetCloseHandle(hRequest);
  end;
end;

function TWinInetHTTP.Post(const AURL, AHeaders, ABody: string; out AResponse: string): Boolean;
var
  Server: string;
  Path: string;
  Port: Integer;
  UseSSL: Boolean;
  Parts: TStringList;
  HostPart: string;
  I: Integer;
  CleanURL: string;
begin
  Result := False;
  AResponse := '';

  if not Assigned(FhInternet) then
  begin
    // Initialize WinInet
    FhInternet := InternetOpen(PChar(FUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if not Assigned(FhInternet) then
      Exit;
  end;
  
  // Parse URL
  Parts := TStringList.Create;
  try
    Parts.Delimiter := '/';
    Parts.StrictDelimiter := True;
    
    // Remove protocol prefix
    CleanURL := AURL;
    if Pos('https://', CleanURL) > 0 then
    begin
      CleanURL := StringReplace(CleanURL, 'https://', '', []);
      UseSSL := True;
    end
    else if Pos('http://', CleanURL) > 0 then
    begin
      CleanURL := StringReplace(CleanURL, 'http://', '', []);
      UseSSL := False;
    end
    else
      UseSSL := False;
    
    Parts.DelimitedText := CleanURL;
    
    if Parts.Count >= 1 then
    begin
      HostPart := Parts[0];
      Path := '/';
      for I := 1 to Parts.Count - 1 do
        Path := Path + Parts[I];
      
      // Extract server and port
      if Pos(':', HostPart) > 0 then
      begin
        Server := Copy(HostPart, 1, Pos(':', HostPart) - 1);
        if UseSSL then
          Port := 443
        else
          Port := 80;
        Port := StrToIntDef(Copy(HostPart, Pos(':', HostPart) + 1, MaxInt), Port);
      end
      else
      begin
        Server := HostPart;
        if UseSSL then
          Port := 443
        else
          Port := 80;
      end;
      
      // Connect and send
      if Connect(Server, Port, UseSSL) then
        Result := SendRequest('POST', Path, AHeaders, ABody, True, AResponse);
    end;
  finally
    Parts.Free;
  end;
end;

end.
