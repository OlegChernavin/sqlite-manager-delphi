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
    procedure btnOKClick(Sender: TObject);
  private
  public
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
