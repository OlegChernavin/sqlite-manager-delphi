object frmAddColumn: TfrmAddColumn
  Left = 0
  Top = 0
  Caption = 'Add Column'
  ClientHeight = 320
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object pnlContent: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 270
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 50
    ExplicitHeight = 220
    object lblColumnName: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 6
      Width = 434
      Height = 15
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Column Name:'
      Layout = tlBottom
      ExplicitWidth = 81
    end
    object lblColumnType: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 56
      Width = 434
      Height = 15
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Column Type:'
      Layout = tlBottom
      ExplicitWidth = 73
    end
    object lblDefaultValue: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 129
      Width = 434
      Height = 15
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Default Value:'
      Layout = tlBottom
      ExplicitWidth = 72
    end
    object lblValidation: TLabel
      Left = 0
      Top = 257
      Width = 450
      Height = 13
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 3
    end
    object edtColumnName: TEdit
      AlignWithMargins = True
      Left = 8
      Top = 27
      Width = 434
      Height = 23
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      TabOrder = 0
      OnChange = edtColumnNameChange
      ExplicitLeft = 0
      ExplicitWidth = 450
    end
    object cbColumnType: TComboBox
      AlignWithMargins = True
      Left = 8
      Top = 77
      Width = 434
      Height = 23
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'VARCHAR'
      OnChange = cbColumnTypeChange
      Items.Strings = (
        'VARCHAR'
        'INTEGER'
        'REAL'
        'BLOB'
        'NUMERIC'
        'TEXT')
    end
    object chkNotNull: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 106
      Width = 434
      Height = 17
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'NOT NULL'
      TabOrder = 2
      OnClick = chkNotNullClick
      ExplicitLeft = 0
      ExplicitWidth = 450
    end
    object edtDefaultValue: TEdit
      AlignWithMargins = True
      Left = 8
      Top = 150
      Width = 434
      Height = 23
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      TabOrder = 3
      OnChange = edtDefaultValueChange
      ExplicitLeft = 0
      ExplicitWidth = 450
    end
    object chkPrimaryKey: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 179
      Width = 434
      Height = 17
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Primary Key'
      TabOrder = 4
      OnClick = chkPrimaryKeyClick
      ExplicitLeft = 0
      ExplicitWidth = 450
    end
    object chkAutoInc: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 202
      Width = 434
      Height = 17
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Autoincrement'
      Enabled = False
      TabOrder = 5
      ExplicitLeft = 0
      ExplicitWidth = 450
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 270
    Width = 450
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 276
    object btnCancel: TButton
      Left = 340
      Top = 12
      Width = 90
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 244
      Top = 12
      Width = 90
      Height = 25
      Caption = 'Add'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
