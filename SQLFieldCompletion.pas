unit SQLFieldCompletion;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Generics.Defaults, DBModule;

type
  TSQLTableRef = record
    TableName: string;
    Schema: string;
    Found: Boolean;
  end;

function SQLUnquoteIdent(const AName: string): string;
function SQLFindLastDotBeforeCaret(const ALine: string; ACaretX: Integer): Integer;
function SQLIsActiveColumnCompletionContext(const ALine: string; ACaretX: Integer): Boolean;
function SQLGetColumnFilterAfterDot(const ALine: string; ACaretX: Integer): string;
function SQLGetTableRefBeforeCaret(const ALine: string; ACaretX: Integer;
  out ATableOrAlias, ASchemaHint: string): Boolean;
function SQLResolveTableRef(const ASQL, ATableOrAlias, ASchemaHint: string;
  ADB: TSQLiteHandler): TSQLTableRef;
function SQLGetColumnNames(ADB: TSQLiteHandler; const ATableRef: TSQLTableRef): TArray<string>;
function SQLGetTableListFilterStart(const ALine: string; ACaretX: Integer): Integer;
function SQLGetTableListContext(const ALine: string; ACaretX: Integer;
  out AFilter, ASchemaPrefix: string): Boolean;
function SQLGetDatabaseObjectNames(ADB: TSQLiteHandler;
  const ASchemaPrefix: string): TArray<string>;

implementation

const
  SQLKeywords: array[0..38] of string = (
    'SELECT', 'FROM', 'WHERE', 'JOIN', 'INNER', 'LEFT', 'RIGHT', 'OUTER', 'CROSS',
    'NATURAL', 'ON', 'AND', 'OR', 'NOT', 'IN', 'IS', 'NULL', 'LIKE', 'BETWEEN',
    'GROUP', 'BY', 'ORDER', 'HAVING', 'LIMIT', 'OFFSET', 'UNION', 'ALL', 'AS',
    'DISTINCT', 'CASE', 'WHEN', 'THEN', 'ELSE', 'END', 'EXISTS', 'INTO', 'INSERT',
    'UPDATE', 'SET'
  );

function SQLUnquoteIdent(const AName: string): string;
begin
  Result := Trim(AName);
  if (Length(Result) >= 2) and (Result[1] = '"') and (Result[Length(Result)] = '"') then
    Result := Copy(Result, 2, Length(Result) - 2);
end;

function SQLFindLastDotBeforeCaret(const ALine: string; ACaretX: Integer): Integer;
var
  I, LastPos: Integer;
begin
  Result := 0;
  if (ACaretX <= 1) or (Length(ALine) = 0) then
    Exit;
  LastPos := ACaretX - 1;
  if LastPos > Length(ALine) then
    LastPos := Length(ALine);
  for I := LastPos downto 1 do
    if ALine[I] = '.' then
      Exit(I);
end;

function SQLIsActiveColumnCompletionContext(const ALine: string; ACaretX: Integer): Boolean;
var
  DotPos, I: Integer;
begin
  Result := False;
  DotPos := SQLFindLastDotBeforeCaret(ALine, ACaretX);
  if DotPos = 0 then
    Exit;
  for I := DotPos + 1 to ACaretX - 1 do
    if not CharInSet(ALine[I], ['A'..'Z', 'a'..'z', '0'..'9', '_', '"']) then
      Exit;
  Result := True;
end;

function SQLGetColumnFilterAfterDot(const ALine: string; ACaretX: Integer): string;
var
  DotPos: Integer;
begin
  DotPos := SQLFindLastDotBeforeCaret(ALine, ACaretX);
  if DotPos = 0 then
    Exit('');
  Result := Copy(ALine, DotPos + 1, ACaretX - DotPos - 1);
end;

function SQLGetTableRefBeforeCaret(const ALine: string; ACaretX: Integer;
  out ATableOrAlias, ASchemaHint: string): Boolean;
var
  BeforeCaret, RefPart: string;
  LastDot, DotPos, StartPos: Integer;
