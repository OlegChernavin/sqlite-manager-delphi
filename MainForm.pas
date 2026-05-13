unit MainForm;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.ImgList,
  System.ImageList, Vcl.BaseImageCollection, Vcl.ImageCollection, System.UITypes,
  DBModule, Vcl.VirtualImageList, System.IniFiles, System.Generics.Collections,
  System.Generics.Defaults, SQLite3, Vcl.ToolWin, Win.Registry, Clipbrd, SynEdit,
  SynEditHighlighter, SynHighlighterSQL, SearchForm, AIService, AIOptionsForm, SQLAdvancedFormatter;
type
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
    mnuExtensionHome: TMenuItem;
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
    edtBrowseTitle: TEdit;
    cbHistory: TComboBox;
    SynSQLSyn1: TSynSQLSyn;
    Timer1: TTimer;
    btnSearchTable: TButton;
    Splitter1: TSplitter;
    DatabaseInformation1: TMenuItem;
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
    procedure mnuExitClick(Sender: TObject);
    procedure mnuRefreshClick(Sender: TObject);
    procedure mnuCreateTableClick(Sender: TObject);
    procedure mnuCreateIndexClick(Sender: TObject);
    procedure mnuDropIndexClick(Sender: TObject);
    procedure mnuReindexIndexClick(Sender: TObject);
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
    procedure sgBrowseDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure memSQLKeyPress(Sender: TObject; var Key: Char);
    procedure cbHistoryChange(Sender: TObject);
    procedure sgBrowseKeyPress(Sender: TObject; var Key: Char);
    procedure tvStructureKeyPress(Sender: TObject; var Key: Char);
    procedure DatabaseInformation1Click(Sender: TObject);
    procedure btnEmptyTableClick(Sender: TObject);
    procedure btnFormatQueryClick(Sender: TObject);
    procedure sgExecuteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
    // Table context
    FCurrentTableName: string;  // Current selected table name
    procedure SplitSQLStatements(const ASQL: string; out AStatements: TArray<string>);
    procedure LoadWindowPosition;
    procedure SaveWindowPosition;
    procedure LoadLastDatabase;
    procedure SaveLastDatabase(const APath: string);
    procedure SaveLastSelectedTable(const ATableName: string);
    procedure LoadLastSelectedTable;
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
  Vcl.FileCtrl, Winapi.ShellAPI, OptionsForm, AboutForm, CreateTreeForm, CreateIndexForm, AddColumnForm, SQLDialogForm, RowEditForm;

function QuoteSQLIdent(const Id: string): string;
begin
  Result := '"' + StringReplace(Id, '"', '""', [rfReplaceAll]) + '"';
end;

function IfThen(B: Boolean; Yes, No: String): String;
begin
  if B then
    Result := Yes
  else
    Result := No;
end;
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDB := TSQLiteHandler.Create;
  FCurrentTable := '';
  FCurrentView := '';
  FRecentDatabases := TStringList.Create;
  FRecentQueries := TStringList.Create;
  FReg := TRegistry.Create(KEY_ALL_ACCESS);
  CurrentGrid := nil;
  PopupMenuCol := 0;
  PopupMenuRow := 0;
  // Load options
  FOptions := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'SQLiteManager.ini');
  LoadOptions;
  // Load recent databases
  FRecentDatabases.CommaText := FOptions.ReadString('Recent', 'Databases', '');
  UpdateRecentMenu;
  // Load recent queries
  LoadRecentQueries;
  FExecuteSortCol := -1;
  FExecuteSortAsc := True;
  FBrowseSortCol := -1;
  FBrowseSortAsc := True;
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
  
  UpdateStatusBar('Ready');
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
  FRecentDatabases.Free;
  FRecentQueries.Free;
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
  FOptions.WriteString('Recent', 'Databases', FRecentDatabases.CommaText);
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
  end;
  
  if FDB.OpenDatabase(APath) then
  begin
    // Store database name (without path) for query history
    FCurrentDatabaseName := ExtractFileName(APath);
    
    AddToRecent(APath);
    SaveLastDatabase(APath); // Save to registry immediately
    RefreshStructure;
    UpdateDbInfo;
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
    FCurrentDatabaseName := '';
    FRecentQueries.Clear;
    tvStructure.Items.Clear;
    lblDbInfo.Caption := 'No database connected';
    sgBrowse.RowCount := 2;
    sgBrowse.ColCount := 1;
    sgBrowse.Cells[0, 0] := 'No data';
    FBrowseSortCol := -1;
    FBrowseSortAsc := True;
    UpdateStatusBar('DB closed');
  end;
