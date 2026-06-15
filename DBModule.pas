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

  TAttachedDatabase = record
    Seq: Integer;
    Name: string;
    FilePath: string;
    IsMain: Boolean;
  end;

  TSQLiteProgressProc = reference to function: Boolean;

  TExportProgressInfo = record
    TableName: string;
    TableIndex: Integer;
    TableCount: Integer;
    RowDone: Int64;
    RowTotal: Int64;
    Percent: Integer;
  end;

  TExportProgressProc = reference to function(const AInfo: TExportProgressInfo): Boolean;

  EExportCancelled = class(Exception);

  TExportProgressContext = record
    Callback: TExportProgressProc;
    TableName: string;
    TableIndex: Integer;
    TableCount: Integer;
    GlobalRowDone: Int64;
    GlobalRowTotal: Int64;
  end;

  TBatchTableExportFormat = (btfSQL, btfCSV, btfExcel);

  TBoundValueKind = (bvkNull, bvkInt, bvkReal, bvkText, bvkBlob);

  TBoundColumnValue = record
    Kind: TBoundValueKind;
    IntValue: Int64;
    RealValue: Double;
    TextValue: string;
    BlobData: TBytes;
  end;

  TSQLiteHandler = class
  private
    FDB: PSQLite3;
    FDatabasePath: string;
    FIsOpen: Boolean;
    FLastError: string;
    function ColumnTypeToStr(AColType: Integer): TSQLiteColumnType;
    procedure ApplyAutoIncFromCreateSQL(const ATableName: string; var AColumns: TArray<TColumnDef>);
    function QuoteIdent(const S: string): string;
    function MasterFrom(const ADatabaseName: string): string;
    function RenameObjectInCreateSQL(const ASQL, AOldName, ANewName: string): string;
    procedure StreamTableSqlToStream(AStream: TStream; const ATableName: string;
      var ACtx: TExportProgressContext; ARowTotal: Int64);
    procedure StreamViewSqlToStream(AStream: TStream; const AViewName: string;
      const ASchema: string; var ACtx: TExportProgressContext; ARowTotal: Int64);
    procedure StreamTableCsvToStream(AStream: TStream; const ATableName: string;
      AIncludeHeaders: Boolean; ADelimiter: Char; var ACtx: TExportProgressContext;
      ARowTotal: Int64);
    procedure StreamTableExcelToStream(AStream: TStream; const ATableName: string;
      var ACtx: TExportProgressContext; ARowTotal: Int64);
    procedure WriteExcelWorkbookHeader(AStream: TStream);
    procedure WriteExcelWorkbookFooter(AStream: TStream);
    function XmlEscape(const S: string): string;
    function SanitizeExcelSheetName(const S: string): string;
    function GetTableRowCount(const ATableName: string): Int64;
    function CalcTablesRowTotal(const ATables: TArray<string>): Int64;
    procedure InitExportContext(var ACtx: TExportProgressContext;
      AOnProgress: TExportProgressProc; const ATables: TArray<string>);
    procedure ReportExportProgress(var ACtx: TExportProgressContext;
      ARowDone, ARowTotal: Int64);
  public
    constructor Create;
    destructor Destroy; override;

    function OpenDatabase(const APath: string; AReadOnly: Boolean = False): Boolean;
    procedure CloseDatabase;

    function ExecuteSQL(const ASQL: string): TQueryResult;
    function InsertRow(const ATableName: string; const AColumnNames: TArray<string>;
      const AValues: TArray<TBoundColumnValue>): TQueryResult;
    function ExecuteScalar(const ASQL: string): Variant;
    function GetTableData(const ATableName: string; ALimit: Integer = 100; AOffset: Integer = 0): TQueryResult;
    function GetBlobData(const ATableName: string; ARow: Integer; ACol: Integer): TBytes;
    function GetBlobDataByRowId(const ATableName, ARowId, AColumnName: string): TBytes;
    function GetTableInfo(const ATableName: string; const ADatabaseName: string = 'main'): TArray<TColumnDef>;
    function GetDatabaseStructure(const ADatabaseName: string = 'main'): TDatabaseStructure;
    function GetDatabaseInfo: TDictionary<string, Variant>;
    function GetAttachedDatabases: TArray<TAttachedDatabase>;
    function AttachDatabase(const AFilePath, AAlias: string): Boolean;
    function DetachDatabase(const AAlias: string): Boolean;
    function QualifiedTableRef(const ASchema, ATable: string): string;

    function CreateTable(const ATableName: string; const AColumns: TArray<TColumnDef>): Boolean;
    function DropTable(const ATableName: string; const ASchema: string = ''): Boolean;
    function GetObjectSQL(const AName, AObjectType: string; const ASchema: string = ''): string;
    function DropView(const AViewName: string; const ASchema: string = ''): Boolean;
    function DropTrigger(const ATriggerName: string; const ASchema: string = ''): Boolean;
    function RenameView(const AOldName, ANewName: string; const ASchema: string = ''): Boolean;
    function RenameTrigger(const AOldName, ANewName: string; const ASchema: string = ''): Boolean;
    function RenameTable(const AOldName, ANewName: string; const ASchema: string = ''): Boolean;
    function CopyTable(const ASourceName, ADestName: string; AWithData: Boolean;
      const ASchema: string = ''): Boolean;
    function EmptyTable(const ATableName: string; const ASchema: string = ''): Boolean;
    function ReindexTable(const ATableName: string; const ASchema: string = ''): Boolean;

    function ExportToSQL(const ATableName: string): string;
    function ExportDatabaseToSQL: string;
    function ExportTableToSQLFile(const ATableName, AFilePath: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportViewToSQLFile(const AViewName, AFilePath: string; const ASchema: string = '';
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportDatabaseToSQLFile(const AFilePath: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportTableToExcelFile(const ATableName, AFilePath: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportDatabaseToExcelFile(const AFilePath: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportToCSV(const ATableName, AFilePath: string; AIncludeHeaders: Boolean;
      ADelimiter: Char; AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportAllTablesToFolder(const AFolder: string; AFormat: TBatchTableExportFormat;
      AIncludeHeaders: Boolean; ADelimiter: Char; AOnProgress: TExportProgressProc = nil): Boolean;
    function ImportFromCSV(const AFilePath, ATableName: string; ACreateTable: Boolean; ADelimiter: Char): Integer;

    function CopyDatabase(const ADestPath: string): Boolean;
    function Vacuum(AOnProgress: TSQLiteProgressProc = nil): Boolean;
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

function EscapeSQLString(const S: string): string;
begin
  Result := StringReplace(S, '''', '''''', [rfReplaceAll]);
end;

procedure StreamWriteUtf8(AStream: TStream; const S: string);
var
  Bytes: TBytes;
begin
  if S = '' then
    Exit;
  Bytes := TEncoding.UTF8.GetBytes(S);
  if Length(Bytes) > 0 then
    AStream.Write(Bytes[0], Length(Bytes));
end;

procedure StreamWriteLine(AStream: TStream; const S: string);
begin
  StreamWriteUtf8(AStream, S + sLineBreak);
end;

function SqlFloatStr(AValue: Double): string;
var
  FS: TFormatSettings;
begin
  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  Result := FloatToStr(AValue, FS);
end;

procedure StreamWriteSqlBlob(AStream: TStream; AStmt: PSQLite3Stmt; ACol: Integer);
const
  HexDigits: PAnsiChar = '0123456789ABCDEF';
var
  BlobPtr: Pointer;
  BlobSize, I: Integer;
  B: PByte;
  Hex: array[0..1] of AnsiChar;
begin
  StreamWriteUtf8(AStream, 'X''');
  BlobPtr := sqlite3_column_blob(AStmt, ACol);
  BlobSize := sqlite3_column_bytes(AStmt, ACol);
  if (BlobPtr <> nil) and (BlobSize > 0) then
  begin
    B := BlobPtr;
    for I := 0 to BlobSize - 1 do
    begin
      Hex[0] := HexDigits[B[I] shr 4];
      Hex[1] := HexDigits[B[I] and $0F];
      AStream.Write(Hex[0], 2);
    end;
  end;
  StreamWriteUtf8(AStream, '''');
end;

procedure StreamWriteSqlColumnValue(AStream: TStream; AStmt: PSQLite3Stmt; ACol: Integer);
var
  ColType: Integer;
  S: string;
begin
  ColType := sqlite3_column_type(AStmt, ACol);
  case ColType of
    SQLITE_NULL:
      StreamWriteUtf8(AStream, 'NULL');
    SQLITE_INTEGER:
      StreamWriteUtf8(AStream, IntToStr(sqlite3_column_int64(AStmt, ACol)));
    SQLITE_FLOAT:
      StreamWriteUtf8(AStream, SqlFloatStr(sqlite3_column_double(AStmt, ACol)));
    SQLITE_TEXT:
      begin
        S := UTF8ToString(sqlite3_column_text(AStmt, ACol));
        StreamWriteUtf8(AStream, '''' + EscapeSQLString(S) + '''');
      end;
    SQLITE_BLOB:
      StreamWriteSqlBlob(AStream, AStmt, ACol);
  else
    StreamWriteUtf8(AStream, 'NULL');
  end;
end;

function ColumnTextFromStmt(AStmt: PSQLite3Stmt; ACol: Integer): string;
var
  ColType: Integer;
  BlobSize: Integer;
begin
  ColType := sqlite3_column_type(AStmt, ACol);
  case ColType of
    SQLITE_NULL:
      Result := '';
    SQLITE_INTEGER:
      Result := IntToStr(sqlite3_column_int64(AStmt, ACol));
    SQLITE_FLOAT:
      Result := SqlFloatStr(sqlite3_column_double(AStmt, ACol));
    SQLITE_TEXT:
      Result := UTF8ToString(sqlite3_column_text(AStmt, ACol));
    SQLITE_BLOB:
      begin
        BlobSize := sqlite3_column_bytes(AStmt, ACol);
        Result := 'BLOB(' + IntToStr(BlobSize) + ' bytes)';
      end;
  else
    Result := '';
  end;
end;

function CsvEscapeCell(const AValue: string; ADelimiter: Char): string;
begin
  Result := AValue;
  if (Pos(ADelimiter, Result) > 0) or (Pos('"', Result) > 0) or
     (Pos(#10, Result) > 0) or (Pos(#13, Result) > 0) then
    Result := '"' + StringReplace(Result, '"', '""', [rfReplaceAll]) + '"';
end;

const
  CExportProgressInterval = 100;

function TSQLiteHandler.XmlEscape(const S: string): string;
begin
  Result := S;
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
end;

function TSQLiteHandler.SanitizeExcelSheetName(const S: string): string;
const
  Invalid: array[0..6] of Char = (':', '\', '/', '?', '*', '[', ']');
var
  I, J: Integer;
  R: string;
begin
  R := Trim(S);
  if R = '' then
    R := 'Sheet';
  for I := 1 to Length(R) do
    for J := Low(Invalid) to High(Invalid) do
      if R[I] = Invalid[J] then
        R[I] := '_';
  if Length(R) > 31 then
    SetLength(R, 31);
  Result := R;
end;

procedure TSQLiteHandler.WriteExcelWorkbookHeader(AStream: TStream);
begin
  StreamWriteLine(AStream, '<?xml version="1.0"?>');
  StreamWriteLine(AStream, '<?mso-application progid="Excel.Sheet"?>');
  StreamWriteLine(AStream, '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"');
  StreamWriteLine(AStream, ' xmlns:o="urn:schemas-microsoft-com:office:office"');
  StreamWriteLine(AStream, ' xmlns:x="urn:schemas-microsoft-com:office:excel"');
  StreamWriteLine(AStream, ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">');
end;

procedure TSQLiteHandler.WriteExcelWorkbookFooter(AStream: TStream);
begin
  StreamWriteLine(AStream, '</Workbook>');
end;

function TSQLiteHandler.GetTableRowCount(const ATableName: string): Int64;
var
  V: Variant;
begin
  V := ExecuteScalar('SELECT COUNT(*) FROM ' + QuoteIdent(ATableName));
  if VarIsNull(V) then
    Result := 0
  else
    Result := V;
end;

function TSQLiteHandler.CalcTablesRowTotal(const ATables: TArray<string>): Int64;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(ATables) do
    Inc(Result, GetTableRowCount(ATables[I]));
end;

procedure TSQLiteHandler.InitExportContext(var ACtx: TExportProgressContext;
  AOnProgress: TExportProgressProc; const ATables: TArray<string>);
begin
  FillChar(ACtx, SizeOf(ACtx), 0);
  ACtx.Callback := AOnProgress;
  ACtx.TableCount := Length(ATables);
  ACtx.TableIndex := 0;
  ACtx.GlobalRowDone := 0;
  if Assigned(AOnProgress) then
    ACtx.GlobalRowTotal := CalcTablesRowTotal(ATables)
  else
    ACtx.GlobalRowTotal := 0;
end;

procedure TSQLiteHandler.ReportExportProgress(var ACtx: TExportProgressContext;
  ARowDone, ARowTotal: Int64);
var
  Info: TExportProgressInfo;
  P: Integer;
begin
  if not Assigned(ACtx.Callback) then
    Exit;
  Info.TableName := ACtx.TableName;
  Info.TableIndex := ACtx.TableIndex;
  Info.TableCount := ACtx.TableCount;
  Info.RowDone := ARowDone;
  Info.RowTotal := ARowTotal;
  if ACtx.GlobalRowTotal > 0 then
    P := Trunc((ACtx.GlobalRowDone * 100.0) / ACtx.GlobalRowTotal)
  else if ACtx.TableCount > 0 then
    P := ((ACtx.TableIndex - 1) * 100) div ACtx.TableCount
  else
    P := 0;
  if P > 100 then
    P := 100;
  if P < 0 then
    P := 0;
  Info.Percent := P;
  if not ACtx.Callback(Info) then
    raise EExportCancelled.Create('Operation cancelled by user.');
end;

procedure TSQLiteHandler.StreamTableExcelToStream(AStream: TStream; const ATableName: string;
  var ACtx: TExportProgressContext; ARowTotal: Int64);
var
  Stmt: PSQLite3Stmt;
  Res, ColCount, I, J: Integer;
  pzTail: PAnsiChar;
  SQL, Cell: string;
  RowDone: Int64;
begin
  StreamWriteLine(AStream, ' <Worksheet ss:Name="' +
    XmlEscape(SanitizeExcelSheetName(ATableName)) + '">');
  StreamWriteLine(AStream, '  <Table>');

  SQL := 'SELECT * FROM ' + QuoteIdent(ATableName);
  Stmt := nil;
  pzTail := nil;
  RowDone := 0;
  ReportExportProgress(ACtx, 0, ARowTotal);
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode(SQL)), -1, Stmt, pzTail);
  if Res <> SQLITE_OK then
    raise Exception.Create(UTF8ToString(sqlite3_errmsg(FDB)));
  try
    ColCount := sqlite3_column_count(Stmt);
    if ColCount > 0 then
    begin
      StreamWriteLine(AStream, '   <Row>');
      for I := 0 to ColCount - 1 do
      begin
        Cell := UTF8ToString(sqlite3_column_name(Stmt, I));
        StreamWriteLine(AStream, '    <Cell><Data ss:Type="String">' +
          XmlEscape(Cell) + '</Data></Cell>');
      end;
      StreamWriteLine(AStream, '   </Row>');
    end;

    while sqlite3_step(Stmt) = SQLITE_ROW do
    begin
      StreamWriteLine(AStream, '   <Row>');
      for J := 0 to ColCount - 1 do
      begin
        Cell := ColumnTextFromStmt(Stmt, J);
        StreamWriteLine(AStream, '    <Cell><Data ss:Type="String">' +
          XmlEscape(Cell) + '</Data></Cell>');
      end;
      StreamWriteLine(AStream, '   </Row>');
      Inc(RowDone);
      Inc(ACtx.GlobalRowDone);
      if (RowDone mod CExportProgressInterval) = 0 then
        ReportExportProgress(ACtx, RowDone, ARowTotal);
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
  ReportExportProgress(ACtx, RowDone, ARowTotal);

  StreamWriteLine(AStream, '  </Table>');
  StreamWriteLine(AStream, ' </Worksheet>');
end;

var
  GSQLiteProgressProc: TSQLiteProgressProc;
  GSQLiteWasCancelled: Boolean;

function SQLiteProgressCallback(pArg: Pointer): Integer; cdecl;
begin
  Result := 0;
  if Assigned(GSQLiteProgressProc) and GSQLiteProgressProc() then
  begin
    GSQLiteWasCancelled := True;
    Result := 1;
  end;
end;

function TSQLiteHandler.QuoteIdent(const S: string): string;
begin
  Result := '"' + StringReplace(S, '"', '""', [rfReplaceAll]) + '"';
end;

function IsValidDatabaseAlias(const S: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if S = '' then
    Exit;
  if SameText(S, 'main') or SameText(S, 'temp') then
    Exit;
  if not CharInSet(S[1], ['A'..'Z', 'a'..'z', '_']) then
    Exit;
  for I := 1 to Length(S) do
    if not CharInSet(S[I], ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
      Exit;
  Result := True;
end;

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
  Res := sqlite3_open_v2(PAnsiChar(UTF8Encode(APath)), FDB, Flags, nil);
  
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

          // Column type: first row, or first non-null if column still null
          if Length(Result.ColumnTypes) = ColCount then
          begin
            if ColType <> SQLITE_NULL then
            begin
              if (Length(Result.Rows) = 1) or (Result.ColumnTypes[I] = sctNull) then
                Result.ColumnTypes[I] := ColumnTypeToStr(ColType);
            end
            else if Length(Result.Rows) = 1 then
              Result.ColumnTypes[I] := sctNull;
          end;

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

function TSQLiteHandler.InsertRow(const ATableName: string;
  const AColumnNames: TArray<string>; const AValues: TArray<TBoundColumnValue>): TQueryResult;
var
  Stmt: PSQLite3Stmt;
  Res: Integer;
  SQL, ColList, Placeholders: string;
  I: Integer;
  Utf8Texts: TArray<UTF8String>;
  BlobPtr: Pointer;
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

  if Length(AColumnNames) <> Length(AValues) then
  begin
    Result.ErrorMessage := 'Column count mismatch';
    Exit;
  end;

  if Length(AColumnNames) = 0 then
  begin
    Result.Success := True;
    Exit;
  end;

  ColList := '';
  Placeholders := '';
  for I := 0 to High(AColumnNames) do
  begin
    if ColList <> '' then
    begin
      ColList := ColList + ', ';
      Placeholders := Placeholders + ', ';
    end;
    ColList := ColList + QuoteIdent(AColumnNames[I]);
    Placeholders := Placeholders + '?';
  end;

  SQL := Format('INSERT INTO %s (%s) VALUES (%s)', [ATableName, ColList, Placeholders]);

  Stmt := nil;
  var pzTail: PAnsiChar := nil;
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode(SQL)), -1, Stmt, pzTail);
  if Res <> SQLITE_OK then
  begin
    Result.ErrorMessage := UTF8ToString(sqlite3_errmsg(FDB));
    Exit;
  end;

  SetLength(Utf8Texts, Length(AValues));
  try
    for I := 0 to High(AValues) do
    begin
      case AValues[I].Kind of
        bvkNull:
          sqlite3_bind_null(Stmt, I + 1);
        bvkInt:
          sqlite3_bind_int64(Stmt, I + 1, AValues[I].IntValue);
        bvkReal:
          sqlite3_bind_double(Stmt, I + 1, AValues[I].RealValue);
        bvkText:
          begin
            Utf8Texts[I] := UTF8Encode(AValues[I].TextValue);
            sqlite3_bind_text(Stmt, I + 1, PAnsiChar(Utf8Texts[I]), Length(Utf8Texts[I]), nil);
          end;
        bvkBlob:
          begin
            if Length(AValues[I].BlobData) > 0 then
            begin
              BlobPtr := @AValues[I].BlobData[0];
              sqlite3_bind_blob(Stmt, I + 1, BlobPtr, Length(AValues[I].BlobData), nil);
            end
            else
              sqlite3_bind_blob(Stmt, I + 1, nil, 0, nil);
          end;
      end;
    end;

    Res := sqlite3_step(Stmt);
    if (Res <> SQLITE_DONE) and (Res <> SQLITE_ROW) then
    begin
      Result.ErrorMessage := UTF8ToString(sqlite3_errmsg(FDB));
      Exit;
    end;

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
  SQL := Format('SELECT * FROM %s LIMIT 1 OFFSET %d', [ATableName, ARow]);
  
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

function TSQLiteHandler.GetBlobDataByRowId(const ATableName, ARowId,
  AColumnName: string): TBytes;
var
  SQL: string;
  Stmt: PSQLite3Stmt;
  Res: Integer;
  BlobSize: Integer;
  BlobPtr: Pointer;
begin
  SetLength(Result, 0);
  if not FIsOpen then
    Exit;

  // Note: ARowId expected numeric literal (rowid). Caller responsible.
  if (ATableName <> '') and (ATableName[1] = '"') then
    SQL := Format('SELECT %s FROM %s WHERE rowid = %s',
      [QuoteIdent(AColumnName), ATableName, Trim(ARowId)])
  else if Pos('.', ATableName) > 0 then
    SQL := Format('SELECT %s FROM %s WHERE rowid = %s',
      [QuoteIdent(AColumnName), ATableName, Trim(ARowId)])
  else
    SQL := Format('SELECT %s FROM %s WHERE rowid = %s',
      [QuoteIdent(AColumnName), QuoteIdent(ATableName), Trim(ARowId)]);

  Stmt := nil;
  var pzTail: PAnsiChar := nil;
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode(SQL)), -1, Stmt, pzTail);
  if Res <> SQLITE_OK then
    Exit;

  try
    Res := sqlite3_step(Stmt);
    if Res = SQLITE_ROW then
    begin
      if sqlite3_column_type(Stmt, 0) = SQLITE_BLOB then
      begin
        BlobPtr := sqlite3_column_blob(Stmt, 0);
        BlobSize := sqlite3_column_bytes(Stmt, 0);
        if (BlobPtr <> nil) and (BlobSize > 0) then
        begin
          SetLength(Result, BlobSize);
          Move(BlobPtr^, Result[0], BlobSize);
        end;
      end;
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

procedure TSQLiteHandler.ApplyAutoIncFromCreateSQL(const ATableName: string;
  var AColumns: TArray<TColumnDef>);
var
  CreateRes: TQueryResult;
  CreateSQL: string;
  UpperFragment: string;
  I, NamePos, CommaPos, ParenPos, FragLen: Integer;
  ColName: string;
  SafeTableName: string;
begin
  SafeTableName := StringReplace(ATableName, '''', '''''', [rfReplaceAll]);
  CreateRes := ExecuteSQL(
    'SELECT sql FROM sqlite_master WHERE type=''table'' AND name=''' + SafeTableName + '''');
  if (not CreateRes.Success) or (CreateRes.RowCount = 0) then
    Exit;

  CreateSQL := VarToStr(CreateRes.Rows[0][0]);

  for I := 0 to High(AColumns) do
  begin
    if AColumns[I].PK and (Pos('INT', UpperCase(AColumns[I].TypeName)) > 0) then
    begin
      AColumns[I].AutoInc := True;
      Continue;
    end;

    ColName := AColumns[I].Name;
    NamePos := Pos('"' + ColName + '"', CreateSQL);
    if NamePos = 0 then
      NamePos := Pos('`' + ColName + '`', CreateSQL);
    if NamePos = 0 then
      NamePos := Pos('[' + ColName + ']', CreateSQL);

    if NamePos = 0 then
      Continue;

    FragLen := Length(CreateSQL) - NamePos + 1;
    if FragLen > 250 then
      FragLen := 250;
    UpperFragment := UpperCase(Copy(CreateSQL, NamePos, FragLen));

    CommaPos := Pos(',', UpperFragment);
    ParenPos := Pos(')', UpperFragment);
    if (CommaPos > 0) and ((ParenPos = 0) or (CommaPos < ParenPos)) then
      UpperFragment := Copy(UpperFragment, 1, CommaPos - 1)
    else if ParenPos > 0 then
      UpperFragment := Copy(UpperFragment, 1, ParenPos - 1);

    if Pos('AUTOINCREMENT', UpperFragment) > 0 then
      AColumns[I].AutoInc := True;
  end;
end;

function TSQLiteHandler.QualifiedTableRef(const ASchema, ATable: string): string;
begin
  if (ASchema = '') or SameText(ASchema, 'main') then
    Result := QuoteIdent(ATable)
  else
    Result := QuoteIdent(ASchema) + '.' + QuoteIdent(ATable);
end;

function TSQLiteHandler.MasterFrom(const ADatabaseName: string): string;
begin
  if (ADatabaseName = '') or SameText(ADatabaseName, 'main') then
    Result := 'sqlite_master'
  else
    Result := QuoteIdent(ADatabaseName) + '.sqlite_master';
end;

function TSQLiteHandler.GetObjectSQL(const AName, AObjectType, ASchema: string): string;
var
  QueryRes: TQueryResult;
begin
  Result := '';
  QueryRes := ExecuteSQL(
    'SELECT sql FROM ' + MasterFrom(ASchema) +
    ' WHERE type=''' + EscapeSQLString(AObjectType) + ''' AND name=''' +
    EscapeSQLString(AName) + '''');
  if QueryRes.Success and (QueryRes.RowCount > 0) then
    Result := VarToStr(QueryRes.Rows[0][0]);
end;

function TSQLiteHandler.RenameObjectInCreateSQL(const ASQL, AOldName, ANewName: string): string;
var
  Lines: TStringList;
  I, P: Integer;
  Line, ULine: string;
begin
  Result := ASQL;
  Lines := TStringList.Create;
  try
    Lines.Text := ASQL;
    for I := 0 to Lines.Count - 1 do
    begin
      ULine := Trim(UpperCase(Lines[I]));
      if Pos('CREATE TRIGGER', ULine) = 1 then
      begin
        Line := Lines[I];
        P := Pos(AOldName, Line);
        if P > 0 then
          Lines[I] := Copy(Line, 1, P - 1) + ANewName + Copy(Line, P + Length(AOldName), MaxInt);
        Result := Lines.Text;
        Break;
      end;
    end;
  finally
    Lines.Free;
  end;
end;

function TSQLiteHandler.GetTableInfo(const ATableName: string; const ADatabaseName: string): TArray<TColumnDef>;
var
  Stmt: PSQLite3Stmt;
  Res: Integer;
  ColDef: TColumnDef;
  PragmaSQL: string;
  SafeTableName: string;
begin
  Result := nil;
  
  if not FIsOpen then
    Exit;

  SafeTableName := StringReplace(ATableName, '"', '""', [rfReplaceAll]);
  if (ADatabaseName = '') or SameText(ADatabaseName, 'main') then
    PragmaSQL := 'PRAGMA table_info("' + SafeTableName + '")'
  else
    PragmaSQL := 'PRAGMA ' + QuoteIdent(ADatabaseName) + '.table_info("' + SafeTableName + '")';

  Stmt := nil;
  var pzTail2: PAnsiChar := nil;
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode(PragmaSQL)), -1, Stmt, pzTail2);

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
      ColDef.AutoInc := False;
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

  ApplyAutoIncFromCreateSQL(ATableName, Result);
end;

function TSQLiteHandler.GetDatabaseStructure(const ADatabaseName: string): TDatabaseStructure;
var
  QueryRes: TQueryResult;
  I: Integer;
  MasterFrom: string;
begin
  if (ADatabaseName = '') or SameText(ADatabaseName, 'main') then
    MasterFrom := 'sqlite_master'
  else
    MasterFrom := QuoteIdent(ADatabaseName) + '.sqlite_master';

  QueryRes := ExecuteSQL(
    'SELECT name FROM ' + MasterFrom +
    ' WHERE type=''table'' AND name NOT LIKE ''sqlite_%'' ORDER BY name');
  SetLength(Result.Tables, QueryRes.RowCount);
  for I := 0 to QueryRes.RowCount - 1 do
    Result.Tables[I] := VarToStr(QueryRes.Rows[I][0]);

  QueryRes := ExecuteSQL(
    'SELECT name FROM ' + MasterFrom + ' WHERE type=''view'' ORDER BY name');
  SetLength(Result.Views, QueryRes.RowCount);
  for I := 0 to QueryRes.RowCount - 1 do
    Result.Views[I] := VarToStr(QueryRes.Rows[I][0]);

  QueryRes := ExecuteSQL(
    'SELECT name FROM ' + MasterFrom +
    ' WHERE type=''index'' AND name NOT LIKE ''sqlite_%'' AND name NOT LIKE ''%autoindex%'' ORDER BY name');
  SetLength(Result.Indexes, QueryRes.RowCount);
  for I := 0 to QueryRes.RowCount - 1 do
    Result.Indexes[I] := VarToStr(QueryRes.Rows[I][0]);

  QueryRes := ExecuteSQL(
    'SELECT name FROM ' + MasterFrom + ' WHERE type=''trigger'' ORDER BY name');
  SetLength(Result.Triggers, QueryRes.RowCount);
  for I := 0 to QueryRes.RowCount - 1 do
    Result.Triggers[I] := VarToStr(QueryRes.Rows[I][0]);
end;

function TSQLiteHandler.GetAttachedDatabases: TArray<TAttachedDatabase>;
var
  QueryRes: TQueryResult;
  I, N: Integer;
  Db: TAttachedDatabase;
begin
  SetLength(Result, 0);
  if not FIsOpen then
    Exit;

  QueryRes := ExecuteSQL('PRAGMA database_list');
  if not QueryRes.Success then
    Exit;

  N := 0;
  for I := 0 to QueryRes.RowCount - 1 do
  begin
    Db.Seq := StrToIntDef(VarToStr(QueryRes.Rows[I][0]), 0);
    Db.Name := VarToStr(QueryRes.Rows[I][1]);
    Db.FilePath := VarToStr(QueryRes.Rows[I][2]);
    Db.IsMain := SameText(Db.Name, 'main');
    SetLength(Result, N + 1);
    Result[N] := Db;
    Inc(N);
  end;
end;

function TSQLiteHandler.AttachDatabase(const AFilePath, AAlias: string): Boolean;
var
  SQL: string;
  Path: string;
  Res: TQueryResult;
  Attached: TArray<TAttachedDatabase>;
  I: Integer;
begin
  Result := False;
  FLastError := '';

  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;

  if not IsValidDatabaseAlias(AAlias) then
  begin
    FLastError := 'Invalid database alias';
    Exit;
  end;

  Attached := GetAttachedDatabases;
  for I := 0 to High(Attached) do
    if SameText(Attached[I].Name, AAlias) then
    begin
      FLastError := 'Alias already in use: ' + AAlias;
      Exit;
    end;

  if not FileExists(AFilePath) then
  begin
    FLastError := 'File not found: ' + AFilePath;
    Exit;
  end;

  Path := ExpandFileName(AFilePath);
  SQL := Format('ATTACH DATABASE ''%s'' AS %s', [EscapeSQLString(Path), QuoteIdent(AAlias)]);
  Res := ExecuteSQL(SQL);
  if Res.Success then
    Result := True
  else
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.DetachDatabase(const AAlias: string): Boolean;
var
  Res: TQueryResult;
begin
  Result := False;
  FLastError := '';

  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;

  if SameText(AAlias, 'main') then
  begin
    FLastError := 'Cannot detach main database';
    Exit;
  end;

  Res := ExecuteSQL(Format('DETACH DATABASE %s', [QuoteIdent(AAlias)]));
  if Res.Success then
    Result := True
  else
    FLastError := Res.ErrorMessage;
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

function TSQLiteHandler.DropTable(const ATableName: string; const ASchema: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('DROP TABLE ' + QualifiedTableRef(ASchema, ATableName));
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.DropView(const AViewName: string; const ASchema: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('DROP VIEW ' + QualifiedTableRef(ASchema, AViewName));
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.DropTrigger(const ATriggerName: string; const ASchema: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('DROP TRIGGER ' + QualifiedTableRef(ASchema, ATriggerName));
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.RenameView(const AOldName, ANewName: string; const ASchema: string): Boolean;
begin
  Result := RenameTable(AOldName, ANewName, ASchema);
end;

function TSQLiteHandler.RenameTrigger(const AOldName, ANewName: string; const ASchema: string): Boolean;
var
  SQL, NewSQL: string;
  Res: TQueryResult;
begin
  Result := False;
  FLastError := '';
  SQL := GetObjectSQL(AOldName, 'trigger', ASchema);
  if SQL = '' then
  begin
    FLastError := 'Trigger not found';
    Exit;
  end;
  NewSQL := RenameObjectInCreateSQL(SQL, AOldName, ANewName);
  Res := ExecuteSQL('DROP TRIGGER ' + QualifiedTableRef(ASchema, AOldName));
  if not Res.Success then
  begin
    FLastError := Res.ErrorMessage;
    Exit;
  end;
  Res := ExecuteSQL(NewSQL);
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.RenameTable(const AOldName, ANewName: string; const ASchema: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('ALTER TABLE ' + QualifiedTableRef(ASchema, AOldName) +
    ' RENAME TO ' + QuoteIdent(ANewName));
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.CopyTable(const ASourceName, ADestName: string; AWithData: Boolean;
  const ASchema: string): Boolean;
var
  Res: TQueryResult;
  SrcRef, DstRef: string;
begin
  Result := False;
  FLastError := '';
  SrcRef := QualifiedTableRef(ASchema, ASourceName);
  DstRef := QualifiedTableRef(ASchema, ADestName);
  Res := ExecuteSQL('CREATE TABLE ' + DstRef + ' AS SELECT * FROM ' + SrcRef + ' WHERE 0');
  if not Res.Success then
  begin
    FLastError := Res.ErrorMessage;
    Exit;
  end;
  if AWithData then
  begin
    Res := ExecuteSQL('INSERT INTO ' + DstRef + ' SELECT * FROM ' + SrcRef);
    if not Res.Success then
    begin
      FLastError := Res.ErrorMessage;
      ExecuteSQL('DROP TABLE ' + DstRef);
      Exit;
    end;
  end;
  Result := True;
end;

function TSQLiteHandler.EmptyTable(const ATableName: string; const ASchema: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('DELETE FROM ' + QualifiedTableRef(ASchema, ATableName));
  Result := Res.Success;
  if not Result then
    FLastError := Res.ErrorMessage;
end;

function TSQLiteHandler.ReindexTable(const ATableName: string; const ASchema: string): Boolean;
var
  Res: TQueryResult;
begin
  Res := ExecuteSQL('REINDEX ' + QualifiedTableRef(ASchema, ATableName));
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

procedure TSQLiteHandler.StreamTableSqlToStream(AStream: TStream; const ATableName: string;
  var ACtx: TExportProgressContext; ARowTotal: Int64);
var
  CreateRes: TQueryResult;
  Stmt: PSQLite3Stmt;
  Res, ColCount, J: Integer;
  pzTail: PAnsiChar;
  SQL: string;
  RowDone: Int64;
begin
  CreateRes := ExecuteSQL(
    'SELECT sql FROM sqlite_master WHERE type=''table'' AND name=''' +
    EscapeSQLString(ATableName) + '''');
  if CreateRes.Success and (CreateRes.RowCount > 0) then
    StreamWriteLine(AStream, VarToStr(CreateRes.Rows[0][0]) + ';');

  SQL := 'SELECT * FROM ' + QuoteIdent(ATableName);
  Stmt := nil;
  pzTail := nil;
  RowDone := 0;
  ReportExportProgress(ACtx, 0, ARowTotal);
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode(SQL)), -1, Stmt, pzTail);
  if Res <> SQLITE_OK then
    raise Exception.Create(UTF8ToString(sqlite3_errmsg(FDB)));
  try
    ColCount := sqlite3_column_count(Stmt);
    while sqlite3_step(Stmt) = SQLITE_ROW do
    begin
      StreamWriteUtf8(AStream, 'INSERT INTO ' + QuoteIdent(ATableName) + ' VALUES (');
      for J := 0 to ColCount - 1 do
      begin
        if J > 0 then
          StreamWriteUtf8(AStream, ', ');
        StreamWriteSqlColumnValue(AStream, Stmt, J);
      end;
      StreamWriteLine(AStream, ');');
      Inc(RowDone);
      Inc(ACtx.GlobalRowDone);
      if (RowDone mod CExportProgressInterval) = 0 then
        ReportExportProgress(ACtx, RowDone, ARowTotal);
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
  ReportExportProgress(ACtx, RowDone, ARowTotal);
end;

procedure TSQLiteHandler.StreamTableCsvToStream(AStream: TStream; const ATableName: string;
  AIncludeHeaders: Boolean; ADelimiter: Char; var ACtx: TExportProgressContext;
  ARowTotal: Int64);
var
  Stmt: PSQLite3Stmt;
  Res, ColCount, I, J: Integer;
  pzTail: PAnsiChar;
  SQL, Line, Cell: string;
  RowDone: Int64;
begin
  SQL := 'SELECT * FROM ' + QuoteIdent(ATableName);
  Stmt := nil;
  pzTail := nil;
  RowDone := 0;
  ReportExportProgress(ACtx, 0, ARowTotal);
  Res := sqlite3_prepare_v2(FDB, PAnsiChar(UTF8Encode(SQL)), -1, Stmt, pzTail);
  if Res <> SQLITE_OK then
    raise Exception.Create(UTF8ToString(sqlite3_errmsg(FDB)));
  try
    ColCount := sqlite3_column_count(Stmt);
    if AIncludeHeaders and (ColCount > 0) then
    begin
      Line := '';
      for I := 0 to ColCount - 1 do
      begin
        if I > 0 then
          Line := Line + ADelimiter;
        Cell := UTF8ToString(sqlite3_column_name(Stmt, I));
        Line := Line + CsvEscapeCell(Cell, ADelimiter);
      end;
      StreamWriteLine(AStream, Line);
    end;

    while sqlite3_step(Stmt) = SQLITE_ROW do
    begin
      Line := '';
      for J := 0 to ColCount - 1 do
      begin
        if J > 0 then
          Line := Line + ADelimiter;
        Line := Line + CsvEscapeCell(ColumnTextFromStmt(Stmt, J), ADelimiter);
      end;
      StreamWriteLine(AStream, Line);
      Inc(RowDone);
      Inc(ACtx.GlobalRowDone);
      if (RowDone mod CExportProgressInterval) = 0 then
        ReportExportProgress(ACtx, RowDone, ARowTotal);
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
  ReportExportProgress(ACtx, RowDone, ARowTotal);
end;

procedure TSQLiteHandler.StreamViewSqlToStream(AStream: TStream; const AViewName: string;
  const ASchema: string; var ACtx: TExportProgressContext; ARowTotal: Int64);
var
  CreateRes: TQueryResult;
begin
  CreateRes := ExecuteSQL(
    'SELECT sql FROM ' + MasterFrom(ASchema) +
    ' WHERE type=''view'' AND name=''' + EscapeSQLString(AViewName) + '''');
  if CreateRes.Success and (CreateRes.RowCount > 0) then
    StreamWriteLine(AStream, VarToStr(CreateRes.Rows[0][0]) + ';');
  ReportExportProgress(ACtx, 0, ARowTotal);
  ReportExportProgress(ACtx, ARowTotal, ARowTotal);
end;

function TSQLiteHandler.ExportTableToSQLFile(const ATableName, AFilePath: string;
  AOnProgress: TExportProgressProc): Boolean;
var
  FS: TFileStream;
  Ctx: TExportProgressContext;
  Tables: TArray<string>;
  RowTotal: Int64;
begin
  Result := False;
  FLastError := '';
  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;
  SetLength(Tables, 1);
  Tables[0] := ATableName;
  InitExportContext(Ctx, AOnProgress, Tables);
  RowTotal := GetTableRowCount(ATableName);
  Ctx.TableName := ATableName;
  Ctx.TableIndex := 1;
  try
    FS := TFileStream.Create(AFilePath, fmCreate);
    try
      StreamTableSqlToStream(FS, ATableName, Ctx, RowTotal);
      Result := True;
    finally
      FS.Free;
    end;
  except
    on E: EExportCancelled do
      FLastError := E.Message;
    on E: Exception do
      FLastError := E.Message;
  end;
end;

function TSQLiteHandler.ExportViewToSQLFile(const AViewName, AFilePath: string;
  const ASchema: string; AOnProgress: TExportProgressProc): Boolean;
var
  FS: TFileStream;
  Ctx: TExportProgressContext;
  Tables: TArray<string>;
  RowTotal: Int64;
begin
  Result := False;
  FLastError := '';
  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;
  SetLength(Tables, 1);
  Tables[0] := AViewName;
  InitExportContext(Ctx, AOnProgress, Tables);
  RowTotal := 1;
  Ctx.TableName := AViewName;
  Ctx.TableIndex := 1;
  try
    FS := TFileStream.Create(AFilePath, fmCreate);
    try
      StreamViewSqlToStream(FS, AViewName, ASchema, Ctx, RowTotal);
      Result := True;
    finally
      FS.Free;
    end;
  except
    on E: EExportCancelled do
      FLastError := E.Message;
    on E: Exception do
      FLastError := E.Message;
  end;
end;

function TSQLiteHandler.ExportDatabaseToSQLFile(const AFilePath: string;
  AOnProgress: TExportProgressProc): Boolean;
var
  FS: TFileStream;
  Structure: TDatabaseStructure;
  I: Integer;
  ObjRes: TQueryResult;
  Ctx: TExportProgressContext;
  RowTotal: Int64;
begin
  Result := False;
  FLastError := '';
  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;
  Structure := GetDatabaseStructure;
  InitExportContext(Ctx, AOnProgress, Structure.Tables);
  try
    FS := TFileStream.Create(AFilePath, fmCreate);
    try
      StreamWriteLine(FS, '-- SQLite Manager Database Export');
      StreamWriteLine(FS, '-- Date: ' + DateTimeToStr(Now));
      StreamWriteLine(FS, '');

      for I := 0 to High(Structure.Tables) do
      begin
        Ctx.TableName := Structure.Tables[I];
        Ctx.TableIndex := I + 1;
        RowTotal := GetTableRowCount(Structure.Tables[I]);
        StreamWriteLine(FS, '-- Table: ' + Structure.Tables[I]);
        StreamTableSqlToStream(FS, Structure.Tables[I], Ctx, RowTotal);
        StreamWriteLine(FS, '');
      end;

      for I := 0 to High(Structure.Views) do
      begin
        ObjRes := ExecuteSQL(
          'SELECT sql FROM sqlite_master WHERE type=''view'' AND name=''' +
          EscapeSQLString(Structure.Views[I]) + '''');
        if ObjRes.Success and (ObjRes.RowCount > 0) then
        begin
          StreamWriteLine(FS, '-- View: ' + Structure.Views[I]);
          StreamWriteLine(FS, VarToStr(ObjRes.Rows[0][0]) + ';');
          StreamWriteLine(FS, '');
        end;
      end;

      for I := 0 to High(Structure.Triggers) do
      begin
        ObjRes := ExecuteSQL(
          'SELECT sql FROM sqlite_master WHERE type=''trigger'' AND name=''' +
          EscapeSQLString(Structure.Triggers[I]) + '''');
        if ObjRes.Success and (ObjRes.RowCount > 0) then
        begin
          StreamWriteLine(FS, '-- Trigger: ' + Structure.Triggers[I]);
          StreamWriteLine(FS, VarToStr(ObjRes.Rows[0][0]) + ';');
          StreamWriteLine(FS, '');
        end;
      end;
      Result := True;
    finally
      FS.Free;
    end;
  except
    on E: EExportCancelled do
      FLastError := E.Message;
    on E: Exception do
      FLastError := E.Message;
  end;
end;

function TSQLiteHandler.ExportAllTablesToFolder(const AFolder: string;
  AFormat: TBatchTableExportFormat; AIncludeHeaders: Boolean; ADelimiter: Char;
  AOnProgress: TExportProgressProc): Boolean;
var
  Structure: TDatabaseStructure;
  Ctx: TExportProgressContext;
  I: Integer;
  FilePath, Ext: string;
  RowTotal: Int64;
  FS: TFileStream;
begin
  Result := False;
  FLastError := '';
  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;
  if not DirectoryExists(AFolder) then
  begin
    FLastError := 'Folder does not exist: ' + AFolder;
    Exit;
  end;

  case AFormat of
    btfSQL: Ext := '.sql';
    btfCSV: Ext := '.csv';
    btfExcel: Ext := '.xls';
  else
    FLastError := 'Unsupported export format';
    Exit;
  end;

  Structure := GetDatabaseStructure;
  InitExportContext(Ctx, AOnProgress, Structure.Tables);
  try
    for I := 0 to High(Structure.Tables) do
    begin
      Ctx.TableName := Structure.Tables[I];
      Ctx.TableIndex := I + 1;
      RowTotal := GetTableRowCount(Structure.Tables[I]);
      FilePath := IncludeTrailingPathDelimiter(AFolder) + Structure.Tables[I] + Ext;
      FS := TFileStream.Create(FilePath, fmCreate);
      try
        case AFormat of
          btfSQL:
            StreamTableSqlToStream(FS, Structure.Tables[I], Ctx, RowTotal);
          btfCSV:
            StreamTableCsvToStream(FS, Structure.Tables[I], AIncludeHeaders, ADelimiter, Ctx, RowTotal);
          btfExcel:
            begin
              WriteExcelWorkbookHeader(FS);
              StreamTableExcelToStream(FS, Structure.Tables[I], Ctx, RowTotal);
              WriteExcelWorkbookFooter(FS);
            end;
        end;
      finally
        FS.Free;
      end;
    end;
    Result := True;
  except
    on E: EExportCancelled do
      FLastError := E.Message;
    on E: Exception do
      FLastError := E.Message;
  end;
end;

function TSQLiteHandler.ExportToCSV(const ATableName, AFilePath: string;
  AIncludeHeaders: Boolean; ADelimiter: Char; AOnProgress: TExportProgressProc): Boolean;
var
  FS: TFileStream;
  Ctx: TExportProgressContext;
  Tables: TArray<string>;
  RowTotal: Int64;
begin
  Result := False;
  FLastError := '';
  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;
  SetLength(Tables, 1);
  Tables[0] := ATableName;
  InitExportContext(Ctx, AOnProgress, Tables);
  RowTotal := GetTableRowCount(ATableName);
  Ctx.TableName := ATableName;
  Ctx.TableIndex := 1;
  try
    FS := TFileStream.Create(AFilePath, fmCreate);
    try
      StreamTableCsvToStream(FS, ATableName, AIncludeHeaders, ADelimiter, Ctx, RowTotal);
      Result := True;
    finally
      FS.Free;
    end;
  except
    on E: EExportCancelled do
      FLastError := E.Message;
    on E: Exception do
      FLastError := E.Message;
  end;
end;

function TSQLiteHandler.ExportTableToExcelFile(const ATableName, AFilePath: string;
  AOnProgress: TExportProgressProc): Boolean;
var
  FS: TFileStream;
  Ctx: TExportProgressContext;
  Tables: TArray<string>;
  RowTotal: Int64;
begin
  Result := False;
  FLastError := '';
  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;
  SetLength(Tables, 1);
  Tables[0] := ATableName;
  InitExportContext(Ctx, AOnProgress, Tables);
  RowTotal := GetTableRowCount(ATableName);
  Ctx.TableName := ATableName;
  Ctx.TableIndex := 1;
  try
    FS := TFileStream.Create(AFilePath, fmCreate);
    try
      WriteExcelWorkbookHeader(FS);
      StreamTableExcelToStream(FS, ATableName, Ctx, RowTotal);
      WriteExcelWorkbookFooter(FS);
      Result := True;
    finally
      FS.Free;
    end;
  except
    on E: EExportCancelled do
      FLastError := E.Message;
    on E: Exception do
      FLastError := E.Message;
  end;
end;

function TSQLiteHandler.ExportDatabaseToExcelFile(const AFilePath: string;
  AOnProgress: TExportProgressProc): Boolean;
var
  FS: TFileStream;
  Structure: TDatabaseStructure;
  I: Integer;
  Ctx: TExportProgressContext;
  RowTotal: Int64;
begin
  Result := False;
  FLastError := '';
  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;
  Structure := GetDatabaseStructure;
  InitExportContext(Ctx, AOnProgress, Structure.Tables);
  try
    FS := TFileStream.Create(AFilePath, fmCreate);
    try
      WriteExcelWorkbookHeader(FS);
      for I := 0 to High(Structure.Tables) do
      begin
        Ctx.TableName := Structure.Tables[I];
        Ctx.TableIndex := I + 1;
        RowTotal := GetTableRowCount(Structure.Tables[I]);
        StreamTableExcelToStream(FS, Structure.Tables[I], Ctx, RowTotal);
      end;
      WriteExcelWorkbookFooter(FS);
      Result := True;
    finally
      FS.Free;
    end;
  except
    on E: EExportCancelled do
      FLastError := E.Message;
    on E: Exception do
      FLastError := E.Message;
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

function TSQLiteHandler.CopyDatabase(const ADestPath: string): Boolean;
var
  DestDb: PSQLite3;
  Backup: PSQLite3Backup;
  Res: Integer;
  PathUtf8: UTF8String;
begin
  Result := False;
  FLastError := '';
  if not FIsOpen then
  begin
    FLastError := 'Database is not open';
    Exit;
  end;
  if not Assigned(@sqlite3_backup_init) or not Assigned(@sqlite3_backup_step) or
     not Assigned(@sqlite3_backup_finish) then
  begin
    FLastError := 'sqlite3_backup API is not available in sqlite3.dll';
    Exit;
  end;

  DestDb := nil;
  PathUtf8 := UTF8Encode(ADestPath);
  Res := sqlite3_open_v2(PAnsiChar(PathUtf8), DestDb,
    SQLITE_OPEN_READWRITE or SQLITE_OPEN_CREATE, nil);
  if Res <> SQLITE_OK then
  begin
    if Assigned(DestDb) then
      FLastError := UTF8ToString(sqlite3_errmsg(DestDb))
    else
      FLastError := 'Cannot create destination database';
    if Assigned(DestDb) then
      sqlite3_close_v2(DestDb);
    Exit;
  end;

  Backup := sqlite3_backup_init(DestDb, PAnsiChar('main'), FDB, PAnsiChar('main'));
  if not Assigned(Backup) then
  begin
    FLastError := UTF8ToString(sqlite3_errmsg(DestDb));
    sqlite3_close_v2(DestDb);
    Exit;
  end;

  Res := sqlite3_backup_step(Backup, -1);
  if Res = SQLITE_DONE then
    Result := True
  else
    FLastError := UTF8ToString(sqlite3_errmsg(DestDb));

  sqlite3_backup_finish(Backup);
  sqlite3_close_v2(DestDb);
end;

function TSQLiteHandler.Vacuum(AOnProgress: TSQLiteProgressProc): Boolean;
var
  Res: TQueryResult;
begin
  GSQLiteWasCancelled := False;
  GSQLiteProgressProc := AOnProgress;
  if Assigned(AOnProgress) and Assigned(@sqlite3_progress_handler) then
    sqlite3_progress_handler(FDB, @SQLiteProgressCallback, nil, 1000);
  try
    Res := ExecuteSQL('VACUUM');
    Result := Res.Success;
    if not Result then
    begin
      if GSQLiteWasCancelled then
        FLastError := 'Operation cancelled by user.'
      else
        FLastError := Res.ErrorMessage;
    end;
  finally
    if Assigned(@sqlite3_progress_handler) then
      sqlite3_progress_handler(FDB, nil, nil, 0);
    GSQLiteProgressProc := nil;
  end;
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
  begin
    FLastError := Res.ErrorMessage;
    Result := nil;
  end;
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
