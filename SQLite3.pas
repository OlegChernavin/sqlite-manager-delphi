{*******************************************************************************
  SQLite3 Dynamic Link Library Wrapper
  Native interface to SQLite3.dll
*******************************************************************************}
unit SQLite3;

interface

uses
  WinApi.Windows, System.SysUtils;

const
  SQLITE_OK         = 0;
  SQLITE_ERROR      = 1;
  SQLITE_INTERNAL   = 2;
  SQLITE_PERM       = 3;
  SQLITE_ABORT      = 4;
  SQLITE_BUSY       = 5;
  SQLITE_LOCKED     = 6;
  SQLITE_NOMEM      = 7;
  SQLITE_READONLY   = 8;
  SQLITE_INTERRUPT  = 9;
  SQLITE_IOERR      = 10;
  SQLITE_CORRUPT    = 11;
  SQLITE_NOTFOUND   = 12;
  SQLITE_FULL       = 13;
  SQLITE_CANTOPEN   = 14;
  SQLITE_PROTOCOL   = 15;
  SQLITE_EMPTY      = 16;
  SQLITE_SCHEMA     = 17;
  SQLITE_TOOBIG     = 18;
  SQLITE_CONSTRAINT = 19;
  SQLITE_MISMATCH   = 20;
  SQLITE_MISUSE     = 21;
  SQLITE_NOLFS      = 22;
  SQLITE_AUTH       = 23;
  SQLITE_FORMAT     = 24;
  SQLITE_RANGE      = 25;
  SQLITE_NOTADB     = 26;
  SQLITE_ROW        = 100;
  SQLITE_DONE       = 101;

  SQLITE_INTEGER = 1;
  SQLITE_FLOAT   = 2;
  SQLITE_TEXT    = 3;
  SQLITE_BLOB    = 4;
  SQLITE_NULL    = 5;

  SQLITE_OPEN_READONLY  = $00000001;
  SQLITE_OPEN_READWRITE = $00000002;
  SQLITE_OPEN_CREATE    = $00000004;

