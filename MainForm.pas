unit MainForm;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.ImgList,
  System.ImageList, Vcl.BaseImageCollection, Vcl.ImageCollection, System.UITypes, System.Math,
  DBModule, ImportExport, Vcl.VirtualImageList, System.IniFiles, System.Generics.Collections,
  System.Generics.Defaults, SQLite3, Vcl.ToolWin, Win.Registry, Clipbrd, SynEdit,
  SynEditHighlighter, SynHighlighterSQL, SynCompletionProposal, SearchForm, AIService,
  AIOptionsForm, SQLAdvancedFormatter;

type
  TFormExportProc = function(AProgress: TExportProgressProc): Boolean of object;

  TExportProgressHelper = class
  public
    CancelRequested: Boolean;
    ExportBaseCaption: string;
    ProgressForm: TForm;
    EdRows: TEdit;
    LblPercent: TLabel;
    Bar: TProgressBar;
    BtnCancel: TButton;
    OnExport: TFormExportProc;
    procedure UpdateProgress(const AInfo: TExportProgressInfo);
    procedure CancelClick(Sender: TObject);
    procedure CloseQuery(Sender: TObject; var CanClose: Boolean);
    function ExecuteExport: Boolean;
  end;

  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    mnuDatabase: TMenuItem;
    mnuNewDatabase: TMenuItem;
    mnuOpenDatabase: TMenuItem;
    mnuCloseDatabase: TMenuItem;
    N1: TMenuItem;
    mnuRecent: TMenuItem;
    N2: TMenuItem;
    mnuAttachDatabase: TMenuItem;
    mnuDetachDatabase: TMenuItem;
    N3: TMenuItem;
    mnuCopyDatabase: TMenuItem;
    mnuCompactDatabase: TMenuItem;
    mnuAnalyzeDatabase: TMenuItem;
    mnuCheckIntegrity: TMenuItem;
    mnuCheckComplete: TMenuItem;
    mnuCheckQuick: TMenuItem;
    N4: TMenuItem;
    mnuExportAll: TMenuItem;
    mnuExportDatabase: TMenuItem;
    mnuImport: TMenuItem;
    N5: TMenuItem;
    mnuRefresh: TMenuItem;
    N6: TMenuItem;
    mnuExit: TMenuItem;
    mnuTable: TMenuItem;
    mnuCreateTable: TMenuItem;
    mnuDropTable: TMenuItem;
    mnuEmptyTable: TMenuItem;
    N7: TMenuItem;
    mnuRenameTable: TMenuItem;
    mnuCopyTable: TMenuItem;
    mnuExportTable: TMenuItem;
    N8: TMenuItem;
    mnuReindexTable: TMenuItem;
    mnuIndex: TMenuItem;
    mnuCreateIndex: TMenuItem;
    mnuDropIndex: TMenuItem;
    N9: TMenuItem;
    mnuReindexIndex: TMenuItem;
    mnuView: TMenuItem;
    mnuCreateView: TMenuItem;
    mnuDropView: TMenuItem;
    N10: TMenuItem;
    mnuRenameView: TMenuItem;
    mnuModifyView: TMenuItem;
    mnuExportView: TMenuItem;
    mnuTrigger: TMenuItem;
    mnuCreateTrigger: TMenuItem;
    mnuDropTrigger: TMenuItem;
    N11: TMenuItem;
    mnuRenameTrigger: TMenuItem;
    mnuTools: TMenuItem;
    mnuOptions: TMenuItem;
    mnuAISettings: TMenuItem;
    mnuUDF: TMenuItem;
    mnuConnectSQL: TMenuItem;
    mnuHelp: TMenuItem;
    mnuReportProblem: TMenuItem;
    mnuFAQ: TMenuItem;
    N12: TMenuItem;
    mnuSQLiteHome: TMenuItem;
    mnuSQLiteSyntax: TMenuItem;
    N13: TMenuItem;
    mnuAbout: TMenuItem;
    ToolBar: TToolBar;
    btnNewDb: TToolButton;
    btnOpenDb: TToolButton;
    btnImport: TToolButton;
    btnSep1: TToolButton;
    btnCreateTable: TToolButton;
    btnCreateView: TToolButton;
    btnCreateIndex: TToolButton;
    btnCreateTrigger: TToolButton;
    btnSep2: TToolButton;
    btnRefresh: TToolButton;
    btnSearch: TToolButton;
    btnShowAll: TToolButton;
    imgToolbar: TImageList;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    splVertical: TSplitter;
    pcMain: TPageControl;
    tsBrowse: TTabSheet;
    tsExecute: TTabSheet;
    tvStructure: TTreeView;
    imgTree: TImageList;
    pnlDbInfo: TPanel;
    lblDbInfo: TLabel;
    sgBrowse: TStringGrid;
    pnlBrowseToolbar: TPanel;
    lblTable: TLabel;
    pnlBrowseStatus: TPanel;
    pnlExecuteToolbar: TPanel;
    btnRunQuery: TButton;
    btnExplainQuery: TButton;
    btnClearSql: TButton;
    btnSaveQuery: TButton;
    btnLoadQuery: TButton;
    memSQL: TSynEdit;
    sgExecute: TStringGrid;
    pnlExecuteStatus: TPanel;
    pnlStatusBar: TPanel;
    lblStatusSQLite: TLabel;
    lblStatusTime: TLabel;
    lblStatusMessage: TLabel;
    btnEditRecord: TButton;
    btnDeleteRecord: TButton;
    btnAddRecord: TButton;
    btnDuplicateRecord: TButton;
    edtBrowseTitle: TEdit;
    cbHistory: TComboBox;
    SynSQLSyn1: TSynSQLSyn;
    SynSQLCompletion: TSynCompletionProposal;
    Timer1: TTimer;
    btnSearchTable: TButton;
    Splitter1: TSplitter;
    DatabaseInformation1: TMenuItem;
    pmRecentDb: TPopupMenu;
    pmSQL: TPopupMenu;
    mnuAIFont: TMenuItem;
    N14: TMenuItem;
    mnuAIFmt: TMenuItem;
    mnuAIExplain: TMenuItem;
    mnuAIOptimize: TMenuItem;
    N15: TMenuItem;
    mnuAIGenerate: TMenuItem;
    N16: TMenuItem;
    tsTable: TTabSheet;
    tsIndex: TTabSheet;
    btnNavFirst: TButton;
    btnNavPrev: TButton;
    lblNavStart: TLabel;
    lblNavTo: TLabel;
    lblNavEnd: TLabel;
    lblNavOf: TLabel;
    lblNavTotal: TLabel;
    btnNavNext: TButton;
    btnNavLast: TButton;
    lblOffset: TLabel;
    edtOffset: TEdit;
    lblLimit: TLabel;
    edtLimit: TEdit;
    btnApplyFilter: TButton;
    pnlTableToolbar: TPanel;
    lblTableName: TLabel;
    edtTableName: TEdit;
    btnAddColumn: TButton;
    btnModifyTable: TButton;
    pnlTableInfo: TPanel;
    lblTableSql: TLabel;
    memTableSQL: TMemo;
    sgTable: TStringGrid;
    pnlIndexToolbar: TPanel;
    lblIndexName: TLabel;
    edtIndexName: TEdit;
    btnDeleteIndex: TButton;
    btnReindex: TButton;
    pnlIndexInfo: TPanel;
    lblIndexTable: TLabel;
    lblIndexTableValue: TLabel;
    lblIndexUnique: TLabel;
    lblIndexUniqueValue: TLabel;
    lblIndexColumns: TLabel;
    lblIndexColumnsValue: TLabel;
    lblIndexSql: TLabel;
    memIndexSQL: TMemo;
    sgIndex: TStringGrid;
    btnEmptyTable: TButton;
    btnFormatQuery: TButton;
    procedure btnAddColumnClick(Sender: TObject);
    procedure btnModifyTableClick(Sender: TObject);
    procedure btnDeleteIndexClick(Sender: TObject);
    procedure btnReindexClick(Sender: TObject);
    procedure mnuAIFmtClick(Sender: TObject);
    procedure mnuAIExplainClick(Sender: TObject);
    procedure mnuAIOptimizeClick(Sender: TObject);
    procedure mnuAIGenerateClick(Sender: TObject);
    procedure mnuAISettingsClick(Sender: TObject);
    procedure mnuAISettingsMainClick(Sender: TObject);
    procedure memSQLPopup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuNewDatabaseClick(Sender: TObject);
    procedure mnuOpenDatabaseClick(Sender: TObject);
    procedure mnuCloseDatabaseClick(Sender: TObject);
    procedure mnuCopyDatabaseClick(Sender: TObject);
    procedure mnuCompactDatabaseClick(Sender: TObject);
    procedure mnuAnalyzeDatabaseClick(Sender: TObject);
    procedure mnuCheckCompleteClick(Sender: TObject);
    procedure mnuCheckQuickClick(Sender: TObject);
    procedure mnuExportAllClick(Sender: TObject);
    procedure mnuExportDatabaseClick(Sender: TObject);
    procedure mnuImportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure mnuAttachDatabaseClick(Sender: TObject);
    procedure OnDetachClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuRefreshClick(Sender: TObject);
    procedure mnuCreateTableClick(Sender: TObject);
    procedure mnuDropTableClick(Sender: TObject);
    procedure mnuEmptyTableClick(Sender: TObject);
    procedure mnuRenameTableClick(Sender: TObject);
    procedure mnuCopyTableClick(Sender: TObject);
    procedure mnuExportTableClick(Sender: TObject);
    procedure mnuReindexTableClick(Sender: TObject);
    procedure mnuCreateIndexClick(Sender: TObject);
    procedure mnuDropIndexClick(Sender: TObject);
    procedure mnuReindexIndexClick(Sender: TObject);
    procedure mnuCreateViewClick(Sender: TObject);
    procedure mnuDropViewClick(Sender: TObject);
    procedure mnuRenameViewClick(Sender: TObject);
    procedure mnuModifyViewClick(Sender: TObject);
    procedure mnuExportViewClick(Sender: TObject);
    procedure mnuCreateTriggerClick(Sender: TObject);
    procedure mnuDropTriggerClick(Sender: TObject);
    procedure mnuRenameTriggerClick(Sender: TObject);
    procedure btnCreateViewClick(Sender: TObject);
    procedure btnCreateTriggerClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure tvStructureClick(Sender: TObject);
    procedure tvStructureDblClick(Sender: TObject);
    procedure btnApplyFilterClick(Sender: TObject);
    procedure sgBrowseSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgBrowseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnRunQueryClick(Sender: TObject);
    procedure btnClearSqlClick(Sender: TObject);
    procedure btnExplainQueryClick(Sender: TObject);
    procedure btnEditRecordClick(Sender: TObject);
    procedure btnDeleteRecordClick(Sender: TObject);
    procedure btnAddRecordClick(Sender: TObject);
    procedure btnDuplicateRecordClick(Sender: TObject);
    procedure btnNavFirstClick(Sender: TObject);
    procedure btnNavPrevClick(Sender: TObject);
    procedure btnNavNextClick(Sender: TObject);
    procedure btnNavLastClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure miCopyRowsCSVClick(Sender: TObject);
    procedure miCopyRowsCSVExcelClick(Sender: TObject);
    procedure miCopyRowsSQLClick(Sender: TObject);
    procedure miCopyCellClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgBrowseMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure sgBrowseMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure sgBrowseTopLeftChanged(Sender: TObject);
    procedure sgBrowseDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure memSQLKeyPress(Sender: TObject; var Key: Char);
    procedure SynSQLCompletionExecute(Kind: SynCompletionType; Sender: TObject;
      var CurrentInput: UnicodeString; var x, y: Integer; var CanExecute: Boolean);
    procedure SynSQLCompletionShow(Sender: TObject);
    procedure SynSQLCompletionClose(Sender: TObject);
    procedure cbHistoryChange(Sender: TObject);
    procedure sgBrowseKeyPress(Sender: TObject; var Key: Char);
    procedure tvStructureKeyPress(Sender: TObject; var Key: Char);
    procedure DatabaseInformation1Click(Sender: TObject);
    procedure btnEmptyTableClick(Sender: TObject);
    procedure btnFormatQueryClick(Sender: TObject);
    procedure sgExecuteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sgExecuteSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure mnuSQLiteHomeClick(Sender: TObject);
    procedure mnuSQLiteSyntaxClick(Sender: TObject);
  private
    FReg: TRegistry;
    pmGrid: TPopupMenu;
    CurrentGrid: TStringGrid;  // Which grid was right-clicked
    PopupMenuCol: Integer;     // Column where popup was opened
    PopupMenuRow: Integer;     // Row where popup was opened
    FTotalRows: Integer; // Total rows in current table/view
    FColumnTypes: TArray<TSQLiteColumnType>; // Column types for sgBrowse
    FExecuteColumnTypes: TArray<TSQLiteColumnType>; // Column types for sgExecute
    FExecuteSortCol: Integer;
    FExecuteSortAsc: Boolean;
    FExecuteCellsBackup: TArray<TArray<string>>; // original data rows for sgExecute (cancel sort)
    FBrowseSortCol: Integer;
    FBrowseSortAsc: Boolean;
    FBrowseSelectedRows: TList<Integer>;
    FExecuteSelectedRows: TList<Integer>;
    FBrowseAnchorRow: Integer;
    FExecuteAnchorRow: Integer;
    FBrowseLeftCol: Integer; // saved horizontal scroll within current table
    FBrowseLeftColUpdating: Boolean;
    FRecentQueries: TStringList; // Last 10 SQL queries for current database
    FCurrentDatabaseName: string; // Current database filename (without path)
    TableInfo: TArray<TColumnDef>;
    // Search context
    FIsSearching: Boolean;  // True if currently viewing search results
    FSearchWhereClause: string;  // WHERE clause from search
    FSearchTotalRows: Integer;  // Total rows in search results
    // AI Service
    FAIService: TAIService;
    FAIConfigured: Boolean;
    // Index context
    FCurrentIndex: string;  // Current selected index name
    FCurrentIndexTable: string;  // Table that the index belongs to
    FCurrentTrigger: string;  // Current selected trigger name
    // Table context
    FCurrentTableName: string;  // Current selected table name
    FCurrentSchema: string;     // '' or 'main' for primary DB; alias for attached
    FDetachMenuAliases: TStringList;
    FImportExport: TImportExport;
    FPendingExportFolder: string;
    FPendingExportFile: string;
    FPendingExportFmt: TDataFileFormat;
    FPendingExportCount: Integer;
    FPendingExportTable: string;
    FPendingExportSchema: string;
    procedure SplitSQLStatements(const ASQL: string; out AStatements: TArray<string>);
    procedure LoadWindowPosition;
    procedure SaveWindowPosition;
    procedure LoadLastDatabase;
    procedure SaveLastDatabase(const APath: string);
    procedure SaveLastSelectedTable(const ATableName: string);
    procedure LoadLastSelectedTable;
    function FindNextTableAfter(const AName: string): string;
    procedure SaveRecentQueries;
    procedure LoadRecentQueries;
    procedure AddToRecentQueries(const ASQL: string);
    procedure CreateGridPopupMenu;
    procedure UpdateRecentQueriesCombo;
    procedure UpdateNavigationControls;
    procedure NavigateToPage(AOffset: Integer);
    procedure InitializeAIService;
    procedure ShowAIMessage(const ATitle, AContent: string);
    procedure ExecuteAIRequest(const AOperation: string; const AFunc: TFunc<TAIResponse>);
    procedure LoadIndexData;
    procedure LoadTableDetails;
    procedure AddColumnToTable;
    procedure ModifyTable;
    procedure DeleteIndex;
    procedure ReindexCurrent;
    function ExecuteCellIsNull(const S: string): Boolean;
    function CompareExecuteGridCells(ACol: Integer; const S1, S2: string): Integer;
    procedure SortExecuteGridByColumn(ACol: Integer);
    procedure SaveExecuteGridBackup;
    procedure RestoreExecuteGridFromBackup;
    function BrowseOrderBySuffix: string;
    function BrowseOrderByClause: string;
    function BrowseRowIdSql(AGridRow: Integer): string;
    function BrowseTableSqlRef: string;
    function BrowseObjectCaption: string;
    function GetNodeSchema(ANode: TTreeNode): string;
    procedure AddStructureToNode(AParent: TTreeNode; const ADatabaseName, ACaption: string; AIsAttached: Boolean);
    procedure UpdateDatabaseMenuState;
    procedure UpdateTableMenuState;
    procedure UpdateViewMenuState;
    procedure UpdateTriggerMenuState;
    function ResolveTableContext(out ATableName, ASchema: string): Boolean;
    function ResolveViewContext(out AViewName, ASchema: string): Boolean;
    function ResolveTriggerContext(out ATriggerName, ASchema: string): Boolean;
    function ExecuteSQLDialog(const ACaption, ATitle, AInitialSQL: string; out ASQL: string): Boolean;
    procedure SelectViewInTree(const AViewName, ASchema: string);
    procedure SelectTriggerInTree(const ATriggerName, ASchema: string);
    procedure PerformExportView;
    procedure SelectTableInTree(const ATableName, ASchema: string);
    function GetConfirmDrop: Boolean;
    procedure PerformExportTable;
    procedure FillDetachMenu;
    procedure PerformDetach(const AAlias: string);
    procedure ShowIntegrityCheckResult(const ATitle: string; AQuick: Boolean);
    function GetCsvDelimiter: Char;
    function GetCsvIncludeHeaders: Boolean;
    function PromptDataFileFormat(const ACaption: string;
      out AFormat: TDataFileFormat): Boolean;
    procedure PerformExportAllTables;
    procedure PerformExportDatabase;
    procedure PerformImportFromFile;
    function ExportAllTablesWorker(AProgress: TExportProgressProc): Boolean;
    function ExportDatabaseWorker(AProgress: TExportProgressProc): Boolean;
    function ExportTableWorker(AProgress: TExportProgressProc): Boolean;
    function ExportViewWorker(AProgress: TExportProgressProc): Boolean;
    function RunExportProgressDialog(AHelper: TExportProgressHelper;
      const ACaption: string): Boolean;
    function GetSQLCompletionLineHeight: Integer;
    procedure ApplySQLCompletionFormSize;
    procedure ScheduleSQLCompletionFixSize;
    procedure SQLCompletionFixTimer(Sender: TObject);
    function GetGridSelectedRows(AGrid: TStringGrid): TList<Integer>;
    function GetGridAnchorRow(AGrid: TStringGrid): Integer;
    procedure SetGridAnchorRow(AGrid: TStringGrid; ARow: Integer);
    procedure ClearGridSelection(AGrid: TStringGrid);
    function IsGridRowSelected(AGrid: TStringGrid; ARow: Integer): Boolean;
    procedure HandleGridRowClick(AGrid: TStringGrid; ARow: Integer; Shift: TShiftState);
    procedure SyncGridSelectionRect(AGrid: TStringGrid);
    procedure SelectGridDefaultRow(AGrid: TStringGrid);
    procedure UpdateBrowseSelectionButtons;
    procedure ApplyBrowseHorzScroll(ACol: Integer; AUpdateSaved: Boolean);
    procedure ResetBrowseHorzScroll;
  public
    FDB: TSQLiteHandler;
    FCurrentTable: string;
    FCurrentView: string;
    FRecentDatabases: TStringList;
    FOptions: TIniFile;
    procedure LoadOptions;
    procedure SaveOptions;
    procedure UpdateStatusBar(const AMsg: string = '');
    procedure RefreshStructure;
    procedure LoadTableData;
    procedure DisplayQueryResult(const AResult: TQueryResult; AGrid: TStringGrid; AStatusPanel: TPanel);
    procedure UpdateDbInfo;
    procedure AddToRecent(const APath: string);
    procedure UpdateRecentMenu;
    procedure OnRecentClick(Sender: TObject);
    procedure OpenDatabase(const APath: string);
    procedure CloseDatabase;
    procedure pmGridPopup(Sender: TObject);
  end;
var
  frmMain: TfrmMain;
implementation
{$R *.dfm}
uses
  Vcl.FileCtrl, Winapi.ShellAPI, Winapi.CommCtrl, OptionsForm, AboutForm, CreateTreeForm,
  CreateIndexForm, AddColumnForm, SQLDialogForm, RowEditForm, SQLFieldCompletion, AppPaths;

type
  TCompactProgressHelper = class
  public
    CancelRequested: Boolean;
    Lbl: TLabel;
    BtnCancel: TButton;
    procedure CancelClick(Sender: TObject);
    procedure CloseQuery(Sender: TObject; var CanClose: Boolean);
  end;

procedure TCompactProgressHelper.CancelClick(Sender: TObject);
begin
  CancelRequested := True;
  if BtnCancel <> nil then
    BtnCancel.Enabled := False;
  if Lbl <> nil then
    Lbl.Caption := 'Cancelling...';
end;

procedure TCompactProgressHelper.CloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if not CancelRequested then
    CancelClick(BtnCancel);
end;

const
  SQLCompletionVisibleLines = 12;
  SQLCompletionRowGap = 6;

var
  GExportProgressHelper: TExportProgressHelper;
  GCompactProgressHelper: TCompactProgressHelper;

function FormatRowCount(N: Int64): string;
begin
  Result := FormatFloat('#,##0', N);
end;

procedure SetExportProgressBarPosition(ABar: TProgressBar; APercent: Integer);
begin
  if (ABar = nil) or not ABar.HandleAllocated then
    Exit;
  if APercent < ABar.Min then
    APercent := ABar.Min;
  if APercent > ABar.Max then
    APercent := ABar.Max;
  ABar.Position := APercent;
  SendMessage(ABar.Handle, PBM_SETPOS, APercent, 1);
end;

function ExportProgressCallback(const AInfo: TExportProgressInfo): Boolean;
begin
  Application.ProcessMessages;
  if GExportProgressHelper <> nil then
  begin
    GExportProgressHelper.UpdateProgress(AInfo);
    Result := not GExportProgressHelper.CancelRequested;
  end
  else
    Result := True;
end;

procedure TExportProgressHelper.UpdateProgress(const AInfo: TExportProgressInfo);
begin
  if ProgressForm <> nil then
  begin
    if AInfo.TableCount > 0 then
      ProgressForm.Caption := Format('%s - %s (%d/%d)', [ExportBaseCaption, AInfo.TableName,
        AInfo.TableIndex, AInfo.TableCount])
    else
      ProgressForm.Caption := Format('%s - %s', [ExportBaseCaption, AInfo.TableName]);
  end;
  if EdRows <> nil then
  begin
    if AInfo.RowTotal > 0 then
      EdRows.Text := Format('Rows: %s / %s', [FormatRowCount(AInfo.RowDone),
        FormatRowCount(AInfo.RowTotal)])
    else
      EdRows.Text := Format('Rows: %s', [FormatRowCount(AInfo.RowDone)]);
  end;
  if LblPercent <> nil then
    LblPercent.Caption := IntToStr(AInfo.Percent) + '%';
  SetExportProgressBarPosition(Bar, AInfo.Percent);
  if ProgressForm <> nil then
    ProgressForm.Update;
