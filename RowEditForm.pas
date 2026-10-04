unit RowEditForm;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, System.Types, System.DateUtils, System.StrUtils, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, DBModule, System.Generics.Collections;
type
  TFieldData = record
    ColName: string;
    ColType: string;
    OldValue: Variant;
    NewValue: Variant;
    IsPK: Boolean;
    IsAutoInc: Boolean;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDB: TSQLiteHandler;
    FTableName: string;
    FColumns: TArray<TColumnDef>;
    FFieldData: TArray<TFieldData>;
    FIsInsert: Boolean;
    FIsDuplicate: Boolean;
    FRowId: string;
    FInsertedRowId: Int64; // rowid of the row created by an insert or duplicate
    FEditControls: TObjectList<TWinControl>;
    FFieldLabels: TArray<TLabel>;
    function FormSizeKey: string;
    procedure LayoutEditControls;
    function CreateEditControl(const AField: TFieldData; AIndex: Integer): TWinControl;
    function IsBlobField(const AField: TFieldData; AIndex: Integer): Boolean;
    function IsDateTimeField(const AField: TFieldData): Boolean;
    function IsDateOnlyField(const AField: TFieldData): Boolean;
    function ParseDateTimeField(const S: string; out ADate: TDateTime): Boolean;
    function ValueHasTimePart(const S: string): Boolean;
    function FormatDateTimeForField(const ADate: TDateTime; const AOriginal: string;
      const AField: TFieldData): string;
    procedure SetupCalendarButtonGlyph(ABtn: TSpeedButton);
    procedure SetupBlobButtonGlyph(ABtn: TSpeedButton);
    procedure SetControlText(Ctrl: TWinControl; const AText: string);
    procedure CalendarButtonClick(Sender: TObject);
    procedure BlobButtonClick(Sender: TObject);
    function BlobBytesToDisplayText(const B: TBytes): string;
    procedure BlobViewerFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BlobViewerMemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function FieldValueChanged(const AField: TFieldData; const AValue: string): Boolean;
    function IsExplicitNullText(const AText: string): Boolean;
    function IsNullFieldText(const AText: string): Boolean;
    function GetControlText(Ctrl: TWinControl): string;
    function GetTypeColor(ColType: TSQLiteColumnType): TColor;
    function GetFieldControlColor(AIndex: Integer; const AText: string): TColor;
    procedure ApplyControlColor(Ctrl: TWinControl; AColor: TColor);
    procedure UpdateFieldAppearance(AIndex: Integer);
    procedure FieldControlChange(Sender: TObject);
    procedure LoadFieldData;
    procedure LoadExistingRecord;
    function ExecuteDuplicateInsert: Boolean;
  public
    constructor CreateEdit(AOwner: TComponent; ADB: TSQLiteHandler;
      const ATableName: string; const AColumns: TArray<TColumnDef>;
      const ARowId: string; AIsInsert: Boolean; AIsDuplicate: Boolean = False);
    destructor Destroy; override;
    property InsertedRowId: Int64 read FInsertedRowId;
  end;
implementation

uses
  DialogFormSize;

{$R *.dfm}
// Same cell colors as sgBrowse/sgExecute (BGR)
const
  clIntegerCell = $CCFFCC;
  clFloatCell   = $66FF66;
  clTextCell    = $FFFFCC;
  clNullCell    = $CCCCFF;
  clBlobCell    = $FFCCCC;
  cFieldHBoxMargin  = 5;
  cFieldLeft        = 210;
  cCalendarBtnWidth = 28;
  cCalendarBtnLeft = cFieldLeft - cCalendarBtnWidth;
  cBlobBtnWidth = 28;
  cBlobBtnLeft = cFieldLeft - cBlobBtnWidth;
{ TfrmRowEdit }
constructor TfrmRowEdit.CreateEdit(AOwner: TComponent; ADB: TSQLiteHandler;
  const ATableName: string; const AColumns: TArray<TColumnDef>;
  const ARowId: string; AIsInsert: Boolean; AIsDuplicate: Boolean);
