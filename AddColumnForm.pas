unit AddColumnForm;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;
type
  TNewColumnDef = record
    ColumnName: string;
    ColumnType: string;
    NotNull: Boolean;
    DefaultValue: string;
    PrimaryKey: Boolean;
    AutoInc: Boolean;
  end;
  TfrmAddColumn = class(TForm)
    pnlContent: TPanel;
    pnlFooter: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblColumnName: TLabel;
    edtColumnName: TEdit;
    lblColumnType: TLabel;
    cbColumnType: TComboBox;
    chkNotNull: TCheckBox;
    lblDefaultValue: TLabel;
    edtDefaultValue: TEdit;
    chkPrimaryKey: TCheckBox;
    chkAutoInc: TCheckBox;
    lblValidation: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure chkPrimaryKeyClick(Sender: TObject);
    procedure edtColumnNameChange(Sender: TObject);
    procedure chkNotNullClick(Sender: TObject);
    procedure edtDefaultValueChange(Sender: TObject);
    procedure ValidateInput;
    procedure cbColumnTypeChange(Sender: TObject);
  private
    FColumnDef: TNewColumnDef;
  public
    function GetColumnDef: TNewColumnDef;
  end;
var
  frmAddColumn: TfrmAddColumn;
implementation
{$R *.dfm}
procedure TfrmAddColumn.ValidateInput;
var
  ColName: string;
  ValidName: Boolean;
  I: Integer;
  C: Char;
  ReservedWords: array of string;
begin
  ColName := Trim(edtColumnName.Text);
  lblValidation.Caption := '';
  
  // Check if column name is empty
  if ColName = '' then
  begin
    btnOK.Enabled := False;
    lblValidation.Caption := 'Column name is required';
    Exit;
  end;
  
  // Check if column name starts with a letter or underscore
  if not CharInSet(ColName[1], ['a'..'z', 'A'..'Z', '_']) then
  begin
    btnOK.Enabled := False;
    lblValidation.Caption := 'Column name must start with a letter or underscore';
    Exit;
  end;

  // Check if all characters are valid (letters, digits, underscore)
  ValidName := True;
  for I := 1 to Length(ColName) do
  begin
    C := ColName[I];
    if not CharInSet(C, ['a'..'z', 'A'..'Z', '0'..'9', '_']) then
    begin
      ValidName := False;
      Break;
    end;
  end;
  
  if not ValidName then
  begin
    btnOK.Enabled := False;
    lblValidation.Caption := 'Column name can only contain letters, digits, and underscores';
    Exit;
  end;
  
  // Check for reserved words
  SetLength(ReservedWords, 10);
  ReservedWords[0] := 'SELECT';
  ReservedWords[1] := 'INSERT';
  ReservedWords[2] := 'UPDATE';
  ReservedWords[3] := 'DELETE';
  ReservedWords[4] := 'CREATE';
  ReservedWords[5] := 'DROP';
  ReservedWords[6] := 'TABLE';
  ReservedWords[7] := 'INDEX';
  ReservedWords[8] := 'VIEW';
  ReservedWords[9] := 'TRIGGER';
  
  for I := 0 to High(ReservedWords) do
  begin
    if UpperCase(ColName) = ReservedWords[I] then
    begin
      btnOK.Enabled := False;
      lblValidation.Caption := '"' + ColName + '" is a reserved word';
      Exit;
    end;
  end;
  // Check if NOT NULL is checked and Default Value is empty
  if chkNotNull.Checked and (Trim(edtDefaultValue.Text) = '') and (cbColumnType.Text <> 'VARCHAR') then
  begin
    btnOK.Enabled := False;
    lblValidation.Caption := 'Default value is required when NOT NULL is checked';
    Exit;
  end;
  // All checks passed
  btnOK.Enabled := True;
end;
procedure TfrmAddColumn.edtColumnNameChange(Sender: TObject);
begin
  ValidateInput;
end;
procedure TfrmAddColumn.cbColumnTypeChange(Sender: TObject);
begin
  ValidateInput;
end;

procedure TfrmAddColumn.chkNotNullClick(Sender: TObject);
begin
  ValidateInput;
end;
procedure TfrmAddColumn.edtDefaultValueChange(Sender: TObject);
begin
  ValidateInput;
end;
procedure TfrmAddColumn.btnOKClick(Sender: TObject);
begin
  if Trim(edtColumnName.Text) = '' then
  begin
    ShowMessage('Please enter a column name');
    Exit;
  end;
  FColumnDef.ColumnName := edtColumnName.Text;
  FColumnDef.ColumnType := cbColumnType.Text;
  FColumnDef.NotNull := chkNotNull.Checked;
  FColumnDef.DefaultValue := edtDefaultValue.Text;
  FColumnDef.PrimaryKey := chkPrimaryKey.Checked;
  FColumnDef.AutoInc := chkAutoInc.Checked;
  ModalResult := mrOk;
end;
function TfrmAddColumn.GetColumnDef: TNewColumnDef;
begin
  Result := FColumnDef;
end;
procedure TfrmAddColumn.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
procedure TfrmAddColumn.chkPrimaryKeyClick(Sender: TObject);
begin
  if chkPrimaryKey.Checked then
  begin
    chkNotNull.Checked := True;
    chkNotNull.Enabled := False;
    chkAutoInc.Enabled := True;
  end
  else
  begin
    chkNotNull.Enabled := True;
    chkAutoInc.Enabled := False;
    chkAutoInc.Checked := False;
  end;
end;
end.
