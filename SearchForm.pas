unit SearchForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, DBModule, System.Generics.Collections;

type
  TSearchOperator = (soEqual, soNotEqual, soLess, soLessOrEqual, soGreater, soGreaterOrEqual,
                     soLike, soIsNull, soIsNotNull, soIn, soCustom);
  
  TSearchCriteria = record
    ColName: string;
    Operator: TSearchOperator;
    Value: string;
  end;

  TfrmSearch = class(TForm)
    pnlContent: TPanel;
    pnlFooter: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    scrFields: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure scrFieldsMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure scrFieldsMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    FDB: TSQLiteHandler;
    FTableName: string;
    FColumns: TArray<TColumnDef>;
    FControls: TList<TControl>;
    FOperatorCombos: TList<TComboBox>;
    FValueEdits: TList<TEdit>;
    procedure CreateSearchRow(const AColName: string; AIndex: Integer);
    function OperatorToSQL(AOp: TSearchOperator): string;
  public
    constructor CreateSearch(AOwner: TComponent; ADB: TSQLiteHandler;
      const ATableName: string; const AColumns: TArray<TColumnDef>);
    destructor Destroy; override;
    
    function GetWhereClause: string;
  end;

implementation

{$R *.dfm}

const
  OperatorNames: string = '='#13#10'<>'#13#10'<'#13#10'<='#13#10'>'#13#10'>='#13#10'LIKE'#13#10'IS NULL'#13#10'IS NOT NULL'#13#10'IN'#13#10'custom';

{ TfrmSearch }

constructor TfrmSearch.CreateSearch(AOwner: TComponent; ADB: TSQLiteHandler;
  const ATableName: string; const AColumns: TArray<TColumnDef>);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FDB := ADB;
  FTableName := ATableName;
  FColumns := AColumns;
  FControls := TList<TControl>.Create;
  FOperatorCombos := TList<TComboBox>.Create;
  FValueEdits := TList<TEdit>.Create;

  Caption := 'Search in Table: ' + ATableName;

  // Create search rows in REVERSE order so they appear top-to-bottom
  // (because Align := alTop means last added appears at top)
  for I := High(FColumns) downto 0 do
    CreateSearchRow(FColumns[I].Name, I);
  
  // Set groupbox height to fit all controls
  scrFields.Height := (Length(FColumns) * 35) + 10;
  scrFields.VertScrollBar.Visible := True;
end;

destructor TfrmSearch.Destroy;
begin
  FControls.Free;
  FOperatorCombos.Free;
  FValueEdits.Free;
  inherited Destroy;
end;

procedure TfrmSearch.FormActivate(Sender: TObject);
begin
  scrFields.VertScrollBar.Position := 0;
end;

procedure TfrmSearch.FormCreate(Sender: TObject);
begin
  // Controls are already created in CreateSearch
end;

procedure TfrmSearch.FormDestroy(Sender: TObject);
begin
  // Controls are owned by grpFields, just clear lists
  FControls.Clear;
  FOperatorCombos.Clear;
  FValueEdits.Clear;
end;

procedure TfrmSearch.CreateSearchRow(const AColName: string; AIndex: Integer);
var
  HBox: TPanel;
  LabelCtrl: TLabel;
  OpCombo: TComboBox;
  ValueEdit: TEdit;