begin
  inherited Create(AOwner);
  FDB := ADB;
  FTableName := ATableName;
  FColumns := AColumns;
  FRowId := ARowId;
  FIsInsert := AIsInsert;
  FIsDuplicate := AIsDuplicate;
  FEditControls := TObjectList<TWinControl>.Create;
  if FIsDuplicate then
    Caption := 'Duplicate Record - ' + ATableName
  else if AIsInsert then
    Caption := 'Add Record - ' + ATableName
  else
    Caption := 'Edit Record - ' + ATableName;
  LoadDialogFormSize(Self, FormSizeKey);
  LoadFieldData;
  LayoutEditControls;
end;

function TfrmRowEdit.FormSizeKey: string;
begin
  if FIsDuplicate then
    Result := 'Duplicate'
  else if FIsInsert then
    Result := 'Add'
  else
    Result := 'Edit';
end;

destructor TfrmRowEdit.Destroy;
begin
  // FEditControls owns its objects, so they will be freed automatically
  inherited Destroy;
end;
procedure TfrmRowEdit.FormActivate(Sender: TObject);
begin
  LayoutEditControls;
end;

procedure TfrmRowEdit.FormShow(Sender: TObject);
begin
  LayoutEditControls;
end;

procedure TfrmRowEdit.FormResize(Sender: TObject);
begin
  LayoutEditControls;
end;

procedure TfrmRowEdit.LayoutEditControls;
var
  I: Integer;
  Ctrl: TWinControl;
  HBox: TWinControl;
  NewWidth: Integer;
begin
  for I := 0 to FEditControls.Count - 1 do
  begin
    Ctrl := FEditControls[I];
    HBox := Ctrl.Parent;
    if HBox = nil then
      Continue;
    NewWidth := HBox.ClientWidth - cFieldLeft - cFieldHBoxMargin;
    if NewWidth < 80 then
      NewWidth := 80;
    Ctrl.Left := cFieldLeft;
    Ctrl.Width := NewWidth;
    Ctrl.Anchors := [akLeft, akTop];
  end;
end;

procedure TfrmRowEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveDialogFormSize(Self, FormSizeKey);
end;

procedure TfrmRowEdit.FormCreate(Sender: TObject);
begin
  ApplyDialogMinConstraints(Self);
end;
procedure TfrmRowEdit.FormDestroy(Sender: TObject);
begin
  // FEditControls freed automatically by TObjectList
end;
function TfrmRowEdit.GetControlText(Ctrl: TWinControl): string;
begin
  if Ctrl is TEdit then
    Result := TEdit(Ctrl).Text
  else if Ctrl is TMemo then
    Result := TMemo(Ctrl).Text
  else
    Result := '';
end;

procedure TfrmRowEdit.SetControlText(Ctrl: TWinControl; const AText: string);
begin
  if Ctrl is TEdit then
    TEdit(Ctrl).Text := AText
  else if Ctrl is TMemo then
    TMemo(Ctrl).Text := AText;
end;

procedure TfrmRowEdit.ApplyControlColor(Ctrl: TWinControl; AColor: TColor);
begin
  if Ctrl is TEdit then
    TEdit(Ctrl).Color := AColor
  else if Ctrl is TMemo then
    TMemo(Ctrl).Color := AColor;
end;

function TfrmRowEdit.GetTypeColor(ColType: TSQLiteColumnType): TColor;
begin
  case ColType of
    sctInteger: Result := clIntegerCell;
    sctReal: Result := clFloatCell;
    sctText: Result := clTextCell;
    sctBlob: Result := clBlobCell;
    sctNull: Result := clNullCell;
  else
    Result := clWindow;
  end;
end;

function TfrmRowEdit.IsExplicitNullText(const AText: string): Boolean;
begin
  Result := SameText(Trim(AText), 'NULL');
end;

function TfrmRowEdit.IsNullFieldText(const AText: string): Boolean;
begin
  Result := (Trim(AText) = '') or IsExplicitNullText(AText);
end;

function TfrmRowEdit.GetFieldControlColor(AIndex: Integer; const AText: string): TColor;
var
  Field: TFieldData;
  ColType: TSQLiteColumnType;
