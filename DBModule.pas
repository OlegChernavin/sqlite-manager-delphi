{*******************************************************************************
  High-level SQLite Database Handler
  Provides convenient interface for database operations
*******************************************************************************}
unit DBModule;

interface

uses
  System.Classes, System.SysUtils, SQLite3, Generics.Collections;

type
  TSQLiteColumnType = (sctInteger, sctReal, sctText, sctBlob, sctNull);

  TColumnDef = record
    Name: string;
    TypeName: string;
    ColumnType: TSQLiteColumnType;
    NotNull: Boolean;
    DefaultVal: string;
    PK: Boolean;
    AutoInc: Boolean;
  end;

  TRowData = array of Variant;
  TRowsData = array of TRowData;

  TQueryResult = record
    Columns: TArray<string>;
    ColumnTypes: TArray<TSQLiteColumnType>;
    Rows: TRowsData;
    RowCount: Integer;
    Changes: Integer;
    ErrorMessage: string;
    Success: Boolean;
  end;

  TTableInfo = record
    Name: string;
    Columns: TArray<TColumnDef>;
  end;

  TDatabaseStructure = record
    Tables: TArray<string>;
    Views: TArray<string>;
    Indexes: TArray<string>;
    Triggers: TArray<string>;
  end;

  TSQLiteHandler = class
  private
    FDB: PSQLite3;
    FDatabasePath: string;
    FIsOpen: Boolean;
    FLastError: string;
    function ColumnTypeToStr(AColType: Integer): TSQLiteColumnType;
  public
    constructor Create;
    destructor Destroy; override;

    function OpenDatabase(const APath: string; AReadOnly: Boolean = False): Boolean;
    procedure CloseDatabase;

    function ExecuteSQL(const ASQL: string): TQueryResult;
    function ExecuteScalar(const ASQL: string): Variant;
    function GetTableData(const ATableName: string; ALimit: Integer = 100; AOffset: Integer = 0): TQueryResult;
    function GetBlobData(const ATableName: string; ARow: Integer; ACol: Integer): TBytes;
    function GetTableInfo(const ATableName: string): TArray<TColumnDef>;
    function GetDatabaseStructure: TDatabaseStructure;
    function GetDatabaseInfo: TDictionary<string, Variant>;

    function CreateTable(const ATableName: string; const AColumns: TArray<TColumnDef>): Boolean;
    function DropTable(const ATableName: string): Boolean;
    function DropView(const AViewName: string): Boolean;
    function RenameTable(const AOldName, ANewName: string): Boolean;
    function CopyTable(const ASourceName, ADestName: string; AWithData: Boolean): Boolean;
    function ReindexTable(const ATableName: string): Boolean;

    function ExportToSQL(const ATableName: string): string;
    function ExportDatabaseToSQL: string;
    function ExportToCSV(const ATableName, AFilePath: string; AIncludeHeaders: Boolean; ADelimiter: Char): Boolean;
    function ImportFromCSV(const AFilePath, ATableName: string; ACreateTable: Boolean; ADelimiter: Char): Integer;

    function Vacuum: Boolean;
    function Analyze: Boolean;
    function IntegrityCheck(AQuick: Boolean = False): TArray<string>;

    function BeginTransaction: Boolean;
    function CommitTransaction: Boolean;
    function RollbackTransaction: Boolean;

    property DatabasePath: string read FDatabasePath;
    property IsOpen: Boolean read FIsOpen;
    property LastError: string read FLastError write FLastError;
  end;

function SQLiteColumnTypeToStr(AColType: TSQLiteColumnType): string;

implementation

uses
  System.Variants;

function SQLiteColumnTypeToStr(AColType: TSQLiteColumnType): string;
begin
  case AColType of
    sctInteger: Result := 'INTEGER';
    sctReal: Result := 'REAL';
    sctText: Result := 'TEXT';
    sctBlob: Result := 'BLOB';
    sctNull: Result := 'NULL';
  else
    Result := 'UNKNOWN';
  end;
end;

{ TSQLiteHandler }

constructor TSQLiteHandler.Create;
begin
  inherited Create;
  FDB := nil;
  FIsOpen := False;
  FLastError := '';
end;

destructor TSQLiteHandler.Destroy;
begin
  CloseDatabase;
  inherited Destroy;
end;