begin
  // Create horizontal box
  HBox := TPanel.Create(scrFields);
  HBox.Parent := scrFields;
  HBox.Align  := alTop;
  HBox.Height := 35;
  HBox.BevelOuter := bvNone;
  FControls.Add(HBox);
  
  // Create label
  LabelCtrl := TLabel.Create(HBox);
  LabelCtrl.Parent := HBox;
  LabelCtrl.Left  := 5;
  LabelCtrl.Top   := 8;
  LabelCtrl.Width := 150;
  LabelCtrl.Caption := AColName;
  
  // Create operator combo
  OpCombo := TComboBox.Create(HBox);
  OpCombo.Parent := HBox;
  OpCombo.Left  := 160;
  OpCombo.Top   := 5;
  OpCombo.Width := 100;
  OpCombo.Style := csDropDownList;

  OpCombo.Items.Text := OperatorNames;

  OpCombo.ItemIndex := 0;  // Default to '='
  FOperatorCombos.Add(OpCombo);

  // Create value edit with column name in Hint
  ValueEdit := TEdit.Create(HBox);
  ValueEdit.Parent := HBox;
  ValueEdit.Left  := 265;
  ValueEdit.Top   := 5;
  ValueEdit.Width := 370;
  ValueEdit.Anchors := [akLeft, akRight, akTop];
  ValueEdit.Hint := AColName;  // Store column name in Hint
  ValueEdit.ShowHint := True;
  FValueEdits.Add(ValueEdit);
end;

function TfrmSearch.OperatorToSQL(AOp: TSearchOperator): string;
begin
  case AOp of
    soEqual: Result := '=';
    soNotEqual: Result := '<>';
    soLess: Result := '<';
    soLessOrEqual: Result := '<=';
    soGreater: Result := '>';
    soGreaterOrEqual: Result := '>=';
    soLike: Result := 'LIKE';
    soIsNull: Result := 'IS NULL';
    soIsNotNull: Result := 'IS NOT NULL';
    soIn: Result := 'IN';
    soCustom: Result := '';
  else
    Result := '=';
  end;
end;

function TfrmSearch.GetWhereClause: string;
var
  I: Integer;
  Op: TSearchOperator;
  Value: string;
  Conditions: TStringList;
  Condition: string;
  ColName: string;
begin
  Conditions := TStringList.Create;
  try
    for I := 0 to FValueEdits.Count - 1 do
    begin
      Op := TSearchOperator(FOperatorCombos[I].ItemIndex);
      Value := Trim(FValueEdits[I].Text);
      ColName := FValueEdits[I].Hint;  // Get column name from Hint
      
      // Skip if no value entered (except for IS NULL / IS NOT NULL)
      if (Value = '') and not (Op in [soIsNull, soIsNotNull]) then
        Continue;
      
      // Build condition
      case Op of
        soIsNull, soIsNotNull:
          Condition := Format('"%s" %s', [ColName, OperatorToSQL(Op)]);
        soIn:
          Condition := Format('"%s" IN (%s)', [ColName, Value]);
        soLike:
          begin
            // Support wildcards: %value%, value%, %value
            if (Pos('%', Value) = 1) and (Copy(Value, Length(Value), 1) = '%') then
              Condition := Format('"%s" LIKE ''%s''', [ColName, Value])
            else if Pos('%', Value) = 1 then
              Condition := Format('"%s" LIKE ''%s''', [ColName, Value])
            else if Copy(Value, Length(Value), 1) = '%' then
              Condition := Format('"%s" LIKE ''%s''', [ColName, Value])
            else
              Condition := Format('"%s" LIKE ''%%%s%%''', [ColName, Value]);  // Default: contains
          end;
        soCustom:
          Condition := Format('"%s" %s', [ColName, Value]);
      else
        Condition := Format('"%s" %s %s', [ColName, OperatorToSQL(Op), QuotedStr(Value)]);
      end;
      
      Conditions.Add(Condition);
    end;
    
    // Combine conditions with AND
    if Conditions.Count > 0 then
    begin
      Result := Conditions[0];
      for I := 1 to Conditions.Count - 1 do
        Result := Result + ' AND ' + Conditions[I];
    end
    else
      Result := '1=1';  // No conditions, return all rows
  finally
    Conditions.Free;
  end;
end;

procedure TfrmSearch.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmSearch.scrFieldsMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  if scrFields.VertScrollBar.Position >= 50 then
    scrFields.VertScrollBar.Position := scrFields.VertScrollBar.Position - 50
  else
    scrFields.VertScrollBar.Position := 0;
end;

procedure TfrmSearch.scrFieldsMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  scrFields.VertScrollBar.Position := scrFields.VertScrollBar.Position + 50;
end;

end.