begin
  Field := FFieldData[AIndex];
  ColType := FColumns[AIndex].ColumnType;

  if IsBlobField(Field, AIndex) then
    Exit(clBlobCell);

  if IsNullFieldText(AText) then
  begin
    if FIsInsert and Field.IsAutoInc and (Trim(AText) = '') then
      Exit(GetTypeColor(sctInteger));
    Exit(clNullCell);
  end;

  Result := GetTypeColor(ColType);
end;

procedure TfrmRowEdit.UpdateFieldAppearance(AIndex: Integer);
var
  Ctrl: TWinControl;
  LabelCtrl: TLabel;
  TextVal: string;
begin
  if (AIndex < 0) or (AIndex >= FEditControls.Count) then
    Exit;

  Ctrl := FEditControls[AIndex];
  LabelCtrl := FFieldLabels[AIndex];
  TextVal := GetControlText(Ctrl);

  if FIsInsert then
    LabelCtrl.Font.Color := clWindowText
  else if FieldValueChanged(FFieldData[AIndex], TextVal) then
    LabelCtrl.Font.Color := clBlue
  else
    LabelCtrl.Font.Color := clWindowText;

  ApplyControlColor(Ctrl, GetFieldControlColor(AIndex, TextVal));
end;

procedure TfrmRowEdit.FieldControlChange(Sender: TObject);
begin
  if Sender is TWinControl then
    UpdateFieldAppearance(TWinControl(Sender).Tag);
end;

procedure TfrmRowEdit.LoadFieldData;
var
  I: Integer;
  Field: TFieldData;
  EditCtrl: TWinControl;
  LabelCtrl: TLabel;
  CalBtn: TSpeedButton;
  BlobBtn: TSpeedButton;
  HBox: TPanel;
begin
  SetLength(FFieldData, Length(FColumns));
  for I := 0 to High(FColumns) do
  begin
    Field.ColName := FColumns[I].Name;
    Field.ColType := FColumns[I].TypeName;
    Field.IsPK := FColumns[I].PK;
    Field.IsAutoInc := FColumns[I].AutoInc;
    Field.NotNull := FColumns[I].NotNull;
    Field.DefaultVal := FColumns[I].DefaultVal;
    Field.OldValue := Null;
    Field.NewValue := Null;
    FFieldData[I] := Field;
  end;
  if (not FIsInsert) or FIsDuplicate then
    LoadExistingRecord;

  if FIsDuplicate then
  begin
    for I := 0 to High(FFieldData) do
      if FFieldData[I].IsAutoInc then
      begin
        FFieldData[I].OldValue := Null;
        FFieldData[I].NewValue := Null;
      end;
  end;
  // Create UI controls
  SetLength(FFieldLabels, Length(FFieldData));
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
    LabelCtrl.Left := cFieldHBoxMargin;
    LabelCtrl.Top := 8;
    LabelCtrl.Width := 200;
    LabelCtrl.Caption := Format('%d. %s (%s)', [I + 1, FFieldData[I].ColName, FFieldData[I].ColType]);
    FFieldLabels[I] := LabelCtrl;
    // Create edit control
    EditCtrl := CreateEditControl(FFieldData[I], I);
    EditCtrl.Parent := HBox;
    EditCtrl.Top := 5;
    if IsDateTimeField(FFieldData[I]) then
    begin
      CalBtn := TSpeedButton.Create(HBox);
      CalBtn.Parent := HBox;
      CalBtn.Left := cCalendarBtnLeft;
      CalBtn.Top := 5;
      CalBtn.Width := cCalendarBtnWidth;
      CalBtn.Height := 25;
      CalBtn.Tag := I;
      CalBtn.Flat := True;
      CalBtn.Hint := 'Select date';
      CalBtn.ShowHint := True;
      SetupCalendarButtonGlyph(CalBtn);
      CalBtn.OnClick := CalendarButtonClick;
    end;
    if IsBlobField(FFieldData[I], I) then
    begin
      BlobBtn := TSpeedButton.Create(HBox);
      BlobBtn.Parent := HBox;
      BlobBtn.Left := cBlobBtnLeft;
      BlobBtn.Top := 5;
      BlobBtn.Width := cBlobBtnWidth;
      BlobBtn.Height := 25;
      BlobBtn.Tag := I;
      BlobBtn.Flat := True;
      BlobBtn.Caption := '';
      BlobBtn.Enabled := (not FIsInsert) or FIsDuplicate;
      if FIsInsert and not FIsDuplicate then
        BlobBtn.Hint := 'BLOB view not available for new record'
      else
        BlobBtn.Hint := 'View BLOB';
      BlobBtn.ShowHint := True;
      SetupBlobButtonGlyph(BlobBtn);
      BlobBtn.OnClick := BlobButtonClick;
    end;
    EditCtrl.Left := cFieldLeft;
    if (FIsInsert or FIsDuplicate) and FFieldData[I].IsAutoInc then
      LabelCtrl.Font.Style := LabelCtrl.Font.Style + [fsItalic];
    FEditControls.Add(EditCtrl);
    UpdateFieldAppearance(I);
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
  SQL := Format('SELECT rowid, * FROM %s WHERE rowid = %s', [FTableName, FRowId]);
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