end;
procedure TfrmMain.RefreshStructure;
var
  Structure: TDatabaseStructure;
  I: Integer;
  RootNode, TablesNode, ViewsNode, IndexesNode, TriggersNode: TTreeNode;
begin
  tvStructure.Items.Clear;
  if not FDB.IsOpen then
    Exit;
  Structure := FDB.GetDatabaseStructure;
  // Root node
  RootNode := tvStructure.Items.Add(nil, ExtractFileName(FDB.DatabasePath));
  RootNode.ImageIndex := 0;
  RootNode.SelectedIndex := 0;
  // Tables
  TablesNode := tvStructure.Items.AddChild(RootNode, 'Tables (' + IntToStr(Length(Structure.Tables)) + ')');
  TablesNode.ImageIndex := 1;
  TablesNode.SelectedIndex := 1;
  for I := 0 to High(Structure.Tables) do
  begin
    var Node := tvStructure.Items.AddChild(TablesNode, Structure.Tables[I]);
    Node.ImageIndex := 2;
    Node.SelectedIndex := 2;
    Node.Data := Pointer(1); // table type
  end;
  // Views
  ViewsNode := tvStructure.Items.AddChild(RootNode, 'Views (' + IntToStr(Length(Structure.Views)) + ')');
  ViewsNode.ImageIndex := 3;
  ViewsNode.SelectedIndex := 3;
  for I := 0 to High(Structure.Views) do
  begin
    var Node := tvStructure.Items.AddChild(ViewsNode, Structure.Views[I]);
    Node.ImageIndex := 4;
    Node.SelectedIndex := 4;
    Node.Data := Pointer(2); // view type
  end;
  // Indexes
  IndexesNode := tvStructure.Items.AddChild(RootNode, 'Indexes (' + IntToStr(Length(Structure.Indexes)) + ')');
  IndexesNode.ImageIndex := 5;
  IndexesNode.SelectedIndex := 5;
  for I := 0 to High(Structure.Indexes) do
  begin
    var Node := tvStructure.Items.AddChild(IndexesNode, Structure.Indexes[I]);
    Node.ImageIndex := 6;
    Node.SelectedIndex := 6;
    Node.Data := Pointer(3); // index type
  end;
  // Triggers
  TriggersNode := tvStructure.Items.AddChild(RootNode, 'Triggers (' + IntToStr(Length(Structure.Triggers)) + ')');
  TriggersNode.ImageIndex := 7;
  TriggersNode.SelectedIndex := 7;
  for I := 0 to High(Structure.Triggers) do
  begin
    var Node := tvStructure.Items.AddChild(TriggersNode, Structure.Triggers[I]);
    Node.ImageIndex := 8;
    Node.SelectedIndex := 8;
  end;
  RootNode.Expand(True);
  UpdateDbInfo;
end;
procedure TfrmMain.UpdateDbInfo;
var
  Info: TDictionary<string, Variant>;
  Structure: TDatabaseStructure;
  Text: string;
begin
  if not FDB.IsOpen then
  begin
    lblDbInfo.Caption := 'No database connected';
    Exit;
  end;
  Info := FDB.GetDatabaseInfo;
  Structure := FDB.GetDatabaseStructure;
  
  Text := 'Page Size: ' + VarToStr(Info['page_size']) + ' bytes' + sLineBreak;
  Text := Text + 'Page Count: ' + VarToStr(Info['page_count']) + sLineBreak;
  Text := Text + 'Tables: ' + IntToStr(Length(Structure.Tables)) + sLineBreak;
  Text := Text + 'Views: ' + IntToStr(Length(Structure.Views)) + sLineBreak;
  Text := Text + 'Indexes: ' + IntToStr(Length(Structure.Indexes)) + sLineBreak;
  Text := Text + 'Triggers: ' + IntToStr(Length(Structure.Triggers));
  
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
    TableInfo := FDB.GetTableInfo(FCurrentTable)
  else if FCurrentView <> '' then
    TableInfo := FDB.GetTableInfo(FCurrentView);

  if FCurrentTable <> '' then
  begin
    if FIsSearching then
      SQL := Format('SELECT * FROM "%s" WHERE %s', [FCurrentTable, FSearchWhereClause])
    else
      SQL := Format('SELECT * FROM "%s"', [FCurrentTable]);
  end
  else
    SQL := Format('SELECT * FROM "%s"', [FCurrentView]);

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
    CountSQL := Format('SELECT COUNT(*) as cnt FROM "%s"', [FCurrentTable]);
    CountResult := FDB.ExecuteSQL(CountSQL);
    if CountResult.Success and (CountResult.RowCount > 0) then
      FTotalRows := CountResult.Rows[0][0]
    else
      FTotalRows := 0;
  end
  else
  begin
    CountSQL := Format('SELECT COUNT(*) as cnt FROM "%s"', [FCurrentView]);
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
    edtBrowseTitle.Text := FCurrentTable;
  end
  else
  begin
    lblTable.Caption := 'VIEW';
    edtBrowseTitle.Text := FCurrentView;
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
  end;
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
    AGrid.Row := 1;
    AGrid.FixedRows := 1;
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
    ColType := FExecuteColumnTypes[ACol]
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

