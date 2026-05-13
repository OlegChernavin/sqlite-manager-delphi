unit SQLAdvancedFormatter;

interface

uses
  System.SysUtils, System.Classes, System.RegularExpressions, System.StrUtils;

type
  TAdvancedSQLFormatter = class
  private
    const
      INDENT_STR = '    ';
    class function IsKeyWord(const AToken: string): Boolean;
    class function IsInlineContainer(const AToken: string): Boolean;
    class function GetTokens(const ASql: string): TArray<string>;
  public
    class function Format(const ASql: string): string;
  end;

implementation

class function TAdvancedSQLFormatter.IsKeyWord(const AToken: string): Boolean;
const
  // Убрали LEFT, RIGHT, INNER, OUTER, JOIN из списка принудительного переноса
  Keywords: array[0..5] of string = ('WHERE', 'GROUP', 'ORDER', 'HAVING', 'LIMIT', 'UNION');
var K: string;
begin
  Result := False;
  for K in Keywords do if SameText(AToken, K) then Exit(True);
end;

class function TAdvancedSQLFormatter.IsInlineContainer(const AToken: string): Boolean;
const
  Containers: array[0..14] of string = ('MAX', 'MIN', 'COUNT', 'AVG', 'SUM',
    'IFNULL', 'COALESCE', 'ABS', 'ROUND', 'UPPER', 'LOWER', 'IN', 'REPLACE',
    'STRFTIME', 'RANDOM');
var C: string;
begin
  Result := False;
  for C in Containers do if SameText(AToken, C) then Exit(True);
end;

class function TAdvancedSQLFormatter.GetTokens(const ASql: string): TArray<string>;
var
  I: Integer;
  CurrentToken: string;
  InQuotes: Boolean;
  QuoteChar, C, NextC: Char;
begin
  Result := [];
  CurrentToken := '';
  InQuotes := False;
  QuoteChar := #0;
  I := 1;
  while I <= ASql.Length do
  begin
    C := ASql[I];
    if I < ASql.Length then NextC := ASql[I+1] else NextC := #0;

    if InQuotes then
    begin
      CurrentToken := CurrentToken + C;
      if (C = QuoteChar) then
      begin
        if (NextC = QuoteChar) then begin CurrentToken := CurrentToken + NextC; Inc(I); end
        else begin InQuotes := False; Result := Result + [CurrentToken]; CurrentToken := ''; end;
      end;
    end
    else if (C = '''') or (C = '"') then
    begin
      if not CurrentToken.IsEmpty then Result := Result + [CurrentToken];
      InQuotes := True; QuoteChar := C; CurrentToken := C;
    end
    else if CharInSet(C, ['(', ')', ',', ' ', #13, #10, #9]) then
    begin
      if not CurrentToken.IsEmpty then Result := Result + [CurrentToken];
      if CharInSet(C, ['(', ')', ',']) then Result := Result + [C];
      CurrentToken := '';
    end
    else CurrentToken := CurrentToken + C;
    Inc(I);
  end;
  if not CurrentToken.IsEmpty then Result := Result + [CurrentToken];
end;

class function TAdvancedSQLFormatter.Format(const ASql: string): string;
var
  Tokens: TArray<string>;
  Token, UpperToken, PrevUpper, LastLine: string;
  IndentLevel, InlineParenLevel: Integer;
  OutList: TStringList;

  procedure AddLine(const Text: string);
  begin
    OutList.Add(DupeString(INDENT_STR, IndentLevel) + Text);
  end;

  procedure AppendToLast(const Text: string; AddSpace: Boolean = True);
  var
    S: string;
  begin
    if OutList.Count = 0 then
      AddLine(Text)
    else
    begin
      S := '';
      if AddSpace then S := ' ';
      OutList[OutList.Count - 1] := OutList[OutList.Count - 1] + S + Text;
    end;
  end;

begin
  IndentLevel := 0;
  InlineParenLevel := 0;
  OutList := TStringList.Create;
  try
    Tokens := GetTokens(ASql);
    for var I := 0 to High(Tokens) do
    begin
      Token := Tokens[I];
      UpperToken := Token.ToUpper;
      if I > 0 then PrevUpper := Tokens[I-1].ToUpper else PrevUpper := '';

      // 1. СКОБКИ
      if UpperToken = '(' then
      begin
        if IsInlineContainer(PrevUpper) or (InlineParenLevel > 0) then
        begin
          AppendToLast('(', False);
          Inc(InlineParenLevel);
        end
        else
        begin
          AddLine('(');
          Inc(IndentLevel);
        end;
      end
      else if UpperToken = ')' then
      begin
        if InlineParenLevel > 0 then
        begin
          AppendToLast(')', False);
          Dec(InlineParenLevel);
        end
        else
        begin
          if IndentLevel > 0 then Dec(IndentLevel);
          AddLine(')');
        end;
      end

      // 2. СТРУКТУРНЫЕ КЛЮЧИ
      else if IsKeyWord(UpperToken) and (InlineParenLevel = 0) then
      begin
        LastLine := '';
        if OutList.Count > 0 then LastLine := OutList[OutList.Count-1].Trim.ToUpper;

        // UNION ALL - клеим
        if (UpperToken = 'ALL') and (LastLine = 'UNION') then
          AppendToLast(Token)
        else
          AddLine(UpperToken); // WHERE, GROUP, etc. теперь всегда с новой строки
      end
      // 3. СВЯЗКИ (JOIN, LEFT, OUTER, BY, ON, AS) - всегда клеим к текущей строке или операндам
      else if (UpperToken = 'JOIN') or (UpperToken = 'LEFT') or (UpperToken = 'RIGHT') or
              (UpperToken = 'INNER') or (UpperToken = 'OUTER') or (UpperToken = 'BY') or
              (UpperToken = 'ON') or (UpperToken = 'AS') or (UpperToken = 'ALL') then
      begin
        AppendToLast(Token);
      end
      else if UpperToken = ',' then
      begin
        AppendToLast(',', False);
      end
      // 4. ОПЕРАНДЫ (Имена полей, алиасы, значения и условия WHERE)
      else
      begin
        LastLine := '';
        if OutList.Count > 0 then LastLine := OutList[OutList.Count-1].Trim.ToUpper;

        // Добавлено условие: если последняя строка WHERE, то операнд (условие) клеится к нему
        if (OutList.Count > 0) and
           ( (InlineParenLevel > 0) or
             (LastLine.EndsWith('SELECT')) or (LastLine.EndsWith('FROM')) or
             (LastLine.EndsWith('WHERE')) or (LastLine.EndsWith('HAVING')) or
             (LastLine.EndsWith(',')) or (LastLine.EndsWith('(')) or (LastLine.EndsWith(')')) or
             (LastLine.EndsWith('ON')) or (LastLine.EndsWith('BY')) or (LastLine.EndsWith('AS')) or
             (not IsKeyWord(LastLine)) ) then
        begin
          var SpaceNeeded: Boolean := not OutList[OutList.Count - 1].EndsWith('(');
          AppendToLast(Token, SpaceNeeded);
        end
        else
          AddLine(Token);
      end;
    end;
    Result := OutList.Text;
  finally
    OutList.Free;
  end;
end;

end.
