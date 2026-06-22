unit DialogFormSize;

interface

uses
  Vcl.Forms, System.SysUtils, System.IniFiles, System.Math;

const
  cDialogMinSize = 300;
  cDialogSizesSection = 'DialogSizes';

procedure ApplyDialogMinConstraints(AForm: TForm);
procedure LoadDialogFormSize(AForm: TForm; const AKey: string);
procedure SaveDialogFormSize(AForm: TForm; const AKey: string);

implementation

uses
  AppPaths;

function DialogIniPath: string;
begin
  Result := GetSettingsIniPath;
end;

function ClampDialogSize(AValue: Integer): Integer;
begin
  Result := Max(cDialogMinSize, AValue);
end;

procedure ApplyDialogMinConstraints(AForm: TForm);
begin
  AForm.Constraints.MinWidth := cDialogMinSize;
  AForm.Constraints.MinHeight := cDialogMinSize;
end;

procedure LoadDialogFormSize(AForm: TForm; const AKey: string);
var
  Ini: TIniFile;
  W, H: Integer;
begin
  ApplyDialogMinConstraints(AForm);
  Ini := TIniFile.Create(DialogIniPath);
  try
    W := Ini.ReadInteger(cDialogSizesSection, AKey + 'Width', 0);
    H := Ini.ReadInteger(cDialogSizesSection, AKey + 'Height', 0);
    if (W >= cDialogMinSize) and (H >= cDialogMinSize) then
    begin
      AForm.Width := W;
      AForm.Height := H;
    end;
  finally
    Ini.Free;
  end;
end;

procedure SaveDialogFormSize(AForm: TForm; const AKey: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(DialogIniPath);
  try
    Ini.WriteInteger(cDialogSizesSection, AKey + 'Width',
      ClampDialogSize(AForm.Width));
    Ini.WriteInteger(cDialogSizesSection, AKey + 'Height',
      ClampDialogSize(AForm.Height));
  finally
    Ini.Free;
  end;
end;

end.