function TfrmRowEdit.IsBlobField(const AField: TFieldData; AIndex: Integer): Boolean;
var
  V: string;
begin
  Result :=
    ((AIndex >= 0) and (AIndex < Length(FColumns)) and (FColumns[AIndex].ColumnType = sctBlob)) or
    (Pos('BLOB', UpperCase(AField.ColType)) > 0);

  if Result then
    Exit;

  // SQLite dynamic typing: column declared VARCHAR, but row value storage-class may be BLOB.
  if not VarIsNull(AField.NewValue) and not VarIsEmpty(AField.NewValue) then
  begin
    V := Trim(VarToStr(AField.NewValue));
    if StartsText('BLOB', V) then
      Exit(True);
  end;
end;

function TfrmRowEdit.IsDateOnlyField(const AField: TFieldData): Boolean;
var
  U: string;
begin
  U := UpperCase(Trim(AField.ColType));
  Result := (U = 'DATE') or
    ((Pos('DATE', U) > 0) and (Pos('TIME', U) = 0) and (Pos('STAMP', U) = 0));
end;

function TfrmRowEdit.IsDateTimeField(const AField: TFieldData): Boolean;
var
  U: string;
begin
  U := UpperCase(Trim(AField.ColType));
  Result := (U = 'DATETIME') or (U = 'TIMESTAMP') or
    (Pos('DATETIME', U) > 0) or (Pos('TIMESTAMP', U) > 0) or
    IsDateOnlyField(AField);
end;

function TfrmRowEdit.ParseDateTimeField(const S: string; out ADate: TDateTime): Boolean;
var
  FS: TFormatSettings;
  Value: string;
begin
  Value := Trim(S);
  if Value = '' then
    Exit(False);

  if TryISO8601ToDate(Value, ADate) then
    Exit(True);

  FS := TFormatSettings.Create;
  FS.DateSeparator := '-';
  FS.TimeSeparator := ':';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.LongDateFormat := 'yyyy-mm-dd';
  FS.ShortTimeFormat := 'hh:nn:ss';
  FS.LongTimeFormat := 'hh:nn:ss';

  if TryStrToDateTime(Value, ADate, FS) then
    Exit(True);
  if TryStrToDate(Value, ADate, FS) then
    Exit(True);

  FS := TFormatSettings.Create;
  Result := TryStrToDateTime(Value, ADate, FS);
  if not Result then
    Result := TryStrToDate(Value, ADate, FS);
end;

function TfrmRowEdit.ValueHasTimePart(const S: string): Boolean;
var
  Value, TimePart: string;
  TPos, SpacePos: Integer;
  Dummy: TDateTime;
  FS: TFormatSettings;
begin
  Value := Trim(S);
  if Value = '' then
    Exit(False);

  TPos := Pos('T', Value);
  if TPos = 0 then
    TPos := Pos('t', Value);
  if TPos > 0 then
  begin
    TimePart := Copy(Value, TPos + 1, MaxInt);
    Exit(Pos(':', TimePart) > 0);
  end;

  SpacePos := Pos(' ', Value);
  if SpacePos > 0 then
  begin
    TimePart := Trim(Copy(Value, SpacePos + 1, MaxInt));
    if TimePart = '' then
      Exit(False);
    FS := TFormatSettings.Create;
    FS.TimeSeparator := ':';
    if TryStrToTime(TimePart, Dummy, FS) then
      Exit(True);
    Exit(TryStrToTime(TimePart, Dummy));
  end;

  Result := False;