type
  TSqlite3Db = type Pointer;
  TSqlite3Stmt = type Pointer;
  TSqlite3Value = type Pointer;
  TSqlite3Context = type Pointer;

  PSQLite3 = ^TSqlite3Db;
  PSQLite3Stmt = ^TSqlite3Stmt;
  PSQLite3Value = ^TSqlite3Value;
  PSQLite3Context = ^TSqlite3Context;
  PPAnsiChar = ^PAnsiChar;

  TSQLite3Func = procedure(pCtx: PSQLite3Context; nVal: Integer; pVal: PSQLite3Value); cdecl;
  TSQLite3FuncX = procedure(pCtx: PSQLite3Context); cdecl;

  TSQLite3Open = function(zFilename: PAnsiChar; var ppDb: PSQLite3): Integer; cdecl;
  TSQLite3Close = function(db: PSQLite3): Integer; cdecl;
  TSQLite3CloseV2 = function(db: PSQLite3): Integer; cdecl;
  TSQLite3Exec = function(db: PSQLite3; zSql: PAnsiChar; xCallback: Pointer;
    pArg: Pointer; var pzErrMsg: PAnsiChar): Integer; cdecl;
  TSQLite3Prepare = function(db: PSQLite3; zSql: PAnsiChar; nByte: Integer;
    var ppStmt: PSQLite3Stmt; var pzTail: PAnsiChar): Integer; cdecl;
  TSQLite3PrepareV2 = function(db: PSQLite3; zSql: PAnsiChar; nByte: Integer;
    var ppStmt: PSQLite3Stmt; var pzTail: PAnsiChar): Integer; cdecl;
  TSQLite3Finalize = function(pStmt: PSQLite3Stmt): Integer; cdecl;
  TSQLite3Step = function(pStmt: PSQLite3Stmt): Integer; cdecl;
  TSQLite3Reset = function(pStmt: PSQLite3Stmt): Integer; cdecl;
  TSQLite3BindParameterCount = function(pStmt: PSQLite3Stmt): Integer; cdecl;
  TSQLite3BindParameterName = function(pStmt: PSQLite3Stmt; N: Integer): PAnsiChar; cdecl;
  TSQLite3BindParameterIndex = function(pStmt: PSQLite3Stmt; zName: PAnsiChar): Integer; cdecl;
  TSQLite3BindNull = function(pStmt: PSQLite3Stmt; N: Integer): Integer; cdecl;
  TSQLite3BindInt = function(pStmt: PSQLite3Stmt; N: Integer; iVal: Integer): Integer; cdecl;
  TSQLite3BindInt64 = function(pStmt: PSQLite3Stmt; N: Integer; iVal: Int64): Integer; cdecl;
  TSQLite3BindDouble = function(pStmt: PSQLite3Stmt; N: Integer; rVal: Double): Integer; cdecl;
  TSQLite3BindText = function(pStmt: PSQLite3Stmt; N: Integer; zData: PAnsiChar;
    nData: Integer; xDel: Pointer): Integer; cdecl;
  TSQLite3BindText16 = function(pStmt: PSQLite3Stmt; N: Integer; zData: PWideChar;
    nData: Integer; xDel: Pointer): Integer; cdecl;
  TSQLite3BindBlob = function(pStmt: PSQLite3Stmt; N: Integer; zData: Pointer;
    nData: Integer; xDel: Pointer): Integer; cdecl;
  TSQLite3ColumnCount = function(pStmt: PSQLite3Stmt): Integer; cdecl;
  TSQLite3ColumnName = function(pStmt: PSQLite3Stmt; N: Integer): PAnsiChar; cdecl;
  TSQLite3ColumnDeclType = function(pStmt: PSQLite3Stmt; N: Integer): PAnsiChar; cdecl;
  TSQLite3ColumnType = function(pStmt: PSQLite3Stmt; N: Integer): Integer; cdecl;
  TSQLite3ColumnInt = function(pStmt: PSQLite3Stmt; N: Integer): Integer; cdecl;
  TSQLite3ColumnInt64 = function(pStmt: PSQLite3Stmt; N: Integer): Int64; cdecl;
  TSQLite3ColumnDouble = function(pStmt: PSQLite3Stmt; N: Integer): Double; cdecl;
  TSQLite3ColumnText = function(pStmt: PSQLite3Stmt; N: Integer): PAnsiChar; cdecl;
  TSQLite3ColumnText16 = function(pStmt: PSQLite3Stmt; N: Integer): PWideChar; cdecl;
  TSQLite3ColumnBlob = function(pStmt: PSQLite3Stmt; N: Integer): Pointer; cdecl;
  TSQLite3ColumnBytes = function(pStmt: PSQLite3Stmt; N: Integer): Integer; cdecl;
  TSQLite3ColumnDatabaseName = function(pStmt: PSQLite3Stmt; N: Integer): PAnsiChar; cdecl;
  TSQLite3ColumnTableName = function(pStmt: PSQLite3Stmt; N: Integer): PAnsiChar; cdecl;
  TSQLite3ColumnOriginName = function(pStmt: PSQLite3Stmt; N: Integer): PAnsiChar; cdecl;
  TSQLite3Changes = function(db: PSQLite3): Integer; cdecl;
  TSQLite3TotalChanges = function(db: PSQLite3): Integer; cdecl;
  TSQLite3LastInsertRowID = function(db: PSQLite3): Int64; cdecl;
  TSQLite3ErrMsg = function(db: PSQLite3): PAnsiChar; cdecl;
  TSQLite3LibVersion = function: PAnsiChar; cdecl;
  TSQLite3LibVersionNumber = function: Integer; cdecl;
  TSQLite3GetTable = function(db: PSQLite3; zSql: PAnsiChar; var pazResult: PPAnsiChar;
    var pnRow: Integer; var pnColumn: Integer; var pzErrMsg: PAnsiChar): Integer; cdecl;
  TSQLite3FreeTable = procedure(pazResult: PPAnsiChar); cdecl;
  TSQLite3Free = procedure(p: Pointer); cdecl;
  TSQLite3GetAutocommit = function(db: PSQLite3): Integer; cdecl;
  TSQLite3CreateFunction = function(db: PSQLite3; zFunctionName: PAnsiChar;
    nArg: Integer; eTextRep: Integer; pApp: Pointer; xFunc: TSQLite3Func;
    xStep: TSQLite3Func; xFinal: TSQLite3FuncX): Integer; cdecl;
  TSQLite3BusyTimeout = function(db: PSQLite3; ms: Integer): Integer; cdecl;
  TSQLite3SetBusyTimeout = function(db: PSQLite3; ms: Integer): Integer; cdecl;
  TSQLite3OpenV2 = function(zFilename: PAnsiChar; var ppDb: PSQLite3; flags: Integer;
    zVfs: PAnsiChar): Integer; cdecl;
  TSQLite3Complete = function(zSql: PAnsiChar): Integer; cdecl;
  TSQLite3TableColumnMetadata = function(db: PSQLite3; zDbName: PAnsiChar;
    zTableName: PAnsiChar; zColumnName: PAnsiChar; var pzDataType: PAnsiChar;
    var pzCollSeq: PAnsiChar; var pNotNull: Integer; var pPrimaryKey: Integer;
    var pAutoInc: Integer): Integer; cdecl;

  TSQLite3Backup = type Pointer;
  PSQLite3Backup = ^TSQLite3Backup;

  TSQLite3BackupInit = function(pDestDb: PSQLite3; zDestName: PAnsiChar;
    pSrcDb: PSQLite3; zSrcName: PAnsiChar): PSQLite3Backup; cdecl;
  TSQLite3BackupStep = function(p: PSQLite3Backup; nPage: Integer): Integer; cdecl;
  TSQLite3BackupFinish = function(p: PSQLite3Backup): Integer; cdecl;

  TSQLite3ProgressHandler = function(pArg: Pointer): Integer; cdecl;
  TSQLite3ProgressHandlerRegister = function(db: PSQLite3;
    xCallback: TSQLite3ProgressHandler; pArg: Pointer; nOp: Integer): Integer; cdecl;