procedure TfrmMain.sgBrowseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  if Button <> mbLeft then
    Exit;
  if (FCurrentTable = '') and (FCurrentView = '') then
    Exit;
  if Length(TableInfo) = 0 then
    Exit;
  sgBrowse.MouseToCell(X, Y, ACol, ARow);
  if (ACol < 0) or (ARow < 0) then
    Exit;
  if sgBrowse.FixedRows < 1 then
    Exit;
  if ARow >= sgBrowse.FixedRows then
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
    Exit;
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
  // Clear existing
  while mnuRecent.Count > 0 do
    mnuRecent.Delete(0);
  // Add items
  for I := 0 to FRecentDatabases.Count - 1 do
  begin
    Item := TMenuItem.Create(mnuRecent);
    Item.Caption := FRecentDatabases[I];
    Item.Tag := I;
    Item.OnClick := OnRecentClick;
    mnuRecent.Add(Item);
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
      FCurrentTable := Node.Text;
      FCurrentTableName := Node.Text;
      FCurrentView := '';
      FCurrentIndex := '';
      FCurrentIndexTable := '';
      // Reset search context when switching tables
      FIsSearching := False;
      FSearchWhereClause := '';
      FBrowseSortCol := -1;
      FBrowseSortAsc := True;
      lblTable.Caption := 'TABLE';
      edtBrowseTitle.Text := FCurrentTable;
      // Reset offset when switching tables
      edtOffset.Text := '0';
      SaveLastSelectedTable(FCurrentTable);
      LoadTableData;
      // Load table details on tsTable tab
      LoadTableDetails;
      // Show tsBrowse and tsExecute tabs
      pcMain.ActivePageIndex := 0;
      sgBrowse.SetFocus;
      tsIndex.TabVisible := False;
    end
    else if NodeType = 2 then // View
    begin
      tsBrowse.TabVisible := True;
      tsTable.TabVisible  := True;
      FCurrentView := Node.Text;
      FCurrentTable := '';
      FCurrentIndex := '';
      FCurrentIndexTable := '';
      // Reset search context when switching views
      FIsSearching := False;
      FSearchWhereClause := '';
      FBrowseSortCol := -1;
      FBrowseSortAsc := True;
      lblTable.Caption := 'VIEW';
      edtBrowseTitle.Text := FCurrentView;
      // Reset offset when switching views
      edtOffset.Text := '0';
      SaveLastSelectedTable(FCurrentView);
      LoadTableData;
      // Show tsBrowse and tsExecute tabs
      pcMain.ActivePageIndex := 0;
      sgBrowse.SetFocus;
      tsIndex.TabVisible := False;
    end
    else if NodeType = 3 then // Index
    begin
      tsIndex.TabVisible := True;
      tsTable.TabVisible := False;
      FCurrentIndex := Node.Text;
      FCurrentTable := '';
      FCurrentView := '';
      // Load index data
      LoadIndexData;
      // Show tsIndex and tsExecute tabs
      pcMain.ActivePageIndex := 1;
      tsBrowse.TabVisible := False;
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
var
  SelectedCount: Integer;