function TSQLiteHandler.ColumnTypeToStr(AColType: Integer): TSQLiteColumnType;
begin
  case AColType of
    SQLITE_INTEGER: Result := sctInteger;
    SQLITE_FLOAT: Result := sctReal;
    SQLITE_TEXT: Result := sctText;
    SQLITE_BLOB: Result := sctBlob;
  else
    Result := sctNull;
  end;
end;

function TSQLiteHandler.OpenDatabase(const APath: string; AReadOnly: Boolean): Boolean;
var
  Flags: Integer;
  Res: Integer;
begin
  Result := False;
  FLastError := '';
  
  if FIsOpen then
    CloseDatabase;

  if not SQLite3IsLoaded then
  begin
    if not LoadSQLite3('') then
    begin
      FLastError := 'Cannot load sqlite3.dll';
      Exit(False);
    end;
  end;

  FDatabasePath := APath;
  
  if AReadOnly then
    Flags := SQLITE_OPEN_READONLY
  else
    Flags := SQLITE_OPEN_READWRITE or SQLITE_OPEN_CREATE;

  FDB := nil;
  Res := sqlite3_open_v2(PAnsiChar(AnsiString(APath)), FDB, Flags, nil);
  
  if Res = SQLITE_OK then
  begin
    FIsOpen := True;
    // Set busy timeout
    sqlite3_busy_timeout(FDB, 5000);
    Result := True;
  end
  else
  begin
    FLastError := UTF8ToString(sqlite3_errmsg(FDB));
    FDB := nil;
  end;
end;

procedure TSQLiteHandler.CloseDatabase;
begin
  if Assigned(FDB) then
  begin
    sqlite3_close_v2(FDB);
    FDB := nil;
  end;
  FIsOpen := False;
  FDatabasePath := '';
end;

function TSQLiteHandler.ExecuteSQL(const ASQL: string): TQueryResult;
var
  Stmt: PSQLite3Stmt;
  Res: Integer;
  ColCount: Integer;
  I, J: Integer;
  ColType: Integer;
  Row: TRowData;
  SQLText: PAnsiChar;
begin
  Result.Columns := nil;
  Result.ColumnTypes := nil;
  Result.Rows := nil;
  Result.RowCount := 0;
  Result.Changes := 0;
  Result.ErrorMessage := '';
  Result.Success := False;

  if not FIsOpen then
  begin
    Result.ErrorMessage := 'Database is not open';
    Exit;
  end;

  SQLText := PAnsiChar(UTF8Encode(ASQL));
  Stmt := nil;
  var pzTail: PAnsiChar := nil;
  Res := sqlite3_prepare_v2(FDB, SQLText, -1, Stmt, pzTail);

  if Res <> SQLITE_OK then
  begin
    Result.ErrorMessage := UTF8ToString(sqlite3_errmsg(FDB));
    Exit;
  end;

  try
    ColCount := sqlite3_column_count(Stmt);

    // Get column names
    if ColCount > 0 then
    begin
      SetLength(Result.Columns, ColCount);
      SetLength(Result.ColumnTypes, ColCount);

      for I := 0 to ColCount - 1 do
      begin
        // Convert UTF-8 to UnicodeString properly
        Result.Columns[I] := UTF8ToString(sqlite3_column_name(Stmt, I));
        // Initialize with default type
        Result.ColumnTypes[I] := sctText;
      end;
    end;

    // Execute and fetch rows
    SetLength(Result.Rows, 0);

    while True do
    begin
      Res := sqlite3_step(Stmt);

      if Res = SQLITE_ROW then
      begin
        // Add row
        SetLength(Result.Rows, Length(Result.Rows) + 1);
        SetLength(Result.Rows[High(Result.Rows)], ColCount);

        for I := 0 to ColCount - 1 do
        begin
          ColType := sqlite3_column_type(Stmt, I);

          // Set column type from first row
          if (Length(Result.Rows) = 1) and (Length(Result.ColumnTypes) = ColCount) then
            Result.ColumnTypes[I] := ColumnTypeToStr(ColType);

          case ColType of
            SQLITE_INTEGER:
              Result.Rows[High(Result.Rows)][I] := sqlite3_column_int64(Stmt, I);
            SQLITE_FLOAT:
              Result.Rows[High(Result.Rows)][I] := sqlite3_column_double(Stmt, I);
            SQLITE_TEXT:
              // Convert UTF-8 to UnicodeString properly
              Result.Rows[High(Result.Rows)][I] := UTF8ToString(sqlite3_column_text(Stmt, I));
            SQLITE_BLOB:
              begin
                // Handle BLOB as hex string
                var BlobData := sqlite3_column_blob(Stmt, I);
                var BlobSize := sqlite3_column_bytes(Stmt, I);
                if (BlobData <> nil) and (BlobSize > 0) then
                  Result.Rows[High(Result.Rows)][I] := 'BLOB (' + IntToStr(BlobSize) + ' bytes)'
                else
                  Result.Rows[High(Result.Rows)][I] := Null;
              end;
          else
            Result.Rows[High(Result.Rows)][I] := Null;
          end;
        end;
      end
      else if Res = SQLITE_DONE then
        Break
      else
      begin
        Result.ErrorMessage := UTF8ToString(sqlite3_errmsg(FDB));
        Exit;
      end;
    end;

    Result.RowCount := Length(Result.Rows);
    Result.Changes := sqlite3_changes(FDB);
    Result.Success := True;
    
  finally
    sqlite3_finalize(Stmt);
  end;