var
  SQLite3DLL: THandle = 0;
  sqlite3_open: TSQLite3Open = nil;
  sqlite3_close: TSQLite3Close = nil;
  sqlite3_close_v2: TSQLite3CloseV2 = nil;
  sqlite3_exec: TSQLite3Exec = nil;
  sqlite3_prepare: TSQLite3Prepare = nil;
  sqlite3_prepare_v2: TSQLite3PrepareV2 = nil;
  sqlite3_finalize: TSQLite3Finalize = nil;
  sqlite3_step: TSQLite3Step = nil;
  sqlite3_reset: TSQLite3Reset = nil;
  sqlite3_bind_parameter_count: TSQLite3BindParameterCount = nil;
  sqlite3_bind_parameter_name: TSQLite3BindParameterName = nil;
  sqlite3_bind_parameter_index: TSQLite3BindParameterIndex = nil;
  sqlite3_bind_null: TSQLite3BindNull = nil;
  sqlite3_bind_int: TSQLite3BindInt = nil;
  sqlite3_bind_int64: TSQLite3BindInt64 = nil;
  sqlite3_bind_double: TSQLite3BindDouble = nil;
  sqlite3_bind_text: TSQLite3BindText = nil;
  sqlite3_bind_text16: TSQLite3BindText16 = nil;
  sqlite3_bind_blob: TSQLite3BindBlob = nil;
  sqlite3_column_count: TSQLite3ColumnCount = nil;
  sqlite3_column_name: TSQLite3ColumnName = nil;
  sqlite3_column_decltype: TSQLite3ColumnDeclType = nil;
  sqlite3_column_type: TSQLite3ColumnType = nil;
  sqlite3_column_int: TSQLite3ColumnInt = nil;
  sqlite3_column_int64: TSQLite3ColumnInt64 = nil;
  sqlite3_column_double: TSQLite3ColumnDouble = nil;
  sqlite3_column_text: TSQLite3ColumnText = nil;
  sqlite3_column_text16: TSQLite3ColumnText16 = nil;
  sqlite3_column_blob: TSQLite3ColumnBlob = nil;
  sqlite3_column_bytes: TSQLite3ColumnBytes = nil;
  sqlite3_column_database_name: TSQLite3ColumnDatabaseName = nil;
  sqlite3_column_table_name: TSQLite3ColumnTableName = nil;
  sqlite3_column_origin_name: TSQLite3ColumnOriginName = nil;
  sqlite3_changes: TSQLite3Changes = nil;
  sqlite3_total_changes: TSQLite3TotalChanges = nil;
  sqlite3_last_insert_rowid: TSQLite3LastInsertRowID = nil;
  sqlite3_errmsg: TSQLite3ErrMsg = nil;
  sqlite3_libversion: TSQLite3LibVersion = nil;
  sqlite3_libversion_number: TSQLite3LibVersionNumber = nil;
  sqlite3_get_table: TSQLite3GetTable = nil;
  sqlite3_free_table: TSQLite3FreeTable = nil;
  sqlite3_free: TSQLite3Free = nil;
  sqlite3_get_autocommit: TSQLite3GetAutocommit = nil;
  sqlite3_create_function: TSQLite3CreateFunction = nil;
  sqlite3_busy_timeout: TSQLite3BusyTimeout = nil;
  sqlite3_open_v2: TSQLite3OpenV2 = nil;
  sqlite3_complete: TSQLite3Complete = nil;
  sqlite3_table_column_metadata: TSQLite3TableColumnMetadata = nil;
  sqlite3_backup_init: TSQLite3BackupInit = nil;
  sqlite3_backup_step: TSQLite3BackupStep = nil;
  sqlite3_backup_finish: TSQLite3BackupFinish = nil;
  sqlite3_progress_handler: TSQLite3ProgressHandlerRegister = nil;

