unit RowEditForm;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, DBModule, System.Generics.Collections;
type
  TFieldData = record
    ColName: string;
    ColType: string;
    OldValue: Variant;
    NewValue: Variant;
    IsPK: Boolean;
    NotNull: Boolean;
    DefaultVal: string;
  end;
  TfrmRowEdit = class(TForm)
    pnlContent: TPanel;
    pnlFooter: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    scrFields: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure scrFieldsMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure scrFieldsMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    FDB: TSQLiteHandler;
    FTableName: string;
    FColumns: TArray<TColumnDef>;
    FFieldData: TArray<TFieldData>;
    FIsInsert: Boolean;
    FRowId: string;
    FEditControls: TObjectList<TWinControl>;
    function CreateEditControl(const AField: TFieldData; AIndex: Integer): TWinControl;
    procedure LoadFieldData;
    procedure LoadExistingRecord;
  public
    constructor CreateEdit(AOwner: TComponent; ADB: TSQLiteHandler;
      const ATableName: string; const AColumns: TArray<TColumnDef>;
      const ARowId: string; AIsInsert: Boolean);
    destructor Destroy; override;
  end;
implementation
{$R *.dfm}
{ TfrmRowEdit }
constructor TfrmRowEdit.CreateEdit(AOwner: TComponent; ADB: TSQLiteHandler;
  const ATableName: string; const AColumns: TArray<TColumnDef>;
  const ARowId: string; AIsInsert: Boolean);
begin
  inherited Create(AOwner);
  FDB := ADB;
  FTableName := ATableName;
  FColumns := AColumns;
  FRowId := ARowId;
  FIsInsert := AIsInsert;
  FEditControls := TObjectList<TWinControl>.Create;
  if AIsInsert then
    Caption := 'Add Record - ' + ATableName
  else
    Caption := 'Edit Record - ' + ATableName;
  LoadFieldData;
end;
destructor TfrmRowEdit.Destroy;
begin
  // FEditControls owns its objects, so they will be freed automatically
  inherited Destroy;
end;
procedure TfrmRowEdit.FormActivate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FEditControls.Count - 1 do
    FEditControls[I].Anchors := [akLeft, akTop, akRight];

end;

procedure TfrmRowEdit.FormCreate(Sender: TObject);
begin
  // FEditControls already created in constructor
end;
procedure TfrmRowEdit.FormDestroy(Sender: TObject);
begin
  // FEditControls freed automatically by TObjectList
end;
procedure TfrmRowEdit.LoadFieldData;
var
  I: Integer;
  Field: TFieldData;
  EditCtrl: TWinControl;
  LabelCtrl: TLabel;
  HBox: TPanel;
begin
  SetLength(FFieldData, Length(FColumns));
  for I := 0 to High(FColumns) do
  begin
    Field.ColName := FColumns[I].Name;
    Field.ColType := FColumns[I].TypeName;
    Field.IsPK := FColumns[I].PK;
    Field.NotNull := FColumns[I].NotNull;
    Field.DefaultVal := FColumns[I].DefaultVal;
    Field.OldValue := Null;
    Field.NewValue := Null;
    FFieldData[I] := Field;
  end;
  // Load existing record if not insert
  if not FIsInsert then
    LoadExistingRecord;
  // Create UI controls
  for I := 0 to High(FFieldData) do
  begin
    // Create horizontal box
    HBox := TPanel.Create(scrFields);
    HBox.Parent := scrFields;
    HBox.Align := alTop;
    HBox.Height := 35;
    HBox.BevelOuter := bvNone;
    // Create label
    LabelCtrl := TLabel.Create(HBox);
    LabelCtrl.Parent := HBox;
    LabelCtrl.Left := 5;
    LabelCtrl.Top := 8;
    LabelCtrl.Width := 200;
    LabelCtrl.Caption := Format('%d. %s (%s)', [I + 1, FFieldData[I].ColName, FFieldData[I].ColType]);
    // Create edit control
    EditCtrl := CreateEditControl(FFieldData[I], I);
    EditCtrl.Parent := HBox;
    EditCtrl.Left := 210;
    EditCtrl.Top := 5;
    EditCtrl.Width := scrFields.Width - EditCtrl.Left - 30;  // Width minus 10px from window width
    FEditControls.Add(EditCtrl);
  end;
  // Set groupbox height to fit all controls
  scrFields.Height := (High(FFieldData) + 1) * 35 + 10;
end;

procedure TfrmRowEdit.LoadExistingRecord;
var
  SQL: string;
  QueryResult: TQueryResult;
  I: Integer;
begin
  // Build WHERE clause from rowid
  SQL := Format('SELECT rowid, * FROM "%s" WHERE rowid = %s', [FTableName, FRowId]);
  QueryResult := FDB.ExecuteSQL(SQL);

  if QueryResult.Success and (QueryResult.RowCount > 0) then
  begin
    // Skip first column (rowid) when loading data
    for I := 0 to High(FFieldData) do
    begin
      FFieldData[I].OldValue := QueryResult.Rows[0][I + 1]; // +1 because first column is rowid
      FFieldData[I].NewValue := QueryResult.Rows[0][I + 1];
    end;
  end;
end;

function TfrmRowEdit.CreateEditControl(const AField: TFieldData; AIndex: Integer): TWinControl;
var
  Edit: TEdit;
  Memo: TMemo;
