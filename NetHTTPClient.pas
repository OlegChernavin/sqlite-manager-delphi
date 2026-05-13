{*******************************************************************************
  HTTP Client using System.Net.HttpClient
  Modern HTTP client for Delphi 10.4+
*******************************************************************************}
unit NetHTTPClient;

interface

uses
  System.Classes, System.SysUtils, System.Net.HttpClient, System.Net.URLClient;

type
  TNetHTTPClientWrapper = class
  private
    FClient: TNetHTTPClient;
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

constructor TNetHTTPClientWrapper.Create;
begin
  inherited Create;
  FClient := TNetHTTPClient.Create(nil);
  FUserAgent := 'SQLiteManager-AI/1.0';
  FTimeout := 30000;
  FClient.UserAgent := FUserAgent;
  FClient.ConnectionTimeout := FTimeout div 1000;
  FClient.ResponseTimeout := FTimeout div 1000;
end;

destructor TNetHTTPClientWrapper.Destroy;
begin
  FClient.Free;
  inherited Destroy;
end;

function TNetHTTPClientWrapper.Post(const AURL, AHeaders, ABody: string; out AResponse: string): Boolean;
var
  Response: IHTTPResponse;
  RequestBody: TStringStream;
  HeadersArray: TArray<TNetHeader>;
  HeaderPair: string;
  HeadersList: TStringList;
  I: Integer;
begin
  Result := False;
  AResponse := '';
  RequestBody := nil;

  try
    // Parse headers
    HeadersList := TStringList.Create;
    try
      if AHeaders <> '' then
      begin
        HeadersList.Text := StringReplace(AHeaders, #13#10, sLineBreak, [rfReplaceAll]);
        SetLength(HeadersArray, HeadersList.Count);
        for I := 0 to HeadersList.Count - 1 do
        begin
          if Pos(':', HeadersList[I]) > 0 then
          begin
            HeadersArray[I].Name := Trim(Copy(HeadersList[I], 1, Pos(':', HeadersList[I]) - 1));
            HeadersArray[I].Value := Trim(Copy(HeadersList[I], Pos(':', HeadersList[I]) + 1, MaxInt));
          end;
        end;
      end;
    finally
      HeadersList.Free;
    end;

    // Create request body
    RequestBody := TStringStream.Create(ABody, TEncoding.UTF8);
    try
      // Send POST request
      FClient.ContentType := 'application/json';
      if Length(HeadersArray) > 0 then
        Response := FClient.Post(AURL, RequestBody, HeadersArray)
      else
        Response := FClient.Post(AURL, RequestBody);

      if Assigned(Response) then
      begin
        AResponse := Response.ContentAsString;
        Result := (Response.StatusCode = 200);
      end;
    finally
      RequestBody.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse := 'Exception: ' + E.Message;
      Result := False;
    end;
  end;
end;

end.
