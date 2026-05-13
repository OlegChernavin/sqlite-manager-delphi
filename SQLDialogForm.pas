unit SQLDialogForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TfrmSQLDialog = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    memSQL: TMemo;
    procedure btnOKClick(Sender: TObject);
  private
  public
  end;

var
  frmSQLDialog: TfrmSQLDialog;

implementation

{$R *.dfm}

procedure TfrmSQLDialog.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
