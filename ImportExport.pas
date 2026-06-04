{*******************************************************************************
  Import/Export Module for SQLite Manager
  Supports SQL, CSV, Excel (SpreadsheetML) formats
*******************************************************************************}
unit ImportExport;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, DBModule, System.Variants;

type
  TDataFileFormat = (dffSQL, dffCSV, dffExcel);

  TImportExport = class
  private
    FDB: TSQLiteHandler;
    function ExportTableToExcel(const ATableName, AFilePath: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportDatabaseToExcel(const AFilePath: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ImportFromExcelFile(const AFilePath, ATableName: string;
      ACreateTable: Boolean): Integer;
    function DecodeXmlEntities(const S: string): string;
    function ImportFromSpreadsheetML(const XML, ATableName: string;
      ACreateTable: Boolean): Integer;
    function ImportFromDelimitedText(const AFilePath, ATableName: string;
      ACreateTable: Boolean; ADelimiter: Char): Integer;
    procedure SplitSQLScript(const ASQL: string; AStatements: TStringList);
  public
    constructor Create(ADB: TSQLiteHandler);

    class function FormatExtension(AFormat: TDataFileFormat): string;
    class function FormatDescription(AFormat: TDataFileFormat): string;
    class function SaveDialogFilter: string;
    class function OpenDialogFilter: string;
    class function DetectFormat(const AFilePath: string): TDataFileFormat;
    class function FormatFromDialogFilter(AFilterIndex: Integer): TDataFileFormat;

    function ExportTable(const ATableName, AFilePath: string; AFormat: TDataFileFormat;
      AIncludeHeaders: Boolean; ADelimiter: Char;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportView(const AViewName, AFilePath: string; AFormat: TDataFileFormat;
      const ASchema: string; AIncludeHeaders: Boolean; ADelimiter: Char;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportAllTables(const AFolder: string; AFormat: TDataFileFormat;
      AIncludeHeaders: Boolean; ADelimiter: Char; out AExportedCount: Integer;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportDatabase(const AFilePath: string; AFormat: TDataFileFormat;
      AIncludeHeaders: Boolean; ADelimiter: Char;
      AOnProgress: TExportProgressProc = nil): Boolean;

    function ImportFromFile(const AFilePath: string; AFormat: TDataFileFormat;
      const ATableName: string; ACreateTable: Boolean; ADelimiter: Char;
      out ARowsImported: Integer): Boolean;

    function ExportToCSV(const ATableName, AFilePath: string;
      AIncludeHeaders: Boolean; ADelimiter: Char;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportToSQL(const ATableName, AFilePath: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportViewToSQL(const AViewName, AFilePath: string; const ASchema: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportDatabaseToSQL(const AFilePath: string;
      AOnProgress: TExportProgressProc = nil): Boolean;
    function ExportToXML(const ATableName, AFilePath: string): Boolean;
    function ImportFromCSV(const AFilePath, ATableName: string;
      ACreateTable: Boolean; ADelimiter: Char): Integer;
    function ImportFromSQL(const AFilePath: string): Boolean;
    function ImportFromXML(const AFilePath, ATableName: string): Integer;
  end;

implementation

uses
  System.StrUtils;

{ TImportExport }

constructor TImportExport.Create(ADB: TSQLiteHandler);
begin
  inherited Create;
  FDB := ADB;
end;

class function TImportExport.FormatExtension(AFormat: TDataFileFormat): string;
begin
  case AFormat of
    dffSQL: Result := '.sql';
    dffCSV: Result := '.csv';
    dffExcel: Result := '.xls';
  else
    Result := '';
  end;
end;

class function TImportExport.FormatDescription(AFormat: TDataFileFormat): string;
begin
  case AFormat of
    dffSQL: Result := 'SQL';
    dffCSV: Result := 'CSV';
    dffExcel: Result := 'Excel';
  else
    Result := '';
  end;
end;

class function TImportExport.SaveDialogFilter: string;
begin
  Result := 'SQL files (*.sql)|*.sql|CSV files (*.csv)|*.csv|' +
    'Excel files (*.xls)|*.xls|All supported|*.sql;*.csv;*.xls';
end;

class function TImportExport.OpenDialogFilter: string;
begin
  Result := SaveDialogFilter;
end;

class function TImportExport.DetectFormat(const AFilePath: string): TDataFileFormat;
var
  Ext: string;
begin
  Ext := LowerCase(ExtractFileExt(AFilePath));
  if Ext = '.sql' then
    Result := dffSQL
  else if (Ext = '.csv') or (Ext = '.txt') then
    Result := dffCSV
  else if (Ext = '.xls') or (Ext = '.xlsx') then
    Result := dffExcel
  else
    Result := dffCSV;
end;

class function TImportExport.FormatFromDialogFilter(AFilterIndex: Integer): TDataFileFormat;
begin
  case AFilterIndex of
    1: Result := dffSQL;
    2: Result := dffCSV;
    3: Result := dffExcel;
  else
    Result := dffSQL;
  end;
end;

function TImportExport.ExportTableToExcel(const ATableName, AFilePath: string;
  AOnProgress: TExportProgressProc): Boolean;
begin
  Result := FDB.ExportTableToExcelFile(ATableName, AFilePath, AOnProgress);
end;

function TImportExport.ExportDatabaseToExcel(const AFilePath: string;
  AOnProgress: TExportProgressProc): Boolean;
begin
  Result := FDB.ExportDatabaseToExcelFile(AFilePath, AOnProgress);
end;

function TImportExport.ExportTable(const ATableName, AFilePath: string;
  AFormat: TDataFileFormat; AIncludeHeaders: Boolean; ADelimiter: Char;
  AOnProgress: TExportProgressProc): Boolean;
begin
  case AFormat of
    dffSQL: Result := ExportToSQL(ATableName, AFilePath, AOnProgress);
    dffCSV: Result := ExportToCSV(ATableName, AFilePath, AIncludeHeaders, ADelimiter, AOnProgress);
    dffExcel: Result := ExportTableToExcel(ATableName, AFilePath, AOnProgress);
  else
    Result := False;
  end;
end;

function TImportExport.ExportView(const AViewName, AFilePath: string;
  AFormat: TDataFileFormat; const ASchema: string; AIncludeHeaders: Boolean;
  ADelimiter: Char; AOnProgress: TExportProgressProc): Boolean;
begin
  case AFormat of
    dffSQL: Result := ExportViewToSQL(AViewName, AFilePath, ASchema, AOnProgress);
    dffCSV: Result := ExportToCSV(AViewName, AFilePath, AIncludeHeaders, ADelimiter, AOnProgress);
    dffExcel: Result := ExportTableToExcel(AViewName, AFilePath, AOnProgress);
  else
    Result := False;
  end;
end;

function TImportExport.ExportAllTables(const AFolder: string; AFormat: TDataFileFormat;
  AIncludeHeaders: Boolean; ADelimiter: Char; out AExportedCount: Integer;
  AOnProgress: TExportProgressProc): Boolean;
var
  Structure: TDatabaseStructure;
  BatchFmt: TBatchTableExportFormat;
begin
  AExportedCount := 0;
  Result := False;
  case AFormat of
    dffSQL: BatchFmt := btfSQL;
    dffCSV: BatchFmt := btfCSV;
    dffExcel: BatchFmt := btfExcel;
  else
    Exit;
  end;

  Structure := FDB.GetDatabaseStructure;
  Result := FDB.ExportAllTablesToFolder(AFolder, BatchFmt, AIncludeHeaders, ADelimiter, AOnProgress);
  if Result then
    AExportedCount := Length(Structure.Tables);
end;

function TImportExport.ExportDatabase(const AFilePath: string; AFormat: TDataFileFormat;
  AIncludeHeaders: Boolean; ADelimiter: Char; AOnProgress: TExportProgressProc): Boolean;
var
  Folder: string;
  Count: Integer;
begin
  case AFormat of
    dffSQL:
      Result := ExportDatabaseToSQL(AFilePath, AOnProgress);
    dffExcel:
      Result := ExportDatabaseToExcel(AFilePath, AOnProgress);
    dffCSV:
      begin
        Folder := ChangeFileExt(AFilePath, '');
        if not DirectoryExists(Folder) then
        begin
          if not ForceDirectories(Folder) then
          begin
            FDB.LastError := 'Cannot create folder: ' + Folder;
            Result := False;
            Exit;
          end;
        end;
        Result := ExportAllTables(Folder, dffCSV, AIncludeHeaders, ADelimiter, Count,
          AOnProgress);
      end;
  else
    Result := False;
  end;
end;

function TImportExport.ExportToCSV(const ATableName, AFilePath: string;
  AIncludeHeaders: Boolean; ADelimiter: Char; AOnProgress: TExportProgressProc): Boolean;
begin
  Result := FDB.ExportToCSV(ATableName, AFilePath, AIncludeHeaders, ADelimiter, AOnProgress);
end;

function TImportExport.ExportToSQL(const ATableName, AFilePath: string;
  AOnProgress: TExportProgressProc): Boolean;
begin
  Result := FDB.ExportTableToSQLFile(ATableName, AFilePath, AOnProgress);
end;

function TImportExport.ExportViewToSQL(const AViewName, AFilePath: string;
  const ASchema: string; AOnProgress: TExportProgressProc): Boolean;
begin
  Result := FDB.ExportViewToSQLFile(AViewName, AFilePath, ASchema, AOnProgress);
end;

function TImportExport.ExportDatabaseToSQL(const AFilePath: string;
  AOnProgress: TExportProgressProc): Boolean;
begin
  Result := FDB.ExportDatabaseToSQLFile(AFilePath, AOnProgress);
end;

function TImportExport.ExportToXML(const ATableName, AFilePath: string): Boolean;
var
  DataRes: TQueryResult;
  SL: TStringList;
  I, J: Integer;
  Row: TRowData;
begin
  Result := False;
  try
    DataRes := FDB.GetTableData(ATableName, -1, 0);

    if not DataRes.Success then
      Exit;

    SL := TStringList.Create;
    try
      SL.Add('<?xml version="1.0" encoding="UTF-8"?>');
      SL.Add('<table name="' + ATableName + '">');
      SL.Add('  <data>');

      for I := 0 to DataRes.RowCount - 1 do
      begin
        SL.Add('    <row>');
        Row := DataRes.Rows[I];

        for J := 0 to High(Row) do
        begin
          if VarIsNull(Row[J]) then
            SL.Add('      <' + DataRes.Columns[J] + '/>')
          else
            SL.Add('      <' + DataRes.Columns[J] + '>' +
              StringReplace(VarToStr(Row[J]), '&', '&amp;', [rfReplaceAll]) +
              '</' + DataRes.Columns[J] + '>');
        end;

        SL.Add('    </row>');
      end;

      SL.Add('  </data>');
      SL.Add('</table>');

      SL.SaveToFile(AFilePath, TEncoding.UTF8);
      Result := True;
    finally
      SL.Free;
    end;
  except
    on E: Exception do
      FDB.LastError := E.Message;
  end;
end;

procedure TImportExport.SplitSQLScript(const ASQL: string; AStatements: TStringList);
var
  P: Integer;
  InQuote: Boolean;
  QuoteChar: Char;
  Stmt: string;
  Ch: Char;
begin
  AStatements.Clear;
  Stmt := '';
  InQuote := False;
  QuoteChar := #0;
  P := 1;
  while P <= Length(ASQL) do
  begin
    Ch := ASQL[P];
    if InQuote then
    begin
      Stmt := Stmt + Ch;
      if Ch = QuoteChar then
      begin
        if (P < Length(ASQL)) and (ASQL[P + 1] = QuoteChar) then
        begin
          Stmt := Stmt + ASQL[P + 1];
          Inc(P, 2);
          Continue;
        end
        else
          InQuote := False;
      end;
    end
    else
    begin
      if (Ch = '''') or (Ch = '"') then
      begin
        InQuote := True;
        QuoteChar := Ch;
        Stmt := Stmt + Ch;
      end
      else if Ch = ';' then
      begin
        Stmt := Trim(Stmt);
        if Stmt <> '' then
          AStatements.Add(Stmt);
        Stmt := '';
      end
      else
        Stmt := Stmt + Ch;
    end;
    Inc(P);
  end;
  Stmt := Trim(Stmt);
  if Stmt <> '' then
    AStatements.Add(Stmt);
end;

function TImportExport.ImportFromSQL(const AFilePath: string): Boolean;
var
  SL, Stmts: TStringList;
  I: Integer;
  Res: TQueryResult;
begin
  Result := False;
  SL := TStringList.Create;
  Stmts := TStringList.Create;
  try
    SL.LoadFromFile(AFilePath, TEncoding.UTF8);
    SplitSQLScript(SL.Text, Stmts);
    for I := 0 to Stmts.Count - 1 do
    begin
      if Trim(Stmts[I]) = '' then
        Continue;
      Res := FDB.ExecuteSQL(Stmts[I]);
      if not Res.Success then
      begin
        FDB.LastError := Res.ErrorMessage;
        Exit;
      end;
    end;
    Result := True;
  except
    on E: Exception do
      FDB.LastError := E.Message;
  end;
  SL.Free;
  Stmts.Free;
end;

function TImportExport.ImportFromDelimitedText(const AFilePath, ATableName: string;
  ACreateTable: Boolean; ADelimiter: Char): Integer;
begin
  Result := FDB.ImportFromCSV(AFilePath, ATableName, ACreateTable, ADelimiter);
end;

function TImportExport.DecodeXmlEntities(const S: string): string;
begin
  Result := S;
  Result := StringReplace(Result, '&amp;', '&', [rfReplaceAll]);
  Result := StringReplace(Result, '&lt;', '<', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;', '>', [rfReplaceAll]);
  Result := StringReplace(Result, '&quot;', '"', [rfReplaceAll]);
end;

function TImportExport.ImportFromSpreadsheetML(const XML, ATableName: string;
  ACreateTable: Boolean): Integer;
var
  S, RowPart, CellVal, ValuesStr: string;
  RowStart, RowEnd, DataStart, DataEnd, P: Integer;
  Headers: TStringList;
  ColDefs: TArray<TColumnDef>;
  ColDef: TColumnDef;
  FirstRow: Boolean;
  Structure: TDatabaseStructure;
  TableExists: Boolean;

  procedure CreateTableFromHeaders;
  var
    J: Integer;
  begin
    if not ACreateTable or (Headers.Count = 0) then
      Exit;
    Structure := FDB.GetDatabaseStructure;
    TableExists := False;
    for J := 0 to High(Structure.Tables) do
      if SameText(Structure.Tables[J], ATableName) then
      begin
        TableExists := True;
        Break;
      end;
    if TableExists then
      Exit;
    SetLength(ColDefs, Headers.Count);
    for J := 0 to Headers.Count - 1 do
    begin
      ColDef.Name := Headers[J];
      if ColDef.Name = '' then
        ColDef.Name := 'col' + IntToStr(J + 1);
      ColDef.TypeName := 'TEXT';
      ColDef.NotNull := False;
      ColDef.DefaultVal := '';
      ColDef.PK := False;
      ColDef.AutoInc := False;
      ColDef.ColumnType := sctText;
      ColDefs[J] := ColDef;
    end;
    if not FDB.CreateTable(ATableName, ColDefs) then
      raise Exception.Create(FDB.LastError);
  end;

begin
  Result := 0;
  Headers := TStringList.Create;
  try
    S := XML;
    FirstRow := True;
    RowStart := Pos('<Row>', S);
    while RowStart > 0 do
    begin
      RowEnd := PosEx('</Row>', S, RowStart);
      if RowEnd = 0 then
        Break;
      RowPart := Copy(S, RowStart, RowEnd - RowStart + 6);
      Delete(S, 1, RowEnd + 5);

      ValuesStr := '';
      P := 1;
      while True do
      begin
        DataStart := PosEx('<Data', RowPart, P);
        if DataStart = 0 then
          Break;
        DataStart := PosEx('>', RowPart, DataStart);
        if DataStart = 0 then
          Break;
        Inc(DataStart);
        DataEnd := PosEx('</Data>', RowPart, DataStart);
        if DataEnd = 0 then
          Break;
        CellVal := DecodeXmlEntities(Copy(RowPart, DataStart, DataEnd - DataStart));
        if FirstRow then
          Headers.Add(CellVal)
        else
        begin
          if ValuesStr <> '' then
            ValuesStr := ValuesStr + ', ';
          if CellVal = '' then
            ValuesStr := ValuesStr + 'NULL'
          else
            ValuesStr := ValuesStr + '''' +
              StringReplace(CellVal, '''', '''''', [rfReplaceAll]) + '''';
        end;
        P := DataEnd;
      end;

      if FirstRow then
      begin
        CreateTableFromHeaders;
        FirstRow := False;
      end
      else if ValuesStr <> '' then
      begin
        FDB.ExecuteSQL(Format('INSERT INTO "%s" VALUES (%s)', [ATableName, ValuesStr]));
        Inc(Result);
      end;

      RowStart := Pos('<Row>', S);
    end;
  finally
    Headers.Free;
  end;
end;

function TImportExport.ImportFromExcelFile(const AFilePath, ATableName: string;
  ACreateTable: Boolean): Integer;
var
  SL: TStringList;
  Content: string;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(AFilePath, TEncoding.UTF8);
    Content := SL.Text;
    if Pos('urn:schemas-microsoft-com:office:spreadsheet', Content) > 0 then
      Result := ImportFromSpreadsheetML(Content, ATableName, ACreateTable)
    else
      Result := ImportFromDelimitedText(AFilePath, ATableName, ACreateTable, #9);
  finally
    SL.Free;
  end;
end;

function TImportExport.ImportFromFile(const AFilePath: string; AFormat: TDataFileFormat;
  const ATableName: string; ACreateTable: Boolean; ADelimiter: Char;
  out ARowsImported: Integer): Boolean;
begin
  ARowsImported := 0;
  Result := False;
  case AFormat of
    dffSQL:
      Result := ImportFromSQL(AFilePath);
    dffCSV:
      begin
        ARowsImported := ImportFromCSV(AFilePath, ATableName, ACreateTable, ADelimiter);
        Result := ARowsImported >= 0;
        if (ARowsImported = 0) and (FDB.LastError <> '') then
          Result := False;
      end;
    dffExcel:
      begin
        ARowsImported := ImportFromExcelFile(AFilePath, ATableName, ACreateTable);
        Result := ARowsImported >= 0;
        if (ARowsImported = 0) and (FDB.LastError <> '') then
          Result := False;
      end;
  end;
  if Result and (AFormat = dffSQL) then
    ARowsImported := -1;
end;

function TImportExport.ImportFromCSV(const AFilePath, ATableName: string;
  ACreateTable: Boolean; ADelimiter: Char): Integer;
begin
  Result := FDB.ImportFromCSV(AFilePath, ATableName, ACreateTable, ADelimiter);
end;

function TImportExport.ImportFromXML(const AFilePath, ATableName: string): Integer;
var
  SL: TStringList;
  XML: string;
  Pos1, Pos2: Integer;
  RowStart, RowEnd: Integer;
  ColName, ColValue: string;
  ValuesList: string;
  InsertSQL: string;
begin
  Result := 0;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(AFilePath, TEncoding.UTF8);
    XML := SL.Text;

    RowStart := Pos('<row>', XML);

    while RowStart > 0 do
    begin
      RowEnd := Pos('</row>', XML);
      if RowEnd = 0 then
        Break;

      var RowContent := Copy(XML, RowStart + 5, RowEnd - RowStart - 5);

      ValuesList := '';
      Pos1 := 1;

      while True do
      begin
        Pos1 := Pos('<', Copy(RowContent, Pos1, Length(RowContent)));
        if Pos1 = 0 then
          Break;

        Pos2 := Pos('>', Copy(RowContent, Pos1, Length(RowContent)));
        if Pos2 = 0 then
          Break;

        ColName := Copy(RowContent, Pos1 + 1, Pos2 - Pos1 - 1);

        if Copy(RowContent, Pos2 - 1, 2) = '/>' then
        begin
          if ValuesList <> '' then
            ValuesList := ValuesList + ', ';
          ValuesList := ValuesList + 'NULL';
          Pos1 := Pos1 + Pos2;
        end
        else
        begin
          var CloseTag := '</' + ColName + '>';
          var ClosePos := Pos(CloseTag, Copy(RowContent, Pos2, Length(RowContent)));

          if ClosePos > 0 then
          begin
            ColValue := Copy(RowContent, Pos2 + 1, ClosePos - Pos2 - 1);
            ColValue := StringReplace(ColValue, '&amp;', '&', [rfReplaceAll]);

            if ValuesList <> '' then
              ValuesList := ValuesList + ', ';
            ValuesList := ValuesList + '''' + StringReplace(ColValue, '''', '''''', [rfReplaceAll]) + '''';

            Pos1 := Pos1 + ClosePos + Length(CloseTag);
          end
          else
            Break;
        end;
      end;

      if ValuesList <> '' then
      begin
        InsertSQL := 'INSERT INTO "' + ATableName + '" VALUES (' + ValuesList + ')';
        FDB.ExecuteSQL(InsertSQL);
        Inc(Result);
      end;

      Delete(XML, 1, RowEnd + 6);
      RowStart := Pos('<row>', XML);
    end;

  except
    on E: Exception do
      FDB.LastError := E.Message;
  end;
  SL.Free;
end;

end.