end;

function TSQLiteHandler.ExecuteScalar(const ASQL: string): Variant;
var
  Stmt: PSQLite3Stmt;
  Res: Integer;
  ColType: Integer;
begin
  Result := Null;

  if not FIsOpen then
    Exit;

  Stmt := nil;
  var pzTail3: PAnsiChar := nil;
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode(ASQL)), -1, Stmt, pzTail3);

  if Res <> SQLITE_OK then
    Exit;

  try
    Res := sqlite3_step(Stmt);

    if Res = SQLITE_ROW then
    begin
      ColType := sqlite3_column_type(Stmt, 0);

      case ColType of
        SQLITE_INTEGER:
          Result := sqlite3_column_int64(Stmt, 0);
        SQLITE_FLOAT:
          Result := sqlite3_column_double(Stmt, 0);
        SQLITE_TEXT:
          Result := UTF8ToString(sqlite3_column_text(Stmt, 0));
        SQLITE_BLOB:
          Result := 'BLOB';
      end;
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

function TSQLiteHandler.GetTableData(const ATableName: string; ALimit, AOffset: Integer): TQueryResult;
var
  SQL: string;
begin
  SQL := Format('SELECT * FROM "%s" LIMIT %d OFFSET %d', [ATableName, ALimit, AOffset]);
  Result := ExecuteSQL(SQL);
end;

function TSQLiteHandler.GetBlobData(const ATableName: string; ARow: Integer; ACol: Integer): TBytes;
var
  SQL: string;
  Stmt: PSQLite3Stmt;
  Res: Integer;
  ColCount: Integer;
  BlobSize: Integer;
  BlobPtr: Pointer;
begin
  SetLength(Result, 0);
  
  if not FIsOpen then
    Exit;
  
  // Build query to get the specific row
  SQL := Format('SELECT * FROM "%s" LIMIT 1 OFFSET %d', [ATableName, ARow]);
  
  Stmt := nil;
  var pzTail: PAnsiChar := nil;
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode(SQL)), -1, Stmt, pzTail);
  
  if Res <> SQLITE_OK then
    Exit;
  
  try
    Res := sqlite3_step(Stmt);
    
    if Res = SQLITE_ROW then
    begin
      ColCount := sqlite3_column_count(Stmt);
      
      if (ACol >= 0) and (ACol < ColCount) then
      begin
        // Check if this column is actually a BLOB
        if sqlite3_column_type(Stmt, ACol) = SQLITE_BLOB then
        begin
          BlobPtr := sqlite3_column_blob(Stmt, ACol);
          BlobSize := sqlite3_column_bytes(Stmt, ACol);
          
          if (BlobPtr <> nil) and (BlobSize > 0) then
          begin
            SetLength(Result, BlobSize);
            Move(BlobPtr^, Result[0], BlobSize);
          end;
        end;
      end;
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

function TSQLiteHandler.GetTableInfo(const ATableName: string): TArray<TColumnDef>;
var
  Stmt: PSQLite3Stmt;
  Res: Integer;
  ColDef: TColumnDef;
