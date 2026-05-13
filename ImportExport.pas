{*******************************************************************************
  Import/Export Module for SQLite Manager
  Supports CSV, SQL, XML formats
*******************************************************************************}
unit ImportExport;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, DBModule, System.Variants;

type
  TImportExport = class
  private
    FDB: TSQLiteHandler;
  public
    constructor Create(ADB: TSQLiteHandler);
    
    // Export functions
    function ExportToCSV(const ATableName, AFilePath: string;
      AIncludeHeaders: Boolean; ADelimiter: Char): Boolean;
    function ExportToSQL(const ATableName, AFilePath: string): Boolean;
    function ExportDatabaseToSQL(const AFilePath: string): Boolean;
    function ExportToXML(const ATableName, AFilePath: string): Boolean;
    
    // Import functions
    function ImportFromCSV(const AFilePath, ATableName: string;
      ACreateTable: Boolean; ADelimiter: Char): Integer;
    function ImportFromSQL(const AFilePath: string): Boolean;
    function ImportFromXML(const AFilePath, ATableName: string): Integer;
  end;

implementation

{ TImportExport }

constructor TImportExport.Create(ADB: TSQLiteHandler);
begin
  inherited Create;
  FDB := ADB;
end;

function TImportExport.ExportToCSV(const ATableName, AFilePath: string;
  AIncludeHeaders: Boolean; ADelimiter: Char): Boolean;
begin
  Result := FDB.ExportToCSV(ATableName, AFilePath, AIncludeHeaders, ADelimiter);
end;

function TImportExport.ExportToSQL(const ATableName, AFilePath: string): Boolean;
var
  SQL: string;
  SL: TStringList;
begin
  Result := False;
  try
    SQL := FDB.ExportToSQL(ATableName);
    SL := TStringList.Create;
    try
      SL.Text := SQL;
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

function TImportExport.ExportDatabaseToSQL(const AFilePath: string): Boolean;
var
  SQL: string;
  SL: TStringList;
begin
  Result := False;
  try
    SQL := FDB.ExportDatabaseToSQL;
    SL := TStringList.Create;
    try
      SL.Text := SQL;
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

function TImportExport.ImportFromCSV(const AFilePath, ATableName: string;
  ACreateTable: Boolean; ADelimiter: Char): Integer;
begin
  Result := FDB.ImportFromCSV(AFilePath, ATableName, ACreateTable, ADelimiter);
end;

function TImportExport.ImportFromSQL(const AFilePath: string): Boolean;
var
  SL: TStringList;
  SQL: string;
  Res: TQueryResult;
begin
  Result := False;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(AFilePath, TEncoding.UTF8);
    SQL := SL.Text;
    
    Res := FDB.ExecuteSQL(SQL);
    Result := Res.Success;
    
    if not Result then
      FDB.LastError := Res.ErrorMessage;
  except
    on E: Exception do
      FDB.LastError := E.Message;
  end;
  SL.Free;
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
    
    // Simple XML parser
    RowStart := Pos('<row>', XML);
    
    while RowStart > 0 do
    begin
      RowEnd := Pos('</row>', XML);
      if RowEnd = 0 then
        Break;
      
      // Extract row content
      var RowContent := Copy(XML, RowStart + 5, RowEnd - RowStart - 5);
      
      // Parse columns
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
        
        // Check for self-closing tag (NULL value)
        if Copy(RowContent, Pos2 - 1, 2) = '/>' then
        begin
          if ValuesList <> '' then
            ValuesList := ValuesList + ', ';
          ValuesList := ValuesList + 'NULL';
          Pos1 := Pos1 + Pos2;
        end
        else
        begin
          // Find closing tag
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
      
      // Insert row
      if ValuesList <> '' then
      begin
        InsertSQL := 'INSERT INTO "' + ATableName + '" VALUES (' + ValuesList + ')';
        FDB.ExecuteSQL(InsertSQL);
        Inc(Result);
      end;
      
      // Move to next row
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