begin
  // Count selected rows using Selection rectangle
  // Selection.Top and Selection.Bottom give the range of selected rows
  SelectedCount := sgBrowse.Selection.Bottom - sgBrowse.Selection.Top + 1;
  // Ensure we have valid selection (not including header row)
  if sgBrowse.Selection.Top < 1 then
    SelectedCount := 0;
  // Enable/disable Edit button based on selection
  // Edit works only with exactly one selected row
  btnEditRecord.Enabled := (SelectedCount = 1);
  // Delete works with one or more selected rows
  btnDeleteRecord.Enabled := (SelectedCount > 0);
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
  // Get actual rowid from the database
  // We need to query the database to get the real rowid
  if FIsSearching then
  begin
    // Get rowid from search results with WHERE clause
    SQL := Format('SELECT rowid FROM "%s" WHERE %s ORDER BY rowid LIMIT 1 OFFSET %d',
      [FCurrentTable, FSearchWhereClause, (SelectedRow - 1) + StrToIntDef(edtOffset.Text, 0)]);
  end
  else
  begin
    SQL := Format('SELECT rowid FROM "%s" ORDER BY rowid LIMIT 1 OFFSET %d',
      [FCurrentTable, (SelectedRow - 1) + StrToIntDef(edtOffset.Text, 0)]);
  end;
  QueryResult := FDB.ExecuteSQL(SQL);
  
  if QueryResult.Success and (QueryResult.RowCount > 0) then
    RowId := VarToStr(QueryResult.Rows[0][0])
  else
    RowId := IntToStr(SelectedRow);
  
  // Get table structure
  Columns := TableInfo;
  // Create and show edit dialog
  Frm := TfrmRowEdit.CreateEdit(Self, FDB, FCurrentTable, Columns, RowId, False);
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
  Node: TTreeNode;
  TableName: string;
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
    ShowMessage('Please select a table to empty');
    Exit;
  end;
  // Check if it's an table node (Data = Pointer(1))
  if Node.Data <> Pointer(1) then
  begin
    ShowMessage('Please select a table to empty');
    Exit;
  end;
  TableName := Node.Text;
  Confirm := MessageDlg('Are you sure you want to empty the table "' + TableName + '"? All its data will be lost!',
                        mtConfirmation, [mbYes, mbNo], 0);
  if Confirm = mrYes then
  begin
    Res := FDB.ExecuteSQL(Format('DELETE FROM "%s"', [TableName]));
    if Res.Success then
    begin
      ShowMessage('Table "' + TableName + '" is empty');
      tvStructureClick(nil);
    end
    else
    begin
      ShowMessage('Error deleting rows: ' + Res.ErrorMessage);
    end;
  end;
end;
procedure TfrmMain.btnDeleteRecordClick(Sender: TObject);
var
  I, RowOffset: Integer;
  Confirm: Integer;
  RowIds: TStringList;
  SQL: string;
  QueryResult: TQueryResult;
  SelTop, SelBottom: Integer;
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
  // Get selection range
  SelTop := sgBrowse.Selection.Top;
  SelBottom := sgBrowse.Selection.Bottom;
  
  // Check if any rows are selected
  if (SelTop < 1) or (SelBottom < SelTop) then
  begin
    ShowMessage('Please select at least one row to delete');
    Exit;
  end;
  RowOffset := StrToIntDef(edtOffset.Text, 0);
  RowIds := TStringList.Create;
  try
    // Get rowids for all selected rows
    for I := SelTop to SelBottom do
    begin
      if FIsSearching then
      begin
        // Get rowid from search results with WHERE clause
        SQL := Format('SELECT rowid FROM "%s" WHERE %s ORDER BY rowid LIMIT 1 OFFSET %d',
          [FCurrentTable, FSearchWhereClause, (I - 1) + RowOffset]);
      end
      else
      begin
        SQL := Format('SELECT rowid FROM "%s" ORDER BY rowid LIMIT 1 OFFSET %d',
          [FCurrentTable, (I - 1) + RowOffset]);
      end;
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
          SQL := Format('DELETE FROM "%s" WHERE rowid = %s', [FCurrentTable, RowIds[I]]);
          FDB.ExecuteSQL(SQL);
        end;
        FDB.CommitTransaction;
        
        // Refresh data
        LoadTableData;
        ShowMessage(IntToStr(RowIds.Count) + ' record(s) deleted successfully');
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
  Frm := TfrmRowEdit.CreateEdit(Self, FDB, FCurrentTable, Columns, '', True);
  try
    if Frm.ShowModal = mrOk then
    begin
      // Refresh data
      LoadTableData;
      ShowMessage('Record added successfully');
    end;
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
      CountSQL := Format('SELECT COUNT(*) FROM "%s" WHERE %s', [FCurrentTable, WhereClause]);
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
    Grid.Canvas.Pen.Color := clBlack;
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
    Grid.Canvas.Pen.Color := clBlack;
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
  IsSelected := (ARow >= Grid.Selection.Top) and (ARow <= Grid.Selection.Bottom) and
                (ACol >= Grid.Selection.Left) and (ACol <= Grid.Selection.Right);
  // Determine color based on column type
  case ColTypes[ColIndex] of
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
  // Check if cell is NULL (using special marker) - color it and don't draw text
  if CellText = '<NULL>' then
  begin
    if IsSelected then
      CellColor := clOrange
    else
      CellColor := clNullCell;
    CellText := '';  // Clear text for NULL - show empty cell with color
  end
  else
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
procedure TfrmMain.LoadLastSelectedTable;
var
  LastTable: string;
  Node: TTreeNode;
  I: Integer;