end;

procedure TExportProgressHelper.CancelClick(Sender: TObject);
begin
  CancelRequested := True;
  if BtnCancel <> nil then
    BtnCancel.Enabled := False;
  if ProgressForm <> nil then
    ProgressForm.Caption := ExportBaseCaption + ' - Cancelling...';
end;

procedure TExportProgressHelper.CloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if not CancelRequested then
    CancelClick(BtnCancel);
end;

function TExportProgressHelper.ExecuteExport: Boolean;
begin
  if Assigned(OnExport) then
    Result := OnExport(ExportProgressCallback)
  else
    Result := False;
end;

function CompactVacuumProgress: Boolean;
begin
  Application.ProcessMessages;
  if GCompactProgressHelper <> nil then
    Result := GCompactProgressHelper.CancelRequested
  else
    Result := False;
end;

function QuoteSQLIdent(const Id: string): string;
begin
  Result := '"' + StringReplace(Id, '"', '""', [rfReplaceAll]) + '"';
end;

function GetDbFileSizeBytes(const APath: string): Int64;
var
  F: TFileStream;
begin
  Result := 0;
  if not FileExists(APath) then
    Exit;
  F := TFileStream.Create(APath, fmOpenRead or fmShareDenyNone);
  try
    Result := F.Size;
  finally
    F.Free;
  end;
end;

function FormatSizeMB(ABytes: Int64): string;
begin
  Result := FormatFloat('0.00', ABytes / (1024 * 1024)) + ' MB';
end;

procedure SetProgressBarMarquee(ABar: TProgressBar; AInterval: Cardinal);
begin
  SetWindowLong(ABar.Handle, GWL_STYLE, GetWindowLong(ABar.Handle, GWL_STYLE) or PBS_MARQUEE);
  SendMessage(ABar.Handle, PBM_SETMARQUEE, 1, AInterval);
end;

procedure StopProgressBarMarquee(ABar: TProgressBar);
begin
  if ABar.HandleAllocated then
    SendMessage(ABar.Handle, PBM_SETMARQUEE, 0, 0);
end;

function IfThen(B: Boolean; Yes, No: String): String;
begin
  if B then
    Result := Yes
  else
    Result := No;
end;

function InferCellTypeFromText(const S: string): TSQLiteColumnType;
var
  I: Int64;
  D: Double;
  FS: TFormatSettings;
begin
  if Copy(S, 1, 4) = 'BLOB' then
    Exit(sctBlob);
  if TryStrToInt64(S, I) then
    Exit(sctInteger);
  FS := TFormatSettings.Invariant;
  if TryStrToFloat(S, D, FS) then
    Exit(sctReal);
  Result := sctText;
end;

function EffectiveColumnType(const ColTypes: TArray<TSQLiteColumnType>; ACol: Integer;
  const CellText: string): TSQLiteColumnType;
begin
  if (ACol >= 0) and (ACol < Length(ColTypes)) then
    Result := ColTypes[ACol]
  else
    Result := sctText;
  if (Result = sctNull) and (CellText <> '<NULL>') and (CellText <> '') then
    Result := InferCellTypeFromText(CellText);
