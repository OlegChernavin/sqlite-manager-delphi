unit AppPaths;

interface

function EnsureAppDataConfigDir: string;
function GetSettingsIniPath: string;
procedure MigrateLegacySettingsIniIfNeeded;

implementation

uses
  System.SysUtils, System.IOUtils;

const
  cAppCompanyDir = 'OlegChernavin';
  cAppConfigDir = 'SQLiteManager';
  cSettingsIniFileName = 'SQLiteManager.ini';

function GetLegacySettingsIniPath: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    cSettingsIniFileName;
end;

function EnsureAppDataConfigDir: string;
var
  AppData: string;
begin
  AppData := GetEnvironmentVariable('APPDATA');
  if AppData = '' then
    raise Exception.Create('APPDATA is not set');
  Result := IncludeTrailingPathDelimiter(AppData) + cAppCompanyDir + '\' +
    cAppConfigDir;
  ForceDirectories(Result);
end;

function GetSettingsIniPath: string;
begin
  Result := IncludeTrailingPathDelimiter(EnsureAppDataConfigDir) +
    cSettingsIniFileName;
end;

procedure MigrateLegacySettingsIniIfNeeded;
var
  NewPath, OldPath: string;
begin
  NewPath := GetSettingsIniPath;
  if FileExists(NewPath) then
    Exit;
  OldPath := GetLegacySettingsIniPath;
  if FileExists(OldPath) then
    TFile.Copy(OldPath, NewPath, False);
end;

end.