begin
  FReg.RootKey := HKEY_CURRENT_USER;
  FReg.Access := KEY_READ;
  if FReg.OpenKeyReadOnly('\Software\OlegChernavin\SQLiteManager') then
  begin
    try
      LastTable := FReg.ReadString('LastSelectedTable');
      if (LastTable <> '') and (tvStructure.Items.Count > 0) then
      begin
        // Search for the table/view in the tree
        for I := 0 to tvStructure.Items.Count - 1 do
        begin
          Node := tvStructure.Items[I];
          // Check if it's a table or view node (has Data <> nil)
          if Node.Data <> nil then
          begin
            if Node.Text = LastTable then
            begin
              // Select this node and trigger load
              tvStructure.Selected := Node;
              tvStructureClick(nil);
              Break;
            end;
          end;
        end;
      end;
    except
    end;
    FReg.CloseKey;
  end;
end;
procedure TfrmMain.sgBrowseMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  if (Sender as TStringGrid).TopRow >= 3 then
    (Sender as TStringGrid).TopRow := (Sender as TStringGrid).TopRow - 3;
end;
procedure TfrmMain.sgBrowseMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  (Sender as TStringGrid).TopRow := (Sender as TStringGrid).TopRow + 3;
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
  I, J, SelTop, SelBottom: Integer;
  CellValue: string;
  S: String;
begin
  if CurrentGrid = nil then
  begin
    ShowMessage('Please select at least one row');
    Exit;
  end;
  
  SL := TStringList.Create;
  try
    // Get selection range
    SelTop := CurrentGrid.Selection.Top;
    SelBottom := CurrentGrid.Selection.Bottom;
    if (SelTop < 1) or (SelBottom < SelTop) then
    begin
      ShowMessage('Please select at least one row');
      Exit;
    end;
    // Build CSV
    for I := SelTop to SelBottom do
    begin
      S := '';
      for J := 0 to CurrentGrid.ColCount - 1 do
      begin
        CellValue := CurrentGrid.Cells[J, I];
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
  I, J, SelTop, SelBottom: Integer;
  CellValue: string;
  S: String;
begin
  SL := TStringList.Create;
  try
    // Get selection range
    SelTop := CurrentGrid.Selection.Top;
    SelBottom := CurrentGrid.Selection.Bottom;
    if (SelTop < 1) or (SelBottom < SelTop) then
    begin
      ShowMessage('Please select at least one row');
      Exit;
    end;
    // Build CSV with tab delimiter (Excel-compatible)
    for I := SelTop to SelBottom do
    begin
      S := '';
      for J := 0 to CurrentGrid.ColCount - 1 do
      begin
        CellValue := CurrentGrid.Cells[J, I];
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
  I, J, SelTop, SelBottom: Integer;
  CellValue: string;
  TableName: string;
  S: String;
begin
  SL := TStringList.Create;
  try
    // Get selection range
    SelTop := CurrentGrid.Selection.Top;
    SelBottom := CurrentGrid.Selection.Bottom;
    if (SelTop < 1) or (SelBottom < SelTop) then
    begin
      ShowMessage('Please select at least one row');
      Exit;
    end;
    TableName := FCurrentTable;
    if TableName = '' then
      TableName := FCurrentView;
    // Build INSERT statements
    for I := SelTop to SelBottom do
    begin
      S := 'INSERT INTO "' + TableName + '" VALUES (';
      for J := 0 to CurrentGrid.ColCount - 1 do
      begin
        CellValue := CurrentGrid.Cells[J, I];
        if J > 0 then
          S := S + ', ';
        if (CellValue = 'NULL') or (CellValue = '<NULL>') then
          S := S + 'NULL'
        else if (FColumnTypes[J] = sctInteger) or (FColumnTypes[J] = sctReal) then
          S := S + CellValue
        else
          S := S + '''' + StringReplace(CellValue, '''', '''''', [rfReplaceAll]) + '''';
      end;
      S := S + ');';
      SL.Add(S);
    end;
    
    Clipboard.AsText := SL.Text;
    //ShowMessage('Copied ' + IntToStr(SelBottom - SelTop + 1) + ' row(s) to clipboard as SQL');
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
      BlobData := FDB.GetBlobData(FCurrentTable, PopupMenuRow - 1 + StrToIntDef(edtOffset.Text, 0), PopupMenuCol);
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