end;
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDB := TSQLiteHandler.Create;
  FImportExport := TImportExport.Create(FDB);
  FCurrentTable := '';
  FCurrentView := '';
  FCurrentTrigger := '';
  FCurrentSchema := '';
  FRecentDatabases := TStringList.Create;
  FRecentQueries := TStringList.Create;
  FDetachMenuAliases := TStringList.Create;
  FReg := TRegistry.Create(KEY_ALL_ACCESS);
  CurrentGrid := nil;
  PopupMenuCol := 0;
  PopupMenuRow := 0;
  // Load options (%APPDATA%\OlegChernavin\SQLiteManager\SQLiteManager.ini)
  MigrateLegacySettingsIniIfNeeded;
  FOptions := TIniFile.Create(GetSettingsIniPath);
  LoadOptions;
  // Load recent databases
  FRecentDatabases.StrictDelimiter := True;
  FRecentDatabases.Delimiter := ',';
  FRecentDatabases.QuoteChar := '"';
  FRecentDatabases.DelimitedText := FOptions.ReadString('Recent', 'Databases', '');
  // Repair legacy corrupted entries (old save logic split on spaces, then re-saved as CSV)
  // Example: 'C:\Borland\Delphi', '7.0\Projects\X\db.sqlite' -> 'C:\Borland\Delphi 7.0\Projects\X\db.sqlite'
  var I := 0;
  while I < FRecentDatabases.Count - 1 do
  begin
    if (Length(FRecentDatabases[I]) >= 3) and
       (FRecentDatabases[I][2] = ':') and (FRecentDatabases[I][3] = '\') and
       (FRecentDatabases[I] <> '') and
       (FRecentDatabases[I + 1] <> '') and
       CharInSet(FRecentDatabases[I + 1][1], ['0'..'9']) and
       (Pos('\', FRecentDatabases[I + 1]) > 0) then
    begin
      FRecentDatabases[I] := FRecentDatabases[I] + ' ' + FRecentDatabases[I + 1];
      FRecentDatabases.Delete(I + 1);
      Continue;
    end;
    Inc(I);
  end;
  // Normalize: drop stray quote tails, trim, remove duplicates
  for I := FRecentDatabases.Count - 1 downto 0 do
  begin
    var S := Trim(FRecentDatabases[I]);
    // DelimitedText should already unquote, but legacy broken values can keep extra quotes.
    while (S <> '') and (S[1] = '"') do
      Delete(S, 1, 1);
    while (S <> '') and (S[Length(S)] = '"') do
      Delete(S, Length(S), 1);
    S := Trim(S);
    if S = '' then
      FRecentDatabases.Delete(I)
    else
      FRecentDatabases[I] := S;
  end;
  I := 0;
  while I < FRecentDatabases.Count do
  begin
    var J := FRecentDatabases.Count - 1;
    while J > I do
    begin
      if SameText(FRecentDatabases[I], FRecentDatabases[J]) then
        FRecentDatabases.Delete(J);
      Dec(J);
    end;
    Inc(I);
  end;
  UpdateRecentMenu;
  // Load recent queries
  LoadRecentQueries;
  FExecuteSortCol := -1;
  FExecuteSortAsc := True;
  FBrowseSortCol := -1;
  FBrowseSortAsc := True;
  FBrowseSelectedRows := TList<Integer>.Create;
  FExecuteSelectedRows := TList<Integer>.Create;
  FBrowseAnchorRow := -1;
  FExecuteAnchorRow := -1;
  FBrowseLeftCol := 0;
  FBrowseLeftColUpdating := False;
  sgBrowse.OnTopLeftChanged := sgBrowseTopLeftChanged;
  // Initialize UI
  edtLimit.Text := '100';
  edtOffset.Text := '0';
  // Load SQLite3 DLL
  if not LoadSQLite3('') then
  begin
    ShowMessage('Cannot load sqlite3.dll!' + sLineBreak + 'Please place sqlite3.dll in application directory.');
  end;
  // Create popup menu for grids
  CreateGridPopupMenu;
  
  // Initialize AI Service
  FAIService := nil;
  FAIConfigured := False;
  InitializeAIService;
  
  UpdateDatabaseMenuState;
  UpdateStatusBar('Ready');
  SynSQLCompletion.Editor := memSQL;
  SynSQLCompletion.Font.Assign(memSQL.Font);
  SynSQLCompletion.TimerInterval := 50;
  SynSQLCompletion.EndOfTokenChr := '()[] ';
  SynSQLCompletion.NbLinesInWindow := SQLCompletionVisibleLines;
  SynSQLCompletion.Resizeable := False;
  SynSQLCompletion.ItemHeight := GetSQLCompletionLineHeight;
  Timer1.Enabled := False;
  Timer1.Interval := 15;
  Timer1.OnTimer := SQLCompletionFixTimer;
end;
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Free popup menu
  if Assigned(pmGrid) then
    pmGrid.Free;
  // Free AI Service
  if Assigned(FAIService) then
    FAIService.Free;
  // Save queries if database is still open
  if FDB.IsOpen then
    SaveRecentQueries;
  // Save last database first, before freeing objects
  if FDB.IsOpen and (FDB.DatabasePath <> '') then
    SaveLastDatabase(FDB.DatabasePath);
  SaveWindowPosition;
  SaveOptions;
  FBrowseSelectedRows.Free;
  FExecuteSelectedRows.Free;
  FRecentDatabases.Free;
  FRecentQueries.Free;
  FDetachMenuAliases.Free;
  FImportExport.Free;
  FDB.Free;
  FOptions.Free;
  // FReg freed last as it's used in save functions
  FReg.Free;
end;
procedure TfrmMain.FormShow(Sender: TObject);
begin
  // Load last database and auto-open
  LoadLastDatabase;
  pcMain.ActivePageIndex := 0;
end;
procedure TfrmMain.FormActivate(Sender: TObject);
begin
  // Load window position
  LoadWindowPosition;
end;
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDB.IsOpen then
    FDB.CloseDatabase;
end;
procedure TfrmMain.LoadOptions;
begin
  // Load from ini file
end;
procedure TfrmMain.SaveOptions;
begin
  FRecentDatabases.StrictDelimiter := True;
  FRecentDatabases.Delimiter := ',';
  FRecentDatabases.QuoteChar := '"';
  FOptions.WriteString('Recent', 'Databases', FRecentDatabases.DelimitedText);
end;
procedure TfrmMain.UpdateStatusBar(const AMsg: string);
begin
  if AMsg <> '' then
    lblStatusMessage.Caption := AMsg;
  if FDB.IsOpen then
  begin
    Caption := 'SQLite Manager - ' + FDB.DatabasePath;
    lblStatusSQLite.Caption := 'SQLite: ' + GetSQLite3Version;
  end
  else
  begin
    Caption := 'SQLite Manager - No database';
    lblStatusSQLite.Caption := 'SQLite: --';
  end;
end;
procedure TfrmMain.OpenDatabase(const APath: string);
begin
  if FDB.IsOpen then
  begin
    // Save queries for current database before closing
    SaveRecentQueries;
    FDB.CloseDatabase;
    ResetBrowseHorzScroll;
    FCurrentTable := '';
    FCurrentView := '';
    FCurrentTrigger := '';
    FCurrentIndex := '';
    FCurrentTableName := '';
    FCurrentSchema := '';
    FIsSearching := False;
    FSearchWhereClause := '';
    sgBrowse.RowCount := 2;
    sgBrowse.ColCount := 1;
    sgBrowse.Cells[0, 0] := 'No data';
    FBrowseSortCol := -1;
    FBrowseSortAsc := True;
  end;

  if FDB.OpenDatabase(APath) then
  begin
    // Store database name (without path) for query history
    FCurrentDatabaseName := ExtractFileName(APath);
    
    AddToRecent(APath);
    SaveLastDatabase(APath); // Save to registry immediately
    RefreshStructure;
    UpdateStatusBar('DB open');
    // Load last selected table after structure is loaded
    LoadLastSelectedTable;
    // Load query history for this database
    LoadRecentQueries;
  end
  else
  begin
    ShowMessage('Error opening database: ' + FDB.LastError);
    UpdateStatusBar('Error opening DB');
  end;
end;
procedure TfrmMain.CloseDatabase;
begin
  if FDB.IsOpen then
  begin
    // Save queries for this database before closing
    SaveRecentQueries;
    FDB.CloseDatabase;
    FCurrentTable := '';
    FCurrentView := '';
    FCurrentTrigger := '';
    FCurrentSchema := '';
    FCurrentDatabaseName := '';
    FRecentQueries.Clear;
    UpdateDatabaseMenuState;
    tvStructure.Items.Clear;
    lblDbInfo.Caption := 'No database connected';
    sgBrowse.RowCount := 2;
    sgBrowse.ColCount := 1;
    sgBrowse.Cells[0, 0] := 'No data';
    FBrowseSortCol := -1;
    FBrowseSortAsc := True;
    ResetBrowseHorzScroll;
    UpdateStatusBar('DB closed');
  end;
end;
procedure TfrmMain.AddStructureToNode(AParent: TTreeNode; const ADatabaseName, ACaption: string; AIsAttached: Boolean);
var
  Structure: TDatabaseStructure;
  I: Integer;
  TablesNode, ViewsNode, IndexesNode, TriggersNode: TTreeNode;
begin
  AParent.ImageIndex := 0;
  AParent.SelectedIndex := 0;
  if AIsAttached then
  begin
    AParent.Data := Pointer(9);
    AParent.Text := ACaption;
  end;

  Structure := FDB.GetDatabaseStructure(ADatabaseName);

  TablesNode := tvStructure.Items.AddChild(AParent, 'Tables (' + IntToStr(Length(Structure.Tables)) + ')');
  TablesNode.ImageIndex := 1;
  TablesNode.SelectedIndex := 1;
  for I := 0 to High(Structure.Tables) do
  begin
    var Node := tvStructure.Items.AddChild(TablesNode, Structure.Tables[I]);
    Node.ImageIndex := 2;
    Node.SelectedIndex := 2;
    Node.Data := Pointer(1);
  end;

  ViewsNode := tvStructure.Items.AddChild(AParent, 'Views (' + IntToStr(Length(Structure.Views)) + ')');
  ViewsNode.ImageIndex := 3;
  ViewsNode.SelectedIndex := 3;
  for I := 0 to High(Structure.Views) do
  begin
    var Node := tvStructure.Items.AddChild(ViewsNode, Structure.Views[I]);
    Node.ImageIndex := 4;
    Node.SelectedIndex := 4;
    Node.Data := Pointer(2);
  end;

  IndexesNode := tvStructure.Items.AddChild(AParent, 'Indexes (' + IntToStr(Length(Structure.Indexes)) + ')');
  IndexesNode.ImageIndex := 5;
  IndexesNode.SelectedIndex := 5;
  for I := 0 to High(Structure.Indexes) do
  begin
    var Node := tvStructure.Items.AddChild(IndexesNode, Structure.Indexes[I]);
    Node.ImageIndex := 6;
    Node.SelectedIndex := 6;
    Node.Data := Pointer(3);
  end;

  TriggersNode := tvStructure.Items.AddChild(AParent, 'Triggers (' + IntToStr(Length(Structure.Triggers)) + ')');
  TriggersNode.ImageIndex := 7;
  TriggersNode.SelectedIndex := 7;
  for I := 0 to High(Structure.Triggers) do
  begin
    var Node := tvStructure.Items.AddChild(TriggersNode, Structure.Triggers[I]);
    Node.ImageIndex := 8;
    Node.SelectedIndex := 8;
    Node.Data := Pointer(4);
  end;
  AParent.Expand(True);
  IndexesNode.Collapse(False);
end;

function AttachedAliasFromNodeText(const AText: string): string;
var
  P: Integer;
begin
  P := Pos(' [', AText);
  if P > 0 then
    Result := Copy(AText, 1, P - 1)
  else
    Result := AText;
end;

function TfrmMain.GetNodeSchema(ANode: TTreeNode): string;
var
  N: TTreeNode;
begin
  Result := '';
  if ANode = nil then
    Exit;
  N := ANode;
  while N <> nil do
  begin
    if N.Data = Pointer(9) then
      Exit(AttachedAliasFromNodeText(N.Text));
    N := N.Parent;
  end;
end;

function TfrmMain.BrowseTableSqlRef: string;
begin
  if FCurrentTable <> '' then
    Result := FDB.QualifiedTableRef(FCurrentSchema, FCurrentTable)
  else if FCurrentView <> '' then
    Result := FDB.QualifiedTableRef(FCurrentSchema, FCurrentView)
  else
    Result := '';
end;

function TfrmMain.BrowseObjectCaption: string;
begin
  if (FCurrentSchema <> '') and not SameText(FCurrentSchema, 'main') then
  begin
    if FCurrentTable <> '' then
      Result := FCurrentSchema + '.' + FCurrentTable
    else
      Result := FCurrentSchema + '.' + FCurrentView;
  end
  else if FCurrentTable <> '' then
    Result := FCurrentTable
  else
    Result := FCurrentView;
end;

procedure TfrmMain.RefreshStructure;
var
  RootNode: TTreeNode;
  Attached: TArray<TAttachedDatabase>;
  I: Integer;
  Caption: string;
begin
  tvStructure.Items.Clear;
  if not FDB.IsOpen then
    Exit;

  RootNode := tvStructure.Items.Add(nil, ExtractFileName(FDB.DatabasePath));
  AddStructureToNode(RootNode, 'main', ExtractFileName(FDB.DatabasePath), False);

  Attached := FDB.GetAttachedDatabases;
  for I := 0 to High(Attached) do
  begin
    if Attached[I].IsMain then
      Continue;
    if Attached[I].FilePath <> '' then
      Caption := Attached[I].Name + ' [' + ExtractFileName(Attached[I].FilePath) + ']'
    else
      Caption := Attached[I].Name;
    RootNode := tvStructure.Items.Add(nil, Caption);
    AddStructureToNode(RootNode, Attached[I].Name, Caption, True);
  end;

  UpdateDbInfo;
  UpdateDatabaseMenuState;
end;
procedure TfrmMain.UpdateDbInfo;
var
  Info: TDictionary<string, Variant>;
  Structure: TDatabaseStructure;
  Attached: TArray<TAttachedDatabase>;
  Text: string;
  I, AttachCount: Integer;
begin
  if not FDB.IsOpen then
  begin
    lblDbInfo.Caption := 'No database connected';
    Exit;
  end;
  Info := FDB.GetDatabaseInfo;
  Structure := FDB.GetDatabaseStructure;
  Attached := FDB.GetAttachedDatabases;

  Text := 'Page Size: ' + VarToStr(Info['page_size']) + ' bytes' + sLineBreak;
  Text := Text + 'Page Count: ' + VarToStr(Info['page_count']) + sLineBreak;
  Text := Text + 'Tables: ' + IntToStr(Length(Structure.Tables)) + sLineBreak;
  Text := Text + 'Views: ' + IntToStr(Length(Structure.Views)) + sLineBreak;
  Text := Text + 'Indexes: ' + IntToStr(Length(Structure.Indexes)) + sLineBreak;
  Text := Text + 'Triggers: ' + IntToStr(Length(Structure.Triggers));

  AttachCount := 0;
  for I := 0 to High(Attached) do
    if not Attached[I].IsMain then
      Inc(AttachCount);
  if AttachCount > 0 then
  begin
    Text := Text + sLineBreak + 'Attached (' + IntToStr(AttachCount) + '):' + sLineBreak;
    for I := 0 to High(Attached) do
      if not Attached[I].IsMain then
      begin
        Text := Text + '  ' + Attached[I].Name;
        if Attached[I].FilePath <> '' then
          Text := Text + ' — ' + Attached[I].FilePath;
        Text := Text + sLineBreak;
      end;
  end;

  lblDbInfo.Caption := Text;
  Info.Free;
end;
procedure TfrmMain.LoadTableData;
var
  Result: TQueryResult;
  Limit, Offset: Integer;
  CountSQL: string;
  CountResult: TQueryResult;
  I: Integer;
  CanSelect: Boolean;
  SQL: string;
  OrderSuffix: string;
begin
  if not FDB.IsOpen then
    Exit;
  if (FCurrentTable = '') and (FCurrentView = '') then
    Exit;
  try
    Limit := StrToIntDef(edtLimit.Text, 100);
    Offset := StrToIntDef(edtOffset.Text, 0);
  except
    Limit := 100;
    Offset := 0;
  end;

  TableInfo := nil;
  if FCurrentTable <> '' then
    TableInfo := FDB.GetTableInfo(FCurrentTable, FCurrentSchema)
  else if FCurrentView <> '' then
    TableInfo := FDB.GetTableInfo(FCurrentView, FCurrentSchema);

  if FCurrentTable <> '' then
  begin
    if FIsSearching then
      SQL := Format('SELECT * FROM %s WHERE %s', [BrowseTableSqlRef, FSearchWhereClause])
    else
      SQL := Format('SELECT * FROM %s', [BrowseTableSqlRef]);
  end
  else
    SQL := Format('SELECT * FROM %s', [BrowseTableSqlRef]);

  OrderSuffix := BrowseOrderBySuffix;
  if (FBrowseSortCol >= 0) and (OrderSuffix = '') then
    FBrowseSortCol := -1;
  SQL := SQL + OrderSuffix + Format(' LIMIT %d OFFSET %d', [Limit, Offset]);

  Result := FDB.ExecuteSQL(SQL);
  // Get total count
  if FIsSearching then
  begin
    // Already have count from search - don't overwrite
    // FTotalRows := FSearchTotalRows;  // Already set in btnSearchClick
  end
  else if FCurrentTable <> '' then
  begin
    CountSQL := Format('SELECT COUNT(*) as cnt FROM %s', [BrowseTableSqlRef]);
    CountResult := FDB.ExecuteSQL(CountSQL);
    if CountResult.Success and (CountResult.RowCount > 0) then
      FTotalRows := CountResult.Rows[0][0]
    else
      FTotalRows := 0;
  end
  else
  begin
    CountSQL := Format('SELECT COUNT(*) as cnt FROM %s', [BrowseTableSqlRef]);
    CountResult := FDB.ExecuteSQL(CountSQL);
    if CountResult.Success and (CountResult.RowCount > 0) then
      FTotalRows := CountResult.Rows[0][0]
    else
      FTotalRows := 0;
  end;
  // Column types from schema (table or view)
  if Length(TableInfo) > 0 then
  begin
    SetLength(FColumnTypes, Length(TableInfo));
    for I := 0 to High(TableInfo) do
      FColumnTypes[I] := TableInfo[I].ColumnType;
  end
  else
    SetLength(FColumnTypes, 0);

  DisplayQueryResult(Result, sgBrowse, pnlBrowseStatus);

  // Update navigation controls
  UpdateNavigationControls;
  // Initialize button states
  sgBrowseSelectCell(sgBrowse, 0, 1, CanSelect);
  if FCurrentTable <> '' then
  begin
    lblTable.Caption := 'TABLE';
    edtBrowseTitle.Text := BrowseObjectCaption;
  end
  else
  begin
    lblTable.Caption := 'VIEW';
    edtBrowseTitle.Text := BrowseObjectCaption;
  end;
end;
procedure TfrmMain.DatabaseInformation1Click(Sender: TObject);
begin
  ShowMessage(lblDbInfo.Caption);
end;
procedure TfrmMain.DisplayQueryResult(const AResult: TQueryResult; AGrid: TStringGrid; AStatusPanel: TPanel);
var
  I, J: Integer;
begin
  if AGrid = sgExecute then
  begin
    FExecuteSortCol := -1;
    FExecuteSortAsc := True;
    SetLength(FExecuteCellsBackup, 0);
    ClearGridSelection(sgExecute);
  end;
  if AGrid = sgBrowse then
    ClearGridSelection(sgBrowse);
  if not AResult.Success then
  begin
    AGrid.RowCount := 2;
    AGrid.ColCount := 1;
    AGrid.Cells[0, 0] := 'Error';
    AGrid.Cells[0, 1] := AResult.ErrorMessage;
    AStatusPanel.Caption := 'Error: ' + AResult.ErrorMessage;
    AGrid.ColWidths[0] := AGrid.Width - 10;
    if AGrid = sgExecute then
      sgExecute.Invalidate;
    if AGrid = sgBrowse then
    begin
      FBrowseSortCol := -1;
      FBrowseSortAsc := True;
      sgBrowse.Invalidate;
    end;
    Exit;
  end;
  // Set up grid
  AGrid.ColCount := Length(AResult.Columns); // No extra column for row numbers
  if AResult.RowCount = 0 then
    AGrid.RowCount := 2
  else
    AGrid.RowCount := AResult.RowCount + 1;
  AGrid.DefaultRowHeight := 22;
  if AGrid.ColWidths[0] = (AGrid.Width - 10) then
    AGrid.ColWidths[0] := AGrid.DefaultColWidth;
  if AGrid.ColWidths[3] = (AGrid.Width - 10 - (AGrid.DefaultColWidth * 3)) then
    AGrid.ColWidths[3] := AGrid.DefaultColWidth;
  // Column headers
  for I := 0 to High(AResult.Columns) do
    AGrid.Cells[I, 0] := AResult.Columns[I];
  if AResult.RowCount = 0 then
    for I := 0 to High(AResult.Columns) do
      AGrid.Cells[I, 1] := '';
  // Data rows
  for I := 0 to AResult.RowCount - 1 do
  begin
    for J := 0 to High(AResult.Rows[I]) do
    begin
      if VarIsNull(AResult.Rows[I][J]) then
        AGrid.Cells[J, I + 1] := '<NULL>'  // Special marker for NULL
      else
        AGrid.Cells[J, I + 1] := VarToStr(AResult.Rows[I][J]);
    end;
  end;
  // Ensure fixed row is never selected
  if AGrid.RowCount > 1 then
  begin
    AGrid.FixedRows := 1;
    SelectGridDefaultRow(AGrid);
  end;
  // Store column types for cell coloring
  if AGrid = sgExecute then
  begin
    SetLength(FExecuteColumnTypes, Length(AResult.ColumnTypes));
    for I := 0 to High(AResult.ColumnTypes) do
      FExecuteColumnTypes[I] := AResult.ColumnTypes[I];
  end;
  AStatusPanel.Caption := Format('Rows: %d | Time: %d ms', [AResult.RowCount, AResult.Changes]);
  if AGrid = sgExecute then
  begin
    SaveExecuteGridBackup;
    sgExecute.Invalidate;
  end;
end;

function TfrmMain.ExecuteCellIsNull(const S: string): Boolean;
begin
  Result := (S = '') or (S = '<NULL>');
end;

function TfrmMain.CompareExecuteGridCells(ACol: Integer; const S1, S2: string): Integer;
var
  ColType: TSQLiteColumnType;
  I1, I2: Int64;
  F1, F2: Double;
  Ok1, Ok2: Boolean;
  FS: TFormatSettings;
begin
  if ExecuteCellIsNull(S1) and ExecuteCellIsNull(S2) then
    Exit(0);
  if ExecuteCellIsNull(S1) then
    Exit(1);
  if ExecuteCellIsNull(S2) then
    Exit(-1);

  if (ACol >= 0) and (ACol < Length(FExecuteColumnTypes)) then
    ColType := EffectiveColumnType(FExecuteColumnTypes, ACol, S1)
  else
    ColType := sctText;

  case ColType of
    sctInteger:
      begin
        Ok1 := TryStrToInt64(S1, I1);
        Ok2 := TryStrToInt64(S2, I2);
        if Ok1 and Ok2 then
        begin
          if I1 < I2 then
            Exit(-1);
          if I1 > I2 then
            Exit(1);
          Exit(0);
        end;
      end;
    sctReal:
      begin
        FS := TFormatSettings.Invariant;
        Ok1 := TryStrToFloat(S1, F1, FS);
        Ok2 := TryStrToFloat(S2, F2, FS);
        if Ok1 and Ok2 then
        begin
          if F1 < F2 then
            Exit(-1);
          if F1 > F2 then
            Exit(1);
          Exit(0);
        end;
      end;
  end;
  Result := CompareText(S1, S2);
end;

procedure TfrmMain.SortExecuteGridByColumn(ACol: Integer);
var
  fr, DataCount, r, c: Integer;
  RowList: TList<Integer>;
  Temp: TArray<TArray<string>>;
begin
  fr := sgExecute.FixedRows;
  DataCount := sgExecute.RowCount - fr;
  if (DataCount < 1) or (ACol < 0) or (ACol >= sgExecute.ColCount) then
    Exit;

  RowList := TList<Integer>.Create;
  try
    for r := 0 to DataCount - 1 do
      RowList.Add(fr + r);
    RowList.Sort(TComparer<Integer>.Construct(
      function(const L, R: Integer): Integer
      var
        SL, SR: string;
      begin
        SL := sgExecute.Cells[ACol, L];
        SR := sgExecute.Cells[ACol, R];
        Result := CompareExecuteGridCells(ACol, SL, SR);
        if not FExecuteSortAsc then
          Result := -Result;
        if Result = 0 then
          Result := L - R;
      end));

    SetLength(Temp, DataCount);
    for r := 0 to DataCount - 1 do
    begin
      SetLength(Temp[r], sgExecute.ColCount);
      for c := 0 to sgExecute.ColCount - 1 do
        Temp[r][c] := sgExecute.Cells[c, RowList[r]];
    end;
    for r := 0 to DataCount - 1 do
      for c := 0 to sgExecute.ColCount - 1 do
        sgExecute.Cells[c, fr + r] := Temp[r][c];
  finally
    RowList.Free;
  end;
  sgExecute.Invalidate;
end;

procedure TfrmMain.SaveExecuteGridBackup;
var
  fr, r, c, dataCount: Integer;
begin
  fr := sgExecute.FixedRows;
  dataCount := sgExecute.RowCount - fr;
  if dataCount < 1 then
  begin
    SetLength(FExecuteCellsBackup, 0);
    Exit;
  end;
  SetLength(FExecuteCellsBackup, dataCount);
  for r := 0 to dataCount - 1 do
  begin
    SetLength(FExecuteCellsBackup[r], sgExecute.ColCount);
    for c := 0 to sgExecute.ColCount - 1 do
      FExecuteCellsBackup[r][c] := sgExecute.Cells[c, fr + r];
  end;
end;

procedure TfrmMain.RestoreExecuteGridFromBackup;
var
  fr, r, c, dataCount: Integer;
begin
  fr := sgExecute.FixedRows;
  dataCount := sgExecute.RowCount - fr;
  if (dataCount < 1) or (Length(FExecuteCellsBackup) <> dataCount) then
    Exit;
  for r := 0 to dataCount - 1 do
    if Length(FExecuteCellsBackup[r]) <> sgExecute.ColCount then
      Exit;
  for r := 0 to dataCount - 1 do
    for c := 0 to sgExecute.ColCount - 1 do
      sgExecute.Cells[c, fr + r] := FExecuteCellsBackup[r][c];
end;

function TfrmMain.BrowseOrderBySuffix: string;
begin
  Result := '';
  if FBrowseSortCol < 0 then
    Exit;
  if (Length(TableInfo) = 0) or (FBrowseSortCol >= Length(TableInfo)) then
    Exit;
  Result := ' ORDER BY ' + QuoteSQLIdent(TableInfo[FBrowseSortCol].Name) + ' ' +
    IfThen(FBrowseSortAsc, 'ASC', 'DESC');
end;

function TfrmMain.BrowseOrderByClause: string;
begin
  Result := BrowseOrderBySuffix;
  if Result = '' then
    Result := ' ORDER BY rowid';
end;

function TfrmMain.BrowseRowIdSql(AGridRow: Integer): string;
var
  RowOffset: Integer;
begin
  RowOffset := (AGridRow - 1) + StrToIntDef(edtOffset.Text, 0);
  if FIsSearching then
    Result := Format('SELECT rowid FROM %s WHERE %s%s LIMIT 1 OFFSET %d',
      [BrowseTableSqlRef, FSearchWhereClause, BrowseOrderByClause, RowOffset])
  else
    Result := Format('SELECT rowid FROM %s%s LIMIT 1 OFFSET %d',
      [BrowseTableSqlRef, BrowseOrderByClause, RowOffset]);
end;

function TfrmMain.GetGridSelectedRows(AGrid: TStringGrid): TList<Integer>;
begin
  if AGrid = sgBrowse then
    Result := FBrowseSelectedRows
  else if AGrid = sgExecute then
    Result := FExecuteSelectedRows
  else
    Result := nil;
end;

function TfrmMain.GetGridAnchorRow(AGrid: TStringGrid): Integer;
begin
  if AGrid = sgBrowse then
    Result := FBrowseAnchorRow
  else if AGrid = sgExecute then
    Result := FExecuteAnchorRow
  else
    Result := -1;
end;

procedure TfrmMain.SetGridAnchorRow(AGrid: TStringGrid; ARow: Integer);
begin
  if AGrid = sgBrowse then
    FBrowseAnchorRow := ARow
  else if AGrid = sgExecute then
    FExecuteAnchorRow := ARow;
end;

procedure TfrmMain.ClearGridSelection(AGrid: TStringGrid);
var
  List: TList<Integer>;
begin
  List := GetGridSelectedRows(AGrid);
  if List <> nil then
    List.Clear;
  SetGridAnchorRow(AGrid, -1);
end;

function TfrmMain.IsGridRowSelected(AGrid: TStringGrid; ARow: Integer): Boolean;
var
  List: TList<Integer>;
begin
  List := GetGridSelectedRows(AGrid);
  Result := (List <> nil) and (List.IndexOf(ARow) >= 0);
end;

procedure TfrmMain.SyncGridSelectionRect(AGrid: TStringGrid);
var
  List: TList<Integer>;
  Sel: TGridRect;
begin
  List := GetGridSelectedRows(AGrid);
  if (List = nil) or (List.Count = 0) then
    Exit;
  Sel.Left := AGrid.FixedCols;
  // sgBrowse: row highlight is drawn in DrawCell; narrow rect avoids horz auto-scroll.
  if AGrid = sgBrowse then
    Sel.Right := AGrid.FixedCols
  else
    Sel.Right := AGrid.ColCount - 1;
  Sel.Top := List.First;
  Sel.Bottom := List.Last;
  AGrid.Selection := Sel;
end;

procedure TfrmMain.SelectGridDefaultRow(AGrid: TStringGrid);
var
  List: TList<Integer>;
  SavedLeft: Integer;
begin
  ClearGridSelection(AGrid);
  if AGrid.RowCount <= AGrid.FixedRows then
    Exit;
  List := GetGridSelectedRows(AGrid);
  List.Add(AGrid.FixedRows);
  SetGridAnchorRow(AGrid, AGrid.FixedRows);
  if AGrid = sgBrowse then
    SavedLeft := FBrowseLeftCol
  else
    SavedLeft := AGrid.FixedCols;
  if AGrid = sgBrowse then
    FBrowseLeftColUpdating := True;
  try
    AGrid.Row := AGrid.FixedRows;
    SyncGridSelectionRect(AGrid);
    if AGrid = sgBrowse then
      ApplyBrowseHorzScroll(SavedLeft, False);
  finally
    if AGrid = sgBrowse then
      FBrowseLeftColUpdating := False
    else
      AGrid.LeftCol := AGrid.FixedCols;
  end;
end;

procedure TfrmMain.ApplyBrowseHorzScroll(ACol: Integer; AUpdateSaved: Boolean);
begin
  if ACol < sgBrowse.FixedCols then
    ACol := sgBrowse.FixedCols;
  if AUpdateSaved then
    FBrowseLeftCol := ACol;
  if not sgBrowse.HandleAllocated then
    Exit;
  FBrowseLeftColUpdating := True;
  try
    sgBrowse.LeftCol := ACol;
  finally
    FBrowseLeftColUpdating := False;
  end;
end;

procedure TfrmMain.ResetBrowseHorzScroll;
begin
  ApplyBrowseHorzScroll(sgBrowse.FixedCols, True);
end;

procedure TfrmMain.sgBrowseTopLeftChanged(Sender: TObject);
var
  NewLeft: Integer;
begin
  if FBrowseLeftColUpdating then
    Exit;
  NewLeft := sgBrowse.LeftCol;
  if NewLeft <> FBrowseLeftCol then
    FBrowseLeftCol := NewLeft;
end;

procedure TfrmMain.HandleGridRowClick(AGrid: TStringGrid; ARow: Integer; Shift: TShiftState);
var
  List: TList<Integer>;
  I, Lo, Hi, Idx, Anchor: Integer;
  SavedLeft: Integer;
begin
  if ARow < AGrid.FixedRows then
    Exit;
  List := GetGridSelectedRows(AGrid);
  if List = nil then
    Exit;
  if AGrid = sgBrowse then
    SavedLeft := FBrowseLeftCol
  else
    SavedLeft := AGrid.LeftCol;
  Anchor := GetGridAnchorRow(AGrid);
  if ssCtrl in Shift then
  begin
    Idx := List.IndexOf(ARow);
    if Idx >= 0 then
      List.Delete(Idx)
    else
      List.Add(ARow);
    SetGridAnchorRow(AGrid, ARow);
  end
  else if ssShift in Shift then
  begin
    if Anchor < AGrid.FixedRows then
      Anchor := ARow;
    Lo := Min(Anchor, ARow);
    Hi := Max(Anchor, ARow);
    List.Clear;
    for I := Lo to Hi do
      List.Add(I);
  end
  else
  begin
    List.Clear;
    List.Add(ARow);
    SetGridAnchorRow(AGrid, ARow);
  end;
  List.Sort;
  if AGrid = sgBrowse then
    FBrowseLeftColUpdating := True;
  try
    AGrid.Row := ARow;
    SyncGridSelectionRect(AGrid);
    if AGrid = sgBrowse then
      ApplyBrowseHorzScroll(SavedLeft, False);
  finally
    if AGrid = sgBrowse then
      FBrowseLeftColUpdating := False
    else
      AGrid.LeftCol := SavedLeft;
  end;
  AGrid.Invalidate;
  if AGrid = sgBrowse then
    UpdateBrowseSelectionButtons;
end;

procedure TfrmMain.UpdateBrowseSelectionButtons;
var
  SelectedCount: Integer;
begin
  SelectedCount := FBrowseSelectedRows.Count;
  btnEditRecord.Enabled := (SelectedCount = 1);
  btnDuplicateRecord.Enabled := (SelectedCount = 1);
  btnDeleteRecord.Enabled := (SelectedCount > 0);
end;

procedure TfrmMain.sgBrowseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  if Button <> mbLeft then
    Exit;
  sgBrowse.MouseToCell(X, Y, ACol, ARow);
  if (ACol < 0) or (ARow < 0) then
    Exit;
  if sgBrowse.FixedRows < 1 then
    Exit;
  if ARow >= sgBrowse.FixedRows then
  begin
    HandleGridRowClick(sgBrowse, ARow, Shift);
    Exit;
  end;
  if (FCurrentTable = '') and (FCurrentView = '') then
    Exit;
  if Length(TableInfo) = 0 then
    Exit;
  if sgBrowse.RowCount <= sgBrowse.FixedRows then
    Exit;
  if ACol >= Length(TableInfo) then
    Exit;

  if FBrowseSortCol = ACol then
  begin
    if FBrowseSortAsc then
    begin
      FBrowseSortAsc := False;
      edtOffset.Text := '0';
      LoadTableData;
    end
    else
    begin
      FBrowseSortCol := -1;
      FBrowseSortAsc := True;
      edtOffset.Text := '0';
      LoadTableData;
    end;
  end
  else
  begin
    FBrowseSortCol := ACol;
    FBrowseSortAsc := True;
    edtOffset.Text := '0';
    LoadTableData;
  end;
  sgBrowse.Invalidate;
end;

procedure TfrmMain.sgExecuteMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  if Button <> mbLeft then
    Exit;
  sgExecute.MouseToCell(X, Y, ACol, ARow);
  if (ACol < 0) or (ARow < 0) then
    Exit;
  if sgExecute.FixedRows < 1 then
    Exit;
  if ARow >= sgExecute.FixedRows then
  begin
    HandleGridRowClick(sgExecute, ARow, Shift);
    Exit;
  end;
  if sgExecute.RowCount <= sgExecute.FixedRows then
    Exit;

  if FExecuteSortCol = ACol then
  begin
    if FExecuteSortAsc then
    begin
      FExecuteSortAsc := False;
      SortExecuteGridByColumn(ACol);
    end
    else
    begin
      FExecuteSortCol := -1;
      FExecuteSortAsc := True;
      RestoreExecuteGridFromBackup;
      sgExecute.Invalidate;
    end;
  end
  else
  begin
    FExecuteSortCol := ACol;
    FExecuteSortAsc := True;
    SortExecuteGridByColumn(ACol);
  end;
end;

procedure TfrmMain.AddToRecent(const APath: string);
var
  I: Integer;
begin
  // Remove if exists
  I := FRecentDatabases.IndexOf(APath);
  if I >= 0 then
    FRecentDatabases.Delete(I);
  // Add to top
  FRecentDatabases.Insert(0, APath);
  // Limit to 10
  while FRecentDatabases.Count > 10 do
    FRecentDatabases.Delete(FRecentDatabases.Count - 1);
  UpdateRecentMenu;
end;
procedure TfrmMain.UpdateRecentMenu;
var
  I: Integer;
  Item: TMenuItem;
begin
  while mnuRecent.Count > 0 do
    mnuRecent.Delete(0);
  while pmRecentDb.Items.Count > 0 do
    pmRecentDb.Items.Delete(0);
  for I := 0 to FRecentDatabases.Count - 1 do
  begin
    Item := TMenuItem.Create(mnuRecent);
    Item.Caption := FRecentDatabases[I];
    Item.Tag := I;
    Item.OnClick := OnRecentClick;
    mnuRecent.Add(Item);

    Item := TMenuItem.Create(pmRecentDb);
    Item.Caption := FRecentDatabases[I];
    Item.Tag := I;
    Item.OnClick := OnRecentClick;
    pmRecentDb.Items.Add(Item);
  end;
end;
procedure TfrmMain.OnRecentClick(Sender: TObject);
var
  Item: TMenuItem;
  Index: Integer;
begin
  if not (Sender is TMenuItem) then
    Exit;
  Item := TMenuItem(Sender);
  Index := Item.Tag;
  if (Index >= 0) and (Index < FRecentDatabases.Count) then
    OpenDatabase(FRecentDatabases[Index]);
end;
procedure TfrmMain.mnuNewDatabaseClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(Self);
  try
    SaveDialog.Filter := 'SQLite Database|*.sqlite;*.db;*.sqlite3|All Files|*.*';
    SaveDialog.DefaultExt := 'sqlite';
    SaveDialog.FileName := 'new_database.sqlite';
    
    if SaveDialog.Execute then
    begin
      // Create empty database
      if FDB.IsOpen then
        FDB.CloseDatabase;
      
      if FDB.OpenDatabase(SaveDialog.FileName) then
      begin
        AddToRecent(SaveDialog.FileName);
        RefreshStructure;
        UpdateStatusBar('New database created: ' + SaveDialog.FileName);
      end
      else
      begin
        ShowMessage('Error creating database: ' + FDB.LastError);
      end;
    end;
  finally
    SaveDialog.Free;
  end;
end;
procedure TfrmMain.mnuOpenDatabaseClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Self);
  try
    OpenDialog.Filter := 'SQLite Database|*.sqlite;*.db;*.sqlite3|All Files|*.*';
    if OpenDialog.Execute then
      OpenDatabase(OpenDialog.FileName);
  finally
    OpenDialog.Free;
  end;
end;
procedure TfrmMain.mnuCloseDatabaseClick(Sender: TObject);
begin
  CloseDatabase;
end;

procedure TfrmMain.mnuCopyDatabaseClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  DestPath: string;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;

  SaveDialog := TSaveDialog.Create(Self);
  try
    SaveDialog.Filter := 'SQLite Database|*.sqlite;*.db;*.sqlite3|All Files|*.*';
    SaveDialog.DefaultExt := 'sqlite';
    SaveDialog.FileName := ChangeFileExt(ExtractFileName(FDB.DatabasePath), '') + '_copy.sqlite';
    if not SaveDialog.Execute then
      Exit;

    DestPath := SaveDialog.FileName;
    if SameText(ExpandFileName(DestPath), ExpandFileName(FDB.DatabasePath)) then
    begin
      ShowMessage('Destination must be different from the current database file.');
      Exit;
    end;

    if FileExists(DestPath) then
      if MessageDlg('File already exists. Overwrite?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        Exit;

    if FDB.CopyDatabase(DestPath) then
    begin
      UpdateStatusBar('Database copied to: ' + DestPath);
      MessageDlg('Database copied successfully to:' + sLineBreak + DestPath,
        mtInformation, [mbOK], 0);
    end
    else
      ShowMessage('Copy failed: ' + FDB.LastError);
  finally
    SaveDialog.Free;
  end;
end;

procedure TfrmMain.mnuCompactDatabaseClick(Sender: TObject);
var
  DbPath: string;
  SizeBefore, SizeAfter, Saved: Int64;
  Msg: string;
  Ok: Boolean;
  ProgressForm: TForm;
  Lbl: TLabel;
  Bar: TProgressBar;
  BtnCancel: TButton;
  ProgressHelper: TCompactProgressHelper;

begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;

  if MessageDlg('Compact database (VACUUM)?' + sLineBreak +
    'This may take a while on large databases.',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  DbPath := FDB.DatabasePath;
  SizeBefore := GetDbFileSizeBytes(DbPath);
  ProgressHelper := TCompactProgressHelper.Create;
  try
    ProgressForm := TForm.Create(Self);
    try
    ProgressForm.BorderStyle := bsDialog;
    ProgressForm.BorderIcons := [biSystemMenu];
    ProgressForm.Caption := 'Compact Database';
    ProgressForm.Position := poOwnerFormCenter;
    ProgressForm.Width := 400;
    ProgressForm.Height := 150;
    ProgressForm.FormStyle := fsStayOnTop;

    Lbl := TLabel.Create(ProgressForm);
    Lbl.Parent := ProgressForm;
    Lbl.Left := 16;
    Lbl.Top := 16;
    Lbl.Width := ProgressForm.ClientWidth - 32;
    Lbl.Caption := 'VACUUM in progress. Please wait...';
    Lbl.AutoSize := False;

    Bar := TProgressBar.Create(ProgressForm);
    Bar.Parent := ProgressForm;
    Bar.Left := 16;
    Bar.Top := 44;
    Bar.Width := ProgressForm.ClientWidth - 32;
    SetProgressBarMarquee(Bar, 40);

    BtnCancel := TButton.Create(ProgressForm);
    BtnCancel.Parent := ProgressForm;
    BtnCancel.Caption := 'Cancel';
    BtnCancel.Width := 90;
    BtnCancel.Height := 25;
    BtnCancel.Left := ProgressForm.ClientWidth - BtnCancel.Width - 16;
    BtnCancel.Top := 80;
    ProgressHelper.CancelRequested := False;
    ProgressHelper.Lbl := Lbl;
    ProgressHelper.BtnCancel := BtnCancel;
    BtnCancel.OnClick := ProgressHelper.CancelClick;
    ProgressForm.OnCloseQuery := ProgressHelper.CloseQuery;

    Enabled := False;
    try
      ProgressForm.Show;
      Application.ProcessMessages;

      GCompactProgressHelper := ProgressHelper;
      try
        Ok := FDB.Vacuum(CompactVacuumProgress);
      finally
        GCompactProgressHelper := nil;
      end;

      StopProgressBarMarquee(Bar);
      ProgressForm.Close;
    finally
      Enabled := True;
    end;
    finally
      ProgressForm.Free;
    end;
  finally
    ProgressHelper.Free;
  end;

  if Ok then
  begin
    SizeAfter := GetDbFileSizeBytes(DbPath);
    Saved := SizeBefore - SizeAfter;
    UpdateDbInfo;
    RefreshStructure;
    UpdateStatusBar('Database compacted');
    Msg := 'Database compacted successfully.' + sLineBreak + sLineBreak +
      'Size before: ' + FormatSizeMB(SizeBefore) + sLineBreak +
      'Size after: ' + FormatSizeMB(SizeAfter) + sLineBreak +
      'Saved: ' + FormatSizeMB(Saved);
    MessageDlg(Msg, mtInformation, [mbOK], 0);
  end
  else if SameText(FDB.LastError, 'Operation cancelled by user.') then
    UpdateStatusBar('Compact cancelled')
  else
    ShowMessage('Compact failed: ' + FDB.LastError);
end;

procedure TfrmMain.mnuAnalyzeDatabaseClick(Sender: TObject);
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    if FDB.Analyze then
    begin
      UpdateStatusBar('Database analyzed');
      ShowMessage('Database analyzed successfully.');
    end
    else
      ShowMessage('Analyze failed: ' + FDB.LastError);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.ShowIntegrityCheckResult(const ATitle: string; AQuick: Boolean);
var
  Lines: TArray<string>;
  I: Integer;
  Msg, Line: string;
  Ok: Boolean;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    Lines := FDB.IntegrityCheck(AQuick);
  finally
    Screen.Cursor := crDefault;
  end;

  if Length(Lines) = 0 then
  begin
    if FDB.LastError <> '' then
      ShowMessage(ATitle + ' failed: ' + FDB.LastError)
    else
      ShowMessage(ATitle + ' failed.');
    Exit;
  end;

  Ok := (Length(Lines) = 1) and SameText(Lines[0], 'ok');
  if Ok then
  begin
    UpdateStatusBar(ATitle + ': OK');
    MessageDlg(ATitle + sLineBreak + sLineBreak + 'No problems found.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  Msg := ATitle + ' found issues:' + sLineBreak + sLineBreak;
  for I := 0 to High(Lines) do
  begin
    Line := Lines[I];
    if Length(Msg) + Length(Line) + 4 > 30000 then
    begin
      Msg := Msg + '...';
      Break;
    end;
    Msg := Msg + Line + sLineBreak;
  end;
  UpdateStatusBar(ATitle + ': problems found');
  MessageDlg(Msg, mtWarning, [mbOK], 0);
end;

procedure TfrmMain.mnuCheckCompleteClick(Sender: TObject);
begin
  ShowIntegrityCheckResult('Integrity check', False);
end;

procedure TfrmMain.mnuCheckQuickClick(Sender: TObject);
begin
  ShowIntegrityCheckResult('Quick integrity check', True);
end;

function SuggestDatabaseAlias(const AFilePath: string): string;
var
  S: string;
  I: Integer;
begin
  S := ChangeFileExt(ExtractFileName(AFilePath), '');
  if S = '' then
    S := 'attached';
  if not CharInSet(S[1], ['A'..'Z', 'a'..'z', '_']) then
    S := '_' + S;
  for I := 2 to Length(S) do
    if not CharInSet(S[I], ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
      S[I] := '_';
  Result := S;
end;

function TfrmMain.GetCsvDelimiter: Char;
begin
  case FOptions.ReadInteger('Options', 'CSVDelimiter', 0) of
    1: Result := ';';
    2: Result := #9;
  else
    Result := ',';
  end;
end;

function TfrmMain.GetCsvIncludeHeaders: Boolean;
begin
  Result := FOptions.ReadBool('Options', 'CSVHeaders', True);
end;

function TfrmMain.PromptDataFileFormat(const ACaption: string;
  out AFormat: TDataFileFormat): Boolean;
var
  Dlg: TForm;
  rbSQL, rbCSV, rbExcel: TRadioButton;
  btnOK, btnCancel: TButton;
  grp: TGroupBox;
begin
  Result := False;
  AFormat := dffSQL;
  Dlg := TForm.Create(Self);
  try
    Dlg.Caption := ACaption;
    Dlg.BorderStyle := bsDialog;
    Dlg.Position := poOwnerFormCenter;
    Dlg.Width := 320;
    Dlg.Height := 200;

    grp := TGroupBox.Create(Dlg);
    grp.Parent := Dlg;
    grp.Left := 12;
    grp.Top := 8;
    grp.Width := 290;
    grp.Height := 110;
    grp.Caption := 'File format';

    rbSQL := TRadioButton.Create(Dlg);
    rbSQL.Parent := grp;
    rbSQL.Left := 16;
    rbSQL.Top := 24;
    rbSQL.Caption := 'SQL (.sql)';
    rbSQL.Checked := True;

    rbCSV := TRadioButton.Create(Dlg);
    rbCSV.Parent := grp;
    rbCSV.Left := 16;
    rbCSV.Top := 48;
    rbCSV.Caption := 'CSV (.csv)';

    rbExcel := TRadioButton.Create(Dlg);
    rbExcel.Parent := grp;
    rbExcel.Left := 16;
    rbExcel.Top := 72;
    rbExcel.Caption := 'Excel (.xls)';

    btnOK := TButton.Create(Dlg);
    btnOK.Parent := Dlg;
    btnOK.Caption := 'OK';
    btnOK.ModalResult := mrOk;
    btnOK.Default := True;
    btnOK.Left := 130;
    btnOK.Top := 130;
    btnOK.Width := 75;

    btnCancel := TButton.Create(Dlg);
    btnCancel.Parent := Dlg;
    btnCancel.Caption := 'Cancel';
    btnCancel.ModalResult := mrCancel;
    btnCancel.Cancel := True;
    btnCancel.Left := 215;
    btnCancel.Top := 130;
    btnCancel.Width := 75;

    if Dlg.ShowModal <> mrOk then
      Exit;

    Result := True;
    if rbCSV.Checked then
      AFormat := dffCSV
    else if rbExcel.Checked then
      AFormat := dffExcel
    else
      AFormat := dffSQL;
  finally
    Dlg.Free;
  end;
end;

function TfrmMain.RunExportProgressDialog(AHelper: TExportProgressHelper;
  const ACaption: string): Boolean;
var
  LblRowsHdr: TLabel;
  LblW: Integer;

  procedure SetupReadOnlyEdit(AEdit: TEdit; const AText: string);
  begin
    AEdit.Parent := AHelper.ProgressForm;
    AEdit.Left := 16;
    AEdit.Width := LblW;
    AEdit.ReadOnly := True;
    AEdit.TabStop := False;
    AEdit.BorderStyle := bsSingle;
    AEdit.Color := clWindow;
    AEdit.Font.Color := clWindowText;
    AEdit.Text := AText;
  end;

begin
  AHelper.ExportBaseCaption := ACaption;
  AHelper.ProgressForm := TForm.Create(Self);
  try
    AHelper.ProgressForm.BorderStyle := bsDialog;
    AHelper.ProgressForm.BorderIcons := [biSystemMenu];
    AHelper.ProgressForm.Caption := ACaption;
    AHelper.ProgressForm.Position := poOwnerFormCenter;
    AHelper.ProgressForm.Width := 580;
    AHelper.ProgressForm.Height := 168;
    AHelper.ProgressForm.FormStyle := fsStayOnTop;
    AHelper.ProgressForm.OnCloseQuery := AHelper.CloseQuery;
    LblW := AHelper.ProgressForm.ClientWidth - 32;

    LblRowsHdr := TLabel.Create(AHelper.ProgressForm);
    LblRowsHdr.Parent := AHelper.ProgressForm;
    LblRowsHdr.SetBounds(16, 12, LblW, 15);
    LblRowsHdr.Caption := 'Progress:';

    AHelper.EdRows := TEdit.Create(AHelper.ProgressForm);
    SetupReadOnlyEdit(AHelper.EdRows, 'Rows: 0 / 0');
    AHelper.EdRows.Top := 30;
    AHelper.EdRows.Height := 22;

    AHelper.Bar := TProgressBar.Create(AHelper.ProgressForm);
    AHelper.Bar.Parent := AHelper.ProgressForm;
    AHelper.Bar.SetBounds(16, 62, LblW, 20);
    AHelper.Bar.Min := 0;
    AHelper.Bar.Max := 100;
    AHelper.Bar.Smooth := True;
    AHelper.Bar.Step := 1;
    SetExportProgressBarPosition(AHelper.Bar, 0);

    AHelper.LblPercent := TLabel.Create(AHelper.ProgressForm);
    AHelper.LblPercent.Parent := AHelper.ProgressForm;
    AHelper.LblPercent.SetBounds(16, 88, 80, 17);
    AHelper.LblPercent.Caption := '0%';

    AHelper.BtnCancel := TButton.Create(AHelper.ProgressForm);
    AHelper.BtnCancel.Parent := AHelper.ProgressForm;
    AHelper.BtnCancel.Caption := 'Cancel';
    AHelper.BtnCancel.SetBounds(AHelper.ProgressForm.ClientWidth - 106, 112, 90, 25);
    AHelper.BtnCancel.OnClick := AHelper.CancelClick;

    AHelper.CancelRequested := False;
    GExportProgressHelper := AHelper;
    Screen.Cursor := crHourGlass;
    try
      AHelper.ProgressForm.Show;
      Application.ProcessMessages;
      Result := AHelper.ExecuteExport;
      AHelper.ProgressForm.Close;
    finally
      Screen.Cursor := crDefault;
      GExportProgressHelper := nil;
    end;
  finally
    AHelper.ProgressForm.Free;
    AHelper.ProgressForm := nil;
    AHelper.EdRows := nil;
    AHelper.LblPercent := nil;
    AHelper.Bar := nil;
    AHelper.BtnCancel := nil;
  end;
end;

function TfrmMain.ExportAllTablesWorker(AProgress: TExportProgressProc): Boolean;
begin
  Result := FImportExport.ExportAllTables(FPendingExportFolder, FPendingExportFmt,
    GetCsvIncludeHeaders, GetCsvDelimiter, FPendingExportCount, AProgress);
end;

function TfrmMain.ExportDatabaseWorker(AProgress: TExportProgressProc): Boolean;
begin
  Result := FImportExport.ExportDatabase(FPendingExportFile, FPendingExportFmt,
    GetCsvIncludeHeaders, GetCsvDelimiter, AProgress);
end;

function TfrmMain.ExportTableWorker(AProgress: TExportProgressProc): Boolean;
begin
  Result := FImportExport.ExportTable(FPendingExportTable, FPendingExportFile,
    FPendingExportFmt, GetCsvIncludeHeaders, GetCsvDelimiter, AProgress);
end;

function TfrmMain.ExportViewWorker(AProgress: TExportProgressProc): Boolean;
begin
  Result := FImportExport.ExportView(FPendingExportTable, FPendingExportFile,
    FPendingExportFmt, FPendingExportSchema, GetCsvIncludeHeaders, GetCsvDelimiter, AProgress);
end;

procedure TfrmMain.PerformExportView;
var
  Fmt: TDataFileFormat;
  SaveDlg: TSaveDialog;
  FilePath, DefName, Msg: string;
  Helper: TExportProgressHelper;
  ViewName, Schema: string;
begin
  if not ResolveViewContext(ViewName, Schema) then
  begin
    ShowMessage('Select a view first');
    Exit;
  end;

  if not PromptDataFileFormat('Export View', Fmt) then
    Exit;
  SaveDlg := TSaveDialog.Create(Self);
  try
    SaveDlg.Filter := TImportExport.SaveDialogFilter;
    DefName := ViewName + TImportExport.FormatExtension(Fmt);
    SaveDlg.FileName := DefName;
    SaveDlg.DefaultExt := Copy(TImportExport.FormatExtension(Fmt), 2, MaxInt);
    case Fmt of
      dffSQL: SaveDlg.FilterIndex := 1;
      dffCSV: SaveDlg.FilterIndex := 2;
      dffExcel: SaveDlg.FilterIndex := 3;
    end;
    if not SaveDlg.Execute then
      Exit;
    FilePath := SaveDlg.FileName;
  finally
    SaveDlg.Free;
  end;

  FPendingExportTable := ViewName;
  FPendingExportSchema := Schema;
  FPendingExportFile := FilePath;
  FPendingExportFmt := Fmt;
  Helper := TExportProgressHelper.Create;
  try
    Helper.OnExport := ExportViewWorker;
    if RunExportProgressDialog(Helper, 'Export View') then
    begin
      UpdateStatusBar('View exported');
      Msg := 'View "' + ViewName + '" exported to:' + sLineBreak + FilePath;
      MessageDlg(Msg, mtInformation, [mbOK], 0);
    end
    else if SameText(FDB.LastError, 'Operation cancelled by user.') then
      UpdateStatusBar('Export cancelled')
    else if FDB.LastError <> '' then
      ShowMessage('Export failed: ' + FDB.LastError);
  finally
    Helper.Free;
  end;
end;

procedure TfrmMain.PerformExportTable;
var
  Fmt: TDataFileFormat;
  SaveDlg: TSaveDialog;
  FilePath, DefName, Msg: string;
  Helper: TExportProgressHelper;
  TableName, Schema: string;
begin
  if not ResolveTableContext(TableName, Schema) then
  begin
    ShowMessage('Select a table first');
    Exit;
  end;

  if not PromptDataFileFormat('Export Table', Fmt) then
    Exit;
  SaveDlg := TSaveDialog.Create(Self);
  try
    SaveDlg.Filter := TImportExport.SaveDialogFilter;
    DefName := TableName + TImportExport.FormatExtension(Fmt);
    SaveDlg.FileName := DefName;
    SaveDlg.DefaultExt := Copy(TImportExport.FormatExtension(Fmt), 2, MaxInt);
    case Fmt of
      dffSQL: SaveDlg.FilterIndex := 1;
      dffCSV: SaveDlg.FilterIndex := 2;
      dffExcel: SaveDlg.FilterIndex := 3;
    end;
    if not SaveDlg.Execute then
      Exit;
    FilePath := SaveDlg.FileName;
  finally
    SaveDlg.Free;
  end;

  FPendingExportTable := TableName;
  FPendingExportFile := FilePath;
  FPendingExportFmt := Fmt;
  Helper := TExportProgressHelper.Create;
  try
    Helper.OnExport := ExportTableWorker;
    if RunExportProgressDialog(Helper, 'Export Table') then
    begin
      UpdateStatusBar('Table exported');
      Msg := 'Table "' + TableName + '" exported to:' + sLineBreak + FilePath;
      MessageDlg(Msg, mtInformation, [mbOK], 0);
    end
    else if SameText(FDB.LastError, 'Operation cancelled by user.') then
      UpdateStatusBar('Export cancelled')
    else if FDB.LastError <> '' then
      ShowMessage('Export failed: ' + FDB.LastError);
  finally
    Helper.Free;
  end;
end;

procedure TfrmMain.PerformExportAllTables;
var
  Fmt: TDataFileFormat;
  Folder: string;
  Helper: TExportProgressHelper;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;

  if not PromptDataFileFormat('Export All Tables', Fmt) then
    Exit;
  Folder := '';
  if not SelectDirectory('Select folder for export', '', Folder) then
    Exit;

  FPendingExportFolder := Folder;
  FPendingExportFmt := Fmt;
  FPendingExportCount := 0;
  Helper := TExportProgressHelper.Create;
  try
    Helper.OnExport := ExportAllTablesWorker;
    if RunExportProgressDialog(Helper, 'Export All Tables') then
    begin
      RefreshStructure;
      UpdateStatusBar(Format('Exported %d table(s)', [FPendingExportCount]));
      MessageDlg(Format('Exported %d table(s) to:' + sLineBreak + '%s',
        [FPendingExportCount, Folder]), mtInformation, [mbOK], 0);
    end
    else if SameText(FDB.LastError, 'Operation cancelled by user.') then
      UpdateStatusBar('Export cancelled')
    else if FDB.LastError <> '' then
      ShowMessage('Export failed: ' + FDB.LastError);
  finally
    Helper.Free;
  end;
end;

procedure TfrmMain.PerformExportDatabase;
var
  Fmt: TDataFileFormat;
  SaveDlg: TSaveDialog;
  FilePath, DefName, Msg: string;
  Helper: TExportProgressHelper;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;

  if not PromptDataFileFormat('Export Database', Fmt) then
    Exit;
  SaveDlg := TSaveDialog.Create(Self);
  try
    SaveDlg.Filter := TImportExport.SaveDialogFilter;
    DefName := ChangeFileExt(ExtractFileName(FDB.DatabasePath), '') +
      TImportExport.FormatExtension(Fmt);
    SaveDlg.FileName := DefName;
    SaveDlg.DefaultExt := Copy(TImportExport.FormatExtension(Fmt), 2, MaxInt);
    case Fmt of
      dffSQL: SaveDlg.FilterIndex := 1;
      dffCSV: SaveDlg.FilterIndex := 2;
      dffExcel: SaveDlg.FilterIndex := 3;
    end;
    if not SaveDlg.Execute then
      Exit;
    FilePath := SaveDlg.FileName;
  finally
    SaveDlg.Free;
  end;

  FPendingExportFile := FilePath;
  FPendingExportFmt := Fmt;
  Helper := TExportProgressHelper.Create;
  try
    Helper.OnExport := ExportDatabaseWorker;
    if RunExportProgressDialog(Helper, 'Export Database') then
    begin
      RefreshStructure;
      UpdateStatusBar('Database exported');
      if Fmt = dffCSV then
        Msg := 'Database exported as CSV files to folder:' + sLineBreak +
          ChangeFileExt(FilePath, '')
      else
        Msg := 'Database exported to:' + sLineBreak + FilePath;
      MessageDlg(Msg, mtInformation, [mbOK], 0);
    end
    else if SameText(FDB.LastError, 'Operation cancelled by user.') then
      UpdateStatusBar('Export cancelled')
    else if FDB.LastError <> '' then
      ShowMessage('Export failed: ' + FDB.LastError);
  finally
    Helper.Free;
  end;
end;

procedure TfrmMain.PerformImportFromFile;
var
  OpenDlg: TOpenDialog;
  FilePath, TableName, Ext: string;
  Fmt: TDataFileFormat;
  CreateTable: Boolean;
  Rows: Integer;
  Msg: string;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;

  OpenDlg := TOpenDialog.Create(Self);
  try
    OpenDlg.Filter := TImportExport.OpenDialogFilter;
    if not OpenDlg.Execute then
      Exit;
    FilePath := OpenDlg.FileName;
    if OpenDlg.FilterIndex > 0 then
      Fmt := TImportExport.FormatFromDialogFilter(OpenDlg.FilterIndex)
    else
      Fmt := TImportExport.DetectFormat(FilePath);
  finally
    OpenDlg.Free;
  end;

  TableName := '';
  CreateTable := False;
  if Fmt <> dffSQL then
  begin
    Ext := ChangeFileExt(ExtractFileName(FilePath), '');
    TableName := InputBox('Import', 'Target table name:', Ext);
    if Trim(TableName) = '' then
      Exit;
    CreateTable := MessageDlg('Create table if it does not exist?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes;
  end;

  Screen.Cursor := crHourGlass;
  try
    if FImportExport.ImportFromFile(FilePath, Fmt, TableName, CreateTable,
      GetCsvDelimiter, Rows) then
    begin
      RefreshStructure;
      LoadTableData;
      UpdateDbInfo;
      if Fmt = dffSQL then
      begin
        UpdateStatusBar('SQL script imported');
        Msg := 'SQL script imported successfully.';
      end
      else
      begin
        UpdateStatusBar(Format('Imported %d row(s)', [Rows]));
        Msg := Format('Imported %d row(s) into table "%s".', [Rows, TableName]);
      end;
      MessageDlg(Msg, mtInformation, [mbOK], 0);
    end
    else
      ShowMessage('Import failed: ' + FDB.LastError);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.mnuExportAllClick(Sender: TObject);
begin
  PerformExportAllTables;
end;

procedure TfrmMain.mnuExportDatabaseClick(Sender: TObject);
begin
  PerformExportDatabase;
end;

procedure TfrmMain.mnuImportClick(Sender: TObject);
begin
  PerformImportFromFile;
end;

procedure TfrmMain.btnImportClick(Sender: TObject);
begin
  PerformImportFromFile;
end;

procedure TfrmMain.UpdateDatabaseMenuState;
begin
  mnuAttachDatabase.Enabled := FDB.IsOpen;
  mnuDetachDatabase.Enabled := FDB.IsOpen;
  mnuCopyDatabase.Enabled := FDB.IsOpen;
  mnuExportAll.Enabled := FDB.IsOpen;
  mnuExportDatabase.Enabled := FDB.IsOpen;
  mnuImport.Enabled := FDB.IsOpen;
  mnuCompactDatabase.Enabled := FDB.IsOpen;
  DatabaseInformation1.Enabled := FDB.IsOpen;
  mnuAnalyzeDatabase.Enabled := FDB.IsOpen;
  mnuCheckIntegrity.Enabled := FDB.IsOpen;
  mnuCheckComplete.Enabled := FDB.IsOpen;
  mnuCheckQuick.Enabled := FDB.IsOpen;
  if FDB.IsOpen then
    FillDetachMenu
  else
  begin
    while mnuDetachDatabase.Count > 0 do
      mnuDetachDatabase.Delete(0);
    FDetachMenuAliases.Clear;
  end;
  UpdateTableMenuState;
  UpdateViewMenuState;
  UpdateTriggerMenuState;
end;

procedure TfrmMain.UpdateViewMenuState;
var
  HasView: Boolean;
begin
  HasView := FDB.IsOpen and (FCurrentView <> '');
  mnuCreateView.Enabled := FDB.IsOpen;
  mnuDropView.Enabled := HasView;
  mnuRenameView.Enabled := HasView;
  mnuModifyView.Enabled := HasView;
  mnuExportView.Enabled := HasView;
  btnCreateView.Enabled := FDB.IsOpen;
end;

procedure TfrmMain.UpdateTriggerMenuState;
var
  HasTrigger: Boolean;
begin
  HasTrigger := FDB.IsOpen and (FCurrentTrigger <> '');
  mnuCreateTrigger.Enabled := FDB.IsOpen;
  mnuDropTrigger.Enabled := HasTrigger;
  mnuRenameTrigger.Enabled := HasTrigger;
  btnCreateTrigger.Enabled := FDB.IsOpen;
end;

procedure TfrmMain.UpdateTableMenuState;
var
  HasTable: Boolean;
begin
  HasTable := FDB.IsOpen and (FCurrentTable <> '');
  mnuCreateTable.Enabled := FDB.IsOpen;
  mnuDropTable.Enabled := HasTable;
  mnuEmptyTable.Enabled := HasTable;
  mnuRenameTable.Enabled := HasTable;
  mnuCopyTable.Enabled := HasTable;
  mnuExportTable.Enabled := HasTable;
  mnuReindexTable.Enabled := HasTable;
end;

function TfrmMain.ResolveTableContext(out ATableName, ASchema: string): Boolean;
var
  Node: TTreeNode;
begin
  Result := False;
  ATableName := '';
  ASchema := '';
  if not FDB.IsOpen then
    Exit;

  Node := tvStructure.Selected;
  if (Node <> nil) and (Node.Data = Pointer(1)) then
  begin
    ATableName := Node.Text;
    ASchema := GetNodeSchema(Node);
    Result := True;
    Exit;
  end;

  if FCurrentTable <> '' then
  begin
    ATableName := FCurrentTable;
    ASchema := FCurrentSchema;
    Result := True;
  end;
end;

function TfrmMain.ResolveViewContext(out AViewName, ASchema: string): Boolean;
var
  Node: TTreeNode;
begin
  Result := False;
  AViewName := '';
  ASchema := '';
  if not FDB.IsOpen then
    Exit;

  Node := tvStructure.Selected;
  if (Node <> nil) and (Node.Data = Pointer(2)) then
  begin
    AViewName := Node.Text;
    ASchema := GetNodeSchema(Node);
    Result := True;
    Exit;
  end;

  if FCurrentView <> '' then
  begin
    AViewName := FCurrentView;
    ASchema := FCurrentSchema;
    Result := True;
  end;
end;

function TfrmMain.ResolveTriggerContext(out ATriggerName, ASchema: string): Boolean;
var
  Node: TTreeNode;
begin
  Result := False;
  ATriggerName := '';
  ASchema := '';
  if not FDB.IsOpen then
    Exit;

  Node := tvStructure.Selected;
  if (Node <> nil) and (Node.Data = Pointer(4)) then
  begin
    ATriggerName := Node.Text;
    ASchema := GetNodeSchema(Node);
    Result := True;
    Exit;
  end;

  if FCurrentTrigger <> '' then
  begin
    ATriggerName := FCurrentTrigger;
    ASchema := FCurrentSchema;
    Result := True;
  end;
end;

function TfrmMain.ExecuteSQLDialog(const ACaption, ATitle, AInitialSQL: string; out ASQL: string): Boolean;
begin
  frmSQLDialog.Caption := ACaption;
  frmSQLDialog.lblTitle.Caption := ATitle;
  frmSQLDialog.memSQL.Lines.Text := AInitialSQL;
  Result := frmSQLDialog.ShowModal = mrOk;
  if Result then
    ASQL := Trim(frmSQLDialog.memSQL.Lines.Text);
end;

function TfrmMain.GetConfirmDrop: Boolean;
begin
  if Assigned(FOptions) then
    Result := FOptions.ReadBool('Options', 'ConfirmDrop', True)
  else
    Result := True;
end;

procedure TfrmMain.FillDetachMenu;
var
  Attached: TArray<TAttachedDatabase>;
  I: Integer;
  Item: TMenuItem;
begin
  while mnuDetachDatabase.Count > 0 do
    mnuDetachDatabase.Delete(0);
  FDetachMenuAliases.Clear;
  if not FDB.IsOpen then
    Exit;

  Attached := FDB.GetAttachedDatabases;
  for I := 0 to High(Attached) do
  begin
    if Attached[I].IsMain then
      Continue;
    FDetachMenuAliases.Add(Attached[I].Name);
    Item := TMenuItem.Create(mnuDetachDatabase);
    if Attached[I].FilePath <> '' then
      Item.Caption := Attached[I].Name + ' - ' + Attached[I].FilePath
    else
      Item.Caption := Attached[I].Name;
    Item.Tag := FDetachMenuAliases.Count - 1;
    Item.OnClick := OnDetachClick;
    mnuDetachDatabase.Add(Item);
  end;

  if FDetachMenuAliases.Count = 0 then
  begin
    Item := TMenuItem.Create(mnuDetachDatabase);
    Item.Caption := '(none attached)';
    Item.Enabled := False;
    mnuDetachDatabase.Add(Item);
  end;
end;

procedure TfrmMain.PerformDetach(const AAlias: string);
begin
  if AAlias = '' then
    Exit;
  if MessageDlg('Detach database "' + AAlias + '"?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;
  if FDB.DetachDatabase(AAlias) then
  begin
    if SameText(FCurrentSchema, AAlias) then
    begin
      FCurrentTable := '';
      FCurrentView := '';
      FCurrentTrigger := '';
      FCurrentSchema := '';
    end;
    RefreshStructure;
    UpdateStatusBar('Detached: ' + AAlias);
  end
  else
    ShowMessage('Detach failed: ' + FDB.LastError);
end;

procedure TfrmMain.OnDetachClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if not (Sender is TMenuItem) then
    Exit;
  Item := TMenuItem(Sender);
  if (Item.Tag < 0) or (Item.Tag >= FDetachMenuAliases.Count) then
    Exit;
  PerformDetach(FDetachMenuAliases[Item.Tag]);
end;

procedure TfrmMain.mnuAttachDatabaseClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  Alias, FilePath: string;
  Attached: TArray<TAttachedDatabase>;
  I: Integer;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;

  OpenDialog := TOpenDialog.Create(Self);
  try
    OpenDialog.Filter := 'SQLite Database|*.sqlite;*.db;*.sqlite3|All Files|*.*';
    if not OpenDialog.Execute then
      Exit;
    FilePath := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;

  Alias := SuggestDatabaseAlias(FilePath);
  if not InputQuery('Attach Database', 'Alias name:', Alias) then
    Exit;
  Alias := Trim(Alias);
  if Alias = '' then
  begin
    ShowMessage('Alias is required');
    Exit;
  end;

  if SameText(ExpandFileName(FilePath), ExpandFileName(FDB.DatabasePath)) then
  begin
    ShowMessage('Cannot attach the same file as the main database');
    Exit;
  end;

  Attached := FDB.GetAttachedDatabases;
  for I := 0 to High(Attached) do
    if (not Attached[I].IsMain) and SameText(ExpandFileName(Attached[I].FilePath), ExpandFileName(FilePath)) then
    begin
      ShowMessage('This file is already attached as "' + Attached[I].Name + '"');
      Exit;
    end;

  if FDB.AttachDatabase(FilePath, Alias) then
  begin
    RefreshStructure;
    UpdateStatusBar('Attached: ' + Alias);
  end
  else
    ShowMessage('Attach failed: ' + FDB.LastError);
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;
procedure TfrmMain.mnuRefreshClick(Sender: TObject);
begin
  if FDB.IsOpen then
  begin
    RefreshStructure;
    if (FCurrentTable <> '') or (FCurrentView <> '') then
      LoadTableData;
    UpdateStatusBar('Database refreshed');
  end;
end;
procedure TfrmMain.mnuCreateTableClick(Sender: TObject);
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  frmCreateTree.ShowModal;
end;

procedure TfrmMain.mnuDropTableClick(Sender: TObject);
var
  TableName, Schema, Msg: string;
  Confirm: Integer;
begin
  if not ResolveTableContext(TableName, Schema) then
  begin
    ShowMessage('Select a table first');
    Exit;
  end;
  if GetConfirmDrop then
  begin
    if (Schema <> '') and not SameText(Schema, 'main') then
      Msg := 'Drop table "' + Schema + '.' + TableName + '"?'
    else
      Msg := 'Drop table "' + TableName + '"?';
    Msg := Msg + sLineBreak + 'This cannot be undone.';
    Confirm := MessageDlg(Msg, mtWarning, [mbYes, mbNo], 0);
    if Confirm <> mrYes then
      Exit;
  end;
  if FDB.DropTable(TableName, Schema) then
  begin
    FCurrentTable := '';
    FCurrentTableName := '';
    RefreshStructure;
    UpdateTableMenuState;
    UpdateStatusBar('Table dropped');
  end
  else
    ShowMessage('Error dropping table: ' + FDB.LastError);
end;

procedure TfrmMain.mnuEmptyTableClick(Sender: TObject);
begin
  btnEmptyTableClick(Sender);
end;

procedure TfrmMain.mnuRenameTableClick(Sender: TObject);
var
  TableName, Schema, NewName: string;
begin
  if not ResolveTableContext(TableName, Schema) then
  begin
    ShowMessage('Select a table first');
    Exit;
  end;
  NewName := TableName;
  if not InputQuery('Rename Table', 'New table name:', NewName) then
    Exit;
  NewName := Trim(NewName);
  if NewName = '' then
  begin
    ShowMessage('Table name cannot be empty');
    Exit;
  end;
  if SameText(NewName, TableName) then
    Exit;
  if FDB.RenameTable(TableName, NewName, Schema) then
  begin
    SaveLastSelectedTable(NewName);
    RefreshStructure;
    SelectTableInTree(NewName, Schema);
    UpdateStatusBar('Table renamed');
  end
  else
    ShowMessage('Error renaming table: ' + FDB.LastError);
end;

procedure TfrmMain.mnuCopyTableClick(Sender: TObject);
var
  TableName, Schema, DestName: string;
  WithData: Boolean;
  Choice: Integer;
begin
  if not ResolveTableContext(TableName, Schema) then
  begin
    ShowMessage('Select a table first');
    Exit;
  end;
  DestName := TableName + '_copy';
  if not InputQuery('Copy Table', 'Destination table name:', DestName) then
    Exit;
  DestName := Trim(DestName);
  if DestName = '' then
  begin
    ShowMessage('Table name cannot be empty');
    Exit;
  end;
  if SameText(DestName, TableName) then
  begin
    ShowMessage('Destination name must differ from source table');
    Exit;
  end;
  Choice := MessageDlg('Copy row data to the new table?', mtConfirmation,
    [mbYes, mbNo, mbCancel], 0);
  if Choice = mrCancel then
    Exit;
  WithData := Choice = mrYes;
  if FDB.CopyTable(TableName, DestName, WithData, Schema) then
  begin
    SaveLastSelectedTable(DestName);
    RefreshStructure;
    SelectTableInTree(DestName, Schema);
    UpdateStatusBar('Table copied');
    MessageDlg('Table copied to "' + DestName + '"', mtInformation, [mbOK], 0);
  end
  else
    ShowMessage('Error copying table: ' + FDB.LastError);
end;

procedure TfrmMain.mnuExportTableClick(Sender: TObject);
begin
  PerformExportTable;
end;

procedure TfrmMain.mnuReindexTableClick(Sender: TObject);
var
  TableName, Schema: string;
begin
  if not ResolveTableContext(TableName, Schema) then
  begin
    ShowMessage('Select a table first');
    Exit;
  end;
  if FDB.ReindexTable(TableName, Schema) then
  begin
    UpdateStatusBar('Table reindexed');
    MessageDlg('Table "' + TableName + '" reindexed successfully', mtInformation, [mbOK], 0);
  end
  else
    ShowMessage('Error reindexing table: ' + FDB.LastError);
end;

procedure TfrmMain.mnuCreateIndexClick(Sender: TObject);
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  frmCreateIndex.ShowModal;
end;
procedure TfrmMain.mnuDropIndexClick(Sender: TObject);
var
  Node: TTreeNode;
  IndexName: string;
  Confirm: Integer;
  Res: TQueryResult;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  Node := tvStructure.Selected;
  if Node = nil then
  begin
    ShowMessage('Please select an index to drop');
    Exit;
  end;
  // Check if it's an index node (Data = Pointer(3))
  if Node.Data <> Pointer(3) then
  begin
    ShowMessage('Please select an index to drop');
    Exit;
  end;
  IndexName := Node.Text;
  Confirm := MessageDlg('Are you sure you want to drop index "' + IndexName + '"?',
                        mtConfirmation, [mbYes, mbNo], 0);
  if Confirm = mrYes then
  begin
    Res := FDB.ExecuteSQL(Format('DROP INDEX "%s"', [IndexName]));
    if Res.Success then
    begin
      ShowMessage('Index "' + IndexName + '" dropped successfully');
      RefreshStructure;
    end
    else
    begin
      ShowMessage('Error dropping index: ' + Res.ErrorMessage);
    end;
  end;
end;
procedure TfrmMain.mnuReindexIndexClick(Sender: TObject);
var
  Node: TTreeNode;
  IndexName: string;
  Res: TQueryResult;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  
  Node := tvStructure.Selected;
  if Node = nil then
  begin
    ShowMessage('Please select an index to reindex');
    Exit;
  end;
  
  // Check if it's an index node (Data = Pointer(3))
  if Node.Data <> Pointer(3) then
  begin
    ShowMessage('Please select an index to reindex');
    Exit;
  end;
  
  IndexName := Node.Text;
  
  Res := FDB.ExecuteSQL(Format('REINDEX "%s"', [IndexName]));
  if Res.Success then
  begin
    ShowMessage('Index "' + IndexName + '" reindexed successfully');
    RefreshStructure;
  end
  else
  begin
    ShowMessage('Error reindexing: ' + Res.ErrorMessage);
  end;
end;

procedure TfrmMain.mnuCreateViewClick(Sender: TObject);
var
  SQL: string;
  Res: TQueryResult;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  if ExecuteSQLDialog('Create View', 'Enter CREATE VIEW statement:',
    'CREATE VIEW view_name AS' + sLineBreak + 'SELECT * FROM table_name', SQL) then
  begin
    if SQL = '' then
      Exit;
    Res := FDB.ExecuteSQL(SQL);
    if Res.Success then
    begin
      RefreshStructure;
      UpdateViewMenuState;
      UpdateStatusBar('View created');
    end
    else
      ShowMessage('Error creating view: ' + Res.ErrorMessage);
  end;
end;

procedure TfrmMain.btnCreateViewClick(Sender: TObject);
begin
  mnuCreateViewClick(Sender);
end;

procedure TfrmMain.mnuDropViewClick(Sender: TObject);
var
  ViewName, Schema, Msg: string;
  Confirm: Integer;
begin
  if not ResolveViewContext(ViewName, Schema) then
  begin
    ShowMessage('Select a view first');
    Exit;
  end;
  if GetConfirmDrop then
  begin
    if (Schema <> '') and not SameText(Schema, 'main') then
      Msg := 'Drop view "' + Schema + '.' + ViewName + '"?'
    else
      Msg := 'Drop view "' + ViewName + '"?';
    Msg := Msg + sLineBreak + 'This cannot be undone.';
    Confirm := MessageDlg(Msg, mtWarning, [mbYes, mbNo], 0);
    if Confirm <> mrYes then
      Exit;
  end;
  if FDB.DropView(ViewName, Schema) then
  begin
    FCurrentView := '';
    RefreshStructure;
    UpdateViewMenuState;
    UpdateStatusBar('View dropped');
  end
  else
    ShowMessage('Error dropping view: ' + FDB.LastError);
end;

procedure TfrmMain.mnuRenameViewClick(Sender: TObject);
var
  ViewName, Schema, NewName: string;
begin
  if not ResolveViewContext(ViewName, Schema) then
  begin
    ShowMessage('Select a view first');
    Exit;
  end;
  NewName := ViewName;
  if not InputQuery('Rename View', 'New view name:', NewName) then
    Exit;
  NewName := Trim(NewName);
  if NewName = '' then
  begin
    ShowMessage('View name cannot be empty');
    Exit;
  end;
  if SameText(NewName, ViewName) then
    Exit;
  if FDB.RenameView(ViewName, NewName, Schema) then
  begin
    SaveLastSelectedTable(NewName);
    RefreshStructure;
    SelectViewInTree(NewName, Schema);
    UpdateViewMenuState;
    UpdateStatusBar('View renamed');
  end
  else
    ShowMessage('Error renaming view: ' + FDB.LastError);
end;

procedure TfrmMain.mnuModifyViewClick(Sender: TObject);
var
  ViewName, Schema, SQL, NewSQL: string;
  Res: TQueryResult;
begin
  if not ResolveViewContext(ViewName, Schema) then
  begin
    ShowMessage('Select a view first');
    Exit;
  end;
  SQL := FDB.GetObjectSQL(ViewName, 'view', Schema);
  if SQL = '' then
  begin
    ShowMessage('Cannot read view definition');
    Exit;
  end;
  if MessageDlg('Modifying a view will drop and recreate it.' + sLineBreak +
    'Continue?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;
  if ExecuteSQLDialog('Modify View', 'Edit view definition:', SQL, NewSQL) then
  begin
    if NewSQL = '' then
      Exit;
    if not FDB.DropView(ViewName, Schema) then
    begin
      ShowMessage('Error dropping view: ' + FDB.LastError);
      Exit;
    end;
    Res := FDB.ExecuteSQL(NewSQL);
    if Res.Success then
    begin
      RefreshStructure;
      SelectViewInTree(ViewName, Schema);
      LoadTableData;
      UpdateViewMenuState;
      UpdateStatusBar('View modified');
    end
    else
      ShowMessage('Error modifying view: ' + Res.ErrorMessage + sLineBreak +
        'The view may have been dropped.');
  end;
end;

procedure TfrmMain.mnuExportViewClick(Sender: TObject);
begin
  PerformExportView;
end;

procedure TfrmMain.mnuCreateTriggerClick(Sender: TObject);
var
  SQL: string;
  Res: TQueryResult;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  if ExecuteSQLDialog('Create Trigger', 'Enter CREATE TRIGGER statement:',
    'CREATE TRIGGER trigger_name' + sLineBreak +
    'AFTER INSERT ON table_name' + sLineBreak +
    'BEGIN' + sLineBreak +
    '  -- statements' + sLineBreak +
    'END;', SQL) then
  begin
    if SQL = '' then
      Exit;
    Res := FDB.ExecuteSQL(SQL);
    if Res.Success then
    begin
      RefreshStructure;
      UpdateTriggerMenuState;
      UpdateStatusBar('Trigger created');
    end
    else
      ShowMessage('Error creating trigger: ' + Res.ErrorMessage);
  end;
end;

procedure TfrmMain.btnCreateTriggerClick(Sender: TObject);
begin
  mnuCreateTriggerClick(Sender);
end;

procedure TfrmMain.mnuDropTriggerClick(Sender: TObject);
var
  TriggerName, Schema, Msg: string;
  Confirm: Integer;
begin
  if not ResolveTriggerContext(TriggerName, Schema) then
  begin
    ShowMessage('Select a trigger first');
    Exit;
  end;
  if GetConfirmDrop then
  begin
    if (Schema <> '') and not SameText(Schema, 'main') then
      Msg := 'Drop trigger "' + Schema + '.' + TriggerName + '"?'
    else
      Msg := 'Drop trigger "' + TriggerName + '"?';
    Msg := Msg + sLineBreak + 'This cannot be undone.';
    Confirm := MessageDlg(Msg, mtWarning, [mbYes, mbNo], 0);
    if Confirm <> mrYes then
      Exit;
  end;
  if FDB.DropTrigger(TriggerName, Schema) then
  begin
    FCurrentTrigger := '';
    RefreshStructure;
    UpdateTriggerMenuState;
    UpdateStatusBar('Trigger dropped');
  end
  else
    ShowMessage('Error dropping trigger: ' + FDB.LastError);
end;

procedure TfrmMain.mnuRenameTriggerClick(Sender: TObject);
var
  TriggerName, Schema, NewName: string;
begin
  if not ResolveTriggerContext(TriggerName, Schema) then
  begin
    ShowMessage('Select a trigger first');
    Exit;
  end;
  NewName := TriggerName;
  if not InputQuery('Rename Trigger', 'New trigger name:', NewName) then
    Exit;
  NewName := Trim(NewName);
  if NewName = '' then
  begin
    ShowMessage('Trigger name cannot be empty');
    Exit;
  end;
  if SameText(NewName, TriggerName) then
    Exit;
  if FDB.RenameTrigger(TriggerName, NewName, Schema) then
  begin
    RefreshStructure;
    SelectTriggerInTree(NewName, Schema);
    UpdateTriggerMenuState;
    UpdateStatusBar('Trigger renamed');
  end
  else
    ShowMessage('Error renaming trigger: ' + FDB.LastError);
end;

procedure TfrmMain.mnuSQLiteHomeClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, 'https://sqlite.org/', nil, nil, SW_SHOW);
end;

procedure TfrmMain.mnuSQLiteSyntaxClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, 'https://sqlite.org/lang.html', nil, nil, SW_SHOW);
end;

procedure TfrmMain.mnuOptionsClick(Sender: TObject);
begin
  frmOptions.ShowModal;
end;

procedure TfrmMain.mnuAISettingsMainClick(Sender: TObject);
begin
  // Called from main menu - delegate to context menu handler
  mnuAISettingsClick(nil);
end;

procedure TfrmMain.memSQLKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #10) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    Key := #0;
    btnRunQueryClick(Sender);
  end;
end;

procedure TfrmMain.SynSQLCompletionExecute(Kind: SynCompletionType; Sender: TObject;
  var CurrentInput: UnicodeString; var x, y: Integer; var CanExecute: Boolean);
var
  Proposal: TSynCompletionProposal;
  TableOrAlias, SchemaHint, Filter, SchemaPrefix: string;
  TableRef: TSQLTableRef;
  Items: TArray<string>;
  I: Integer;
begin
  Proposal := Sender as TSynCompletionProposal;
  Proposal.ItemList.Clear;
  Proposal.InsertList.Clear;

  if not FDB.IsOpen then
  begin
    CanExecute := False;
    Exit;
  end;

  if SQLIsActiveColumnCompletionContext(memSQL.LineText, memSQL.CaretX) then
  begin
    if not SQLGetTableRefBeforeCaret(memSQL.LineText, memSQL.CaretX, TableOrAlias, SchemaHint) then
    begin
      CanExecute := False;
      Exit;
    end;

    TableRef := SQLResolveTableRef(memSQL.Text, TableOrAlias, SchemaHint, FDB);
    if not TableRef.Found then
    begin
      CanExecute := False;
      Exit;
    end;

    Items := SQLGetColumnNames(FDB, TableRef);
    if Length(Items) = 0 then
    begin
      CanExecute := False;
      Exit;
    end;

    for I := 0 to High(Items) do
    begin
      Proposal.ItemList.Add(Items[I]);
      Proposal.InsertList.Add(Items[I]);
    end;

    Proposal.CompletionStart := SQLFindLastDotBeforeCaret(memSQL.LineText, memSQL.CaretX) + 1;
    CurrentInput := SQLGetColumnFilterAfterDot(memSQL.LineText, memSQL.CaretX);
    CanExecute := True;
    ScheduleSQLCompletionFixSize;
    Exit;
  end;

  if SQLGetTableListContext(memSQL.LineText, memSQL.CaretX, Filter, SchemaPrefix) then
  begin
    Items := SQLGetDatabaseObjectNames(FDB, SchemaPrefix);
    if Length(Items) = 0 then
    begin
      CanExecute := False;
      Exit;
    end;

    for I := 0 to High(Items) do
    begin
      Proposal.ItemList.Add(Items[I]);
      Proposal.InsertList.Add(Items[I]);
    end;

    Proposal.CompletionStart := SQLGetTableListFilterStart(memSQL.LineText, memSQL.CaretX);
    CurrentInput := Filter;
    CanExecute := True;
    ScheduleSQLCompletionFixSize;
    Exit;
  end;

  CanExecute := False;
end;

function TfrmMain.GetSQLCompletionLineHeight: Integer;
begin
  SynSQLCompletion.Form.Canvas.Font := SynSQLCompletion.Font;
  Result := SynSQLCompletion.Form.Canvas.TextHeight('Ag') + SQLCompletionRowGap;
  if Result < 16 then
    Result := 16;
end;

procedure TfrmMain.ApplySQLCompletionFormSize;
var
  LineH, TotalH: Integer;
begin
  if not SynSQLCompletion.Form.Visible then
    Exit;

  LineH := GetSQLCompletionLineHeight;
  SynSQLCompletion.ItemHeight := LineH;
  TotalH := LineH * SQLCompletionVisibleLines;
  SynSQLCompletion.NbLinesInWindow := SQLCompletionVisibleLines;

  with SynSQLCompletion.Form do
  begin
    ClientHeight := TotalH;
    Height := TotalH;
    Invalidate;
  end;
end;

procedure TfrmMain.ScheduleSQLCompletionFixSize;
begin
  Timer1.Enabled := False;
  ApplySQLCompletionFormSize;
  Timer1.Enabled := True;
end;

procedure TfrmMain.SQLCompletionFixTimer(Sender: TObject);
begin
  Timer1.Enabled := False;
  ApplySQLCompletionFormSize;
end;

procedure TfrmMain.SynSQLCompletionShow(Sender: TObject);
begin
  ScheduleSQLCompletionFixSize;
end;

procedure TfrmMain.SynSQLCompletionClose(Sender: TObject);
begin
  SynSQLCompletion.NbLinesInWindow := SQLCompletionVisibleLines;
  SynSQLCompletion.ItemList.Clear;
  SynSQLCompletion.InsertList.Clear;
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure TfrmMain.tvStructureClick(Sender: TObject);
var
  Node: TTreeNode;
  NodeType: Integer;
begin
  Node := tvStructure.Selected;
  if Node = nil then
    Exit;
  // Check if it's a table or view node
  if Node.Data <> nil then
  begin
    NodeType := Integer(Node.Data);
    if NodeType = 1 then // Table
    begin
      tsBrowse.TabVisible := True;
      tsTable.TabVisible  := True;
      FCurrentSchema := GetNodeSchema(Node);
      FCurrentTable := Node.Text;
      FCurrentTableName := Node.Text;
      FCurrentView := '';
      FCurrentTrigger := '';
      FCurrentIndex := '';
      FCurrentIndexTable := '';
      // Reset search context when switching tables
      FIsSearching := False;
      FSearchWhereClause := '';
      FBrowseSortCol := -1;
      FBrowseSortAsc := True;
      lblTable.Caption := 'TABLE';
      edtBrowseTitle.Text := BrowseObjectCaption;
      // Reset offset when switching tables
      edtOffset.Text := '0';
      ResetBrowseHorzScroll;
      SaveLastSelectedTable(FCurrentTable);
      LoadTableData;
      // Load table details on tsTable tab
      LoadTableDetails;
      // Show tsBrowse and tsExecute tabs
      pcMain.ActivePageIndex := 0;
      sgBrowse.SetFocus;
      ResetBrowseHorzScroll;
      tsIndex.TabVisible := False;
      UpdateTableMenuState;
      UpdateViewMenuState;
      UpdateTriggerMenuState;
    end
    else if NodeType = 2 then // View
    begin
      tsBrowse.TabVisible := True;
      tsTable.TabVisible  := True;
      FCurrentSchema := GetNodeSchema(Node);
      FCurrentView := Node.Text;
      FCurrentTable := '';
      FCurrentTrigger := '';
      FCurrentIndex := '';
      FCurrentIndexTable := '';
      // Reset search context when switching views
      FIsSearching := False;
      FSearchWhereClause := '';
      FBrowseSortCol := -1;
      FBrowseSortAsc := True;
      lblTable.Caption := 'VIEW';
      edtBrowseTitle.Text := BrowseObjectCaption;
      // Reset offset when switching views
      edtOffset.Text := '0';
      ResetBrowseHorzScroll;
      SaveLastSelectedTable(FCurrentView);
      LoadTableData;
      // Show tsBrowse and tsExecute tabs
      pcMain.ActivePageIndex := 0;
      sgBrowse.SetFocus;
      ResetBrowseHorzScroll;
      tsIndex.TabVisible := False;
      UpdateTableMenuState;
      UpdateViewMenuState;
      UpdateTriggerMenuState;
    end
    else if NodeType = 3 then // Index
    begin
      tsIndex.TabVisible := True;
      tsTable.TabVisible := False;
      FCurrentIndex := Node.Text;
      FCurrentTable := '';
      FCurrentView := '';
      FCurrentTrigger := '';
      // Load index data
      LoadIndexData;
      // Show tsIndex and tsExecute tabs
      pcMain.ActivePageIndex := 1;
      tsBrowse.TabVisible := False;
      UpdateTableMenuState;
      UpdateViewMenuState;
      UpdateTriggerMenuState;
    end
    else if NodeType = 4 then // Trigger
    begin
      tsBrowse.TabVisible := False;
      tsTable.TabVisible := False;
      tsIndex.TabVisible := False;
      FCurrentSchema := GetNodeSchema(Node);
      FCurrentTrigger := Node.Text;
      FCurrentTable := '';
      FCurrentView := '';
      FCurrentIndex := '';
      memSQL.Lines.Text := FDB.GetObjectSQL(FCurrentTrigger, 'trigger', FCurrentSchema);
      pcMain.ActivePage := tsExecute;
      UpdateTableMenuState;
      UpdateViewMenuState;
      UpdateTriggerMenuState;
    end;
  end;
end;

procedure TfrmMain.tvStructureDblClick(Sender: TObject);
begin
  tvStructureClick(Sender);
end;
procedure TfrmMain.tvStructureKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    tvStructureClick(Sender);
end;
procedure TfrmMain.btnApplyFilterClick(Sender: TObject);
begin
  LoadTableData;
end;
procedure TfrmMain.sgBrowseSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ARow >= sgBrowse.FixedRows then
    CanSelect := False
  else
    CanSelect := True;
  UpdateBrowseSelectionButtons;
end;

procedure TfrmMain.sgExecuteSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ARow >= sgExecute.FixedRows then
    CanSelect := False
  else
    CanSelect := True;
end;
procedure TfrmMain.SplitSQLStatements(const ASQL: string; out AStatements: TArray<string>);
var
  Current: string;
  I, Len: Integer;
  InString: Boolean;
  QuoteChar: Char;
  C: Char;
begin
  SetLength(AStatements, 0);
  Current := '';
  InString := False;
  QuoteChar := #0;
  Len := Length(ASQL);
  I := 1;
  while I <= Len do
  begin
    C := ASQL[I];
    if InString then
    begin
      Current := Current + C;
      if C = QuoteChar then
      begin
        if (I < Len) and (ASQL[I + 1] = QuoteChar) then
        begin
          Inc(I);
          Current := Current + ASQL[I];
        end
        else
          InString := False;
      end;
    end
    else
    begin
      if (C = '''') or (C = '"') then
      begin
        InString := True;
        QuoteChar := C;
        Current := Current + C;
      end
      else if C = ';' then
      begin
        if Trim(Current) <> '' then
        begin
          var Idx := Length(AStatements);
          SetLength(AStatements, Idx + 1);
          AStatements[Idx] := Trim(Current);
        end;
        Current := '';
      end
      else
        Current := Current + C;
    end;
    Inc(I);
  end;
  if Trim(Current) <> '' then
  begin
    var Idx := Length(AStatements);
    SetLength(AStatements, Idx + 1);
    AStatements[Idx] := Trim(Current);
  end;
end;
procedure TfrmMain.btnRunQueryClick(Sender: TObject);
var
  Result, LastResult: TQueryResult;
  StartTime: DWORD;
  SQL: string;
  Statements: TArray<string>;
  I, ExecutedCount: Integer;
  TotalChanges: Integer;
  HasSelectResult: Boolean;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  if Trim(memSQL.Text) = '' then
  begin
    ShowMessage('Please enter a SQL query');
    Exit;
  end;
  SQL := memSQL.Text;
  SplitSQLStatements(SQL, Statements);
  if Length(Statements) = 0 then
  begin
    ShowMessage('Please enter a SQL query');
    Exit;
  end;
  StartTime := GetTickCount;
  TotalChanges := 0;
  ExecutedCount := 0;
  HasSelectResult := False;
  for I := 0 to Length(Statements) - 1 do
  begin
    if Trim(Statements[I]) = '' then
      Continue;
    Result := FDB.ExecuteSQL(Statements[I]);
    if not Result.Success then
    begin
      lblStatusTime.Caption := 'Time: ' + IntToStr(GetTickCount - StartTime) + ' ms';
      DisplayQueryResult(Result, sgExecute, pnlExecuteStatus);
      Exit;
    end;
    Inc(ExecutedCount);
    Inc(TotalChanges, Result.Changes);
    if Length(Result.Columns) > 0 then
    begin
      LastResult := Result;
      HasSelectResult := True;
    end;
  end;
  lblStatusTime.Caption := 'Time: ' + IntToStr(GetTickCount - StartTime) + ' ms';
  if HasSelectResult then
  begin
    LastResult.Changes := TotalChanges;
    DisplayQueryResult(LastResult, sgExecute, pnlExecuteStatus);
  end
  else
  begin
    sgExecute.ColCount := 1;
    sgExecute.RowCount := 2;
    sgExecute.Cells[0, 0] := 'Result';
    sgExecute.Cells[0, 1] := Format('Statements: %d, Changes: %d', [ExecutedCount, TotalChanges]);
    pnlExecuteStatus.Caption := Format('Statements: %d | Changes: %d', [ExecutedCount, TotalChanges]);
  end;
  if ExecutedCount > 0 then
    AddToRecentQueries(Trim(memSQL.Text));
end;
procedure TfrmMain.btnClearSqlClick(Sender: TObject);
begin
  memSQL.Clear;
  sgExecute.RowCount := 2;
  sgExecute.ColCount := 1;
  pnlExecuteStatus.Caption := '';
end;
procedure TfrmMain.btnExplainQueryClick(Sender: TObject);
var
  Result: TQueryResult;
begin
  if not FDB.IsOpen then
    Exit;
  
  if Trim(memSQL.Text) = '' then
    Exit;
  Result := FDB.ExecuteSQL('EXPLAIN QUERY PLAN ' + memSQL.Text);
  DisplayQueryResult(Result, sgExecute, pnlExecuteStatus);
  sgExecute.ColWidths[3] := sgExecute.Width - 10 - (sgExecute.DefaultColWidth * 3);
end;
procedure TfrmMain.btnFormatQueryClick(Sender: TObject);
begin
  //var Caret := memSQL.CaretXY;
  memSQL.BeginUpdate;
  try
    memSQL.Text := TAdvancedSQLFormatter.Format(memSQL.Text);
  finally
    memSQL.EndUpdate;
    //memSQL.CaretXY := Caret;
  end;
end;

procedure TfrmMain.btnEditRecordClick(Sender: TObject);
var
  SelectedRow: Integer;
  RowId: string;
  Frm: TfrmRowEdit;
  Columns: TArray<TColumnDef>;
  QueryResult: TQueryResult;
  SQL: string;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  if (FCurrentTable = '') and (FCurrentView = '') then
  begin
    ShowMessage('Please select a table or view first');
    Exit;
  end;
  SelectedRow := sgBrowse.Row;
  if SelectedRow < 1 then
  begin
    ShowMessage('Please select a row to edit');
    Exit;
  end;
  SQL := BrowseRowIdSql(SelectedRow);
  QueryResult := FDB.ExecuteSQL(SQL);
  
  if QueryResult.Success and (QueryResult.RowCount > 0) then
    RowId := VarToStr(QueryResult.Rows[0][0])
  else
    RowId := IntToStr(SelectedRow);
  
  // Get table structure
  Columns := TableInfo;
  // Create and show edit dialog
  Frm := TfrmRowEdit.CreateEdit(Self, FDB, BrowseTableSqlRef, Columns, RowId, False);
  try
    if Frm.ShowModal = mrOk then
    begin
      // Refresh data
      LoadTableData;
      sgBrowse.Row := SelectedRow;
      //ShowMessage('Record updated successfully');
    end;
  finally
    Frm.Free;
  end;
end;
procedure TfrmMain.btnEmptyTableClick(Sender: TObject);
var
  TableName, Schema, Msg: string;
  Confirm: Integer;
begin
  if not ResolveTableContext(TableName, Schema) then
  begin
    ShowMessage('Select a table first');
    Exit;
  end;
  if (Schema <> '') and not SameText(Schema, 'main') then
    Msg := Schema + '.' + TableName
  else
    Msg := TableName;
  Confirm := MessageDlg('Empty table "' + Msg + '"?' + sLineBreak +
    'All row data will be deleted.',
    mtConfirmation, [mbYes, mbNo], 0);
  if Confirm <> mrYes then
    Exit;
  if FDB.EmptyTable(TableName, Schema) then
  begin
    LoadTableData;
    UpdateStatusBar('Table emptied');
  end
  else
    ShowMessage('Error emptying table: ' + FDB.LastError);
end;
procedure TfrmMain.btnDeleteRecordClick(Sender: TObject);
var
  I: Integer;
  Confirm: Integer;
  RowIds: TStringList;
  SQL: string;
  QueryResult: TQueryResult;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  if (FCurrentTable = '') and (FCurrentView = '') then
  begin
    ShowMessage('Please select a table or view first');
    Exit;
  end;
  if FBrowseSelectedRows.Count = 0 then
  begin
    ShowMessage('Please select at least one row to delete');
    Exit;
  end;
  RowIds := TStringList.Create;
  try
    for I := 0 to FBrowseSelectedRows.Count - 1 do
    begin
      SQL := BrowseRowIdSql(FBrowseSelectedRows[I]);
      QueryResult := FDB.ExecuteSQL(SQL);
      if QueryResult.Success and (QueryResult.RowCount > 0) then
        RowIds.Add(VarToStr(QueryResult.Rows[0][0]));
    end;
    if RowIds.Count = 0 then
    begin
      ShowMessage('No rows selected');
      Exit;
    end;
    // Confirm deletion
    if RowIds.Count = 1 then
      Confirm := MessageDlg('Are you sure you want to delete the selected record?', mtConfirmation, [mbYes, mbNo], 0)
    else
      Confirm := MessageDlg('Are you sure you want to delete ' + IntToStr(RowIds.Count) + ' selected records?', mtConfirmation, [mbYes, mbNo], 0);
    if Confirm = mrYes then
    begin
      // Delete selected rows
      FDB.BeginTransaction;
      try
        for I := 0 to RowIds.Count - 1 do
        begin
          SQL := Format('DELETE FROM %s WHERE rowid = %s', [BrowseTableSqlRef, RowIds[I]]);
          FDB.ExecuteSQL(SQL);
        end;
        FDB.CommitTransaction;
        
        // Refresh data
        LoadTableData;
        //ShowMessage(IntToStr(RowIds.Count) + ' record(s) deleted successfully');
      except
        FDB.RollbackTransaction;
        raise;
      end;
    end;
  finally
    RowIds.Free;
  end;
end;
procedure TfrmMain.btnAddRecordClick(Sender: TObject);
var
  Frm: TfrmRowEdit;
  Columns: TArray<TColumnDef>;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  if (FCurrentTable = '') and (FCurrentView = '') then
  begin
    ShowMessage('Please select a table or view first');
    Exit;
  end;
  // Get table structure
  Columns := TableInfo;
  // Create and show add dialog
  Frm := TfrmRowEdit.CreateEdit(Self, FDB, BrowseTableSqlRef, Columns, '', True);
  try
    if Frm.ShowModal = mrOk then
    begin
      // Refresh data
      LoadTableData;
      //ShowMessage('Record added successfully');
    end;
  finally
    Frm.Free;
  end;
end;

procedure TfrmMain.btnDuplicateRecordClick(Sender: TObject);
var
  SelectedRow: Integer;
  RowId: string;
  Frm: TfrmRowEdit;
  Columns: TArray<TColumnDef>;
  QueryResult: TQueryResult;
  SQL: string;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  if (FCurrentTable = '') and (FCurrentView = '') then
  begin
    ShowMessage('Please select a table or view first');
    Exit;
  end;
  SelectedRow := sgBrowse.Row;
  if SelectedRow < 1 then
  begin
    ShowMessage('Please select a row to duplicate');
    Exit;
  end;
  SQL := BrowseRowIdSql(SelectedRow);
  QueryResult := FDB.ExecuteSQL(SQL);
  if QueryResult.Success and (QueryResult.RowCount > 0) then
    RowId := VarToStr(QueryResult.Rows[0][0])
  else
    RowId := IntToStr(SelectedRow);
  Columns := TableInfo;
  Frm := TfrmRowEdit.CreateEdit(Self, FDB, BrowseTableSqlRef, Columns, RowId, True, True);
  try
    if Frm.ShowModal = mrOk then
      LoadTableData;
  finally
    Frm.Free;
  end;
end;
procedure TfrmMain.btnNavFirstClick(Sender: TObject);
begin
  NavigateToPage(0);
end;
procedure TfrmMain.btnNavPrevClick(Sender: TObject);
var
  Limit, Offset: Integer;
begin
  Limit := StrToIntDef(edtLimit.Text, 100);
  Offset := StrToIntDef(edtOffset.Text, 0);
  NavigateToPage(Offset - Limit);
end;
procedure TfrmMain.btnNavNextClick(Sender: TObject);
var
  Limit, Offset: Integer;
begin
  Limit := StrToIntDef(edtLimit.Text, 100);
  Offset := StrToIntDef(edtOffset.Text, 0);
  NavigateToPage(Offset + Limit);
end;
procedure TfrmMain.btnNavLastClick(Sender: TObject);
var
  Limit, Remainder: Integer;
begin
  Limit := StrToIntDef(edtLimit.Text, 100);
  if Limit > 0 then
  begin
    Remainder := FTotalRows mod Limit;
    if Remainder = 0 then
      NavigateToPage(FTotalRows - Limit)
    else
      NavigateToPage(FTotalRows - Remainder);
  end;
end;
procedure TfrmMain.btnSearchClick(Sender: TObject);
var
  Frm: TfrmSearch;
  WhereClause: string;
  CountSQL: string;
  CountResult: TQueryResult;
  Columns: TArray<TColumnDef>;
begin
  if not FDB.IsOpen then
  begin
    ShowMessage('No database connected');
    Exit;
  end;
  if (FCurrentTable = '') and (FCurrentView = '') then
  begin
    ShowMessage('Please select a table or view first');
    Exit;
  end;
  if FCurrentTable = '' then
  begin
    ShowMessage('Search is only available for tables');
    Exit;
  end;
  // Get table structure
  Columns := TableInfo;
  if Length(Columns) = 0 then
  begin
    ShowMessage('No columns found in table');
    Exit;
  end;
  // Create and show search dialog
  Frm := TfrmSearch.CreateSearch(Self, FDB, FCurrentTable, Columns);
  try
    if Frm.ShowModal = mrOk then
    begin
      WhereClause := Frm.GetWhereClause;
      CountSQL := Format('SELECT COUNT(*) FROM %s WHERE %s', [BrowseTableSqlRef, WhereClause]);
      CountResult := FDB.ExecuteSQL(CountSQL);
      if CountResult.Success and (CountResult.RowCount > 0) then
      begin
        FIsSearching := True;
        FSearchWhereClause := WhereClause;
        FSearchTotalRows := StrToIntDef(VarToStr(CountResult.Rows[0][0]), 0);
        FTotalRows := FSearchTotalRows;
        FBrowseSortCol := -1;
        FBrowseSortAsc := True;
        edtOffset.Text := '0';
        LoadTableData;
        UpdateNavigationControls;
      end
      else
        ShowMessage('Search error: ' + CountResult.ErrorMessage);
    end;
  finally
    Frm.Free;
  end;
end;
procedure TfrmMain.NavigateToPage(AOffset: Integer);
begin
  if AOffset < 0 then
    AOffset := 0;
  if AOffset >= FTotalRows then
    AOffset := FTotalRows - 1;
  edtOffset.Text := IntToStr(AOffset);
  LoadTableData;
end;
procedure TfrmMain.LoadTableDetails;
var
  TableInfo: TArray<TColumnDef>;
  I: Integer;
  CreateQuery: TQueryResult;
begin
  if not FDB.IsOpen then
    Exit;
  if FCurrentTableName = '' then
    Exit;
  // Get table name
  edtTableName.Text := FCurrentTableName;
  // Get CREATE TABLE statement
  CreateQuery := FDB.ExecuteSQL(
    Format('SELECT sql FROM sqlite_master WHERE type=''table'' AND name=''%s''', [FCurrentTableName]));
  if CreateQuery.RowCount > 0 then
    memTableSQL.Text := VarToStr(CreateQuery.Rows[0][0])
  else
    memTableSQL.Text := '';
  // Get table columns
  TableInfo := FDB.GetTableInfo(FCurrentTableName);
  // Setup grid
  sgTable.ColCount := 6;
  sgTable.RowCount := Length(TableInfo) + 1;
  sgTable.Cells[0, 0] := 'ID';
  sgTable.Cells[1, 0] := 'Name';
  sgTable.Cells[2, 0] := 'Type';
  sgTable.Cells[3, 0] := 'Not Null';
  sgTable.Cells[4, 0] := 'Default';
  sgTable.Cells[5, 0] := 'Primary key';
  for I := 0 to High(TableInfo) do
  begin
    sgTable.Cells[0, I + 1] := IntToStr(I);
    sgTable.Cells[1, I + 1] := TableInfo[I].Name;
    sgTable.Cells[2, I + 1] := TableInfo[I].TypeName;
    sgTable.Cells[3, I + 1] := IfThen(TableInfo[I].NotNull, 'Yes', 'No');
    sgTable.Cells[4, I + 1] := TableInfo[I].DefaultVal;
    sgTable.Cells[5, I + 1] := IfThen(TableInfo[I].PK, 'Yes', 'No');
  end;
  // Adjust column widths
  sgTable.ColWidths[0] := 50;
  sgTable.ColWidths[1] := 150;
  sgTable.ColWidths[2] := 100;
  sgTable.ColWidths[3] := 70;
  sgTable.ColWidths[4] := 150;
  sgTable.ColWidths[5] := 100;
end;
procedure TfrmMain.AddColumnToTable;
var
  Frm: TfrmAddColumn;
  ColDef: TNewColumnDef;
  SQL: string;
  Res: TQueryResult;
begin
  if not FDB.IsOpen then
    Exit;
  if FCurrentTableName = '' then
    Exit;
  Frm := TfrmAddColumn.Create(Self);
  try
    if Frm.ShowModal = mrOk then
    begin
      ColDef := Frm.GetColumnDef;
      // Build ALTER TABLE ADD COLUMN statement
      SQL := Format('ALTER TABLE "%s" ADD COLUMN "%s" %s', 
        [FCurrentTableName, ColDef.ColumnName, ColDef.ColumnType]);
      if ColDef.NotNull then
        SQL := SQL + ' NOT NULL';
      if ColDef.DefaultValue <> '' then
        SQL := SQL + ' DEFAULT ' + ColDef.DefaultValue;
      if ColDef.PrimaryKey then
      begin
        SQL := SQL + ' PRIMARY KEY';
        if ColDef.AutoInc then
          SQL := SQL + ' AUTOINCREMENT';
      end;
      Res := FDB.ExecuteSQL(SQL);
      if Res.Success then
      begin
        ShowMessage('Column "' + ColDef.ColumnName + '" added successfully');
        LoadTableDetails;
        tvStructureClick(nil);
      end
      else
      begin
        ShowMessage('Error adding column: ' + Res.ErrorMessage);
      end;
    end;
  finally
    Frm.Free;
  end;
end;
procedure TfrmMain.ModifyTable;
begin
  ShowMessage('Table modification is not yet implemented.' + sLineBreak +
              'SQLite has limited ALTER TABLE support.' + sLineBreak +
              'You can add columns using the "Add Column" button.');
end;
procedure TfrmMain.btnAddColumnClick(Sender: TObject);
begin
  AddColumnToTable;
end;
procedure TfrmMain.btnModifyTableClick(Sender: TObject);
begin
  ModifyTable;
end;
procedure TfrmMain.LoadIndexData;
var
  IndexInfoQuery, Result: TQueryResult;
  I: Integer;
  IndexName, TableName, SQL, Columns: string;
  IsUnique: Boolean;
begin
  if not FDB.IsOpen then
    Exit;
  if FCurrentIndex = '' then
    Exit;
  // Get index information from sqlite_master
  IndexInfoQuery := FDB.ExecuteSQL(
    Format('SELECT type, name, tbl_name, sql FROM sqlite_master WHERE type=''index'' AND name=''%s''', [FCurrentIndex]));
  if IndexInfoQuery.RowCount = 0 then
  begin
    ShowMessage('Index not found: ' + FCurrentIndex);
    Exit;
  end;
  IndexName := VarToStr(IndexInfoQuery.Rows[0][1]);
  TableName := VarToStr(IndexInfoQuery.Rows[0][2]);
  SQL := VarToStr(IndexInfoQuery.Rows[0][3]);
  
  // Check if index is unique by parsing the SQL
  IsUnique := Pos('UNIQUE', UpperCase(SQL)) > 0;
  // Get indexed columns using PRAGMA index_info
  Result := FDB.ExecuteSQL(Format('PRAGMA index_info(''%s'')', [FCurrentIndex]));
  Columns := '';
  for I := 0 to Result.RowCount - 1 do
  begin
    if Columns <> '' then
      Columns := Columns + ', ';
    Columns := Columns + VarToStr(Result.Rows[I][2]); // Column name is at index 2
  end;
  // Display index information
  edtIndexName.Text := IndexName;
  lblIndexTableValue.Caption := TableName;
  if IsUnique then
    lblIndexUniqueValue.Caption := 'Yes'
  else
    lblIndexUniqueValue.Caption := 'No';
  lblIndexColumnsValue.Caption := Columns;
  memIndexSQL.Text := SQL;
  // Display index details in grid
  sgIndex.ColCount := 4;
  sgIndex.RowCount := Result.RowCount + 1;
  sgIndex.Cells[0, 0] := 'Seq';
  sgIndex.Cells[1, 0] := 'Column ID';
  sgIndex.Cells[2, 0] := 'Column Name';
  sgIndex.Cells[3, 0] := 'Sort Order';
  
  for I := 0 to Result.RowCount - 1 do
  begin
    sgIndex.Cells[0, I + 1] := VarToStr(Result.Rows[I][0]); // seqno
    sgIndex.Cells[1, I + 1] := VarToStr(Result.Rows[I][1]); // cid
    sgIndex.Cells[2, I + 1] := VarToStr(Result.Rows[I][2]); // name
    // Column 3 (desc) may not exist in older SQLite versions
    if Length(Result.Rows[I]) > 3 then
    begin
      if VarIsNull(Result.Rows[I][3]) or (VarToStr(Result.Rows[I][3]) = '0') then
        sgIndex.Cells[3, I + 1] := 'ASC'
      else
        sgIndex.Cells[3, I + 1] := 'DESC';
    end
    else
      sgIndex.Cells[3, I + 1] := 'ASC'; // Default to ASC if column not present
  end;
  // Adjust column widths
  sgIndex.ColWidths[0] := 50;
  sgIndex.ColWidths[1] := 70;
  sgIndex.ColWidths[2] := 200;
  sgIndex.ColWidths[3] := 100;
end;
procedure TfrmMain.DeleteIndex;
var
  Confirm: Integer;
  Res: TQueryResult;
begin
  if not FDB.IsOpen then
    Exit;
  if FCurrentIndex = '' then
    Exit;
  Confirm := MessageDlg('Are you sure you want to delete index "' + FCurrentIndex + '"?', 
                        mtConfirmation, [mbYes, mbNo], 0);
  if Confirm = mrYes then
  begin
    Res := FDB.ExecuteSQL(Format('DROP INDEX "%s"', [FCurrentIndex]));
    if Res.Success then
    begin
      FCurrentIndex := '';
      FCurrentIndexTable := '';
      RefreshStructure;
      // Switch to tsExecute tab
      pcMain.ActivePageIndex := 1;
    end
    else
    begin
      ShowMessage('Error deleting index: ' + Res.ErrorMessage);
    end;
  end;
end;
procedure TfrmMain.ReindexCurrent;
var
  Res: TQueryResult;
begin
  if not FDB.IsOpen then
    Exit;
  if FCurrentIndex = '' then
    Exit;
  Res := FDB.ExecuteSQL(Format('REINDEX "%s"', [FCurrentIndex]));
  if Res.Success then
  begin
    ShowMessage('Index "' + FCurrentIndex + '" reindexed successfully');
    RefreshStructure;
  end
  else
  begin
    ShowMessage('Error reindexing: ' + Res.ErrorMessage);
  end;
end;
procedure TfrmMain.btnDeleteIndexClick(Sender: TObject);
begin
  DeleteIndex;
end;
procedure TfrmMain.btnReindexClick(Sender: TObject);
begin
  ReindexCurrent;
end;
procedure TfrmMain.UpdateNavigationControls;
var
  Limit, StartRow, EndRow: Integer;
begin
  Limit := StrToIntDef(edtLimit.Text, 100);
  if FTotalRows = 0 then
  begin
    StartRow := 0;
    EndRow := 0;
  end
  else
  begin
    StartRow := StrToIntDef(edtOffset.Text, 0) + 1;
    EndRow := StrToIntDef(edtOffset.Text, 0) + Limit;
    if EndRow > FTotalRows then
      EndRow := FTotalRows;
  end;
  lblNavStart.Caption := IntToStr(StartRow);
  lblNavEnd.Caption := IntToStr(EndRow);
  lblNavTotal.Caption := IntToStr(FTotalRows);
  // Enable/disable buttons
  btnNavFirst.Enabled := StrToIntDef(edtOffset.Text, 0) > 0;
  btnNavPrev.Enabled := StrToIntDef(edtOffset.Text, 0) > 0;
  btnNavNext.Enabled := EndRow < FTotalRows;
  btnNavLast.Enabled := EndRow < FTotalRows;
end;
// Cell background colors (from original Firefox extension)
// Colors are in BGR format for Delphi
const
  clIntegerCell = $CCFFCC;  // Light green for INTEGER (#CCFFCC)
  clFloatCell   = $66FF66;  // Green for REAL/FLOAT (#66FF66)
  clTextCell    = $FFFFCC;  // Light blue for TEXT (#CCCCFF in RGB = $FFCCCC in BGR)
  clNullCell    = $CCCCFF;  // Light red/pink for NULL (#FFCCCC in RGB = $CCCCFF in BGR)
  clOrange      = $6666FF;  // Light red/pink for NULL (#FFCCCC in RGB = $CCCCFF in BGR)
  clBlobCell    = $FFCCCC;  // Orange for BLOB (#FF9966 in RGB = $6699FF in BGR)
procedure TfrmMain.sgBrowseDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
var
  CellColor: TColor;
  ColIndex: Integer;
  CellText: string;
  Grid: TStringGrid;
  IsSelected: Boolean;
  ColTypes: TArray<TSQLiteColumnType>;
  ColType: TSQLiteColumnType;
begin
  Grid := Sender as TStringGrid;
  if (Grid = sgBrowse) and (Grid.FixedRows > 0) and (ARow < Grid.FixedRows) and (ACol >= Grid.FixedCols) then
  begin
    CellText := Grid.Cells[ACol, ARow];
    Grid.Canvas.Font.Assign(Grid.Font);
    if (FBrowseSortCol >= 0) and (FBrowseSortCol = ACol) then
    begin
      if FBrowseSortAsc then
        Grid.Canvas.Font.Color := clGreen
      else
        Grid.Canvas.Font.Color := clRed;
    end
    else
      Grid.Canvas.Font.Color := clBlack;
    Grid.Canvas.Brush.Color := Grid.FixedColor;
    Grid.Canvas.FillRect(Rect);
    if CellText <> '' then
      Grid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 4, CellText);
    Grid.Canvas.Pen.Color := clWhite;
    Grid.Canvas.MoveTo(Rect.Left, Rect.Bottom);
    Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
    Grid.Canvas.Pen.Color := clGray;
    Grid.Canvas.MoveTo(Rect.Right, Rect.Top);
    Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
    Exit;
  end;
  // sgExecute: header row (sort colors)
  if (Grid = sgExecute) and (Grid.FixedRows > 0) and (ARow < Grid.FixedRows) and (ACol >= Grid.FixedCols) then
  begin
    CellText := Grid.Cells[ACol, ARow];
    Grid.Canvas.Font.Assign(Grid.Font);
    if (FExecuteSortCol >= 0) and (FExecuteSortCol = ACol) then
    begin
      if FExecuteSortAsc then
        Grid.Canvas.Font.Color := clGreen
      else
        Grid.Canvas.Font.Color := clRed;
    end
    else
      Grid.Canvas.Font.Color := clBlack;
    Grid.Canvas.Brush.Color := Grid.FixedColor;
    Grid.Canvas.FillRect(Rect);
    if CellText <> '' then
      Grid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 4, CellText);
    Grid.Canvas.Pen.Color := clWhite;
    Grid.Canvas.MoveTo(Rect.Left, Rect.Bottom);
    Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
    Grid.Canvas.Pen.Color := clGray;
    Grid.Canvas.MoveTo(Rect.Right, Rect.Top);
    Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
    Exit;
  end;
  // Don't color fixed rows/columns
  if (ARow < Grid.FixedRows) or (ACol < Grid.FixedCols) then
    Exit;
  // Determine which column types to use based on which grid is drawing
  if Grid = sgBrowse then
    ColTypes := FColumnTypes
  else if Grid = sgExecute then
    ColTypes := FExecuteColumnTypes
  else
    Exit;
  // Check if we have column types
  if Length(ColTypes) = 0 then
    Exit;
  // Get column index (no row number column anymore)
  ColIndex := ACol;
  if (ColIndex < 0) or (ColIndex >= Length(ColTypes)) then
    Exit;
  // Get cell text to check for NULL
  CellText := Grid.Cells[ACol, ARow];
  // Check if this cell is selected
  IsSelected := IsGridRowSelected(Grid, ARow);
  // NULL cells — always red, regardless of column type
  if CellText = '<NULL>' then
  begin
    if IsSelected then
      CellColor := clOrange
    else
      CellColor := clNullCell;
    Grid.Canvas.Brush.Color := CellColor;
    Grid.Canvas.FillRect(Rect);
    Grid.Canvas.Pen.Color := clWhite;
    Grid.Canvas.MoveTo(Rect.Left, Rect.Bottom);
    Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
    Grid.Canvas.Pen.Color := clBlack;
    Grid.Canvas.MoveTo(Rect.Right, Rect.Top);
    Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
    Exit;
  end;
  ColType := EffectiveColumnType(ColTypes, ColIndex, CellText);
  // Determine color based on column/cell type
  case ColType of
    sctInteger:
      begin
        if IsSelected then
          CellColor := clGreen  // Dark green for selected integers
        else
          CellColor := clIntegerCell;
      end;
    sctReal:
      begin
        if IsSelected then
          CellColor := clGreen
        else
          CellColor := clFloatCell;
      end;
    sctText:
      begin
        if IsSelected then
          CellColor := clNavy  // Blue for selected text
        else
          CellColor := clTextCell;
      end;
    sctBlob:
      begin
        if IsSelected then
          CellColor := clGreen
        else
          CellColor := clBlobCell;
      end;
    sctNull:
      begin
        if IsSelected then
          CellColor := clOrange
        else
          CellColor := clNullCell;
      end;
  else
    CellColor := Grid.Color;
  end;
  if Copy(CellText, 1, 4) = 'BLOB' then
  begin
    if IsSelected then
      CellColor := clGreen
    else
      CellColor := clBlobCell;
  end;
  // Fill cell background
  Grid.Canvas.Brush.Color := CellColor;
  Grid.Canvas.FillRect(Rect);
  // Draw text only if not NULL
  if CellText <> '' then
  begin
    // Set text color based on selection
    if IsSelected then
      Grid.Canvas.Font.Color := clWhite
    else
      Grid.Canvas.Font.Color := clBlack;
      
    Grid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 4, CellText);
  end;
    
  // Draw grid lines - white for horizontal, black for vertical
  Grid.Canvas.Pen.Color := clWhite;
  Grid.Canvas.MoveTo(Rect.Left, Rect.Bottom);
  Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
  
  Grid.Canvas.Pen.Color := clBlack;
  Grid.Canvas.MoveTo(Rect.Right, Rect.Top);
  Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
end;
procedure TfrmMain.sgBrowseKeyPress(Sender: TObject; var Key: Char);
begin
  btnEditRecordClick(Sender);
end;
procedure TfrmMain.LoadWindowPosition;
var
  LeftPos, TopPos, WidthVal, HeightVal: Integer;
  AWindowState: Integer;
begin
  FReg.RootKey := HKEY_CURRENT_USER;
  if FReg.OpenKey('\Software\OlegChernavin\SQLiteManager', True) then
  begin
    try
      LeftPos := FReg.ReadInteger('WindowLeft');
      TopPos := FReg.ReadInteger('WindowTop');
      WidthVal := FReg.ReadInteger('WindowWidth');
      HeightVal := FReg.ReadInteger('WindowHeight');
      AWindowState := FReg.ReadInteger('WindowState');
      memSQL.Height := FReg.ReadInteger('memSQLHeight');
      if (LeftPos > 0) and (TopPos > 0) and (WidthVal > 0) and (HeightVal > 0) then
      begin
        Left := LeftPos;
        Top := TopPos;
        Width := WidthVal;
        Height := HeightVal;
      end;
      if AWindowState = 1 then
        WindowState := wsMaximized;
    except
    end;
    FReg.CloseKey;
  end;
end;
procedure TfrmMain.SaveWindowPosition;
begin
  FReg.RootKey := HKEY_CURRENT_USER;
  FReg.Access  := KEY_ALL_ACCESS;
  if FReg.OpenKey('\Software\OlegChernavin\SQLiteManager', True) then
  begin
    try
      if WindowState = wsMaximized then
        FReg.WriteInteger('WindowState', 1)
      else
      begin
        FReg.WriteInteger('WindowState', 0);
        FReg.WriteInteger('WindowLeft', Left);
        FReg.WriteInteger('WindowTop', Top);
        FReg.WriteInteger('WindowWidth', Width);
        FReg.WriteInteger('WindowHeight', Height);
      end;
      FReg.WriteInteger('memSQLHeight', memSQL.Height);
    except
    end;
    FReg.CloseKey;
  end;
end;
procedure TfrmMain.LoadLastDatabase;
var
  LastDb: string;
begin
  FReg.RootKey := HKEY_CURRENT_USER;
  FReg.Access := KEY_READ;
  if FReg.OpenKeyReadOnly('\Software\OlegChernavin\SQLiteManager') then
  begin
    try
      LastDb := FReg.ReadString('LastDatabase');
      if (LastDb <> '') and FileExists(LastDb) then
        OpenDatabase(LastDb);
    except
    end;
    FReg.CloseKey;
  end;
end;
procedure TfrmMain.SaveLastDatabase(const APath: string);
begin
  if APath = '' then
    Exit;
  FReg.RootKey := HKEY_CURRENT_USER;
  FReg.Access  := KEY_ALL_ACCESS;
  // Create all keys in the path first
  if FReg.CreateKey('\Software\OlegChernavin\SQLiteManager') then
  begin
    // Now open for writing
    if FReg.OpenKey('\Software\OlegChernavin\SQLiteManager', False) then
    begin
      try
        FReg.WriteString('LastDatabase', APath);
      except
        on E: Exception do
          ShowMessage('Error saving to registry: ' + E.Message);
      end;
      FReg.CloseKey;
    end;
  end;
end;
function NormalizeTableSchema(const ASchema: string): string;
begin
  if (ASchema = '') or SameText(ASchema, 'main') then
    Result := ''
  else
    Result := ASchema;
end;

function TableSchemaMatches(const ANodeSchema, ATargetSchema: string): Boolean;
begin
  Result := SameText(NormalizeTableSchema(ANodeSchema), NormalizeTableSchema(ATargetSchema));
end;

procedure TfrmMain.SelectTableInTree(const ATableName, ASchema: string);
var
  I: Integer;
  Node: TTreeNode;
begin
  for I := 0 to tvStructure.Items.Count - 1 do
  begin
    Node := tvStructure.Items[I];
    if (Node.Data = Pointer(1)) and SameText(Node.Text, ATableName) and
      TableSchemaMatches(GetNodeSchema(Node), ASchema) then
    begin
      tvStructure.Selected := Node;
      Node.MakeVisible;
      tvStructureClick(nil);
      Break;
    end;
  end;
end;

procedure TfrmMain.SelectViewInTree(const AViewName, ASchema: string);
var
  I: Integer;
  Node: TTreeNode;
begin
  for I := 0 to tvStructure.Items.Count - 1 do
  begin
    Node := tvStructure.Items[I];
    if (Node.Data = Pointer(2)) and SameText(Node.Text, AViewName) and
      TableSchemaMatches(GetNodeSchema(Node), ASchema) then
    begin
      tvStructure.Selected := Node;
      Node.MakeVisible;
      tvStructureClick(nil);
      Break;
    end;
  end;
end;

procedure TfrmMain.SelectTriggerInTree(const ATriggerName, ASchema: string);
var
  I: Integer;
  Node: TTreeNode;
begin
  for I := 0 to tvStructure.Items.Count - 1 do
  begin
    Node := tvStructure.Items[I];
    if (Node.Data = Pointer(4)) and SameText(Node.Text, ATriggerName) and
      TableSchemaMatches(GetNodeSchema(Node), ASchema) then
    begin
      tvStructure.Selected := Node;
      Node.MakeVisible;
      tvStructureClick(nil);
      Break;
    end;
  end;
end;

procedure TfrmMain.SaveLastSelectedTable(const ATableName: string);
begin
  FReg.RootKey := HKEY_CURRENT_USER;
  FReg.Access  := KEY_ALL_ACCESS;
  // Create all keys in the path first
  if FReg.CreateKey('\Software\OlegChernavin\SQLiteManager') then
  begin
    // Now open for writing
    if FReg.OpenKey('\Software\OlegChernavin\SQLiteManager', False) then
    begin
      try
        FReg.WriteString('LastSelectedTable', ATableName);
      except
      end;
      FReg.CloseKey;
    end;
  end;
end;
function TfrmMain.FindNextTableAfter(const AName: string): string;
var
  Structure: TDatabaseStructure;
  I: Integer;
begin
  Result := '';
  Structure := FDB.GetDatabaseStructure;
  for I := 0 to High(Structure.Tables) do
    if CompareText(Structure.Tables[I], AName) > 0 then
      Exit(Structure.Tables[I]);
  if Length(Structure.Tables) > 0 then
    Result := Structure.Tables[0];
end;

procedure TfrmMain.LoadLastSelectedTable;
var
  LastTable: string;
  FallbackTable: string;
  I: Integer;
  Node: TTreeNode;
begin
  FReg.RootKey := HKEY_CURRENT_USER;
  FReg.Access := KEY_READ;
  if FReg.OpenKeyReadOnly('\Software\OlegChernavin\SQLiteManager') then
  begin
    try
      LastTable := FReg.ReadString('LastSelectedTable');
      if (LastTable <> '') and (tvStructure.Items.Count > 0) then
      begin
        SelectTableInTree(LastTable, '');
        if FCurrentTable = '' then
        begin
          for I := 0 to tvStructure.Items.Count - 1 do
          begin
            Node := tvStructure.Items[I];
            if (Node.Data = Pointer(2)) and (Node.Text = LastTable) then
            begin
              tvStructure.Selected := Node;
              Node.MakeVisible;
              tvStructureClick(nil);
              Break;
            end;
          end;
          if (FCurrentTable = '') and (FCurrentView = '') then
          begin
            FallbackTable := FindNextTableAfter(LastTable);
            if FallbackTable <> '' then
              SelectTableInTree(FallbackTable, '');
          end;
        end;
      end;
    except
    end;
    FReg.CloseKey;
  end;
end;
procedure TfrmMain.sgBrowseMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  G: TStringGrid;
  SavedLeft: Integer;
begin
  Handled := True;
  G := Sender as TStringGrid;
  SavedLeft := FBrowseLeftCol;
  FBrowseLeftColUpdating := True;
  try
    if G.TopRow >= 3 then
      G.TopRow := G.TopRow - 3;
    ApplyBrowseHorzScroll(SavedLeft, False);
  finally
    FBrowseLeftColUpdating := False;
  end;
end;
procedure TfrmMain.sgBrowseMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  G: TStringGrid;
  SavedLeft: Integer;
begin
  Handled := True;
  G := Sender as TStringGrid;
  SavedLeft := FBrowseLeftCol;
  FBrowseLeftColUpdating := True;
  try
    G.TopRow := G.TopRow + 3;
    ApplyBrowseHorzScroll(SavedLeft, False);
  finally
    FBrowseLeftColUpdating := False;
  end;
end;
procedure TfrmMain.SaveRecentQueries;
var
  I: Integer;
  QueriesStr: string;
begin
  if FCurrentDatabaseName = '' then
    Exit;
  FReg.RootKey := HKEY_CURRENT_USER;
  FReg.Access  := KEY_ALL_ACCESS;
  // Create all keys in the path
  if FReg.CreateKey('\Software\OlegChernavin\SQLiteManager\Queries\' + FCurrentDatabaseName) then
  begin
    // Now open the key for writing
    if FReg.OpenKey('\Software\OlegChernavin\SQLiteManager\Queries\' + FCurrentDatabaseName, False) then
    begin
      try
        // Save queries as tab-separated list
        QueriesStr := '';
        for I := 0 to FRecentQueries.Count - 1 do
        begin
          if QueriesStr <> '' then
            QueriesStr := QueriesStr + #9;
          QueriesStr := QueriesStr + FRecentQueries[I];
        end;
        FReg.WriteString('Queries', QueriesStr);
      except
      end;
      FReg.CloseKey;
    end;
  end;
end;
procedure TfrmMain.LoadRecentQueries;
var
  QueriesStr: string;
  Queries: TArray<string>;
  I: Integer;
begin
  if FCurrentDatabaseName = '' then
    Exit;
  FReg.RootKey := HKEY_CURRENT_USER;
  FReg.Access := KEY_READ;
  if FReg.OpenKeyReadOnly('\Software\OlegChernavin\SQLiteManager\Queries\' + FCurrentDatabaseName) then
  begin
    try
      QueriesStr := FReg.ReadString('Queries');
      if QueriesStr <> '' then
      begin
        Queries := QueriesStr.Split([#9]);
        FRecentQueries.Clear;
        for I := 0 to High(Queries) do
        begin
          if Queries[I] <> '' then
            FRecentQueries.Add(Queries[I]);
        end;
      end;
    except
    end;
    FReg.CloseKey;
  end;
  // Update ComboBox
  UpdateRecentQueriesCombo;
end;
procedure TfrmMain.AddToRecentQueries(const ASQL: string);
var
  I: Integer;
begin
  if Trim(ASQL) = '' then
    Exit;
    
  // Remove if already exists
  for I := 0 to FRecentQueries.Count - 1 do
  begin
    if SameText(FRecentQueries[I], ASQL) then
    begin
      FRecentQueries.Delete(I);
      Break;
    end;
  end;
  
  // Add to top
  FRecentQueries.Insert(0, ASQL);
  
  // Keep only last 10
  while FRecentQueries.Count > 10 do
    FRecentQueries.Delete(FRecentQueries.Count - 1);
  
  // Save to registry immediately
  SaveRecentQueries;
  
  // Update ComboBox
  UpdateRecentQueriesCombo;
end;
procedure TfrmMain.UpdateRecentQueriesCombo;
var
  I: Integer;
begin
  // Check if cbHistory exists on form
  if FindComponent('cbHistory') = nil then
    Exit;
    
  // Clear and add header
  cbHistory.Items.Clear;
  cbHistory.Items.Add('** Saved Queries **');
  
  // Add saved queries
  for I := 0 to FRecentQueries.Count - 1 do
  begin
    cbHistory.Items.Add(StringReplace(FRecentQueries[I], #13#10, ' ', [rfReplaceAll]));
  end;
  
  // Set first item as selected
  cbHistory.ItemIndex := 0;
end;
procedure TfrmMain.cbHistoryChange(Sender: TObject);
begin
  // Ignore header item
  if cbHistory.ItemIndex < 1 then
    Exit;
  // Insert selected query into memo
  if cbHistory.ItemIndex <= FRecentQueries.Count then
    memSQL.Text := FRecentQueries[cbHistory.ItemIndex - 1];
end;
procedure TfrmMain.miCopyRowsCSVClick(Sender: TObject);
var
  SL: TStringList;
  SelectedRows: TList<Integer>;
  I, J, RowIdx: Integer;
  CellValue: string;
  S: String;
begin
  if CurrentGrid = nil then
  begin
    ShowMessage('Please select at least one row');
    Exit;
  end;
  SelectedRows := GetGridSelectedRows(CurrentGrid);
  if (SelectedRows = nil) or (SelectedRows.Count = 0) then
  begin
    ShowMessage('Please select at least one row');
    Exit;
  end;
  SL := TStringList.Create;
  try
    for I := 0 to SelectedRows.Count - 1 do
    begin
      RowIdx := SelectedRows[I];
      S := '';
      for J := 0 to CurrentGrid.ColCount - 1 do
      begin
        CellValue := CurrentGrid.Cells[J, RowIdx];
        // Escape quotes and wrap in quotes if contains comma
        if (Pos(',', CellValue) > 0) or (Pos('"', CellValue) > 0) then
          CellValue := '"' + StringReplace(CellValue, '"', '""', [rfReplaceAll]) + '"';
        if J > 0 then
          S := S + ',' + CellValue
        else
          S := CellValue;
      end;
      SL.Add(S);
    end;
    Clipboard.AsText := SL.Text;
    //ShowMessage('Copied ' + IntToStr(SelBottom - SelTop + 1) + ' row(s) to clipboard as CSV');
  finally
    SL.Free;
  end;
end;
procedure TfrmMain.miCopyRowsCSVExcelClick(Sender: TObject);
var
  SL: TStringList;
  SelectedRows: TList<Integer>;
  I, J, RowIdx: Integer;
  CellValue: string;
  S: String;
begin
  if CurrentGrid = nil then
  begin
    ShowMessage('Please select at least one row');
    Exit;
  end;
  SelectedRows := GetGridSelectedRows(CurrentGrid);
  if (SelectedRows = nil) or (SelectedRows.Count = 0) then
  begin
    ShowMessage('Please select at least one row');
    Exit;
  end;
  SL := TStringList.Create;
  try
    for I := 0 to SelectedRows.Count - 1 do
    begin
      RowIdx := SelectedRows[I];
      S := '';
      for J := 0 to CurrentGrid.ColCount - 1 do
      begin
        CellValue := CurrentGrid.Cells[J, RowIdx];
        // Escape quotes and wrap in quotes if contains tab or quote
        if (Pos(#9, CellValue) > 0) or (Pos('"', CellValue) > 0) then
          CellValue := '"' + StringReplace(CellValue, '"', '""', [rfReplaceAll]) + '"';
        
        if J > 0 then
          S := S + #9 + CellValue
        else
          S := CellValue;
      end;
      SL.Add(S);
    end;
    
    Clipboard.AsText := SL.Text;
    //ShowMessage('Copied ' + IntToStr(SelBottom - SelTop + 1) + ' row(s) to clipboard as CSV (Excel)');
  finally
    SL.Free;
  end;
end;
procedure TfrmMain.miCopyRowsSQLClick(Sender: TObject);
var
  SL: TStringList;
  SelectedRows: TList<Integer>;
  ColTypes: TArray<TSQLiteColumnType>;
  I, J, RowIdx: Integer;
  CellValue: string;
  TableName: string;
  S: String;
begin
  if CurrentGrid = nil then
  begin
    ShowMessage('Please select at least one row');
    Exit;
  end;
  SelectedRows := GetGridSelectedRows(CurrentGrid);
  if (SelectedRows = nil) or (SelectedRows.Count = 0) then
  begin
    ShowMessage('Please select at least one row');
    Exit;
  end;
  if CurrentGrid = sgBrowse then
    ColTypes := FColumnTypes
  else
    ColTypes := FExecuteColumnTypes;
  SL := TStringList.Create;
  try
    TableName := FCurrentTable;
    if TableName = '' then
      TableName := FCurrentView;
    for I := 0 to SelectedRows.Count - 1 do
    begin
      RowIdx := SelectedRows[I];
      S := 'INSERT INTO "' + TableName + '" VALUES (';
      for J := 0 to CurrentGrid.ColCount - 1 do
      begin
        CellValue := CurrentGrid.Cells[J, RowIdx];
        if J > 0 then
          S := S + ', ';
        if (CellValue = 'NULL') or (CellValue = '<NULL>') then
          S := S + 'NULL'
        else if (J < Length(ColTypes)) and
          ((ColTypes[J] = sctInteger) or (ColTypes[J] = sctReal)) then
          S := S + CellValue
        else
          S := S + '''' + StringReplace(CellValue, '''', '''''', [rfReplaceAll]) + '''';
      end;
      S := S + ');';
      SL.Add(S);
    end;
    
    Clipboard.AsText := SL.Text;
  finally
    SL.Free;
  end;
end;

procedure TfrmMain.miCopyCellClick(Sender: TObject);
var
  CellValue: string;
  BlobData: TBytes;
  BlobStr: string;
begin
  if CurrentGrid = nil then
  begin
    ShowMessage('No cell selected');
    Exit;
  end;
  // Use the cell where popup menu was opened
  CellValue := CurrentGrid.Cells[PopupMenuCol, PopupMenuRow];
  // Check if this is a BLOB cell
  if Copy(CellValue, 1, 6) = 'BLOB (' then
  begin
    // Get BLOB data from database
    if FDB.IsOpen and (FCurrentTable <> '') then
    begin
      BlobData := FDB.GetBlobData(BrowseTableSqlRef, PopupMenuRow - 1 + StrToIntDef(edtOffset.Text, 0), PopupMenuCol);
      if Length(BlobData) > 0 then
      begin
        // Convert BLOB to string (try UTF-8 first, then ANSI)
        try
          BlobStr := TEncoding.UTF8.GetString(BlobData);
        except
          BlobStr := TEncoding.ANSI.GetString(BlobData);
        end;

        Clipboard.AsText := BlobStr;
        //ShowMessage('BLOB data (' + IntToStr(Length(BlobData)) + ' bytes) copied to clipboard as string');
        Exit;
      end;
    end;
  end;
  // Copy regular cell value
  Clipboard.AsText := CellValue;
  //ShowMessage('Cell value copied to clipboard');
end;

procedure TfrmMain.CreateGridPopupMenu;
var
  miCopyRowsCSV, miCopyRowsCSVExcel, miCopyRowsSQL, NGrid1, miCopyCell: TMenuItem;
begin
  pmGrid := TPopupMenu.Create(Self);

  miCopyRowsCSV := TMenuItem.Create(pmGrid);
  miCopyRowsCSV.Caption := 'Copy Rows to CSV';
  miCopyRowsCSV.OnClick := miCopyRowsCSVClick;
  pmGrid.Items.Add(miCopyRowsCSV);

  miCopyRowsCSVExcel := TMenuItem.Create(pmGrid);
  miCopyRowsCSVExcel.Caption := 'Copy Rows to CSV (Excel)';
  miCopyRowsCSVExcel.OnClick := miCopyRowsCSVExcelClick;
  pmGrid.Items.Add(miCopyRowsCSVExcel);

  miCopyRowsSQL := TMenuItem.Create(pmGrid);
  miCopyRowsSQL.Caption := 'Copy Rows to SQL';
  miCopyRowsSQL.OnClick := miCopyRowsSQLClick;
  pmGrid.Items.Add(miCopyRowsSQL);

  NGrid1 := TMenuItem.Create(pmGrid);
  NGrid1.Caption := '-';
  pmGrid.Items.Add(NGrid1);

  miCopyCell := TMenuItem.Create(pmGrid);
  miCopyCell.Caption := 'Copy Cell';
  miCopyCell.OnClick := miCopyCellClick;
  pmGrid.Items.Add(miCopyCell);

  // Assign to grids
  sgBrowse.PopupMenu := pmGrid;
  sgExecute.PopupMenu := pmGrid;

  // Set current grid on popup
  pmGrid.OnPopup := pmGridPopup;
end;

procedure TfrmMain.pmGridPopup(Sender: TObject);
var
  MousePt: TPoint;
  GridPt: TPoint;
  I, XPos, YPos: Integer;
begin
  // Determine which grid was right-clicked
  GetCursorPos(MousePt);
  CurrentGrid := nil;
  // Check sgBrowse
  if pcMain.ActivePage = tsBrowse then
  begin
    GridPt := sgBrowse.ScreenToClient(MousePt);
    if (GridPt.X >= 0) and (GridPt.X < sgBrowse.ClientWidth) and
       (GridPt.Y >= 0) and (GridPt.Y < sgBrowse.ClientHeight) then
    begin
      CurrentGrid := sgBrowse;
      // Find which cell was clicked by iterating through rows
      PopupMenuRow := sgBrowse.FixedRows;
      YPos := sgBrowse.RowHeights[0];
      for I := sgBrowse.TopRow to sgBrowse.RowCount - 1 do
      begin
        if GridPt.Y < (YPos + (sgBrowse.DefaultRowHeight + 1)) then
        begin
          PopupMenuRow := I;
          //lblStatusMessage.Caption := IntToStr(I);
          Break;
        end;
        Inc(YPos, sgBrowse.DefaultRowHeight + 1);
      end;
      // Find column
      PopupMenuCol := 0;
      XPos := GridPt.X;
      for I := 0 to sgBrowse.ColCount - 1 do
      begin
        if XPos < sgBrowse.ColWidths[I] then
        begin
          PopupMenuCol := I;
          Break;
        end;
        XPos := XPos - sgBrowse.ColWidths[I];
      end;
      Exit;
    end;
  end;
  // Check sgExecute
  if pcMain.ActivePage = tsExecute then
  begin
    GridPt := sgExecute.ScreenToClient(MousePt);
    if (GridPt.X >= 0) and (GridPt.X < sgExecute.ClientWidth) and
       (GridPt.Y >= 0) and (GridPt.Y < sgExecute.ClientHeight) then
    begin
      CurrentGrid := sgExecute;
      // Find which cell was clicked by iterating through rows
      PopupMenuRow := sgExecute.FixedRows;
      YPos := sgExecute.RowHeights[0];
      for I := sgExecute.TopRow to sgExecute.RowCount - 1 do
      begin
        if GridPt.Y < (YPos + sgExecute.DefaultRowHeight + 1) then
        begin
          PopupMenuRow := I;
          Break;
        end;
        Inc(YPos, sgExecute.DefaultRowHeight + 1);
      end;
      // Find column
      PopupMenuCol := 0;
      XPos := GridPt.X;
      for I := 0 to sgExecute.ColCount - 1 do
      begin
        if XPos < sgExecute.ColWidths[I] then
        begin
          PopupMenuCol := I;
          Break;
        end;
        XPos := XPos - sgExecute.ColWidths[I];
      end;
    end;
  end;
end;

{ AI Service Methods }
procedure TfrmMain.InitializeAIService;
var
  Config: TAIServiceConfig;
begin
  if Assigned(FAIService) then
    FAIService.Free;
  Config.Enabled := False;
  FAIService := TAIService.Create(Config);
  FAIService.LoadFromRegistry(HKEY_CURRENT_USER, 'Software\SQLiteManager\AI');
  FAIConfigured := FAIService.IsConfigured;
end;
procedure TfrmMain.ShowAIMessage(const ATitle, AContent: string);
var
  Memo: TMemo;
  Form: TForm;
begin
  Form := TForm.Create(Self);
  try
    Form.Caption := ATitle;
    Form.Width := 600;
    Form.Height := 500;
    Form.Position := poOwnerFormCenter;
    
    Memo := TMemo.Create(Form);
    Memo.Parent := Form;
    Memo.Align := alClient;
    Memo.ReadOnly := True;
    Memo.ScrollBars := ssBoth;
    Memo.WordWrap := True;
    Memo.Text := AContent;
    Memo.Font.Name := 'Consolas';
    Memo.Font.Size := 10;
    
    Form.ShowModal;
  finally
    Form.Free;
  end;
end;
procedure TfrmMain.ExecuteAIRequest(const AOperation: string; const AFunc: TFunc<TAIResponse>);
var
  Response: TAIResponse;
  SQL: string;
  Thread: TThread;
begin
  if not FAIConfigured then
  begin
    if MessageDlg('AI features are not configured. Do you want to open AI settings?', 
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      mnuAISettingsClick(nil);
    end;
    Exit;
  end;
  SQL := memSQL.SelText;
  if Trim(SQL) = '' then
    SQL := memSQL.Text;
  if Trim(SQL) = '' then
  begin
    ShowMessage('Please enter or select a SQL query first');
    Exit;
  end;
  // Show wait cursor
  Screen.Cursor := crHourglass;
  try
    lblStatusMessage.Caption := 'AI: ' + AOperation + '...';
    Application.ProcessMessages;
    // Execute in background thread using TThread
    Thread := TThread.CreateAnonymousThread(
      procedure
      begin
        try
          Response := AFunc();
          TThread.Synchronize(nil,
            procedure
            begin
              if Response.Success then
              begin
                if AOperation = 'Format' then
                  memSQL.Text := Trim(Response.Content)
                else if (AOperation = 'Explain') or (AOperation = 'Optimize') or (AOperation = 'Generate') then
                  ShowAIMessage('AI - ' + AOperation, Response.Content);
                lblStatusMessage.Caption := 'AI: ' + AOperation + ' completed';
              end
              else
              begin
                ShowMessage('AI Error: ' + Response.ErrorMessage);
                lblStatusMessage.Caption := 'AI Error';
              end;
              Screen.Cursor := crDefault;
            end);
        except
          on E: Exception do
          begin
            TThread.Synchronize(nil,
              procedure
              begin
                ShowMessage('AI Error: ' + E.Message);
                lblStatusMessage.Caption := 'AI Error';
                Screen.Cursor := crDefault;
              end);
          end;
        end;
      end);
    Thread.FreeOnTerminate := True;
    Thread.Start;
  except
    Screen.Cursor := crDefault;
    raise;
  end;
end;
procedure TfrmMain.mnuAIFmtClick(Sender: TObject);
begin
  ExecuteAIRequest('Format',
    function: TAIResponse
    begin
      Result := FAIService.FormatSQL(memSQL.Text);
    end);
end;
procedure TfrmMain.mnuAIExplainClick(Sender: TObject);
begin
  ExecuteAIRequest('Explain',
    function: TAIResponse
    begin
      Result := FAIService.ExplainQuery(memSQL.Text);
    end);
end;
procedure TfrmMain.mnuAIOptimizeClick(Sender: TObject);
begin
  ExecuteAIRequest('Optimize',
    function: TAIResponse
    begin
      Result := FAIService.OptimizeSQL(memSQL.Text);
    end);
end;
procedure TfrmMain.mnuAIGenerateClick(Sender: TObject);
var
  Description: string;
begin
  if InputQuery('Generate SQL', 'Describe what you want to query:', Description) then
  begin
    ExecuteAIRequest('Generate',
      function: TAIResponse
      begin
        Result := FAIService.GenerateQuery(Description);
      end);
  end;
end;
procedure TfrmMain.mnuAISettingsClick(Sender: TObject);
var
  Frm: TfrmAIOptions;
  Config: TAIServiceConfig;
begin
  Frm := TfrmAIOptions.Create(Self);
  try
    // Load current config
    if Assigned(FAIService) then
      Config := FAIService.Config
    else
      Config.Enabled := False;
      
    Frm.SetConfig(Config);
    
    if Frm.ShowModal = mrOk then
    begin
      // Save new config
      Config := Frm.GetConfig;
      if Assigned(FAIService) then
      begin
        FAIService.Config := Config;
        FAIService.SaveToRegistry(HKEY_CURRENT_USER, 'Software\SQLiteManager\AI');
        FAIConfigured := FAIService.IsConfigured;
      end;
      
      if Config.Enabled then
        lblStatusMessage.Caption := 'AI enabled: ' + Config.ProviderName
      else
        lblStatusMessage.Caption := 'AI disabled';
    end;
  finally
    Frm.Free;
  end;
end;
procedure TfrmMain.memSQLPopup(Sender: TObject);
begin
  // Enable/disable AI menu items based on configuration
  mnuAIFmt.Enabled := FAIConfigured;
  mnuAIExplain.Enabled := FAIConfigured;
  mnuAIOptimize.Enabled := FAIConfigured;
  mnuAIGenerate.Enabled := True; // Always enabled - will prompt to configure
end;
end.