end;

function TfrmRowEdit.FormatDateTimeForField(const ADate: TDateTime; const AOriginal: string;
  const AField: TFieldData): string;
var
  FS: TFormatSettings;
  Existing: TDateTime;
  Combined: TDateTime;
begin
  FS := TFormatSettings.Create;
  FS.DateSeparator := '-';
  FS.TimeSeparator := ':';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.LongDateFormat := 'yyyy-mm-dd';
  FS.ShortTimeFormat := 'hh:nn:ss';
  FS.LongTimeFormat := 'hh:nn:ss';

  if IsDateOnlyField(AField) then
    Exit(FormatDateTime('yyyy-mm-dd', ADate, FS));

  if (Trim(AOriginal) <> '') and not ValueHasTimePart(AOriginal) then
    Exit(FormatDateTime('yyyy-mm-dd', ADate, FS));

  if ParseDateTimeField(AOriginal, Existing) then
    Combined := DateOf(ADate) + TimeOf(Existing)
  else
    Combined := DateOf(ADate) + Time;
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Combined, FS);
end;

procedure TfrmRowEdit.SetupCalendarButtonGlyph(ABtn: TSpeedButton);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    Bmp.SetSize(16, 16);
    Bmp.Canvas.Brush.Color := clBtnFace;
    Bmp.Canvas.FillRect(Rect(0, 0, 16, 16));
    Bmp.Canvas.Pen.Color := clGray;
    Bmp.Canvas.Rectangle(2, 4, 14, 15);
    Bmp.Canvas.MoveTo(2, 7);
    Bmp.Canvas.LineTo(14, 7);
    Bmp.Canvas.Pen.Color := clMaroon;
    Bmp.Canvas.MoveTo(5, 2);
    Bmp.Canvas.LineTo(5, 5);
    Bmp.Canvas.MoveTo(11, 2);
    Bmp.Canvas.LineTo(11, 5);
    ABtn.Glyph.Assign(Bmp);
    ABtn.NumGlyphs := 1;
  finally
    Bmp.Free;
  end;
end;

procedure TfrmRowEdit.SetupBlobButtonGlyph(ABtn: TSpeedButton);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    Bmp.SetSize(16, 16);
    Bmp.Canvas.Brush.Color := clBtnFace;
    Bmp.Canvas.FillRect(Rect(0, 0, 16, 16));

    // Simple "cylinder" icon
    Bmp.Canvas.Pen.Color := clNavy;
    Bmp.Canvas.Brush.Color := $E6E6FF;
    Bmp.Canvas.Ellipse(3, 2, 13, 6);
    Bmp.Canvas.Rectangle(3, 4, 13, 13);
    Bmp.Canvas.Ellipse(3, 10, 13, 14);

    ABtn.Glyph.Assign(Bmp);
    ABtn.NumGlyphs := 1;
  finally
    Bmp.Free;
  end;
end;

function TfrmRowEdit.BlobBytesToDisplayText(const B: TBytes): string;
begin
  if Length(B) = 0 then
    Exit('');

  // Prefer UTF-8 text; if binary garbage, still show best-effort (replacement chars).
  Result := TEncoding.UTF8.GetString(B);
end;

procedure TfrmRowEdit.CalendarButtonClick(Sender: TObject);
var
  FieldIndex: Integer;
  Btn: TSpeedButton;
  Dlg: TForm;
  Cal: TMonthCalendar;
  BtnOK, BtnCancel: TButton;
  CurrentText, NewText: string;
  SelectedDate: TDateTime;
