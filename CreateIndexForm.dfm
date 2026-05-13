object frmCreateIndex: TfrmCreateIndex
  Left = 0
  Top = 0
  Caption = 'Create Index'
  ClientHeight = 400
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 0
      Top = 0
      Width = 135
      Height = 21
      Align = alClient
      Caption = 'Create New Index'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 50
    Width = 500
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblIndexName: TLabel
      Left = 0
      Top = 0
      Width = 67
      Height = 15
      Align = alTop
      Caption = 'Index Name:'
      Layout = tlBottom
    end
    object lblTable: TLabel
      Left = 0
      Top = 53
      Width = 30
      Height = 15
      Align = alTop
      Caption = 'Table:'
      Layout = tlBottom
    end
    object lblColumns: TLabel
      Left = 0
      Top = 106
      Width = 96
      Height = 15
      Align = alTop
      Caption = 'Indexed Columns:'
      Layout = tlBottom
    end
    object edtIndexName: TEdit
      Left = 0
      Top = 15
      Width = 500
      Height = 23
      Align = alTop
      TabOrder = 0
    end
    object cbTable: TComboBox
      Left = 0
      Top = 68
      Width = 500
      Height = 23
      Align = alTop
      Style = csDropDownList
      TabOrder = 1
    end
    object chkUnique: TCheckBox
      Left = 0
      Top = 76
      Width = 500
      Height = 17
      Align = alTop
      Caption = 'Unique Index'
      TabOrder = 2
      ExplicitTop = 91
      ExplicitWidth = 97
    end
    object pnlColumns: TScrollBox
      Left = 0
      Top = 108
      Width = 500
      Height = 192
      Align = alClient
      TabOrder = 3
      ExplicitTop = 121
      ExplicitHeight = 179
      object btnAddColumn: TButton
        Left = 0
        Top = 154
        Width = 492
        Height = 25
        Align = alBottom
        Caption = '+ Add Column'
        TabOrder = 0
        OnClick = btnAddColumnClick
      end
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 350
    Width = 500
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnCancel: TButton
      Left = 390
      Top = 12
      Width = 90
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 290
      Top = 12
      Width = 90
      Height = 25
      Caption = 'Create'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
