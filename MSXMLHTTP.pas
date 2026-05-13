{*******************************************************************************
  HTTP Client using MSXML XMLHTTP
  Built into Windows, no additional DLLs needed
*******************************************************************************}
unit MSXMLHTTP;

interface

uses
  System.Classes, System.SysUtils, Variants, ActiveX, ComObj;

type
  TMSXMLHTTP = class
  private
    FXMLHTTP: Variant;
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

constructor TMSXMLHTTP.Create;
begin
  inherited Create;
  CoInitialize(nil);
  try
    // Try MSXML 6.0 first, then 3.0
    FXMLHTTP := CreateOleObject('MSXML2.ServerXMLHTTP.6.0');
  except
    try
      FXMLHTTP := CreateOleObject('MSXML2.ServerXMLHTTP.3.0');
    except
      FXMLHTTP := CreateOleObject('MSXML2.XMLHTTP.3.0');
    end;
  end;
  FUserAgent := 'SQLiteManager-AI/1.0';
  FTimeout := 30000;
end;

destructor TMSXMLHTTP.Destroy;
begin
  FXMLHTTP := Unassigned;
  CoUninitialize;
  inherited Destroy;
end;

function TMSXMLHTTP.Post(const AURL, AHeaders, ABody: string; out AResponse: string): Boolean;
var
  HeadersList: TStringList;
  I: Integer;
  HeaderName, HeaderValue: string;
  PosIdx: Integer;
begin
  Result := False;
  AResponse := '';

  try
    // Open connection first (async = false for synchronous)
    FXMLHTTP.open('POST', AURL, False);

    // Set User-Agent
    FXMLHTTP.setRequestHeader('User-Agent', FUserAgent);

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
            FXMLHTTP.setRequestHeader(HeaderName, HeaderValue);
          end;
        end;
      end;
    finally
      HeadersList.Free;
    end;

    // Send POST request
    FXMLHTTP.send(ABody);

    // Get response
    AResponse := FXMLHTTP.responseText;
    Result := (FXMLHTTP.status >= 200) and (FXMLHTTP.status < 300);
  except
    on E: Exception do
    begin
      AResponse := 'Exception: ' + E.Message;
      Result := False;
    end;
  end;
end;

end.
