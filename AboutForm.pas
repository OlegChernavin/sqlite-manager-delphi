unit AboutForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TfrmAbout = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    btnOK: TButton;
    imgLogo: TImage;
    lblVersion: TLabel;
    lblDescription: TLabel;
    lblBasedOn: TLabel;
    lblLicense: TLabel;
    lblGitHub: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
  public
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

function GetExeFileVersion: string;
var
  FileName: string;
  InfoSize, Dummy: DWORD;
  Info: Pointer;
  Value: Pointer;
  FileInfo: PVSFixedFileInfo;
  Len: UINT;
begin
  Result := '';
  FileName := ParamStr(0);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  if InfoSize = 0 then
    Exit;
  GetMem(Info, InfoSize);
  try
    if not GetFileVersionInfo(PChar(FileName), 0, InfoSize, Info) then
      Exit;
    if VerQueryValue(Info, '\', Value, Len) then
    begin
      FileInfo := PVSFixedFileInfo(Value);
      Result := Format('%d.%d.%d.%d', [
        HiWord(FileInfo.dwFileVersionMS),
        LoWord(FileInfo.dwFileVersionMS),
        HiWord(FileInfo.dwFileVersionLS),
        LoWord(FileInfo.dwFileVersionLS)]);
    end;
  finally
    FreeMem(Info);
  end;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
var
  Ver: string;
begin
  Ver := GetExeFileVersion;
  if Ver <> '' then
    lblVersion.Caption := 'Version: ' + Ver;
end;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
