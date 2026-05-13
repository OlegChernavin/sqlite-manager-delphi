object frmCreateTree: TfrmCreateTree
  Left = 0
  Top = 0
  Caption = 'Create Table'
  ClientHeight = 450
  ClientWidth = 550
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
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 0
      Top = 0
      Width = 133
      Height = 21
      Align = alClient
      Caption = 'Create New Table'
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
    Width = 550
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblTableName: TLabel
      Left = 0
      Top = 0
      Width = 65
      Height = 15
      Align = alTop
      Caption = 'Table Name:'
      Layout = tlBottom
    end
    object lblColumns: TLabel
      Left = 0
      Top = 53
      Width = 51
      Height = 15
      Align = alTop
      Caption = 'Columns:'
      Layout = tlBottom
    end
    object edtTableName: TEdit
      Left = 0
      Top = 30
      Width = 550
      Height = 23
      Align = alTop
      TabOrder = 0
    end
    object pnlColumns: TScrollBox
      Left = 0
      Top = 68
      Width = 550
      Height = 282
      Align = alClient
      TabOrder = 1
      object btnAddColumn: TButton
        Left = 0
        Top = 257
        Width = 542
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
    Top = 400
    Width = 550
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnCancel: TButton
      Left = 450
      Top = 12
      Width = 90
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 350
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