function LoadSQLite3(const DllPath: string = ''): Boolean;
procedure UnloadSQLite3;
function SQLite3IsLoaded: Boolean;
function GetSQLite3Version: string;

implementation

function LoadSQLite3(const DllPath: string): Boolean;
var
  DllName: string;
begin
  Result := False;
  
  if SQLite3DLL <> 0 then
  begin
    Result := True;
    Exit;
  end;

  if DllPath <> '' then
    DllName := DllPath
  else
    DllName := 'sqlite3.dll';

  SQLite3DLL := LoadLibrary(PChar(DllName));
  
  if SQLite3DLL = 0 then
  begin
    // Try to load from system path
    SQLite3DLL := LoadLibrary('sqlite3.dll');
  end;

  if SQLite3DLL <> 0 then
  begin
    @sqlite3_open := GetProcAddress(SQLite3DLL, 'sqlite3_open');
    @sqlite3_close := GetProcAddress(SQLite3DLL, 'sqlite3_close');
    @sqlite3_close_v2 := GetProcAddress(SQLite3DLL, 'sqlite3_close_v2');
    @sqlite3_exec := GetProcAddress(SQLite3DLL, 'sqlite3_exec');
    @sqlite3_prepare := GetProcAddress(SQLite3DLL, 'sqlite3_prepare');
    @sqlite3_prepare_v2 := GetProcAddress(SQLite3DLL, 'sqlite3_prepare_v2');
    @sqlite3_finalize := GetProcAddress(SQLite3DLL, 'sqlite3_finalize');
    @sqlite3_step := GetProcAddress(SQLite3DLL, 'sqlite3_step');
    @sqlite3_reset := GetProcAddress(SQLite3DLL, 'sqlite3_reset');
    @sqlite3_bind_parameter_count := GetProcAddress(SQLite3DLL, 'sqlite3_bind_parameter_count');
    @sqlite3_bind_parameter_name := GetProcAddress(SQLite3DLL, 'sqlite3_bind_parameter_name');
    @sqlite3_bind_parameter_index := GetProcAddress(SQLite3DLL, 'sqlite3_bind_parameter_index');
    @sqlite3_bind_null := GetProcAddress(SQLite3DLL, 'sqlite3_bind_null');
    @sqlite3_bind_int := GetProcAddress(SQLite3DLL, 'sqlite3_bind_int');
    @sqlite3_bind_int64 := GetProcAddress(SQLite3DLL, 'sqlite3_bind_int64');
    @sqlite3_bind_double := GetProcAddress(SQLite3DLL, 'sqlite3_bind_double');
    @sqlite3_bind_text := GetProcAddress(SQLite3DLL, 'sqlite3_bind_text');
    @sqlite3_bind_text16 := GetProcAddress(SQLite3DLL, 'sqlite3_bind_text16');
    @sqlite3_bind_blob := GetProcAddress(SQLite3DLL, 'sqlite3_bind_blob');
    @sqlite3_column_count := GetProcAddress(SQLite3DLL, 'sqlite3_column_count');
    @sqlite3_column_name := GetProcAddress(SQLite3DLL, 'sqlite3_column_name');
    @sqlite3_column_decltype := GetProcAddress(SQLite3DLL, 'sqlite3_column_decltype');
    @sqlite3_column_type := GetProcAddress(SQLite3DLL, 'sqlite3_column_type');
    @sqlite3_column_int := GetProcAddress(SQLite3DLL, 'sqlite3_column_int');
    @sqlite3_column_int64 := GetProcAddress(SQLite3DLL, 'sqlite3_column_int64');
    @sqlite3_column_double := GetProcAddress(SQLite3DLL, 'sqlite3_column_double');
    @sqlite3_column_text := GetProcAddress(SQLite3DLL, 'sqlite3_column_text');
    @sqlite3_column_text16 := GetProcAddress(SQLite3DLL, 'sqlite3_column_text16');
    @sqlite3_column_blob := GetProcAddress(SQLite3DLL, 'sqlite3_column_blob');
    @sqlite3_column_bytes := GetProcAddress(SQLite3DLL, 'sqlite3_column_bytes');
    @sqlite3_column_database_name := GetProcAddress(SQLite3DLL, 'sqlite3_column_database_name');
    @sqlite3_column_table_name := GetProcAddress(SQLite3DLL, 'sqlite3_column_table_name');
    @sqlite3_column_origin_name := GetProcAddress(SQLite3DLL, 'sqlite3_column_origin_name');
    @sqlite3_changes := GetProcAddress(SQLite3DLL, 'sqlite3_changes');
    @sqlite3_total_changes := GetProcAddress(SQLite3DLL, 'sqlite3_total_changes');
    @sqlite3_last_insert_rowid := GetProcAddress(SQLite3DLL, 'sqlite3_last_insert_rowid');
    @sqlite3_errmsg := GetProcAddress(SQLite3DLL, 'sqlite3_errmsg');
    @sqlite3_libversion := GetProcAddress(SQLite3DLL, 'sqlite3_libversion');
    @sqlite3_libversion_number := GetProcAddress(SQLite3DLL, 'sqlite3_libversion_number');
    @sqlite3_get_table := GetProcAddress(SQLite3DLL, 'sqlite3_get_table');
    @sqlite3_free_table := GetProcAddress(SQLite3DLL, 'sqlite3_free_table');
    @sqlite3_free := GetProcAddress(SQLite3DLL, 'sqlite3_free');
    @sqlite3_get_autocommit := GetProcAddress(SQLite3DLL, 'sqlite3_get_autocommit');
    @sqlite3_create_function := GetProcAddress(SQLite3DLL, 'sqlite3_create_function');
    @sqlite3_busy_timeout := GetProcAddress(SQLite3DLL, 'sqlite3_busy_timeout');
    @sqlite3_open_v2 := GetProcAddress(SQLite3DLL, 'sqlite3_open_v2');
    @sqlite3_complete := GetProcAddress(SQLite3DLL, 'sqlite3_complete');
    @sqlite3_table_column_metadata := GetProcAddress(SQLite3DLL, 'sqlite3_table_column_metadata');
    @sqlite3_backup_init := GetProcAddress(SQLite3DLL, 'sqlite3_backup_init');
    @sqlite3_backup_step := GetProcAddress(SQLite3DLL, 'sqlite3_backup_step');
    @sqlite3_backup_finish := GetProcAddress(SQLite3DLL, 'sqlite3_backup_finish');
    @sqlite3_progress_handler := GetProcAddress(SQLite3DLL, 'sqlite3_progress_handler');

    Result := Assigned(@sqlite3_open) and Assigned(@sqlite3_close) and
              Assigned(@sqlite3_exec) and Assigned(@sqlite3_prepare_v2) and
              Assigned(@sqlite3_step) and Assigned(@sqlite3_finalize);
  end;
end;

procedure UnloadSQLite3;
begin
  if SQLite3DLL <> 0 then
  begin
    FreeLibrary(SQLite3DLL);
    SQLite3DLL := 0;
  end;
  
  @sqlite3_open := nil;
  @sqlite3_close := nil;
  @sqlite3_exec := nil;
  @sqlite3_prepare_v2 := nil;
  @sqlite3_step := nil;
  @sqlite3_finalize := nil;
end;

function SQLite3IsLoaded: Boolean;
begin
  Result := (SQLite3DLL <> 0) and Assigned(@sqlite3_open);
end;

function GetSQLite3Version: string;
begin
  if Assigned(@sqlite3_libversion) then
    Result := string(AnsiString(sqlite3_libversion))
  else
    Result := 'Unknown';
end;

initialization
finalization
  UnloadSQLite3;
end.