begin
  if not (Sender is TSpeedButton) then
    Exit;

  Btn := TSpeedButton(Sender);
  FieldIndex := Btn.Tag;
  if (FieldIndex < 0) or (FieldIndex >= FEditControls.Count) then
    Exit;

  CurrentText := GetControlText(FEditControls[FieldIndex]);
  if not ParseDateTimeField(CurrentText, SelectedDate) then
    SelectedDate := Date;

  Dlg := TForm.Create(Self);
  try
    Dlg.BorderStyle := bsDialog;
    Dlg.Caption := 'Select date';
    Dlg.Position := poOwnerFormCenter;
    Dlg.ClientWidth := 230;
    Dlg.ClientHeight := 210;

    Cal := TMonthCalendar.Create(Dlg);
    Cal.Parent := Dlg;
    Cal.Left := 8;
    Cal.Top := 8;
    Cal.Width := 210;
    Cal.Height := 160;
    Cal.Date := SelectedDate;

    BtnOK := TButton.Create(Dlg);
    BtnOK.Parent := Dlg;
    BtnOK.Caption := 'OK';
    BtnOK.ModalResult := mrOk;
    BtnOK.Default := True;
    BtnOK.SetBounds(48, 172, 75, 25);

    BtnCancel := TButton.Create(Dlg);
    BtnCancel.Parent := Dlg;
    BtnCancel.Caption := 'Cancel';
    BtnCancel.ModalResult := mrCancel;
    BtnCancel.Cancel := True;
    BtnCancel.SetBounds(130, 172, 75, 25);

    if Dlg.ShowModal = mrOk then
    begin
      NewText := FormatDateTimeForField(Cal.Date, CurrentText, FFieldData[FieldIndex]);
      SetControlText(FEditControls[FieldIndex], NewText);
      UpdateFieldAppearance(FieldIndex);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmRowEdit.BlobButtonClick(Sender: TObject);
var
  FieldIndex: Integer;
  Btn: TSpeedButton;
  Dlg: TForm;
  Memo: TMemo;
  BtnClose: TButton;
  Bytes: TBytes;
  Text: string;
begin
  if not (Sender is TSpeedButton) then
    Exit;

  Btn := TSpeedButton(Sender);
  FieldIndex := Btn.Tag;
  if (FieldIndex < 0) or (FieldIndex >= Length(FFieldData)) then
    Exit;

  if not IsBlobField(FFieldData[FieldIndex], FieldIndex) then
    Exit;

  Bytes := FDB.GetBlobDataByRowId(FTableName, FRowId, FFieldData[FieldIndex].ColName);
  Text := BlobBytesToDisplayText(Bytes);

  Dlg := TForm.Create(Self);
  try
    Dlg.BorderStyle := bsDialog;
    Dlg.Caption := Format('BLOB: %s (%d bytes)', [FFieldData[FieldIndex].ColName, Length(Bytes)]);
    Dlg.Position := poOwnerFormCenter;
    Dlg.ClientWidth := 640;
    Dlg.ClientHeight := 420;
    Dlg.KeyPreview := True;
    Dlg.OnKeyDown := BlobViewerFormKeyDown;

    Memo := TMemo.Create(Dlg);
    Memo.Parent := Dlg;
    Memo.Align := alClient;
    Memo.ReadOnly := True;
    Memo.ScrollBars := ssBoth;
    Memo.WordWrap := False;
    Memo.Font.Name := 'Consolas';
    Memo.Font.Size := 10;
    Memo.Lines.Text := Text;
    Memo.OnKeyDown := BlobViewerMemoKeyDown;

    BtnClose := TButton.Create(Dlg);
    BtnClose.Parent := Dlg;
    BtnClose.Caption := 'Close';
    BtnClose.ModalResult := mrClose;
    BtnClose.Align := alBottom;
    BtnClose.Height := 32;

    Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmRowEdit.BlobViewerFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    if Sender is TCustomForm then
      TCustomForm(Sender).ModalResult := mrClose;
  end;
end;

procedure TfrmRowEdit.BlobViewerMemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = Ord('A')) then
  begin
    Key := 0;
    if Sender is TMemo then
      TMemo(Sender).SelectAll;
  end
  else if Key = VK_ESCAPE then
  begin
    Key := 0;
    if (Sender is TWinControl) and (TWinControl(Sender).Owner is TCustomForm) then
      TCustomForm(TWinControl(Sender).Owner).ModalResult := mrClose;
  end;