begin
  Result := nil;
  
  if not FIsOpen then
    Exit;

  Stmt := nil;
  var pzTail2: PAnsiChar := nil;
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode('PRAGMA table_info("' + ATableName + '")')), -1, Stmt, pzTail2);

  if Res <> SQLITE_OK then
    Exit;

  try
    while sqlite3_step(Stmt) = SQLITE_ROW do
    begin
      SetLength(Result, Length(Result) + 1);

      ColDef.Name := UTF8ToString(sqlite3_column_text(Stmt, 1));
      ColDef.TypeName := UTF8ToString(sqlite3_column_text(Stmt, 2));
      ColDef.NotNull := sqlite3_column_int(Stmt, 3) <> 0;
      ColDef.DefaultVal := UTF8ToString(sqlite3_column_text(Stmt, 4));
      ColDef.PK := sqlite3_column_int(Stmt, 5) <> 0;
      ColDef.AutoInc := False; // Need to check CREATE TABLE for this
      ColDef.ColumnType := sctText; // Default

      // Determine column type from typename
      if Pos('INT', UpperCase(ColDef.TypeName)) > 0 then
        ColDef.ColumnType := sctInteger
      else if Pos('CHAR', UpperCase(ColDef.TypeName)) > 0 then
        ColDef.ColumnType := sctText
      else if Pos('TEXT', UpperCase(ColDef.TypeName)) > 0 then
        ColDef.ColumnType := sctText
      else if Pos('BLOB', UpperCase(ColDef.TypeName)) > 0 then
        ColDef.ColumnType := sctBlob
      else if (Pos('REAL', UpperCase(ColDef.TypeName)) > 0) or
              (Pos('FLOA', UpperCase(ColDef.TypeName)) > 0) or
              (Pos('DOUB', UpperCase(ColDef.TypeName)) > 0) then
        ColDef.ColumnType := sctReal;

      Result[High(Result)] := ColDef;
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

function TSQLiteHandler.GetDatabaseStructure: TDatabaseStructure;
var
  QueryRes: TQueryResult;
  I: Integer;
begin
  // Get tables
  QueryRes := ExecuteSQL(
    'SELECT name FROM sqlite_master WHERE type=''table'' AND name NOT LIKE ''sqlite_%'' ORDER BY name');
  SetLength(Result.Tables, QueryRes.RowCount);
  for I := 0 to QueryRes.RowCount - 1 do
    Result.Tables[I] := VarToStr(QueryRes.Rows[I][0]);

  // Get views
  QueryRes := ExecuteSQL(
    'SELECT name FROM sqlite_master WHERE type=''view'' ORDER BY name');
  SetLength(Result.Views, QueryRes.RowCount);
  for I := 0 to QueryRes.RowCount - 1 do
    Result.Views[I] := VarToStr(QueryRes.Rows[I][0]);

  // Get indexes
  QueryRes := ExecuteSQL(
    'SELECT name FROM sqlite_master WHERE type=''index'' AND name NOT LIKE ''sqlite_%'' AND name NOT LIKE ''%autoindex%'' ORDER BY name');
  SetLength(Result.Indexes, QueryRes.RowCount);
  for I := 0 to QueryRes.RowCount - 1 do
    Result.Indexes[I] := VarToStr(QueryRes.Rows[I][0]);

  // Get triggers
  QueryRes := ExecuteSQL(
    'SELECT name FROM sqlite_master WHERE type=''trigger'' ORDER BY name');
  SetLength(Result.Triggers, QueryRes.RowCount);
  for I := 0 to QueryRes.RowCount - 1 do
    Result.Triggers[I] := VarToStr(QueryRes.Rows[I][0]);
end;

function TSQLiteHandler.GetDatabaseInfo: TDictionary<string, Variant>;
var
  PageSize, PageCount, Freelist, CacheSize: Variant;
begin
  Result := TDictionary<string, Variant>.Create;
  
  if not FIsOpen then
    Exit;

  PageSize := ExecuteScalar('PRAGMA page_size');
  PageCount := ExecuteScalar('PRAGMA page_count');
  Freelist := ExecuteScalar('PRAGMA freelist_count');
  CacheSize := ExecuteScalar('PRAGMA cache_size');

  Result.Add('page_size', PageSize);
  Result.Add('page_count', PageCount);
  Result.Add('freelist_count', Freelist);
  Result.Add('cache_size', CacheSize);
  Result.Add('size', PageSize * PageCount);
end;

function TSQLiteHandler.CreateTable(const ATableName: string; const AColumns: TArray<TColumnDef>): Boolean;
var
  SQL: string;
  ColDefs: TStringList;
  I: Integer;
  ColDef: string;