begin
  Result := False;
  ATableOrAlias := '';
  ASchemaHint := '';
  if (ACaretX < 1) or (ACaretX > Length(ALine) + 1) then
    Exit;

  BeforeCaret := Copy(ALine, 1, ACaretX - 1);
  LastDot := SQLFindLastDotBeforeCaret(ALine, ACaretX);
  if LastDot = 0 then
    Exit;

  StartPos := LastDot - 1;
  while (StartPos >= 1) and (StartPos <= Length(BeforeCaret)) and
        CharInSet(BeforeCaret[StartPos], ['A'..'Z', 'a'..'z', '0'..'9', '_', '"', '.']) do
    Dec(StartPos);
  Inc(StartPos);

  RefPart := Copy(BeforeCaret, StartPos, LastDot - StartPos);
  if RefPart = '' then
    Exit;

  DotPos := LastDelimiter('.', RefPart);
  if DotPos > 0 then
  begin
    ASchemaHint := SQLUnquoteIdent(Copy(RefPart, 1, DotPos - 1));
    ATableOrAlias := SQLUnquoteIdent(Copy(RefPart, DotPos + 1, MaxInt));
  end
  else
  begin
    ASchemaHint := '';
    ATableOrAlias := SQLUnquoteIdent(RefPart);
  end;

  Result := ATableOrAlias <> '';
end;

function SQLIsKeyword(const AWord: string): Boolean;
var
  I: Integer;
  U: string;
begin
  U := UpperCase(Trim(AWord));
  if U = '' then
    Exit(False);
  for I := Low(SQLKeywords) to High(SQLKeywords) do
    if U = SQLKeywords[I] then
      Exit(True);
  Result := False;
end;

