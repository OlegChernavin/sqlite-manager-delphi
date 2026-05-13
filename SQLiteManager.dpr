program SQLiteManager;

uses
  Vcl.Forms,
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Grids,
  Vcl.ValEdit,
  Vcl.ImgList,
  Vcl.BaseImageCollection,
  Vcl.ImageCollection,
  Vcl.Menus,
  Vcl.Dialogs,
  System.UITypes,
  MainForm in 'MainForm.pas' {frmMain},
  DBModule in 'DBModule.pas',
  CreateTreeForm in 'CreateTreeForm.pas' {frmCreateTree},
  CreateIndexForm in 'CreateIndexForm.pas' {frmCreateIndex},
  AddColumnForm in 'AddColumnForm.pas' {frmAddColumn},
  ImportExport in 'ImportExport.pas',
  OptionsForm in 'OptionsForm.pas' {frmOptions},
  AboutForm in 'AboutForm.pas' {frmAbout},
  SQLDialogForm in 'SQLDialogForm.pas' {frmSQLDialog},
  RowEditForm in 'RowEditForm.pas' {frmRowEdit},
  SearchForm in 'SearchForm.pas' {frmSearch};
{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SQLite Manager';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmCreateTree, frmCreateTree);
  Application.CreateForm(TfrmCreateIndex, frmCreateIndex);
  Application.CreateForm(TfrmAddColumn, frmAddColumn);
  Application.CreateForm(TfrmSQLDialog, frmSQLDialog);
  Application.Run;
end.