begin
  // Decide which control to create based on field type
  if Pos('INT', UpperCase(AField.ColType)) > 0 then
  begin
    // Integer field
    Edit := TEdit.Create(scrFields);
    if not VarIsNull(AField.NewValue) then
      Edit.Text := VarToStr(AField.NewValue);
    Edit.Tag := AIndex;
    Result := Edit;
  end
  else if (Pos('TEXT', UpperCase(AField.ColType)) > 0) or
          (Pos('CHAR', UpperCase(AField.ColType)) > 0) then
  begin
    // Text field - use Memo for longer text
    var TextStr := VarToStr(AField.NewValue);
    if Length(TextStr) > 50000 then
    begin
      Memo := TMemo.Create(scrFields);
      Memo.Height := 80;
      if not VarIsNull(AField.NewValue) then
        Memo.Text := VarToStr(AField.NewValue);
      Memo.ScrollBars := ssVertical;
      Memo.Tag := AIndex;
      Result := Memo;
    end
    else
    begin
      Edit := TEdit.Create(scrFields);
      if not VarIsNull(AField.NewValue) then
        Edit.Text := VarToStr(AField.NewValue);
      Edit.Tag := AIndex;
      Result := Edit;
    end;
  end
  else if Pos('BLOB', UpperCase(AField.ColType)) > 0 then
  begin
    Edit := TEdit.Create(scrFields);
    Edit.ReadOnly := True;
    if not VarIsNull(AField.NewValue) then
    begin
      var BlobStr := VarToStr(AField.NewValue);
      Edit.Text := 'BLOB (' + IntToStr(Length(BlobStr)) + ' bytes)';
    end
    else
      Edit.Text := 'BLOB';
    Edit.Tag := AIndex;
    Result := Edit;
  end
  else
  begin
    // Default: Edit
    Edit := TEdit.Create(scrFields);
    if not VarIsNull(AField.NewValue) then
      Edit.Text := VarToStr(AField.NewValue);
    Edit.Tag := AIndex;
    Result := Edit;
  end;
end;

procedure TfrmRowEdit.btnOKClick(Sender: TObject);
var
  I: Integer;
  ValuesList, ColumnsList: string;
  SQL: string;
  Value: string;
begin
  if FIsInsert then
  begin
    // Build INSERT statement
    ColumnsList := '';
    ValuesList := '';
    for I := 0 to High(FFieldData) do
    begin
      // Get value from control
      if FEditControls[I] is TEdit then
        Value := TEdit(FEditControls.Items[I]).Text
      else if FEditControls[I] is TMemo then
        Value := TMemo(FEditControls.Items[I]).Text
      else
        Value := '';
      // Skip if empty and has default
      if (Value = '') and (FFieldData[I].DefaultVal <> '') then
        Continue;
      if ColumnsList <> '' then
      begin
        ColumnsList := ColumnsList + ', ';
        ValuesList := ValuesList + ', ';
      end;
      ColumnsList := ColumnsList + '"' + FFieldData[I].ColName + '"';
      if Value = '' then
        ValuesList := ValuesList + 'NULL'
      else if Pos('INT', UpperCase(FFieldData[I].ColType)) > 0 then
        ValuesList := ValuesList + Value
      else
        ValuesList := ValuesList + '''' + StringReplace(Value, '''', '''''', [rfReplaceAll]) + '''';
    end;
    SQL := Format('INSERT INTO "%s" (%s) VALUES (%s)', [FTableName, ColumnsList, ValuesList]);
  end
  else
  begin
    // Build UPDATE statement
    ValuesList := '';
    for I := 0 to High(FFieldData) do
    begin
      // Get value from control
      if FEditControls[I] is TEdit then
        Value := TEdit(FEditControls.Items[I]).Text
      else if FEditControls[I] is TMemo then
        Value := TMemo(FEditControls.Items[I]).Text
      else
        Value := '';
      
      // Skip primary key
      if FFieldData[I].IsPK then
        Continue;
      
      if ValuesList <> '' then
        ValuesList := ValuesList + ', ';
      
      if Value = '' then
        ValuesList := ValuesList + '"' + FFieldData[I].ColName + '" = NULL'
      else if Pos('INT', UpperCase(FFieldData[I].ColType)) > 0 then
        ValuesList := ValuesList + '"' + FFieldData[I].ColName + '" = ' + Value
      else
        ValuesList := ValuesList + '"' + FFieldData[I].ColName + '" = ''' + 
                      StringReplace(Value, '''', '''''', [rfReplaceAll]) + '''';
    end;
    
    SQL := Format('UPDATE "%s" SET %s WHERE rowid = %s', [FTableName, ValuesList, FRowId]);
  end;
  
  // Execute SQL
  var Result := FDB.ExecuteSQL(SQL);
  
  if Result.Success then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    ShowMessage('Error: ' + Result.ErrorMessage);
  end;
end;

procedure TfrmRowEdit.scrFieldsMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  if scrFields.VertScrollBar.Position >= 50 then
    scrFields.VertScrollBar.Position := scrFields.VertScrollBar.Position - 50
  else
    scrFields.VertScrollBar.Position := 0;
end;

procedure TfrmRowEdit.scrFieldsMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  scrFields.VertScrollBar.Position := scrFields.VertScrollBar.Position + 50;
end;

end.