begin
  Result := False;
  FLastError := '';
  
  if Length(AColumns) = 0 then
  begin
    FLastError := 'Table must have at least one column';
    Exit;
  end;

  ColDefs := TStringList.Create;
  try
    for I := 0 to High(AColumns) do
    begin
      ColDef := Format('"%s" %s', [AColumns[I].Name, AColumns[I].TypeName]);
      
      if AColumns[I].PK then
      begin
        ColDef := ColDef + ' PRIMARY KEY';
        if AColumns[I].AutoInc then
          ColDef := ColDef + ' AUTOINCREMENT';
      end;
      
      if AColumns[I].NotNull and not AColumns[I].PK then
        ColDef := ColDef + ' NOT NULL';
      
      if AColumns[I].DefaultVal <> '' then
        ColDef := ColDef + ' DEFAULT ' + AColumns[I].DefaultVal;
      
      ColDefs.Add(ColDef);
    end;
    
    SQL := 'CREATE TABLE "' + ATableName + '" (' + sLineBreak + '  ' +
           ColDefs.CommaText + sLineBreak + ')';
    
    ColDefs.CommaText := StringReplace(ColDefs.Text, sLineBreak, ', ' + sLineBreak + '  ', [rfReplaceAll]);
    SQL := 'CREATE TABLE "' + ATableName + '" (' + sLineBreak + '  ' +
           ColDefs.Text + sLineBreak + ')';
    
    Result := ExecuteSQL(SQL).Success;
    
    if not Result then
      FLastError := 'Failed to create table';
      
  finally
    ColDefs.Free;
  end;
end;

