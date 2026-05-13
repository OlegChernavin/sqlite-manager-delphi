object frmSQLDialog: TfrmSQLDialog
  Left = 0
  Top = 0
  Caption = 'SQL Dialog'
  ClientHeight = 400
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 0
      Top = 0
      Width = 600
      Height = 50
      Align = alClient
      Caption = 'SQL Statement'
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
    Width = 600
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object memSQL: TMemo
      Left = 0
      Top = 0
      Width = 600
      Height = 300
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 350
    Width = 600
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnCancel: TButton
      Left = 500
      Top = 12
      Width = 90
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 400
      Top = 12
      Width = 90
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
