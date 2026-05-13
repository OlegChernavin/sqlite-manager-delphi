unit OptionsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmOptions = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pcOptions: TPageControl;
    tsGeneral: TTabSheet;
    tsDisplay: TTabSheet;
    tsImportExport: TTabSheet;
    tsAI: TTabSheet;
    chkConfirmDrop: TCheckBox;
    chkConfirmDelete: TCheckBox;
    chkReconnectLastDb: TCheckBox;
    lblMaxRecent: TLabel;
    edtMaxRecent: TEdit;
    lblDefaultLimit: TLabel;
    edtDefaultLimit: TEdit;
    chkShowRowNumbers: TCheckBox;
    chkHighlightSql: TCheckBox;
    lblCSVDelimiter: TLabel;
    cbCSVDelimiter: TComboBox;
    chkCSVHeaders: TCheckBox;
    lblBlobDisplay: TLabel;
    cbBlobDisplay: TComboBox;
    btnAIOptions: TButton;
    lblAIStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnAIOptionsClick(Sender: TObject);
  private
    procedure UpdateAIStatus;
  public
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

uses
  System.IniFiles, MainForm, AIOptionsForm;

procedure TfrmOptions.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'SQLiteManager.ini');
  try
    // General
    chkConfirmDrop.Checked := Ini.ReadBool('Options', 'ConfirmDrop', True);
    chkConfirmDelete.Checked := Ini.ReadBool('Options', 'ConfirmDelete', True);
    chkReconnectLastDb.Checked := Ini.ReadBool('Options', 'ReconnectLastDb', False);
    edtMaxRecent.Text := IntToStr(Ini.ReadInteger('Options', 'MaxRecent', 10));
    
    // Display
    edtDefaultLimit.Text := IntToStr(Ini.ReadInteger('Options', 'DefaultLimit', 100));
    chkShowRowNumbers.Checked := Ini.ReadBool('Options', 'ShowRowNumbers', True);
    chkHighlightSql.Checked := Ini.ReadBool('Options', 'HighlightSQL', True);
    
    // Import/Export
    cbCSVDelimiter.ItemIndex := Ini.ReadInteger('Options', 'CSVDelimiter', 0);
    chkCSVHeaders.Checked := Ini.ReadBool('Options', 'CSVHeaders', True);
    cbBlobDisplay.ItemIndex := Ini.ReadInteger('Options', 'BlobDisplay', 0);
  finally
    Ini.Free;
  end;
  
  // Initialize AI tab
  UpdateAIStatus;
end;

procedure TfrmOptions.UpdateAIStatus;
var
  Ini: TIniFile;
  Enabled: Boolean;
  ProviderName: string;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'SQLiteManager.ini');
  try
    Enabled := Ini.ReadBool('AI', 'Enabled', False);
    ProviderName := Ini.ReadString('AI', 'ProviderName', 'Not configured');
    
    if Enabled then
      lblAIStatus.Caption := 'AI Status: Enabled (' + ProviderName + ')'
    else
      lblAIStatus.Caption := 'AI Status: Disabled';
  finally
    Ini.Free;
  end;
end;

procedure TfrmOptions.btnOKClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'SQLiteManager.ini');
  try
    // General
    Ini.WriteBool('Options', 'ConfirmDrop', chkConfirmDrop.Checked);
    Ini.WriteBool('Options', 'ConfirmDelete', chkConfirmDelete.Checked);
    Ini.WriteBool('Options', 'ReconnectLastDb', chkReconnectLastDb.Checked);
    Ini.WriteInteger('Options', 'MaxRecent', StrToIntDef(edtMaxRecent.Text, 10));
    
    // Display
    Ini.WriteInteger('Options', 'DefaultLimit', StrToIntDef(edtDefaultLimit.Text, 100));
    Ini.WriteBool('Options', 'ShowRowNumbers', chkShowRowNumbers.Checked);
    Ini.WriteBool('Options', 'HighlightSQL', chkHighlightSql.Checked);
    
    // Import/Export
    Ini.WriteInteger('Options', 'CSVDelimiter', cbCSVDelimiter.ItemIndex);
    Ini.WriteBool('Options', 'CSVHeaders', chkCSVHeaders.Checked);
    Ini.WriteInteger('Options', 'BlobDisplay', cbBlobDisplay.ItemIndex);
  finally
    Ini.Free;
  end;
  
  ModalResult := mrOk;
end;

procedure TfrmOptions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmOptions.btnAIOptionsClick(Sender: TObject);
var
  Frm: TfrmAIOptions;
begin
  Frm := TfrmAIOptions.Create(Self);
  try
    Frm.ShowModal;
    UpdateAIStatus;
  finally
    Frm.Free;
  end;
end;

end.