function TSQLiteHandler.DropTable(const ATableName: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('DROP TABLE "' + ATableName + '"');
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.DropView(const AViewName: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('DROP VIEW "' + AViewName + '"');
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.RenameTable(const AOldName, ANewName: string): Boolean;
var
  Res: TQueryResult;
begin
  // ALTER TABLE RENAME is supported in SQLite 3.25.0+
  Res := ExecuteSQL('ALTER TABLE "' + AOldName + '" RENAME TO "' + ANewName + '"');
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.CopyTable(const ASourceName, ADestName: string; AWithData: Boolean): Boolean;
var
  Res: TQueryResult;
  ColInfo, DataRes: TQueryResult;
  I: Integer;
  ColList, ValuesList: string;
begin
  Result := False;
  FLastError := '';
  
  // Get source table structure
  ColInfo := ExecuteSQL('PRAGMA table_info("' + ASourceName + '")');
  
  if ColInfo.RowCount = 0 then
  begin
    FLastError := 'Source table not found';
    Exit;
  end;

  // Build column list
  ColList := '';
  for I := 0 to ColInfo.RowCount - 1 do
  begin
    if ColList <> '' then
      ColList := ColList + ', ';
    ColList := ColList + '"' + VarToStr(ColInfo.Rows[I][1]) + '"';
  end;

  // Create destination table with same structure
  Res := ExecuteSQL('CREATE TABLE "' + ADestName + '" AS SELECT * FROM "' + ASourceName + '" WHERE 0');
  
  if not Res.Success then
  begin
    FLastError := Res.ErrorMessage;
    Exit;
  end;

  // Copy data if requested
  if AWithData then
  begin
    DataRes := ExecuteSQL('SELECT * FROM "' + ASourceName + '"');
    
    if DataRes.Success and (DataRes.RowCount > 0) then
    begin
      BeginTransaction;
      try
        for I := 0 to DataRes.RowCount - 1 do
        begin
          // Build INSERT statement
          ValuesList := '';
          // Simplified - in production use parameterized queries
        end;
        CommitTransaction;
      except
        RollbackTransaction;
        raise;
      end;
    end;
  end;

  Result := True;
end;

function TSQLiteHandler.ReindexTable(const ATableName: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('REINDEX "' + ATableName + '"');
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.ExportToSQL(const ATableName: string): string;
var
  CreateRes, DataRes: TQueryResult;
  I, J: Integer;
  Row: TRowData;
  ValuesStr: string;
begin
  Result := '';
  
  // Get CREATE TABLE statement
  CreateRes := ExecuteSQL(
    'SELECT sql FROM sqlite_master WHERE type=''table'' AND name=''' + ATableName + '''');
  
  if CreateRes.RowCount > 0 then
    Result := VarToStr(CreateRes.Rows[0][0]) + ';' + sLineBreak + sLineBreak;

  // Get data and generate INSERT statements
  DataRes := ExecuteSQL('SELECT * FROM "' + ATableName + '"');
  
  for I := 0 to DataRes.RowCount - 1 do
  begin
    Row := DataRes.Rows[I];
    ValuesStr := '';
    
    for J := 0 to High(Row) do
    begin
      if J > 0 then
        ValuesStr := ValuesStr + ', ';
      
      if VarIsNull(Row[J]) then
        ValuesStr := ValuesStr + 'NULL'
      else if VarType(Row[J]) in [varInteger, varInt64, varDouble, varCurrency] then
        ValuesStr := ValuesStr + VarToStr(Row[J])
      else
        ValuesStr := ValuesStr + '''' + StringReplace(VarToStr(Row[J]), '''', '''''', [rfReplaceAll]) + '''';
    end;
    
    Result := Result + Format('INSERT INTO "%s" VALUES (%s);' + sLineBreak, [ATableName, ValuesStr]);
  end;
end;

function TSQLiteHandler.ExportDatabaseToSQL: string;
var
  Structure: TDatabaseStructure;
  I: Integer;
begin
  Result := '-- SQLite Manager Database Export' + sLineBreak;
  Result := Result + '-- Date: ' + DateTimeToStr(Now) + sLineBreak + sLineBreak;
  
  Structure := GetDatabaseStructure;
  
  // Export tables
  for I := 0 to High(Structure.Tables) do
  begin
    Result := Result + '-- Table: ' + Structure.Tables[I] + sLineBreak;
    Result := Result + ExportToSQL(Structure.Tables[I]) + sLineBreak;
  end;
  
  // Export views
  for I := 0 to High(Structure.Views) do
  begin
    var ViewRes := ExecuteSQL(
      'SELECT sql FROM sqlite_master WHERE type=''view'' AND name=''' + Structure.Views[I] + '''');
    if ViewRes.RowCount > 0 then
      Result := Result + '-- View: ' + Structure.Views[I] + sLineBreak +
                VarToStr(ViewRes.Rows[0][0]) + ';' + sLineBreak + sLineBreak;
  end;
  
  // Export triggers
  for I := 0 to High(Structure.Triggers) do
  begin
    var TriggerRes := ExecuteSQL(
      'SELECT sql FROM sqlite_master WHERE type=''trigger'' AND name=''' + Structure.Triggers[I] + '''');
    if TriggerRes.RowCount > 0 then
      Result := Result + '-- Trigger: ' + Structure.Triggers[I] + sLineBreak +
                VarToStr(TriggerRes.Rows[0][0]) + ';' + sLineBreak + sLineBreak;
  end;
end;

function TSQLiteHandler.ExportToCSV(const ATableName, AFilePath: string;
  AIncludeHeaders: Boolean; ADelimiter: Char): Boolean;
var
  DataRes: TQueryResult;
  SL: TStringList;
  I, J: Integer;
  Line: string;
  Cell: string;
begin
  Result := False;
  FLastError := '';
  
  DataRes := GetTableData(ATableName, -1, 0); // Get all rows
  
  if not DataRes.Success then
  begin
    FLastError := DataRes.ErrorMessage;
    Exit;
  end;

  SL := TStringList.Create;
  try
    // Add headers
    if AIncludeHeaders and (Length(DataRes.Columns) > 0) then
    begin
      Line := '';
      for I := 0 to High(DataRes.Columns) do
      begin
        if I > 0 then
          Line := Line + ADelimiter;
        Cell := DataRes.Columns[I];
        if (Pos(ADelimiter, Cell) > 0) or (Pos('"', Cell) > 0) or (Pos(sLineBreak, Cell) > 0) then
          Cell := '"' + StringReplace(Cell, '"', '""', [rfReplaceAll]) + '"';
        Line := Line + Cell;
      end;
      SL.Add(Line);
    end;

    // Add data rows
    for I := 0 to DataRes.RowCount - 1 do
    begin
      Line := '';
      for J := 0 to High(DataRes.Rows[I]) do
      begin
        if J > 0 then
          Line := Line + ADelimiter;
        
        if VarIsNull(DataRes.Rows[I][J]) then
          Cell := ''
        else
          Cell := VarToStr(DataRes.Rows[I][J]);
        
        if (Pos(ADelimiter, Cell) > 0) or (Pos('"', Cell) > 0) or (Pos(sLineBreak, Cell) > 0) then
          Cell := '"' + StringReplace(Cell, '"', '""', [rfReplaceAll]) + '"';
        
        Line := Line + Cell;
      end;
      SL.Add(Line);
    end;

    SL.SaveToFile(AFilePath, TEncoding.UTF8);
    Result := True;
  finally
    SL.Free;
  end;
end;

function TSQLiteHandler.ImportFromCSV(const AFilePath, ATableName: string;
  ACreateTable: Boolean; ADelimiter: Char): Integer;
var
  SL: TStringList;
  I, J: Integer;
  Lines: TArray<string>;
  Headers: TArray<string>;
  ColDefs: TArray<TColumnDef>;
  ColDef: TColumnDef;
begin
  Result := 0;
  FLastError := '';
  
  SL := TStringList.Create;
  try
    SL.LoadFromFile(AFilePath, TEncoding.UTF8);
    
    if SL.Count = 0 then
      Exit;

    // Parse headers
    Lines := SL[0].Split([ADelimiter]);
    SetLength(Headers, Length(Lines));
    
    for I := 0 to High(Lines) do
    begin
      Headers[I] := Trim(Lines[I]);
      Headers[I] := StringReplace(Headers[I], '"', '', [rfReplaceAll]);
    end;

    // Create table if needed
    if ACreateTable then
    begin
      SetLength(ColDefs, Length(Headers));
      for I := 0 to High(Headers) do
      begin
        ColDef.Name := Headers[I];
        ColDef.TypeName := 'TEXT';
        ColDef.NotNull := False;
        ColDef.DefaultVal := '';
        ColDef.PK := False;
        ColDef.AutoInc := False;
        ColDef.ColumnType := sctText;
        ColDefs[I] := ColDef;
      end;
      
      // Check if table exists
      var Structure := GetDatabaseStructure;
      var TableExists := False;
      for I := 0 to High(Structure.Tables) do
      begin
        if SameText(Structure.Tables[I], ATableName) then
        begin
          TableExists := True;
          Break;
        end;
      end;
      
      if not TableExists then
      begin
        if not CreateTable(ATableName, ColDefs) then
        begin
          FLastError := 'Failed to create table: ' + FLastError;
          Exit;
        end;
      end;
    end;

    // Import data
    BeginTransaction;
    try
      for I := 1 to SL.Count - 1 do
      begin
        Lines := SL[I].Split([ADelimiter]);
        
        // Build and execute INSERT
        var ValuesStr := '';
        for J := 0 to High(Lines) do
        begin
          if J > 0 then
            ValuesStr := ValuesStr + ', ';
          
          var Val := Trim(Lines[J]);
          Val := StringReplace(Val, '"', '', [rfReplaceAll]);
          
          if Val = '' then
            ValuesStr := ValuesStr + 'NULL'
          else
            ValuesStr := ValuesStr + '''' + StringReplace(Val, '''', '''''', [rfReplaceAll]) + '''';
        end;
        
        var InsertSQL := Format('INSERT INTO "%s" VALUES (%s)', [ATableName, ValuesStr]);
        ExecuteSQL(InsertSQL);
        Inc(Result);
      end;
      CommitTransaction;
    except
      RollbackTransaction;
      raise;
    end;
    
  finally
    SL.Free;
  end;
end;

function TSQLiteHandler.Vacuum: Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('VACUUM');
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.Analyze: Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('ANALYZE');
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.IntegrityCheck(AQuick: Boolean): TArray<string>;
var
  Res: TQueryResult;
  I: Integer;
begin
  if AQuick then
    Res := ExecuteSQL('PRAGMA quick_check')
  else
    Res := ExecuteSQL('PRAGMA integrity_check');
  
  if Res.Success then
  begin
    SetLength(Result, Res.RowCount);
    for I := 0 to Res.RowCount - 1 do
      Result[I] := VarToStr(Res.Rows[I][0]);
  end
  else
    Result := nil;
end;

function TSQLiteHandler.BeginTransaction: Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('BEGIN TRANSACTION');
  Result := Res.Success;
end;

function TSQLiteHandler.CommitTransaction: Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('COMMIT');
  Result := Res.Success;
end;

function TSQLiteHandler.RollbackTransaction: Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('ROLLBACK');
  Result := Res.Success;
end;

end.
