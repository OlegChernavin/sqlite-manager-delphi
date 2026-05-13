unit CreateIndexForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, DBModule;

type
  TfrmCreateIndex = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblIndexName: TLabel;
    edtIndexName: TEdit;
    lblTable: TLabel;
    cbTable: TComboBox;
    chkUnique: TCheckBox;
    lblColumns: TLabel;
    pnlColumns: TScrollBox;
    btnAddColumn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddColumnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FColumnPanels: TList;
    FTables: TStringList;
    procedure RemoveColumn(Sender: TObject);
    procedure PopulateTables;
  public
  end;

var
  frmCreateIndex: TfrmCreateIndex;

implementation

{$R *.dfm}

uses
  MainForm;

procedure TfrmCreateIndex.FormCreate(Sender: TObject);
begin
  FColumnPanels := TList.Create;
  FTables := TStringList.Create;
end;

procedure TfrmCreateIndex.FormShow(Sender: TObject);
begin
  PopulateTables;
  // Add first column row
  if FColumnPanels.Count = 0 then
    btnAddColumnClick(Sender);
end;

procedure TfrmCreateIndex.PopulateTables;
var
  Structure: TDatabaseStructure;
  I: Integer;
begin
  cbTable.Clear;
  FTables.Clear;

  if not frmMain.FDB.IsOpen then
    Exit;

  Structure := frmMain.FDB.GetDatabaseStructure;

  for I := 0 to High(Structure.Tables) do
  begin
    cbTable.Items.Add(Structure.Tables[I]);
    FTables.Add(Structure.Tables[I]);
  end;

  if cbTable.Items.Count > 0 then
    cbTable.ItemIndex := 0;
end;

procedure TfrmCreateIndex.btnAddColumnClick(Sender: TObject);
var
  pnl: TPanel;
  cbColumn: TComboBox;
  chkDesc: TCheckBox;
  btnRemove: TButton;
  I: Integer;
  TableColumns: TArray<TColumnDef>;
begin
  if cbTable.ItemIndex < 0 then
  begin
    ShowMessage('Please select a table first');
    Exit;
  end;

  // Get table columns
  TableColumns := frmMain.FDB.GetTableInfo(cbTable.Text);

  pnl := TPanel.Create(pnlColumns);
  pnl.Parent := pnlColumns;
  pnl.Align := alTop;
  pnl.Height := 35;
  pnl.BevelOuter := bvNone;

  cbColumn := TComboBox.Create(pnl);
  cbColumn.Parent := pnl;
  cbColumn.Left := 0;
  cbColumn.Top := 5;
  cbColumn.Width := 200;
  cbColumn.Style := csDropDownList;

  // Populate column names
  for I := 0 to High(TableColumns) do
  begin
    cbColumn.Items.Add(TableColumns[I].Name);
  end;

  if cbColumn.Items.Count > 0 then
    cbColumn.ItemIndex := 0;

  chkDesc := TCheckBox.Create(pnl);
  chkDesc.Parent := pnl;
  chkDesc.Left := 210;
  chkDesc.Top := 8;
  chkDesc.Width := 50;
  chkDesc.Caption := 'DESC';
  chkDesc.Hint := 'Descending order';

  btnRemove := TButton.Create(pnl);
  btnRemove.Parent := pnl;
  btnRemove.Left := 265;
  btnRemove.Top := 5;
  btnRemove.Width := 25;
  btnRemove.Height := 25;
  btnRemove.Caption := '×';
  btnRemove.OnClick := RemoveColumn;

  FColumnPanels.Add(pnl);
end;

procedure TfrmCreateIndex.RemoveColumn(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FColumnPanels.Count - 1 do
  begin
    if Sender is TButton then
    begin
      if TButton(Sender).Parent = TPanel(FColumnPanels[I]) then
      begin
        TPanel(FColumnPanels[I]).Free;
        FColumnPanels.Delete(I);
        Break;
      end;
    end;
  end;
end;

procedure TfrmCreateIndex.btnOKClick(Sender: TObject);
var
  I: Integer;
  IndexName, TableName, SQL, Columns: string;
  pnl: TPanel;
  cbColumn: TComboBox;
  chkDesc: TCheckBox;
  ColName: string;
  //SortOrder: String;
  Res: TQueryResult;
begin
  IndexName := Trim(edtIndexName.Text);
  TableName := cbTable.Text;

  if IndexName = '' then
  begin
    ShowMessage('Please enter an index name');
    Exit;
  end;

  if TableName = '' then
  begin
    ShowMessage('Please select a table');
    Exit;
  end;

  if FColumnPanels.Count = 0 then
  begin
    ShowMessage('Please select at least one column');
    Exit;
  end;

  // Build column list
  Columns := '';
  for I := 0 to FColumnPanels.Count - 1 do
  begin
    pnl := TPanel(FColumnPanels[I]);
    cbColumn := pnl.Controls[0] as TComboBox;
    chkDesc := pnl.Controls[1] as TCheckBox;

    ColName := cbColumn.Text;
    if ColName = '' then
    begin
      ShowMessage('Please select all columns');
      Exit;
    end;

    if Columns <> '' then
      Columns := Columns + ', ';

    Columns := Columns + '"' + ColName + '"';
    if chkDesc.Checked then
      Columns := Columns + ' DESC';
  end;

  // Build CREATE INDEX statement
  SQL := 'CREATE ';
  if chkUnique.Checked then
    SQL := SQL + 'UNIQUE ';
  SQL := SQL + 'INDEX "' + IndexName + '" ON "' + TableName + '" (' + Columns + ')';

  // Execute
  Res := frmMain.FDB.ExecuteSQL(SQL);

  if Res.Success then
  begin
    ShowMessage('Index "' + IndexName + '" created successfully');
    frmMain.RefreshStructure;
    ModalResult := mrOk;
  end
  else
  begin
    ShowMessage('Error creating index: ' + Res.ErrorMessage);
  end;
end;

procedure TfrmCreateIndex.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