end;

function TfrmRowEdit.FieldValueChanged(const AField: TFieldData; const AValue: string): Boolean;
var
  OldStr: string;
begin
  if VarIsNull(AField.OldValue) or VarIsEmpty(AField.OldValue) then
    Exit((AValue <> '') and not IsExplicitNullText(AValue));

  OldStr := VarToStr(AField.OldValue);
  if IsExplicitNullText(AValue) then
    Exit(True);
  if Pos('INT', UpperCase(AField.ColType)) > 0 then
    Result := Trim(AValue) <> Trim(OldStr)
  else
    Result := AValue <> OldStr;
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
    Edit.OnChange := FieldControlChange;
    Result := Edit;
  end
  else if IsDateTimeField(AField) then
  begin
    Edit := TEdit.Create(scrFields);
    if not VarIsNull(AField.NewValue) then
      Edit.Text := VarToStr(AField.NewValue);
    Edit.Tag := AIndex;
    Edit.OnChange := FieldControlChange;
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
      Memo.OnChange := FieldControlChange;
      Result := Memo;
    end
    else
    begin
      Edit := TEdit.Create(scrFields);
      if not VarIsNull(AField.NewValue) then
        Edit.Text := VarToStr(AField.NewValue);
      Edit.Tag := AIndex;
      Edit.OnChange := FieldControlChange;
      Result := Edit;
    end;
  end
  else if IsBlobField(AField, AIndex) then
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
    Edit.OnChange := FieldControlChange;
    Result := Edit;
  end;
end;

function TfrmRowEdit.ExecuteDuplicateInsert: Boolean;
var
  I, ColCount: Integer;
  Value: string;
  BoundVal: TBoundColumnValue;
  ColumnNames: TArray<string>;
  BoundValues: TArray<TBoundColumnValue>;
  InsertResult: TQueryResult;
  ColTypeU: string;
begin
  Result := False;
  ColCount := 0;
  SetLength(ColumnNames, Length(FFieldData));
  SetLength(BoundValues, Length(FFieldData));

  for I := 0 to High(FFieldData) do
  begin
    BoundVal.Kind := bvkNull;
    BoundVal.IntValue := 0;
    BoundVal.RealValue := 0;
    BoundVal.TextValue := '';
    SetLength(BoundVal.BlobData, 0);

    if FFieldData[I].IsAutoInc then
      Continue;

    if FEditControls[I] is TEdit then
      Value := TEdit(FEditControls.Items[I]).Text
    else if FEditControls[I] is TMemo then
      Value := TMemo(FEditControls.Items[I]).Text
    else
      Value := '';

    if IsBlobField(FFieldData[I], I) then
    begin
      if (FFieldData[I].DefaultVal <> '') and
         (VarIsNull(FFieldData[I].NewValue) or VarIsEmpty(FFieldData[I].NewValue)) then
        Continue;

      if VarIsNull(FFieldData[I].NewValue) or VarIsEmpty(FFieldData[I].NewValue) then
        BoundVal.Kind := bvkNull
      else
      begin
        BoundVal.Kind := bvkBlob;
        BoundVal.BlobData := FDB.GetBlobDataByRowId(FTableName, FRowId, FFieldData[I].ColName);
        if (BoundVal.Kind = bvkBlob) and (Length(BoundVal.BlobData) = 0) then
        begin
          Value := Trim(VarToStr(FFieldData[I].NewValue));
          if (Value <> '') and not StartsText('BLOB', Value) then
          begin
            BoundVal.Kind := bvkText;
            BoundVal.TextValue := Value;
          end;
        end;
      end;
    end
    else
    begin
      if (Value = '') and (FFieldData[I].DefaultVal <> '') then
        Continue;

      ColTypeU := UpperCase(FFieldData[I].ColType);
      if IsExplicitNullText(Value) or (Value = '') then
        BoundVal.Kind := bvkNull
      else if Pos('INT', ColTypeU) > 0 then
      begin
        BoundVal.Kind := bvkInt;
        BoundVal.IntValue := StrToInt64Def(Value, 0);
      end
      else if (Pos('REAL', ColTypeU) > 0) or (Pos('FLOA', ColTypeU) > 0) or
              (Pos('DOUB', ColTypeU) > 0) or (Pos('NUMERIC', ColTypeU) > 0) or
              (Pos('DECIMAL', ColTypeU) > 0) then
      begin
        BoundVal.Kind := bvkReal;
        BoundVal.RealValue := StrToFloatDef(StringReplace(Value, ',', '.', [rfReplaceAll]), 0);
      end
      else
      begin
        BoundVal.Kind := bvkText;
        BoundVal.TextValue := Value;
      end;
    end;

    ColumnNames[ColCount] := FFieldData[I].ColName;
    BoundValues[ColCount] := BoundVal;
    Inc(ColCount);
  end;

  SetLength(ColumnNames, ColCount);
  SetLength(BoundValues, ColCount);

  InsertResult := FDB.InsertRow(FTableName, ColumnNames, BoundValues);
  if InsertResult.Success then
  begin
    FInsertedRowId := FDB.LastInsertRowID;
    Result := True;
  end
  else
    ShowMessage('Error: ' + InsertResult.ErrorMessage);
