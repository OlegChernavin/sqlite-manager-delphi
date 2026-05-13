unit CreateTreeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, DBModule;

type
  TfrmCreateTree = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblTableName: TLabel;
    edtTableName: TEdit;
    lblColumns: TLabel;
    pnlColumns: TScrollBox;
    btnAddColumn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddColumnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FColumnPanels: TList;
    procedure RemoveColumn(Sender: TObject);
  public
  end;

var
  frmCreateTree: TfrmCreateTree;

implementation

{$R *.dfm}

uses
  MainForm;

procedure TfrmCreateTree.FormCreate(Sender: TObject);
begin
  FColumnPanels := TList.Create;
  // Add first column row
  btnAddColumnClick(Sender);
end;

procedure TfrmCreateTree.btnAddColumnClick(Sender: TObject);
var
  pnl: TPanel;
  edtName: TEdit;
  cbType: TComboBox;
  chkPK, chkNotNull, chkAutoInc: TCheckBox;
  btnRemove: TButton;
begin
  pnl := TPanel.Create(pnlColumns);
  pnl.Parent := pnlColumns;
  pnl.Align := alTop;
  pnl.Height := 35;
  pnl.BevelOuter := bvNone;

  edtName := TEdit.Create(pnl);
  edtName.Parent := pnl;
  edtName.Left := 0;
  edtName.Top := 5;
  edtName.Width := 120;
  edtName.Text := '';
  edtName.Hint := 'Column Name';

  cbType := TComboBox.Create(pnl);
  cbType.Parent := pnl;
  cbType.Left := 125;
  cbType.Top := 5;
  cbType.Width := 100;
  cbType.Style := csDropDownList;
  cbType.Items.Add('INTEGER');
  cbType.Items.Add('TEXT');
  cbType.Items.Add('REAL');
  cbType.Items.Add('BLOB');
  cbType.Items.Add('NUMERIC');
  cbType.ItemIndex := 0;

  chkPK := TCheckBox.Create(pnl);
  chkPK.Parent := pnl;
  chkPK.Left := 230;
  chkPK.Top := 8;
  chkPK.Width := 35;
  chkPK.Caption := 'PK';

  chkNotNull := TCheckBox.Create(pnl);
  chkNotNull.Parent := pnl;
  chkNotNull.Left := 265;
  chkNotNull.Top := 8;
  chkNotNull.Width := 40;
  chkNotNull.Caption := 'NN';
  
  chkAutoInc := TCheckBox.Create(pnl);
  chkAutoInc.Parent := pnl;
  chkAutoInc.Left := 305;
  chkAutoInc.Top := 8;
  chkAutoInc.Width := 45;
  chkAutoInc.Caption := 'AI';
  
  btnRemove := TButton.Create(pnl);
  btnRemove.Parent := pnl;
  btnRemove.Left := 350;
  btnRemove.Top := 5;
  btnRemove.Width := 25;
  btnRemove.Height := 25;
  btnRemove.Caption := '×';
  btnRemove.OnClick := RemoveColumn;
  
  FColumnPanels.Add(pnl);
end;

procedure TfrmCreateTree.RemoveColumn(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FColumnPanels.Count - 1 do
  begin
    if TPanel(FColumnPanels[I]).FindComponent('') = nil then
    begin
      // Find the button that was clicked
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
end;

procedure TfrmCreateTree.btnOKClick(Sender: TObject);
var
  I: Integer;
  TableName: string;
  Columns: TArray<TColumnDef>;
  ColDef: TColumnDef;
  pnl: TPanel;
  edtName: TEdit;
  cbType: TComboBox;
  chkPK, chkNotNull, chkAutoInc: TCheckBox;
begin
  TableName := Trim(edtTableName.Text);
  
  if TableName = '' then
  begin
    ShowMessage('Please enter a table name');
    Exit;
  end;

  SetLength(Columns, FColumnPanels.Count);
  
  for I := 0 to FColumnPanels.Count - 1 do
  begin
    pnl := TPanel(FColumnPanels[I]);
    edtName := pnl.Controls[0] as TEdit;
    cbType := pnl.Controls[1] as TComboBox;
    chkPK := pnl.Controls[2] as TCheckBox;
    chkNotNull := pnl.Controls[3] as TCheckBox;
    chkAutoInc := pnl.Controls[4] as TCheckBox;
    
    ColDef.Name := Trim(edtName.Text);
    ColDef.TypeName := cbType.Text;
    ColDef.NotNull := chkNotNull.Checked;
    ColDef.PK := chkPK.Checked;
    ColDef.AutoInc := chkAutoInc.Checked;
    ColDef.DefaultVal := '';
    ColDef.ColumnType := sctText;
    
    Columns[I] := ColDef;
  end;

  if Length(Columns) = 0 then
  begin
    ShowMessage('Please define at least one column');
    Exit;
  end;

  if frmMain.FDB.CreateTable(TableName, Columns) then
  begin
    ShowMessage('Table "' + TableName + '" created successfully');
    frmMain.RefreshStructure;
    ModalResult := mrOk;
  end
  else
  begin
    ShowMessage('Error creating table: ' + frmMain.FDB.LastError);
  end;
end;

procedure TfrmCreateTree.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