procedure SQLSkipWhitespace(const S: string; var P: Integer);
begin
  while (P <= Length(S)) and CharInSet(S[P], [#9, #10, #13, ' ']) do
    Inc(P);
end;

function SQLReadQuotedIdent(const S: string; var P: Integer): string;
var
  Start: Integer;
begin
  Result := '';
  if (P > Length(S)) or (S[P] <> '"') then
    Exit;
  Inc(P);
  Start := P;
  while P <= Length(S) do
  begin
    if S[P] = '"' then
    begin
      if (P < Length(S)) and (S[P + 1] = '"') then
      begin
        Inc(P, 2);
        Continue;
      end;
      Result := Copy(S, Start, P - Start);
      Result := StringReplace(Result, '""', '"', [rfReplaceAll]);
      Inc(P);
      Exit;
    end;
    Inc(P);
  end;
end;

function SQLReadBareIdent(const S: string; var P: Integer): string;
var
  Start: Integer;
begin
  Result := '';
  if P > Length(S) then
    Exit;
  if not CharInSet(S[P], ['A'..'Z', 'a'..'z', '_']) then
    Exit;
  Start := P;
  Inc(P);
  while (P <= Length(S)) and CharInSet(S[P], ['A'..'Z', 'a'..'z', '0'..'9', '_']) do
    Inc(P);
  Result := Copy(S, Start, P - Start);
end;

function SQLReadIdent(const S: string; var P: Integer): string;
begin
  if (P <= Length(S)) and (S[P] = '"') then
    Result := SQLReadQuotedIdent(S, P)
  else
    Result := SQLReadBareIdent(S, P);
end;

procedure SQLReadTableReference(const S: string; var P: Integer;
  out ASchema, ATable: string);
var
  Part1, Part2: string;
begin
  ASchema := '';
  ATable := '';
  SQLSkipWhitespace(S, P);
  if P > Length(S) then
    Exit;

  Part1 := SQLReadIdent(S, P);
  if Part1 = '' then
    Exit;

  SQLSkipWhitespace(S, P);
  if (P <= Length(S)) and (S[P] = '.') then
  begin
    Inc(P);
    Part2 := SQLReadIdent(S, P);
    if Part2 <> '' then
    begin
      ASchema := SQLUnquoteIdent(Part1);
      ATable := SQLUnquoteIdent(Part2);
      Exit;
    end;
    Dec(P);
  end;

  ATable := SQLUnquoteIdent(Part1);
end;

function SQLMatchKeyword(const S: string; var P: Integer; const AKeyword: string): Boolean;
var
  U, KW: string;
  Len: Integer;
begin
  Result := False;
  SQLSkipWhitespace(S, P);
  if P > Length(S) then
    Exit;

  U := UpperCase(S);
  KW := UpperCase(AKeyword);
  Len := Length(KW);
  if P + Len - 1 > Length(S) then
    Exit;

  if Copy(U, P, Len) <> KW then
    Exit;

  if (P + Len <= Length(S)) and CharInSet(S[P + Len], ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
    Exit;

  Inc(P, Len);
  Result := True;
end;

procedure SQLRegisterAlias(AMap: TDictionary<string, TSQLTableRef>;
  const AAlias, ATable, ASchema: string);
var
  Ref: TSQLTableRef;
  Key: string;
begin
  if AAlias = '' then
    Exit;
  Key := UpperCase(SQLUnquoteIdent(AAlias));
  Ref.TableName := ATable;
  Ref.Schema := ASchema;
  Ref.Found := True;
  AMap.AddOrSetValue(Key, Ref);
end;

procedure SQLRegisterTableAlias(AMap: TDictionary<string, TSQLTableRef>;
  var P: Integer; const S: string);
var
  Schema, Table, NextToken: string;
  SaveP: Integer;
begin
  SQLReadTableReference(S, P, Schema, Table);
  if Table = '' then
    Exit;

  SQLRegisterAlias(AMap, Table, Table, Schema);

  SQLSkipWhitespace(S, P);
  if SQLMatchKeyword(S, P, 'AS') then
    SQLSkipWhitespace(S, P);

  SaveP := P;
  NextToken := SQLReadIdent(S, P);
  if (NextToken <> '') and not SQLIsKeyword(NextToken) then
    SQLRegisterAlias(AMap, NextToken, Table, Schema)
  else
    P := SaveP;
end;

procedure SQLParseTableContext(const ASQL: string; AMap: TDictionary<string, TSQLTableRef>);
var
  S: string;
  P: Integer;
begin
  S := ASQL;
  P := 1;
  while P <= Length(S) do
  begin
    if SQLMatchKeyword(S, P, 'FROM') or SQLMatchKeyword(S, P, 'UPDATE') or
       SQLMatchKeyword(S, P, 'INTO') then
      SQLRegisterTableAlias(AMap, P, S)
    else if SQLMatchKeyword(S, P, 'INNER') or SQLMatchKeyword(S, P, 'LEFT') or
            SQLMatchKeyword(S, P, 'RIGHT') or SQLMatchKeyword(S, P, 'CROSS') or
            SQLMatchKeyword(S, P, 'NATURAL') then
    begin
      SQLSkipWhitespace(S, P);
      while SQLMatchKeyword(S, P, 'OUTER') or SQLMatchKeyword(S, P, 'INNER') or
            SQLMatchKeyword(S, P, 'LEFT') or SQLMatchKeyword(S, P, 'RIGHT') or
            SQLMatchKeyword(S, P, 'CROSS') or SQLMatchKeyword(S, P, 'NATURAL') do
        SQLSkipWhitespace(S, P);
      if SQLMatchKeyword(S, P, 'JOIN') then
        SQLRegisterTableAlias(AMap, P, S);
    end
    else if SQLMatchKeyword(S, P, 'JOIN') then
      SQLRegisterTableAlias(AMap, P, S)
    else
      Inc(P);
  end;
end;

function SQLObjectExists(ADB: TSQLiteHandler; const AName, ASchema: string): Boolean;
var
  Structure: TDatabaseStructure;
  Attached: TArray<TAttachedDatabase>;
  I, J: Integer;
  SchemaName: string;
begin
  Result := False;
  if not ADB.IsOpen then
    Exit;

  if ASchema <> '' then
  begin
    Structure := ADB.GetDatabaseStructure(ASchema);
    for I := 0 to High(Structure.Tables) do
      if SameText(Structure.Tables[I], AName) then
        Exit(True);
    for I := 0 to High(Structure.Views) do
      if SameText(Structure.Views[I], AName) then
        Exit(True);
    Exit;
  end;

  Structure := ADB.GetDatabaseStructure('main');
  for I := 0 to High(Structure.Tables) do
    if SameText(Structure.Tables[I], AName) then
      Exit(True);
  for I := 0 to High(Structure.Views) do
    if SameText(Structure.Views[I], AName) then
      Exit(True);

  Attached := ADB.GetAttachedDatabases;
  for I := 0 to High(Attached) do
  begin
    if Attached[I].IsMain then
      Continue;
    SchemaName := Attached[I].Name;
    Structure := ADB.GetDatabaseStructure(SchemaName);
    for J := 0 to High(Structure.Tables) do
      if SameText(Structure.Tables[J], AName) then
        Exit(True);
    for J := 0 to High(Structure.Views) do
      if SameText(Structure.Views[J], AName) then
        Exit(True);
  end;
end;

function SQLFindObjectSchema(ADB: TSQLiteHandler; const AName: string): string;
var
  Structure: TDatabaseStructure;
  Attached: TArray<TAttachedDatabase>;
  I, J: Integer;
begin
  Result := '';
  if not ADB.IsOpen then
    Exit;

  Structure := ADB.GetDatabaseStructure('main');
  for I := 0 to High(Structure.Tables) do
    if SameText(Structure.Tables[I], AName) then
      Exit('main');
  for I := 0 to High(Structure.Views) do
    if SameText(Structure.Views[I], AName) then
      Exit('main');

  Attached := ADB.GetAttachedDatabases;
  for I := 0 to High(Attached) do
  begin
    if Attached[I].IsMain then
      Continue;
    Structure := ADB.GetDatabaseStructure(Attached[I].Name);
    for J := 0 to High(Structure.Tables) do
      if SameText(Structure.Tables[J], AName) then
        Exit(Attached[I].Name);
    for J := 0 to High(Structure.Views) do
      if SameText(Structure.Views[J], AName) then
        Exit(Attached[I].Name);
  end;
end;

function SQLResolveTableRef(const ASQL, ATableOrAlias, ASchemaHint: string;
  ADB: TSQLiteHandler): TSQLTableRef;
var
  AliasMap: TDictionary<string, TSQLTableRef>;
  RefName, Schema: string;
  MapRef: TSQLTableRef;
begin
  Result.Found := False;
  Result.TableName := '';
  Result.Schema := '';

  if not ADB.IsOpen then
    Exit;

  RefName := SQLUnquoteIdent(ATableOrAlias);
  if RefName = '' then
    Exit;

  if ASchemaHint <> '' then
  begin
    if SQLObjectExists(ADB, RefName, ASchemaHint) then
    begin
      Result.TableName := RefName;
      Result.Schema := ASchemaHint;
      Result.Found := True;
      Exit;
    end;
  end;

  Schema := SQLFindObjectSchema(ADB, RefName);
  if Schema <> '' then
  begin
    Result.TableName := RefName;
    Result.Schema := Schema;
    Result.Found := True;
    Exit;
  end;

  AliasMap := TDictionary<string, TSQLTableRef>.Create;
  try
    SQLParseTableContext(ASQL, AliasMap);
    if AliasMap.TryGetValue(UpperCase(RefName), MapRef) then
    begin
      Result := MapRef;
      if Result.Schema = '' then
        Result.Schema := SQLFindObjectSchema(ADB, Result.TableName);
      if Result.Schema = '' then
        Result.Schema := 'main';
      Result.Found := Length(ADB.GetTableInfo(Result.TableName, Result.Schema)) > 0;
    end;
  finally
    AliasMap.Free;
  end;
end;

function SQLFindLastTableListKeywordPos(const S: string): Integer;
var
  P, AfterKw: Integer;
begin
  Result := 0;
  P := 1;
  while P <= Length(S) do
  begin
    AfterKw := P;
    if SQLMatchKeyword(S, AfterKw, 'FROM') or SQLMatchKeyword(S, AfterKw, 'JOIN') then
    begin
      if AfterKw > Result then
        Result := AfterKw;
      P := AfterKw;
    end
    else
      Inc(P);
  end;
end;

procedure SQLSkipJoinModifiers(const S: string; var P: Integer);
begin
  SQLSkipWhitespace(S, P);
  while SQLMatchKeyword(S, P, 'OUTER') or SQLMatchKeyword(S, P, 'INNER') or
        SQLMatchKeyword(S, P, 'LEFT') or SQLMatchKeyword(S, P, 'RIGHT') or
        SQLMatchKeyword(S, P, 'CROSS') or SQLMatchKeyword(S, P, 'NATURAL') do
    SQLSkipWhitespace(S, P);
  SQLMatchKeyword(S, P, 'JOIN');
  SQLSkipWhitespace(S, P);
end;

function SQLGetTableListFilterStart(const ALine: string; ACaretX: Integer): Integer;
var
  P: Integer;
begin
  Result := ACaretX;
  if ACaretX <= 1 then
    Exit;
  P := ACaretX - 1;
  if P > Length(ALine) then
    Exit;
  while (P >= 1) and (P <= Length(ALine)) and
        CharInSet(ALine[P], ['A'..'Z', 'a'..'z', '0'..'9', '_', '"', '.']) do
    Dec(P);
  Result := P + 1;
end;

function SQLIsSpaceAfterFromOrJoin(const BeforeCaret: string): Boolean;
var
  KeywordPos, P: Integer;
begin
  Result := False;
  if BeforeCaret = '' then
    Exit;

  if not CharInSet(BeforeCaret[Length(BeforeCaret)], [#9, #10, #13, ' ']) then
    Exit;

  KeywordPos := SQLFindLastTableListKeywordPos(BeforeCaret);
  if KeywordPos = 0 then
    Exit;

  P := KeywordPos;
  SQLSkipJoinModifiers(BeforeCaret, P);
  SQLSkipWhitespace(BeforeCaret, P);

  while P <= Length(BeforeCaret) do
  begin
    if not CharInSet(BeforeCaret[P], [#9, #10, #13, ' ']) then
      Exit;
    Inc(P);
  end;
  Result := True;
end;

function SQLGetTableListContext(const ALine: string; ACaretX: Integer;
  out AFilter, ASchemaPrefix: string): Boolean;
var
  BeforeCaret: string;
begin
  Result := False;
  AFilter := '';
  ASchemaPrefix := '';
  if (ACaretX < 1) or (ACaretX > Length(ALine) + 1) then
    Exit;

  BeforeCaret := Copy(ALine, 1, ACaretX - 1);
  Result := SQLIsSpaceAfterFromOrJoin(BeforeCaret);
end;

function SQLGetDatabaseObjectNames(ADB: TSQLiteHandler;
  const ASchemaPrefix: string): TArray<string>;
var
  Structure: TDatabaseStructure;
  Attached: TArray<TAttachedDatabase>;
  Names: TList<string>;
  I: Integer;
  SchemaName, Prefix: string;

  procedure AddSchemaObjects(const ASchema, APrefix: string);
  var
    K: Integer;
  begin
    Structure := ADB.GetDatabaseStructure(ASchema);
    for K := 0 to High(Structure.Tables) do
      Names.Add(APrefix + Structure.Tables[K]);
    for K := 0 to High(Structure.Views) do
      Names.Add(APrefix + Structure.Views[K]);
  end;

begin
  SetLength(Result, 0);
  if not ADB.IsOpen then
    Exit;

  Names := TList<string>.Create;
  try
    if (ASchemaPrefix = '') or SameText(ASchemaPrefix, 'main') then
      AddSchemaObjects('main', '');

    Attached := ADB.GetAttachedDatabases;
    for I := 0 to High(Attached) do
    begin
      if Attached[I].IsMain then
        Continue;
      SchemaName := Attached[I].Name;
      if (ASchemaPrefix = '') or SameText(ASchemaPrefix, SchemaName) then
      begin
        if ASchemaPrefix = '' then
          Prefix := SchemaName + '.'
        else
          Prefix := '';
        AddSchemaObjects(SchemaName, Prefix);
      end;
    end;

    Names.Sort;
    SetLength(Result, Names.Count);
    for I := 0 to Names.Count - 1 do
      Result[I] := Names[I];
  finally
    Names.Free;
  end;
end;

function SQLGetColumnNames(ADB: TSQLiteHandler; const ATableRef: TSQLTableRef): TArray<string>;
var
  Cols: TArray<TColumnDef>;
  I: Integer;
  Schema: string;
begin
  SetLength(Result, 0);
  if not ATableRef.Found then
    Exit;

  Schema := ATableRef.Schema;
  if Schema = '' then
    Schema := 'main';

  Cols := ADB.GetTableInfo(ATableRef.TableName, Schema);
  SetLength(Result, Length(Cols));
  for I := 0 to High(Cols) do
    Result[I] := Cols[I].Name;
end;

end.
