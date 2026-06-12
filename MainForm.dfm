object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'SQLite Manager'
  ClientHeight = 600
  ClientWidth = 1461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  Position = poDefault
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object splVertical: TSplitter
    Left = 250
    Top = 27
    Width = 5
    Height = 573
    Beveled = True
    ExplicitHeight = 543
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 27
    Width = 250
    Height = 573
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnlLeft'
    TabOrder = 0
    object tvStructure: TTreeView
      Left = 0
      Top = 0
      Width = 250
      Height = 430
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      HideSelection = False
      Images = imgTree
      Indent = 19
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnClick = tvStructureClick
      OnDblClick = tvStructureDblClick
      OnKeyPress = tvStructureKeyPress
    end
    object pnlDbInfo: TPanel
      Left = 0
      Top = 430
      Width = 250
      Height = 143
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object lblDbInfo: TLabel
        Left = 0
        Top = 0
        Width = 250
        Height = 143
        Align = alClient
        AutoSize = False
        Caption = 'No database connected'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitLeft = 1
      end
    end
  end
  object pnlRight: TPanel
    Left = 255
    Top = 27
    Width = 1206
    Height = 573
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pcMain: TPageControl
      Left = 0
      Top = 0
      Width = 1206
      Height = 543
      ActivePage = tsBrowse
      Align = alClient
      TabOrder = 0
      object tsBrowse: TTabSheet
        Caption = 'Browse Data'
        object pnlBrowseToolbar: TPanel
          Left = 0
          Top = 0
          Width = 1198
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblTable: TLabel
            Left = 0
            Top = 0
            Width = 36
            Height = 15
            Align = alLeft
            Caption = 'TABLE'
            Layout = tlCenter
          end
          object btnEditRecord: TButton
            Left = 443
            Top = 4
            Width = 75
            Height = 25
            Caption = 'Edit'
            TabOrder = 0
            OnClick = btnEditRecordClick
          end
          object btnDeleteRecord: TButton
            Left = 524
            Top = 4
            Width = 75
            Height = 25
            Caption = 'Delete'
            TabOrder = 1
            OnClick = btnDeleteRecordClick
          end
          object btnAddRecord: TButton
            Left = 604
            Top = 4
            Width = 75
            Height = 25
            Caption = 'Add'
            TabOrder = 2
            OnClick = btnAddRecordClick
          end
          object btnDuplicateRecord: TButton
            Left = 685
            Top = 4
            Width = 75
            Height = 25
            Caption = 'Duplicate'
            Enabled = False
            TabOrder = 5
            OnClick = btnDuplicateRecordClick
          end
          object edtBrowseTitle: TEdit
            Left = 46
            Top = 5
            Width = 194
            Height = 23
            ReadOnly = True
            TabOrder = 3
          end
          object btnSearchTable: TButton
            Left = 246
            Top = 4
            Width = 75
            Height = 25
            Caption = 'Search'
            TabOrder = 4
            OnClick = btnSearchClick
          end
        end
        object sgBrowse: TStringGrid
          Left = 0
          Top = 33
          Width = 1198
          Height = 447
          Align = alClient
          ColCount = 1
          DefaultColWidth = 100
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect, goThumbTracking, goFixedRowDefAlign]
          TabOrder = 1
          OnDblClick = btnEditRecordClick
          OnDrawCell = sgBrowseDrawCell
          OnKeyPress = sgBrowseKeyPress
          OnMouseDown = sgBrowseMouseDown
          OnMouseWheelDown = sgBrowseMouseWheelDown
          OnMouseWheelUp = sgBrowseMouseWheelUp
          OnSelectCell = sgBrowseSelectCell
        end
        object pnlBrowseStatus: TPanel
          Left = 0
          Top = 480
          Width = 1198
          Height = 33
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          object lblNavStart: TLabel
            Left = 93
            Top = 8
            Width = 7
            Height = 17
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblNavTo: TLabel
            Left = 134
            Top = 10
            Width = 10
            Height = 15
            Caption = 'to'
          end
          object lblNavEnd: TLabel
            Left = 151
            Top = 8
            Width = 21
            Height = 17
            Caption = '100'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblNavOf: TLabel
            Left = 220
            Top = 10
            Width = 10
            Height = 15
            Caption = 'of'
          end
          object lblNavTotal: TLabel
            Left = 237
            Top = 8
            Width = 7
            Height = 17
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblOffset: TLabel
            Left = 454
            Top = 10
            Width = 35
            Height = 15
            Caption = 'Offset:'
          end
          object lblLimit: TLabel
            Left = 625
            Top = 9
            Width = 45
            Height = 15
            Caption = '     Limit:'
            Layout = tlCenter
          end
          object btnNavFirst: TButton
            Left = 2
            Top = 5
            Width = 40
            Height = 25
            Caption = '<<'
            TabOrder = 0
            OnClick = btnNavFirstClick
          end
          object btnNavPrev: TButton
            Left = 47
            Top = 5
            Width = 40
            Height = 25
            Caption = '<'
            TabOrder = 1
            OnClick = btnNavPrevClick
          end
          object btnNavNext: TButton
            Left = 332
            Top = 4
            Width = 40
            Height = 25
            Caption = '>'
            TabOrder = 2
            OnClick = btnNavNextClick
          end
          object btnNavLast: TButton
            Left = 378
            Top = 4
            Width = 40
            Height = 25
            Caption = '>>'
            TabOrder = 3
            OnClick = btnNavLastClick
          end
          object edtOffset: TEdit
            Left = 498
            Top = 5
            Width = 50
            Height = 23
            TabOrder = 4
            Text = '0'
          end
          object edtLimit: TEdit
            Left = 676
            Top = 5
            Width = 50
            Height = 23
            TabOrder = 5
            Text = '100'
          end
          object btnApplyFilter: TButton
            Left = 731
            Top = 4
            Width = 75
            Height = 25
            Caption = 'Apply'
            TabOrder = 6
            OnClick = btnApplyFilterClick
          end
        end
      end
      object tsIndex: TTabSheet
        Caption = 'Index Details'
        ImageIndex = 2
        object pnlIndexToolbar: TPanel
          Left = 0
          Top = 0
          Width = 1198
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblIndexName: TLabel
            Left = 0
            Top = 0
            Width = 69
            Height = 15
            Align = alLeft
            Caption = 'Index Name:'
            Layout = tlCenter
          end
          object edtIndexName: TEdit
            Left = 73
            Top = 5
            Width = 200
            Height = 23
            ReadOnly = True
            TabOrder = 0
          end
          object btnDeleteIndex: TButton
            Left = 280
            Top = 4
            Width = 100
            Height = 25
            Caption = 'Delete Index'
            TabOrder = 1
            OnClick = btnDeleteIndexClick
          end
          object btnReindex: TButton
            Left = 386
            Top = 4
            Width = 100
            Height = 25
            Caption = 'ReIndex'
            TabOrder = 2
            OnClick = btnReindexClick
          end
        end
        object pnlIndexInfo: TPanel
          Left = 0
          Top = 33
          Width = 1198
          Height = 150
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object lblIndexTable: TLabel
            Left = 2
            Top = 2
            Width = 32
            Height = 15
            Caption = 'Table:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblIndexTableValue: TLabel
            Left = 40
            Top = 2
            Width = 97
            Height = 15
            Caption = 'lblIndexTableValue'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblIndexUnique: TLabel
            Left = 2
            Top = 22
            Width = 43
            Height = 15
            Caption = 'Unique:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblIndexUniqueValue: TLabel
            Left = 60
            Top = 22
            Width = 108
            Height = 15
            Caption = 'lblIndexUniqueValue'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblIndexColumns: TLabel
            Left = 2
            Top = 42
            Width = 50
            Height = 15
            Caption = 'Columns:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblIndexColumnsValue: TLabel
            Left = 70
            Top = 42
            Width = 118
            Height = 15
            Caption = 'lblIndexColumnsValue'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblIndexSql: TLabel
            Left = 2
            Top = 62
            Width = 69
            Height = 15
            Caption = 'CREATE SQL:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object memIndexSQL: TMemo
            Left = 0
            Top = 82
            Width = 1198
            Height = 68
            Align = alBottom
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object sgIndex: TStringGrid
          Left = 0
          Top = 183
          Width = 1198
          Height = 330
          Align = alClient
          ColCount = 4
          DefaultColWidth = 100
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect, goThumbTracking, goFixedRowDefAlign]
          TabOrder = 2
        end
      end
      object tsExecute: TTabSheet
        Caption = 'Execute SQL'
        ImageIndex = 1
        object Splitter1: TSplitter
          Left = 0
          Top = 183
          Width = 1198
          Height = 5
          Cursor = crVSplit
          Align = alTop
        end
        object pnlExecuteToolbar: TPanel
          Left = 0
          Top = 0
          Width = 1198
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            1198
            33)
          object btnRunQuery: TButton
            Left = 0
            Top = 5
            Width = 90
            Height = 25
            Caption = 'Run Query'
            TabOrder = 0
            OnClick = btnRunQueryClick
          end
          object btnExplainQuery: TButton
            Left = 90
            Top = 5
            Width = 90
            Height = 25
            Caption = 'Explain'
            TabOrder = 1
            OnClick = btnExplainQueryClick
          end
          object btnClearSql: TButton
            Left = 180
            Top = 5
            Width = 90
            Height = 25
            Caption = 'Clear'
            TabOrder = 2
            OnClick = btnClearSqlClick
          end
          object btnSaveQuery: TButton
            Left = 270
            Top = 5
            Width = 90
            Height = 25
            Caption = 'Save'
            TabOrder = 3
          end
          object btnLoadQuery: TButton
            Left = 360
            Top = 5
            Width = 90
            Height = 25
            Caption = 'Load'
            TabOrder = 4
          end
          object cbHistory: TComboBox
            Left = 576
            Top = 6
            Width = 617
            Height = 23
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 5
            OnChange = cbHistoryChange
          end
          object btnFormatQuery: TButton
            Left = 450
            Top = 5
            Width = 90
            Height = 25
            Caption = 'Format'
            TabOrder = 6
            OnClick = btnFormatQueryClick
          end
        end
        object memSQL: TSynEdit
          Left = 0
          Top = 33
          Width = 1198
          Height = 150
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Cascadia Code'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          PopupMenu = pmSQL
          TabOrder = 0
          OnKeyPress = memSQLKeyPress
          CodeFolding.GutterShapeSize = 11
          CodeFolding.CollapsedLineColor = clGrayText
          CodeFolding.FolderBarLinesColor = clGrayText
          CodeFolding.IndentGuidesColor = clGray
          CodeFolding.IndentGuides = True
          CodeFolding.ShowCollapsedLine = False
          CodeFolding.ShowHintMark = True
          UseCodeFolding = False
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Consolas'
          Gutter.Font.Style = []
          Gutter.Visible = False
          Gutter.Width = 0
          Highlighter = SynSQLSyn1
          Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
          RightEdge = 500
        end
        object sgExecute: TStringGrid
          Left = 0
          Top = 188
          Width = 1198
          Height = 303
          Align = alClient
          ColCount = 1
          DefaultColWidth = 100
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect, goThumbTracking, goFixedRowDefAlign]
          TabOrder = 2
          OnDrawCell = sgBrowseDrawCell
          OnMouseDown = sgExecuteMouseDown
          OnMouseWheelDown = sgBrowseMouseWheelDown
          OnMouseWheelUp = sgBrowseMouseWheelUp
          OnSelectCell = sgExecuteSelectCell
        end
        object pnlExecuteStatus: TPanel
          Left = 0
          Top = 491
          Width = 1198
          Height = 22
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
        end
      end
      object tsTable: TTabSheet
        Caption = 'Table Details'
        ImageIndex = 1
        object pnlTableToolbar: TPanel
          Left = 0
          Top = 0
          Width = 1198
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblTableName: TLabel
            Left = 0
            Top = 0
            Width = 70
            Height = 15
            Align = alLeft
            Caption = 'Table Name:'
            Layout = tlCenter
          end
          object edtTableName: TEdit
            Left = 81
            Top = 5
            Width = 200
            Height = 23
            ReadOnly = True
            TabOrder = 0
          end
          object btnAddColumn: TButton
            Left = 287
            Top = 4
            Width = 110
            Height = 25
            Caption = 'Add Column'
            TabOrder = 1
            OnClick = btnAddColumnClick
          end
          object btnModifyTable: TButton
            Left = 403
            Top = 4
            Width = 110
            Height = 25
            Caption = 'Modify Table'
            TabOrder = 2
            OnClick = btnModifyTableClick
          end
          object btnEmptyTable: TButton
            Left = 519
            Top = 4
            Width = 110
            Height = 25
            Caption = 'Empty table'
            TabOrder = 3
            OnClick = btnEmptyTableClick
          end
        end
        object pnlTableInfo: TPanel
          Left = 0
          Top = 33
          Width = 1198
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object lblTableSql: TLabel
            Left = 2
            Top = 2
            Width = 69
            Height = 15
            Caption = 'CREATE SQL:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object memTableSQL: TMemo
            Left = 0
            Top = 0
            Width = 1198
            Height = 120
            Align = alClient
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object sgTable: TStringGrid
          Left = 0
          Top = 153
          Width = 1198
          Height = 360
          Align = alClient
          ColCount = 6
          DefaultColWidth = 100
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect, goThumbTracking, goFixedRowDefAlign]
          TabOrder = 2
        end
      end
    end
    object pnlStatusBar: TPanel
      Left = 0
      Top = 543
      Width = 1206
      Height = 30
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lblStatusSQLite: TLabel
        Left = 823
        Top = 0
        Width = 129
        Height = 30
        Align = alRight
        AutoSize = False
        Caption = 'SQLite: --'
        Layout = tlCenter
        ExplicitLeft = 828
        ExplicitTop = 2
      end
      object lblStatusTime: TLabel
        Left = 1112
        Top = 0
        Width = 94
        Height = 30
        Align = alRight
        AutoSize = False
        Caption = 'Time: 0 ms'
        Layout = tlCenter
        ExplicitLeft = 672
        ExplicitTop = 2
      end
      object lblStatusMessage: TLabel
        Left = 952
        Top = 0
        Width = 160
        Height = 30
        Align = alRight
        AutoSize = False
        Caption = 'Ready'
        Layout = tlCenter
      end
    end
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 1461
    Height = 27
    ButtonHeight = 27
    ButtonWidth = 27
    Caption = 'ToolBar'
    Images = imgToolbar
    TabOrder = 1
    object btnNewDb: TToolButton
      Left = 0
      Top = 0
      Hint = 'New Database'
      Caption = 'btnNewDb'
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
      OnClick = mnuNewDatabaseClick
    end
    object btnOpenDb: TToolButton
      Left = 27
      Top = 0
      Hint = 'Open Database'
      Caption = 'btnOpenDb'
      DropdownMenu = pmRecentDb
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      Style = tbsDropDown
      OnClick = mnuOpenDatabaseClick
    end
    object btnImport: TToolButton
      Left = 54
      Top = 0
      Hint = 'Import'
      Caption = 'btnImport'
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnImportClick
    end
    object btnSep1: TToolButton
      Left = 81
      Top = 0
      Width = 8
      Caption = 'btnSep1'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object btnCreateTable: TToolButton
      Left = 89
      Top = 0
      Hint = 'Create Table'
      Caption = 'btnCreateTable'
      ImageIndex = 4
      ParentShowHint = False
      ShowHint = True
    end
    object btnCreateView: TToolButton
      Left = 116
      Top = 0
      Hint = 'Create View'
      Caption = 'btnCreateView'
      ImageIndex = 5
      ParentShowHint = False
      ShowHint = True
      OnClick = btnCreateViewClick
    end
    object btnCreateIndex: TToolButton
      Left = 143
      Top = 0
      Hint = 'Create Index'
      Caption = 'btnCreateIndex'
      ImageIndex = 6
      ParentShowHint = False
      ShowHint = True
    end
    object btnCreateTrigger: TToolButton
      Left = 170
      Top = 0
      Hint = 'Create Trigger'
      Caption = 'btnCreateTrigger'
      ImageIndex = 7
      ParentShowHint = False
      ShowHint = True
      OnClick = btnCreateTriggerClick
    end
    object btnRefresh: TToolButton
      Left = 197
      Top = 0
      Hint = 'Refresh'
      Caption = 'btnRefresh'
      ImageIndex = 8
      ParentShowHint = False
      ShowHint = True
      OnClick = mnuRefreshClick
    end
    object btnSearch: TToolButton
      Left = 224
      Top = 0
      Hint = 'Search'
      Caption = 'btnSearch'
      ImageIndex = 9
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSearchClick
    end
    object btnSep2: TToolButton
      Left = 251
      Top = 0
      Width = 8
      Caption = 'btnSep2'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object btnShowAll: TToolButton
      Left = 259
      Top = 0
      Hint = 'Show All'
      Caption = 'btnShowAll'
      ImageIndex = 10
      ParentShowHint = False
      ShowHint = True
    end
  end
  object MainMenu: TMainMenu
    Left = 96
    Top = 32
    object mnuDatabase: TMenuItem
      Caption = 'Database'
      object mnuNewDatabase: TMenuItem
        Caption = 'New Database'
        OnClick = mnuNewDatabaseClick
      end
      object mnuOpenDatabase: TMenuItem
        Caption = 'Open Database'
        OnClick = mnuOpenDatabaseClick
      end
      object mnuCloseDatabase: TMenuItem
        Caption = 'Close Database'
        OnClick = mnuCloseDatabaseClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuRecent: TMenuItem
        Caption = 'Recent Databases'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuAttachDatabase: TMenuItem
        Caption = 'Attach Database'
        OnClick = mnuAttachDatabaseClick
      end
      object mnuDetachDatabase: TMenuItem
        Caption = 'Detach Database'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuCopyDatabase: TMenuItem
        Caption = 'Copy Database'
        OnClick = mnuCopyDatabaseClick
      end
      object mnuCompactDatabase: TMenuItem
        Caption = 'Compact Database'
        OnClick = mnuCompactDatabaseClick
      end
      object DatabaseInformation1: TMenuItem
        Caption = 'Database Information'
        OnClick = DatabaseInformation1Click
      end
      object mnuAnalyzeDatabase: TMenuItem
        Caption = 'Analyze Database'
        OnClick = mnuAnalyzeDatabaseClick
      end
      object mnuCheckIntegrity: TMenuItem
        Caption = 'Check Integrity'
        object mnuCheckComplete: TMenuItem
          Caption = 'Complete Check'
          OnClick = mnuCheckCompleteClick
        end
        object mnuCheckQuick: TMenuItem
          Caption = 'Quick Check'
          OnClick = mnuCheckQuickClick
        end
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuExportAll: TMenuItem
        Caption = 'Export All Tables'
        OnClick = mnuExportAllClick
      end
      object mnuExportDatabase: TMenuItem
        Caption = 'Export Database'
        OnClick = mnuExportDatabaseClick
      end
      object mnuImport: TMenuItem
        Caption = 'Import from File'
        OnClick = mnuImportClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuRefresh: TMenuItem
        Caption = 'Refresh'
        OnClick = mnuRefreshClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuTable: TMenuItem
      Caption = 'Table'
      object mnuCreateTable: TMenuItem
        Caption = 'Create Table'
        OnClick = mnuCreateTableClick
      end
      object mnuDropTable: TMenuItem
        Caption = 'Drop Table'
        OnClick = mnuDropTableClick
      end
      object mnuEmptyTable: TMenuItem
        Caption = 'Empty Table'
        OnClick = mnuEmptyTableClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mnuRenameTable: TMenuItem
        Caption = 'Rename Table'
        OnClick = mnuRenameTableClick
      end
      object mnuCopyTable: TMenuItem
        Caption = 'Copy Table'
        OnClick = mnuCopyTableClick
      end
      object mnuExportTable: TMenuItem
        Caption = 'Export Table'
        OnClick = mnuExportTableClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object mnuReindexTable: TMenuItem
        Caption = 'Reindex Table'
        OnClick = mnuReindexTableClick
      end
    end
    object mnuIndex: TMenuItem
      Caption = 'Index'
      object mnuCreateIndex: TMenuItem
        Caption = 'Create Index'
        OnClick = mnuCreateIndexClick
      end
      object mnuDropIndex: TMenuItem
        Caption = 'Drop Index'
        OnClick = mnuDropIndexClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object mnuReindexIndex: TMenuItem
        Caption = 'Reindex Index'
        OnClick = mnuReindexIndexClick
      end
    end
    object mnuView: TMenuItem
      Caption = 'View'
      object mnuCreateView: TMenuItem
        Caption = 'Create View'
        OnClick = mnuCreateViewClick
      end
      object mnuDropView: TMenuItem
        Caption = 'Drop View'
        OnClick = mnuDropViewClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object mnuRenameView: TMenuItem
        Caption = 'Rename View'
        OnClick = mnuRenameViewClick
      end
      object mnuModifyView: TMenuItem
        Caption = 'Modify View'
        OnClick = mnuModifyViewClick
      end
      object mnuExportView: TMenuItem
        Caption = 'Export View'
        OnClick = mnuExportViewClick
      end
    end
    object mnuTrigger: TMenuItem
      Caption = 'Trigger'
      object mnuCreateTrigger: TMenuItem
        Caption = 'Create Trigger'
        OnClick = mnuCreateTriggerClick
      end
      object mnuDropTrigger: TMenuItem
        Caption = 'Drop Trigger'
        OnClick = mnuDropTriggerClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object mnuRenameTrigger: TMenuItem
        Caption = 'Rename Trigger'
        OnClick = mnuRenameTriggerClick
      end
    end
    object mnuTools: TMenuItem
      Caption = 'Tools'
      object mnuOptions: TMenuItem
        Caption = 'Options'
        OnClick = mnuOptionsClick
      end
      object mnuAISettings: TMenuItem
        Caption = 'AI Settings...'
        OnClick = mnuAISettingsMainClick
      end
      object mnuUDF: TMenuItem
        Caption = 'User-Defined Functions'
      end
      object mnuConnectSQL: TMenuItem
        Caption = 'On-Connect SQL Statements'
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      object mnuReportProblem: TMenuItem
        Caption = 'Report Problem'
      end
      object mnuFAQ: TMenuItem
        Caption = 'FAQ'
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object mnuSQLiteHome: TMenuItem
        Caption = 'SQLite Home'
        OnClick = mnuSQLiteHomeClick
      end
      object mnuSQLiteSyntax: TMenuItem
        Caption = 'SQLite Syntax'
        OnClick = mnuSQLiteSyntaxClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mnuAbout: TMenuItem
        Caption = 'About SQLite Manager'
        OnClick = mnuAboutClick
      end
    end
  end
  object imgToolbar: TImageList
    Left = 160
    Top = 32
    Bitmap = {
      494C01010B001800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004040405E404040E440404038000000000000000000000000B763
      1104B7631160B76311C0B76311F9B76311FFB76311FFB76311F9B76311C0B763
      115FB76311030000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C9DFA95E7FB435DE6DA917FF72AC20F5ABCD7A92FEFEFE010000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000040404061404040FC404040FF404040EF0000000000000000B7631126B763
      11D0B76311FFB76311FFB76311FFB76311FFB76311FFB76311FFB76311FFB763
      11FFB76311CEB763112500000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CFE3
      B3536DA917FF6DA917FF6DA917FF6DA917FF6DA917FF6DA917FF6DA917FF8FBD
      4EC2000000000000000071AB1EF7000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004040
      4065404040FD404040FF404040FF4040409300000000B7631129B76311EBB763
      11FFB76311FFB76311CDB7631171B7631146B7631146B7631171B76311CEB763
      11FFB76311FFB76311EAB7631127000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B5D38A806DA9
      17FF6DA917FFADCE7C8F000000000000000000000000D5E6BC496DA917FF6DA9
      17FF75AD23F1000000006DA917FF000000000000000000000000000000004040
      40023E3E3E443D3D3D833C3C3C963A3A3A7E3737373600000000404040684040
      40FD404040FF404040FF4040409000000000B7631107B76311D7B76311FFB763
      11FBB763116AB763110100000000000000000000000000000000B7631101B763
      116BB76311FBB76311FFB76311D5B76311070000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F2F7EB156DA917FF6DA9
      17FFFAFCF8070000000000000000000000000000000000000000000000007EB3
      33E06DA917FF6DA917FF6DA917FF000000000000000000000000404040394040
      40D8404040FF404040FF404040FF404040FF404040FF414141D3404040FE4040
      40FF404040FF4040408D0000000000000000B763116EB76311FFB76311FFB763
      1169000000000000000000000000000000000000000000000000000000000000
      0000B763116CB76311FFB76311FFB763116B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000071AB1EF76DA917FFECF4
      E120000000000000000000000000000000000000000000000000000000000000
      00006DA917FF6DA917FF6DA917FFFEFEFE010000000040404045404040F74040
      40FF484848FC8C8C8CFEA2A2A2FF818181FF444444FF404040FF404040FF4040
      40FF40404089000000000000000000000000B76311CFB76311FFB76311D0B763
      1101000000000000000000000000000000000000000000000000000000000000
      0000B7631101B76311D1B76311FFB76311CD0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006DA917FF6DA917FF0000
      00000000000000000000000000000000000000000000000000006EAA19FC6DA9
      17FF6DA917FF6DA917FF6DA917FFFDFDFC0340404011404040EA404040FF7474
      74F4FFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFEFEFEFE626262FF404040FF4141
      41DF00000000000000000000000000000000B76311FDB76311FFB76311790000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B763117BB76311FFB76311FC0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFC036DA917FFB3D287830000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000040404078404040FF515151F1FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF484848FF4040
      40FF39393941000000000000000000000000B76311FFB76311FFB76311590000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B763115BB76311FFB76311FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006DA917FF6DA917FF00000000404040C1404040FFABABABE0FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8FFF4040
      40FF3C3C3C8B000000000000000000000000B76311FFB76311FFB763116A0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B763116CB76311FFB76311FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006DA917FF6DA917FF6DA917FF6DA9
      17FF6DA917FF6DA917FF00000000000000000000000000000000000000000000
      0000EBF3E0226DA917FF96C158B700000000404040DE404040FFD6D6D6DCFFFF
      FFFEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFB5B5B5FF4040
      40FF3D3D3DA6000000000000000000000000B76311E4B76311FFB76311AF0000
      0000000000000000000000000000000000000000000000000000B76311F5B763
      110A00000000B76311B2B76311FFB76311E20000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006EA918FD6DA917FF6DA917FFE2EE
      D132000000000000000000000000000000000000000000000000000000000000
      000073AD21F36DA917FFF2F7EA1600000000404040D1404040FFB7B7B7C6FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA3A3A3FE4040
      40FF3E3E3E96000000000000000000000000B763118FB76311FFB76311FCB763
      11360000000000000000000000000000000000000000B76311F6B76311FFB763
      1110B7631137B76311FDB76311FFB763118D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006FAA1AFB6DA917FF6DA917FF6DA9
      17FFE5F0D62C0000000000000000000000000000000000000000000000009DC5
      63AB6DA917FF76AE25EF00000000000000004040409A404040FF525252CDFFFF
      FFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF565656F94040
      40FF3E3E3E5B000000000000000000000000B763111BB76311F2B76311FFB763
      11E2B763112800000000000000000000000000000000B76311FFB76311FFB763
      1138B76311E3B76311FFB76311F2B763111A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000070AB1CF96DA917FFE2EED2316DA9
      17FF6DA917FF92BF53BDFCFDFA050000000000000000E6F0D82A72AC1FF66DA9
      17FF6DA917FF00000000000000000000000040404036404040FE404040FF9696
      96B4FFFFFFF0FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFE929292EF404040FF4040
      40EA4040400A00000000000000000000000000000000B763115BB76311FDB763
      11FFB76311F3B763117E000000000000000000000000B76311FFB76311FFB763
      11F6B76311FFB76311FDB7631159000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006DA917FF6DA917FF00000000EFF5
      E61B6DA917FF6DA917FF6DA917FF6DA917FF6DA917FF6DA917FF6DA917FF79B0
      2AEA000000000000000000000000000000000000000040404093404040FF4040
      40FE585858C6C6C6C6BFEBEBEBD7C6C6C6DA606060E5404040FF404040FD4040
      4053000000000000000000000000000000000000000000000000B7631161B763
      11F7B76311FFB76311C9000000000000000000000000B76311FFB76311FFB763
      11FFB76311F7B763116000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006DA917FF000000000000
      000000000000DCEAC83C8ABA46CB6DA917FF6FAA1AFB9FC767A6F7FAF30D0000
      0000000000000000000000000000000000000000000040404003404040984040
      40FE404040FF404040FF404040FF404040FF404040FF404040F6404040600000
      000000000000000000000000000000000000000000000000000000000000B763
      112AB76311AD00000000000000000000000000000000B76311FFB76311FFB763
      11FFB76311FFB76311FFB76311FFB76311FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004040
      403E404040A7404040E0404040EF404040D54040409040404021000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B76311FFB76311FFB763
      11FFB76311FFB76311FFB76311FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000076AE
      23FF76AE23FF00000000000000000000000000000000B56210FFB56210FFB562
      10FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFFDFBFA0576AE
      23FF76AE23FFB66514FA00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000076AE
      23FF76AE23FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000076AE
      23FF76AE23FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000076AE
      23FF76AE23FF00000000000000000000000000000000B56210FFB56210FFB562
      10FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFFDFBFA0576AE
      23FF76AE23FFB66514FA00000000000000000000000000000000000000000000
      000000000000000000005A5A5AFD5F5F5FFF5A5A5AFD000000000000000076AE
      23FF76AE23FF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0576AE
      23FF76AE23FFFFFFFFFA0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA058E8E8EFEFFFFFFFFE3E3E3FFB562
      10FFB56210FFB56210FFB56210FFB56312FC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA050000000000000000000000000000
      000000000000000000005A5A5AFD606060FC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA05FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA05FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA0500000000B56210FFB56210FFB562
      10FFB56210FFB56210FFB56210FFB56312FC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA050000000000000000000000000000
      000000000000000000005A5A5AFD606060FC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA05FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF433333FF433333FF453535FC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA05B3B3B3FF929292FF929292FF9292
      92FF929292FF929292FF929292FF929292FFFBFBFB09FBFBFB09FEFEFE0176AE
      23FF76AE23FFFBFBFB09F8F8F809000000008E8E8EFEFFFFFFFFE3E3E3FFB562
      10FFB56210FFB56210FFB56210FFB56210FFFCF9F609FCF9F609FEFEFE0176AE
      23FF76AE23FFFCF9F60900000000000000000000000000000000000000000000
      000000000000000000005A5A5AFD5F5F5FFFF9F9F908000000000000000076AE
      23FF76AE23FF000000000000000000000000FFFFFFFF433333FF433333FF4333
      33FFFFFFFFFF6F6F6FFF6F6F6FFF6F6F6FFFFFFFFF09FFFFFF09FFFFFF0176AE
      23FF76AE23FFFFFFFF090000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF929292FFFFFFFF0576AE
      23FF76AE23FFFFFFFFFA4A4A4AFF0000000000000000B56210FFB56210FFB562
      10FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFFDFBFA0576AE
      23FF76AE23FFB66514FA00000000000000000000000000000000000000000000
      000000000000000000005A5A5AFD5F5F5FFF5A5A5AFD000000000000000076AE
      23FF76AE23FF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0576AE
      23FF76AE23FFFFFFFFFA0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF929292FFFFFFFF0576AE
      23FF76AE23FFFFFFFFFA4A4A4AFF000000008E8E8EFEFFFFFFFFE3E3E3FFB562
      10FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFFDFBFA0576AE
      23FF76AE23FFB66514FA00000000000000000000000000000000000000000000
      000000000000000000005A5A5AFD5F5F5FFF5A5A5AFD000000000000000076AE
      23FF76AE23FF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0576AE
      23FF76AE23FFFFFFFFFA0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF929292FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4A4A4AFF0000000000000000B56210FFB56210FFB562
      10FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFB562
      10FFB56210FFB56210FF00000000000000000000000000000000000000000000
      000000000000000000005A5A5AFD5F5F5FFF5A5A5AFD00000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4A3A3AFF433333FF433333FF433333FF433333FF4333
      33FFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF929292FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4A4A4AFF000000008E8E8EFEFFFFFFFFE3E3E3FFB562
      10FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFB562
      10FFB56210FFB56210FF00000000000000000000000000000000000000000000
      000000000000959595A2595959FF595959FFEFEFEFFF9999999C000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF433333FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF0000000000000000B3B3B3FF929292FF929292FF9292
      92FF929292FF929292FF929292FF929292FF929292FF929292FF929292FF9292
      92FF929292FF929292FF4A4A4AFF0000000000000000B56210FFB56210FFB562
      10FFB56210FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB562
      10FFB56210FFB56210FF00000000000000000000000000000000000000000000
      0000A8A8A885595959FF595959FF595959FFD7D7D7FF959595FFAEAEAE7C0000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4A3A3AFF433333FF433333FF433333FF433333FF4333
      33FFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF929292FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4A4A4AFF000000008E8E8EFEFFFFFFFFE3E3E3FFB562
      10FFB56210FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFB562
      10FFB56210FFB56210FF0000000000000000000000000000000000000000BBBB
      BB67595959FF595959FF595959FF595959FF595959FFFFFFFFFF5E5E5EFFC2C2
      C25D00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB3B3B3FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF4A4A4AFF0000000000000000B56210FFB56210FFB562
      10FFB56210FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFB562
      10FFB56210FFB56210FF00000000000000000000000000000000CDCDCD4C5959
      59FF595959FF595959FF595959FF595959FF595959FFF5F5F5FFFFFFFFFF5959
      59FFD3D3D343000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF0000000000000000C26A15FFC26A15FFC26A15FFC26A
      15FFC26A15FFC26A15FFC26A15FFC26A15FFC26A15FF894501FFC26A15FFC26A
      15FFC26A15FFC26A15FF894501FF000000008E8E8EFEFFFFFFFFE3E3E3FFB562
      10FFB56210FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB562
      10FFB56210FFB56210FF000000000000000000000000DCDCDC35595959FF5959
      59FF595959FF595959FF595959FF595959FF595959FF5B5B5BFFFFFFFFFFFEFE
      FEFF595959FFE1E1E12D0000000000000000A6287BFFA6287BFFA6287BFFA628
      7BFFA6287BFFA6287BFFA6287BFFA6287BFFA6287BFFA6287BFFA6287BFFA628
      7BFFA6287BFFA6287BFF0000000000000000C26A15FFC26A15FFC26A15FFC26A
      15FFC26A15FFC26A15FFC26A15FFC26A15FFC26A15FF894501FFC26A15FFC26A
      15FFC26A15FFC26A15FF894501FF0000000000000000B56210FFB56210FFB562
      10FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFB562
      10FFB56210FFB56210FF0000000000000000E8E8E822595959FF595959FF5959
      59FF595959FF595959FF595959FF595959FF595959FF595959FFFFFFFFFFFFFF
      FFFF939393FF595959FFEDEDED1B00000000A6287BFFA6287BFFA6287BFFA628
      7BFFA6287BFFA6287BFFA6287BFFA6287BFFA6287BFFA6287BFFA6287BFFA628
      7BFFA6287BFFA6287BFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B56210FFB56210FFB562
      10FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFB56210FFB562
      10FFB56210FFB56210FF0000000000000000E0E0E02F595959FF595959FF5959
      59FF595959FF595959FF595959FF595959FF595959FF595959FF595959FF5959
      59FF595959FF595959FFE4E4E429000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E3C5A759C07A35CCB15A05FCB76616EBCF99649CFAF5F10E0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000076AE
      23FF76AE23FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000636363FE636363FF636363FF6363
      63FF636363FF636363FF636363FF636363FF636363FF636363FF636363FF6363
      63FF636363FF636363FF636363FF00000000000000000000000000000000D4A3
      748CB15903FFB15903FFC58445BCD6A97C84D09C6997B56210F1B15903FFB25C
      07FAFCF9F609000000000000000000000000000000000000000000000000AEE1
      FF724ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFFFCFDFF0476AE
      23FF76AE23FF000000000000000000000000A3A5A5954ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF90D6FF9C0000000000000000636363FF636363FF636363FF6363
      63FF636363FF636363FF636363FF636363FF636363FF636363FF636363FF6363
      63FF636363FF636363FF636363FF000000000000000000000000B76617EAB159
      03FFF0E0D02F000000000000000000000000000000000000000000000000C27E
      3CC5B15903FFF0DFCF300000000000000000000000000000000059C1FFE94ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4CBCFFFC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA05666666FA84CEFFAD4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFE0000000000000000636363FF636363FF636363FF6363
      63FF636363FF636363FF636363FF00000000636363FF636363FF636363FF6363
      63FF636363FF636363FF636363FF0000000000000000BE752ED3B15903FE0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DDB7926EB15903FFFCF9F6090000000000000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4CBCFFFC76AE23FF76AE23FF76AE23FF76AE
      23FF76AE23FF76AE23FF76AE23FFFCFDFA05656565FBD9EBF7364ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF0000000000000000636363FE636363FF636363FF6363
      63FF636363FF636363FF0000000076AE23FF00000000636363FF636363FF6363
      63FF636363FF636363FF636363FF00000000F3E6DA25B15903FFFEFDFC030000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C27E3BC6B25C07FA0000000000000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFFF8FCFF09F8FCFF09FEFEFF0176AE
      23FF76AE23FF000000000000000000000000656565FBF7F9FA0B4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFFF7FCFF0B0000000000000000FBFBFB06FBFBFB06FBFB
      FB06FBFBFB06FCFCFC0476AE23FF76AE23FF76AE23FFFCFCFC04FBFBFB06FBFB
      FB06FBFBFB06FBFBFB060000000000000000B35E0BF6CA8E54AD000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B15903FFFBF7F30C00000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFFFBFDFF0576AE
      23FF76AE23FF000000000000000000000000656565FBAFB3B57F4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFFA2DCFF83000000000000000000000000000000000000
      00000000000076AE23FF76AE23FF76AE23FF76AE23FF76AE23FF000000000000
      000000000000000000000000000000000000B15903FFFDFBFA05000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B56210F1CF9A659B00000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFFFBFDFF0576AE
      23FF76AE23FF000000000000000000000000656565FB696969F469C6FFD34ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4EBDFFF9000000000000000000000000000000000000
      000076AE23FF76AE23FF76AE23FF76AE23FF76AE23FF76AE23FF76AE23FF0000
      000000000000000000000000000000000000B15903FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D09C6997B76616EB00000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF000000000000000000000000656565FB636363FFBFE1F65B4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF0000000000000000000000000000000076AE
      23FF76AE23FF76AE23FF76AE23FF76AE23FF76AE23FF76AE23FF76AE23FF76AE
      23FF00000000000000000000000000000000B15903FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6A77A86B25B06FB00000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF000000000000000000000000656565FB636363FFFDFDFD034ABC
      FFFE4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFFFCFDFF040000000000000000FCFDFA0576AE
      23FF76AE23FF7BB12BF576AE23FF76AE23FF76AE23FF7EB22FF076AE23FF76AE
      23FF00000000000000000000000000000000B15903FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C58344BDC07A35CC00000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF000000000000000000000000656565FB636363FF636363FF6363
      63FF636363FF636363FF636363FF636363FF636363FF636363FF636363FF6363
      63FF636363FF636363FF00000000000000000000000000000000FCFDFA0576AE
      23FF7AB02AF60000000076AE23FF76AE23FF76AE23FF0000000080B434EB76AE
      23FF00000000000000000000000000000000B15903FFE9D0B847000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B15903FFE3C5A75900000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF4ABCFFFF000000000000000000000000656565FB636363FF636363FF6363
      63FF636363FF636363FF636363FF636363FF636363FF636363FF636363FF6363
      63FF636363FF636363FF00000000000000000000000000000000FCFDFA057AB0
      2AF6000000000000000076AE23FF76AE23FF76AE23FF000000000000000083B6
      39E500000000000000000000000000000000CE98639DB15A05FC000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0E0D02FB15903FF00000000000000000000000061C4FFDEE1F3
      FF2AFAFDFF06CEECFF45B6E4FF66B2E2FF6CBFE7FF59E1F4FF2900000000AEE1
      FF724ABCFFFF000000000000000000000000656565FB636363FF636363FF6363
      63FF636363FF636363FF636363FFB6B6B6760000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FCFDFB040000
      0000000000000000000076AE23FF76AE23FF76AE23FF00000000000000000000
      00000000000000000000000000000000000000000000B15903FFD5A678880000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B15903FFD4A4758B00000000000000000000000071CAFFC74ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFFE3F4FF270000000000000000000000009E9E9E9D636363FF636363FF6363
      63FF636363FF636363FF747474E3000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000076AE23FF76AE23FF76AE23FF00000000000000000000
      00000000000000000000000000000000000000000000F3E7DB24B15903FFD6A7
      7A8600000000000000000000000000000000000000000000000000000000FEFD
      FC03B15903FEB86719E8000000000000000000000000000000004ABCFFFF4ABC
      FFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABCFFFF4ABC
      FFFF8FD5FF9D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000076AE23FF76AE23FF76AE23FF00000000000000000000
      0000000000000000000000000000000000000000000000000000F3E7DB24B159
      03FFB15A05FCE9D0B847000000000000000000000000FDFCFB04CA8E54ADB159
      03FFBE752ED3000000000000000000000000000000000000000000000000DDF2
      FF2F95D7FF9569C7FFD255C0FFEF51BEFFF55CC2FFE57BCEFFB9B3E2FF6BFEFE
      FF01000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000076AE23FF76AE23FF76AE23FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CE98639DB15903FFB15903FFB15903FFB15903FFB15903FFB45F0CF5F3E6
      DA2500000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFF8E0070000F81FFFF0C0030000
      E00DFFE080010000C385E04103C0000087E1C0030FF000008FF080070FF00000
      9FC0000F1FF800001FFF00071FF80000FFF900071FF8000003F100071FC80000
      0FF100070F80000007E30007078000000187000783810000200F800FC3830000
      B81F801FE7800000FFFFE03FFF810000FFFFFFFFFFFFFFFFFFE78003FFE7FFE7
      FFE78003FC67000300000000FC00000000008000FC00000000010003FC670003
      00018003FC67000300010003FC67000300018003FC7F000300010003F83F0003
      00018003F01F000300010003E00F000300018003C00700030001000380030003
      0001800300010003FFFF80030001FFFFFFFFFFFFFFFFF81FFFE7FFFF0001E007
      E00700030001C7E3C000000301019FF1C000000302811FF9C007000180033FFC
      C0070001F83F3FFCC0070001F01F7FFCC0070001E00F7FFCC0070000C00F7FFC
      C0070003C44F3FFCC0070003CC6F3FF9C02700FFDC7F9FF9C00701FFFC7F8FE3
      C007FFFFFC7FC387E00FFFFFFC7FF00F00000000000000000000000000000000
      000000000000}
  end
  object imgTree: TImageList
    Left = 224
    Top = 32
    Bitmap = {
      494C010109001800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000009E9E
      9E002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B007979
      7900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000ACACAC002B2B2B002B2B2B002B2B2B00A2A2A200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002828280000000000000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      0000000000000000000029292900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002B2B2B004F4F4F00000000000000
      000000000000000000002B2B2B002B2B2B002B2B2B0000000000000000000000
      000000000000818181002B2B2B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000565656002B2B2B002B2B2B002B2B
      2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B
      2B002B2B2B002B2B2B002B2B2B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000545454002B2B2B002B2B2B002B2B
      2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B2B002B2B
      2B002B2B2B002B2B2B002B2B2B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009E9E9E0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007A7A7A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5621000B5621000B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      0000000000000000000055555500555555005B5B5B0055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000055555500555555005B5B5B0055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009A9A9A0063636300000000000000000000000000B5621000B5621000B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F006363630063636300636363000000000000000000B5621000B5621000B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007D7D7D006363
      630000000000000000006D6D6D006363630088888800FFFFFF00E3E3E300B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007A7A7A00636363006363
      63000000000000000000636363007E7E7E0088888800FFFFFF00E3E3E300B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007777770063636300636363006363
      63006363630063636300717171000000000000000000B5621000B5621000B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000757575006363630063636300636363006363
      6300636363007C7C7C00000000000000000000000000B5621000B5621000B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      000000000000000000000000000000000000000000000000000000000000AAAA
      AA0098989800B1B1B1007D7D7D00636363006363630063636300636363006363
      63008787870000000000000000000000000088888800FFFFFF00E3E3E300B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005555550055555500D0D0D00055555500000000000000
      0000000000000000000000000000000000000000000000000000626262006262
      6200626262006262620063636300636363006363630063636300636363009393
      93000000000000000000000000000000000088888800FFFFFF00E3E3E300B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      000000000000797979005555550055555500D2D2D200747474007C7C7C000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000797979005555550055555500D2D2D200747474007C7C7C000000
      0000000000000000000000000000000000000000000062626200636363006363
      6300636363006363630063636300636363006363630063636300A0A0A0000000
      00000000000000000000000000000000000000000000B5621000B5621000B562
      1000B5621000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00B5621000B562100000000000000000000000000000000000000000000000
      00009090900055555500555555005555550076767600FFFFFF00666666009494
      9400000000000000000000000000000000000000000000000000000000000000
      00009090900055555500555555005555550076767600FFFFFF00666666009494
      9400000000000000000000000000000000008E8E8E0063636300636363006363
      63006363630063636300636363006363630063636300ADADAD00000000000000
      00000000000000000000000000000000000000000000B5621000B5621000B562
      1000B5621000FFFFFF00FFFFF800FFFFF800FFFFF800FFFFF800FFFFF800FFFF
      FF00B5621000B56210000000000000000000000000000000000000000000AAAA
      AA005555550055555500555555005555550055555500D6D6D600F5F5F5005B5B
      5B00AEAEAE00000000000000000000000000000000000000000000000000AAAA
      AA005555550055555500555555005555550055555500D6D6D600F5F5F5005B5B
      5B00AEAEAE000000000000000000000000006363630063636300636363000000
      0000000000006363630063636300636363006262620000000000000000000000
      00000000000000000000000000000000000088888800FFFFFF00E3E3E300B562
      1000B5621000FFFFFF00FFFFF800FFFFF800FFFFF800FFFFF800FFFFF800FFFF
      FF00B5621000B562100000000000000000000000000000000000000000005858
      580055555500555555005555550055555500555555006F6F6F00FFFFFF00DDDD
      DD00595959000000000000000000000000000000000000000000000000005858
      580055555500555555005555550055555500555555006F6F6F00FFFFFF00DDDD
      DD00595959000000000000000000000000006363630063636300000000000000
      00000000000000000000636363006363630062626200B2B2B200000000000000
      00000000000000000000000000000000000088888800FFFFFF00E3E3E300B562
      1000B5621000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00B5621000B562100000000000000000000000000000000000616161005555
      5500555555005555550055555500555555005555550055555500CDCDCD00FFFF
      FF00BFBFBF006464640000000000000000000000000000000000616161005555
      5500555555005555550055555500555555005555550055555500CDCDCD00FFFF
      FF00BFBFBF006464640000000000000000006262620000000000000000000000
      0000000000000000000062626200636363006262620000000000000000000000
      00000000000000000000000000000000000000000000B5621000B5621000B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000071717100555555005555
      550055555500555555005555550055555500555555005555550069696900FFFF
      FF00FFFFFF009A9A9A0074747400000000000000000071717100555555005555
      550055555500555555005555550055555500555555005555550069696900FFFF
      FF00FFFFFF009A9A9A0074747400000000000000000000000000000000000000
      0000000000006262620063636300636363006262620000000000000000000000
      00000000000000000000000000000000000000000000B5621000B5621000B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000009797970055555500555555005555
      5500555555005555550055555500555555005555550055555500555555005858
      58005858580055555500555555009C9C9C009797970055555500555555005555
      5500555555005555550055555500555555005555550055555500555555005858
      58005858580055555500555555009C9C9C000000000000000000000000000000
      0000626262006363630063636300626262000000000000000000000000000000
      00000000000000000000000000000000000000000000B5621000B5621000B562
      1000B5621000B5621000B5621000B5621000B5621000B5621000B5621000B562
      1000B5621000B562100000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006262
      62006363630073737300A3A3A300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000082C7F1005EBEF8004BB9FB0044B7FC004AB9FB005BBDF8007DC6F200AFD3
      E90000000000000000000000000000000000A8A8A800A2A2A200A2A2A200A2A2
      A200A2A2A200A2A2A200A7A7A7000000000000000000A8A8A800A2A2A200A2A2
      A200A2A2A200A2A2A200A2A2A200A7A7A70000000000868686004E4E4E004E4E
      4E004E4E4E004E4E4E004E4E4E004E4E4E004E4E4E004E4E4E004E4E4E004E4E
      4E004E4E4E004E4E4E0084848400000000009F785400B7631100B7631100B763
      1100B7631100B76311009F78540000000000000000009F785400B7631100B763
      1100B7631100B7631100B76311009F785400000000000000000063BFF70037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0059BDF9000000000000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A200000000004E4E4E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004E4E4E0000000000B7631100B7631100B7631100B763
      1100B7631100B7631100B76311000000000000000000B7631100B7631100B763
      1100B7631100B7631100B7631100B7631100000000006FC2F50037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0065C0F60000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A200000000004E4E4E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004E4E4E0000000000B7631100B7631100FFFFFF00FFFF
      FF00FFFFFF00B7631100B76311000000000000000000B7631100B7631100FFFF
      FF00FFFFFF00FFFFFF00B7631100B76311000000000037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A200000000004E4E4E00FFFFFF00FFFF
      FF003939390039393900FFFFFF00989898009898980098989800989898009292
      9200FFFFFF00FFFFFF004E4E4E0000000000B7631100B7631100FFFFFF00FFFF
      FF00FFFFFF00B7631100B76311000000000000000000B7631100B7631100FFFF
      FF00FFFFFF00FFFFFF00B7631100B76311000000000037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A200000000004E4E4E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004E4E4E0000000000B7631100B7631100FFFFFF00FFFF
      FF00FFFFFF00B7631100B76311000000000000000000B7631100B7631100FFFF
      FF00FFFFFF00FFFFFF00B7631100B76311000000000037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A200000000004E4E4E00FFFFFF00FFFF
      FF003939390039393900FFFFFF00989898009898980098989800989898009292
      9200FFFFFF00FFFFFF004E4E4E0000000000B7631100B7631100B7631100B763
      1100B7631100B7631100B76311000000000000000000B7631100B7631100B763
      1100B7631100B7631100B7631100B76311000000000037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF000000000000000000A9A9A9009D9D9D009D9D9D009D9D
      9D009D9D9D009D9D9D00A8A8A8000000000000000000A9A9A9009D9D9D009D9D
      9D009D9D9D009D9D9D009D9D9D00A8A8A800000000004E4E4E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004E4E4E00000000009F785400B7631100B7631100B763
      1100B7631100B76311009F78540000000000000000009F785400B7631100B763
      1100B7631100B7631100B76311009F7854000000000037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004E4E4E00FFFFFF00FFFF
      FF003939390039393900FFFFFF00989898009898980098989800989898009292
      9200FFFFFF00FFFFFF004E4E4E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004E4E4E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004E4E4E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FF000000000000000000A8A8A800A2A2A200A2A2A200A2A2
      A200A2A2A200A2A2A200A7A7A7000000000000000000A8A8A800A2A2A200A2A2
      A200A2A2A200A2A2A200A2A2A200A7A7A700000000004E4E4E00FFFFFF00FFFF
      FF003939390039393900FFFFFF00989898009898980098989800989898009292
      9200FFFFFF00FFFFFF004E4E4E00000000009F785400B7631100B7631100B763
      1100B7631100B76311009F78540000000000000000009F785400B7631100B763
      1100B7631100B7631100B76311009F7854000000000037B4FF0037B4FF0037B4
      FF0037B4FF0037B4FE0041B6FD0047B8FC0043B7FC0038B4FE0037B4FF0037B4
      FF0037B4FF0037B4FF0000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A200000000004E4E4E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004E4E4E0000000000B7631100B7631100B7631100B763
      1100B7631100B7631100B76311000000000000000000B7631100B7631100B763
      1100B7631100B7631100B7631100B76311000000000037B4FF005FBEF7009ACE
      ED00000000000000000000000000000000000000000000000000000000009FCF
      EC0065C0F60037B4FF0000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A200000000004E4E4E00FFFFFF00FFFF
      FF003939390039393900FFFFFF00989898009898980098989800989898009292
      9200FFFFFF00FFFFFF004E4E4E0000000000B7631100B7631100FFFFFF00FFFF
      FF00FFFFFF00B7631100B76311000000000000000000B7631100B7631100FFFF
      FF00FFFFFF00FFFFFF00B7631100B763110000000000B4D5E800B1D4E9007BC6
      F20059BDF90043B7FC0037B4FE0037B4FF0037B4FE0042B7FD0057BCF90079C5
      F300ADD3EA00B3D5E90000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A200000000004E4E4E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004E4E4E0000000000B7631100B7631100FFFFFF00FFFF
      FF00FFFFFF00B7631100B76311000000000000000000B7631100B7631100FFFF
      FF00FFFFFF00FFFFFF00B7631100B7631100000000007DC6F20037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF006FC3F50000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A20000000000B5631100B7631100B763
      1100B7631100B7631100B7631100B7631100B7631100B7631100B7631100B763
      1100B7631100B7631100B763110000000000B7631100B7631100FFFFFF00FFFF
      FF00FFFFFF00B7631100B76311000000000000000000B7631100B7631100FFFF
      FF00FFFFFF00FFFFFF00B7631100B7631100000000006FC2F50037B4FF0037B4
      FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4FF0037B4
      FF0037B4FF0062BFF70000000000000000009D9D9D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A2A2A20000000000000000009D9D9D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A20000000000B7631100B7631100B763
      1100B7631100B7631100B7631100B7631100B7631100B7631100B7631100B763
      1100B7631100B7631100B763110000000000B7631100B7631100B7631100B763
      1100B7631100B7631100B76311000000000000000000B7631100B7631100B763
      1100B7631100B7631100B7631100B76311000000000000000000A1D0EC006FC2
      F5004EBAFA003BB5FE0037B4FF0037B4FF0037B4FF003AB4FE004DB9FB006CC2
      F5009DCFEC00000000000000000000000000A9A9A9009D9D9D009D9D9D009D9D
      9D009D9D9D009D9D9D00A8A8A8000000000000000000A9A9A9009D9D9D009D9D
      9D009D9D9D009D9D9D009D9D9D00A8A8A80000000000B9691B00B7631100B763
      1100B7631100B7631100B7631100B7631100B7631100B7631100B7631100B763
      1100B7631100B7631100B8681900000000009F785400B7631100B7631100B763
      1100B7631100B76311009F78540000000000000000009F785400B7631100B763
      1100B7631100B7631100B76311009F785400424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00E00F000000000000F83F000000000000
      FC7F000000000000FC7F000000000000FC7F000000000000FC7F000000000000
      FC7F000000000000FC7F000000000000FC7F000000000000FC7F000000000000
      FC7F0000000000007C7D0000000000003C790000000000000001000000000000
      00010000000000007FFD0000000000008003FC3FFC3FFFF38003FC3FFC3FFFE1
      8003FC3FFC3FFFCC0003FC3FFC3FFF8C0003FC3FFC3FFF018003FC3FFC3FFE03
      8003FC3FFC3FE0070003FC3FFC3FC00F0003F81FF81F801F8003F00FF00F003F
      8003E007E007187F0003E007E0073C3F0003C003C0037C7F800380018001F87F
      800300000000F0FF8003FFFFFFFFE1FFF00F018080010180C007018080010180
      8003018080010180800301808001018080030180800101808003018080010180
      80030180800101808003FFFF8001FFFF8003FFFF8001FFFF8003018080010180
      80030180800101808FE301808001018080030180800101808003018080010180
      8003018080010180C00701808001018000000000000000000000000000000000
      000000000000}
  end
  object SynSQLSyn1: TSynSQLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    DataTypeAttri.Foreground = clNavy
    NumberAttri.Foreground = clGreen
    StringAttri.Foreground = clBlue
    TableNameAttri.Foreground = clPurple
    Left = 467
    Top = 141
  end
  object SynSQLCompletion: TSynCompletionProposal
    Options = [scoLimitToMatchedText, scoUseBuiltInTimer, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter]
    NbLinesInWindow = 12
    EndOfTokenChr = '()[] '
    TriggerChars = '. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <>
    Resizeable = False
    OnClose = SynSQLCompletionClose
    OnExecute = SynSQLCompletionExecute
    OnShow = SynSQLCompletionShow
    ShortCut = 16416
    Editor = memSQL
    TimerInterval = 50
    Left = 536
    Top = 141
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    Left = 787
    Top = 301
  end
  object pmRecentDb: TPopupMenu
    Left = 456
    Top = 140
  end
  object pmSQL: TPopupMenu
    OnPopup = memSQLPopup
    Left = 520
    Top = 140
    object mnuAIFont: TMenuItem
      Caption = 'AI Tools'
      object mnuAIFmt: TMenuItem
        Caption = 'Format SQL'
        OnClick = mnuAIFmtClick
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object mnuAIExplain: TMenuItem
        Caption = 'Explain Query'
        OnClick = mnuAIExplainClick
      end
      object mnuAIOptimize: TMenuItem
        Caption = 'Optimize SQL'
        OnClick = mnuAIOptimizeClick
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object mnuAIGenerate: TMenuItem
        Caption = 'Generate SQL...'
        OnClick = mnuAIGenerateClick
      end
      object N16: TMenuItem
        Caption = '-'
      end
    end
  end
end