end;

procedure TfrmRowEdit.btnOKClick(Sender: TObject);
var
  I: Integer;
  ValuesList, ColumnsList: string;
  SQL: string;
  Value: string;
begin
  if FIsInsert and FIsDuplicate then
  begin
    if ExecuteDuplicateInsert then
      ModalResult := mrOk;
    Exit;
  end;

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
      // Skip empty autoincrement - SQLite assigns next value
      if (Value = '') and FFieldData[I].IsAutoInc then
        Continue;
      // Skip if empty and has default
      if (Value = '') and (FFieldData[I].DefaultVal <> '') then
        Continue;
      if ColumnsList <> '' then
      begin
        ColumnsList := ColumnsList + ', ';
        ValuesList := ValuesList + ', ';
      end;
      ColumnsList := ColumnsList + '"' + FFieldData[I].ColName + '"';
      if IsExplicitNullText(Value) or (Value = '') then
        ValuesList := ValuesList + 'NULL'
      else if Pos('INT', UpperCase(FFieldData[I].ColType)) > 0 then
        ValuesList := ValuesList + Value
      else
        ValuesList := ValuesList + '''' + StringReplace(Value, '''', '''''', [rfReplaceAll]) + '''';
    end;
    SQL := Format('INSERT INTO %s (%s) VALUES (%s)', [FTableName, ColumnsList, ValuesList]);
  end
  else
  begin
    // Build UPDATE statement - only changed fields, skip BLOB
    ValuesList := '';
    for I := 0 to High(FFieldData) do
    begin
      if FFieldData[I].IsPK then
        Continue;
      if IsBlobField(FFieldData[I], I) then
        Continue;

      if FEditControls[I] is TEdit then
        Value := TEdit(FEditControls.Items[I]).Text
      else if FEditControls[I] is TMemo then
        Value := TMemo(FEditControls.Items[I]).Text
      else
        Value := '';

      if not FieldValueChanged(FFieldData[I], Value) then
        Continue;

      if ValuesList <> '' then
        ValuesList := ValuesList + ', ';

      if IsExplicitNullText(Value) then
        ValuesList := ValuesList + '"' + FFieldData[I].ColName + '" = NULL'
      else if Pos('INT', UpperCase(FFieldData[I].ColType)) > 0 then
        ValuesList := ValuesList + '"' + FFieldData[I].ColName + '" = ' + Value
      else
        ValuesList := ValuesList + '"' + FFieldData[I].ColName + '" = ''' +
                      StringReplace(Value, '''', '''''', [rfReplaceAll]) + '''';
    end;

    if ValuesList = '' then
    begin
      ModalResult := mrOk;
      Exit;
    end;

    SQL := Format('UPDATE %s SET %s WHERE rowid = %s', [FTableName, ValuesList, FRowId]);
  end;
  
  // Execute SQL
  var Result := FDB.ExecuteSQL(SQL);
  
  if Result.Success then
  begin
    if FIsInsert then
      FInsertedRowId := FDB.LastInsertRowID;
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
